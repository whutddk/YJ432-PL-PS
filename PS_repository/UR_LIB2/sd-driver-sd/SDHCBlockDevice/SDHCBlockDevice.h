#ifndef MBED_SDHC_BLOCK_DEVICE_H
#define MBED_SDHC_BLOCK_DEVICE_H

#include "BlockDevice.h"
#include "mbed.h"

#include "fsl_card.h"

/** Access an SD Card using SDHC
 *
 * @code
 * #include "mbed.h"
 * #include "SDHCBlockDevice.h"
 *
 * SDHCBlockDevice sd();
 * uint8_t block[512] = "Hello World!\n";
 *
 * int main() {
 *     sd.init();
 *     sd.program(block, 0, 512);
 *     sd.read(block, 0, 512);
 *     printf("%s", block);
 *     sd.erase(0, 512);
 *     sd.deinit();
 * }
 */

class SDHCBlockDevice : public BlockDevice
{
public:
	SDHCBlockDevice();
	virtual ~SDHCBlockDevice();

	/** Initialize a block device
	 *
	 *  @return         0 on success or a negative error code on failure
	 */
	virtual int init();

	/** Deinitialize a block device
	 *
	 *  @return         0 on success or a negative error code on failure
	 */
	virtual int deinit();

	/** Read blocks from a block device
	 *
	 *  @param buffer   Buffer to write blocks to
	 *  @param addr     Address of block to begin reading from
	 *  @param size     Size to read in bytes, must be a multiple of read block size
	 *  @return         0 on success, negative error code on failure
	 */
	virtual int read(void *buffer, bd_addr_t addr, bd_size_t size);

	/** Program blocks to a block device
	 *
	 *  The blocks must have been erased prior to being programmed
	 *
	 *  @param buffer   Buffer of data to write to blocks
	 *  @param addr     Address of block to begin writing to
	 *  @param size     Size to write in bytes, must be a multiple of program block size
	 *  @return         0 on success, negative error code on failure
	 */
	virtual int program(const void *buffer, bd_addr_t addr, bd_size_t size);

	/** Erase blocks on a block device
	 *
	 *  The state of an erased block is undefined until it has been programmed
	 *
	 *  @param addr     Address of block to begin erasing
	 *  @param size     Size to erase in bytes, must be a multiple of erase block size
	 *  @return         0 on success, negative error code on failure
	 */
	virtual int erase(bd_addr_t addr, bd_size_t size);

	/** Get the size of a readable block
	 *
	 *  @return         Size of a readable block in bytes
	 */
	 virtual bd_size_t get_read_size() const;

	/** Get the size of a programable block
	 *
	 *  @return         Size of a programable block in bytes
	 *  @note Must be a multiple of the read size
	 */
	 virtual bd_size_t get_program_size() const;

	/** Get the total size of the underlying device
	 *
	 *  @return         Size of the underlying device in bytes
	 */
	 virtual bd_size_t size() const;

private:
	bool _is_initialized;
	bool _is_writable;
	bd_size_t _sectors;

	// Card descriptor
	sd_card_t _sd;
	sd_card_t *_card;
};

#endif // MBED_SDHC_BLOCK_DEVICE_H
