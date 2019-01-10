#include "mbed.h"
#include <stdio.h>
#include "sd_pin_mux.h"
#include "fsl_sysmpu.h"

#include "SDHCBlockDevice.h"

// The number of operational block:
// size/FSL_SDMMC_DEFAULT_BLOCK_SIZE == size >> SHIFT_BIT_TRANSFER
#define SHIFT_BIT_TRANSFER (9)

SDHCBlockDevice::SDHCBlockDevice()
{
	_is_initialized = false;
	_is_writable = false;
	_sectors = 1;
}

SDHCBlockDevice::~SDHCBlockDevice()
{
	deinit();
}

int SDHCBlockDevice::init()
{
	_card = &_sd;

	SD_InitPins();

	// MPU must be enable, or the SD card will init failed
	SYSMPU_Enable(SYSMPU, false);

	_card->host.base = SD_HOST_BASEADDR;
	_card->host.sourceClock_Hz = SD_HOST_CLK_FREQ;

	/* Init card. */
	if (SD_Init(_card)) {
		printf("\r\nSD card init failed.\r\n");
		return -1;
	}

	/* Check if card is readonly. */
	_is_writable = !SD_CheckReadOnly(_card);

	_is_initialized = true;

	return 0;
}

int SDHCBlockDevice::deinit()
{
	if (_is_initialized) {
		SD_Deinit(_card);
		_is_initialized = false;
	}

	return 0;
}

int SDHCBlockDevice::read(void *buffer, bd_addr_t addr, bd_size_t size)
{
	if (_is_initialized) {
		if (kStatus_Success != SD_ReadBlocks(_card,
		                                     (uint8_t *)buffer,
		                                     (uint32_t)(addr >> SHIFT_BIT_TRANSFER),
		                                     (uint32_t)(size >> SHIFT_BIT_TRANSFER)))
		{
			printf("\r\nerr: Read data block failed.\r\n");
			return -1;
		}
		return 0;
	} else {
		printf("\r\nerr: SD card must be init.\r\n");
		return -1;
	}
}

int SDHCBlockDevice::program(const void *buffer, bd_addr_t addr, bd_size_t size)
{
	if (_is_initialized) {
		if (_is_writable) {
			if (kStatus_Success != SD_WriteBlocks(_card,
			                                      (uint8_t *)buffer,
			                                      (uint32_t)(addr >> SHIFT_BIT_TRANSFER),
			                                      (uint32_t)(size >> SHIFT_BIT_TRANSFER)))
			{
				printf("\r\nerr: Write data block failed.\r\n");
				return -1;
			}
			return 0;
		} else {
			printf("\r\nerr: SD card doesn't support writing.\r\n");
			return -1;
		}
	} else {
		printf("\r\nerr: SD card must be init.\r\n");
		return -1;
	}
}

int SDHCBlockDevice::erase(bd_addr_t addr, bd_size_t size)
{
	if (_is_initialized) {
		if (_is_writable) {
			if (kStatus_Success != SD_EraseBlocks(_card,
			                                      (uint32_t)(addr >> SHIFT_BIT_TRANSFER),
			                                      (uint32_t)(size >> SHIFT_BIT_TRANSFER)))
			{
				printf("Erase multiple data blocks failed.\r\n");
				return -1;
			}
			return 0;
		} else {
			printf("\r\nerr: SD card doesn't support erasing.\r\n");
			return -1;
		}
	} else {
		printf("\r\nerr: SD card must be init.\r\n");
		return -1;
	}
}

bd_size_t SDHCBlockDevice::get_read_size() const
{
    return FSL_SDMMC_DEFAULT_BLOCK_SIZE;
}

bd_size_t SDHCBlockDevice::get_program_size() const
{
    return FSL_SDMMC_DEFAULT_BLOCK_SIZE;
}

bd_size_t SDHCBlockDevice::size() const
{
    return FSL_SDMMC_DEFAULT_BLOCK_SIZE * _sectors;
}
