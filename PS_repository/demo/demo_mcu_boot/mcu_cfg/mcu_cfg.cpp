/*
* @File Name mcu_cfg.cpp
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\demo\demo_mcu_boot\mcu_cfg\mcu_cfg.cpp
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-11 10:56:50
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-11 11:22:01
* @Email: 295054118@whut.edu.cn"
*/


#include "mbed.h"

#include "mcu_cfg.h"


DigitalIn FPGA_DONE(DONE_IO);
DigitalIn FPGA_INIT(INIT_IO);
DigitalOut FPGA_PROG(PROG_IO);

void wait_fpga_init()
{
	//make sure FPGA reset is High
	FPGA_PROG = 1;

	//Wait until Done Goes HIGH
	while(!FPGA_DONE)
	{
		;
	}
}


#if SPI_CFG

SDHCBlockDevice sd;
FATFileSystem fs("fs");

//SPI2 :SOUT = PTD13,SIN = PTD14,SCK = PTD12,PCS = PTD11
SPI spi_config(PTD13, PTD14, PTD12);

void spi_cfg_fpga()
{
	FILE* fd;
	uint32_t num_read = 0;
	uint8_t buf_read[1024] = {0};
	uint32_t write_sum = 0;

	fs.mount(&sd);

	fd = fopen("/fs/FPGA_boot.bin","rb");

	if (fd == NULL)
	{
		//File FPGA_boot.bin Open Failure
		return;
	}
	else
	{
		//File FPGA_boot.bin Open finish
	}

	spi_config.format(8, 0);
	spi_config.frequency(5000000);



	//Pull Down PROG to Reset FPGA
	FPGA_PROG = 0;

	//Wait until INIT Goes LOW
	// while(FPGA_INIT);
	
	//Pull Up PROG

	FPGA_PROG = 1;


	//Wait until INIT Goes HIGH
	// while(!FPGA_INIT);

	while(1)
	{
		memset(buf_read, 0, 1024);
		num_read = fread(buf_read,1,1024,fd);	

		if ( num_read == 0 )
		{
			break;
		}

		spi_config.write((const char*)(buf_read), num_read, NULL, 0);
		write_sum += num_read;
		//printf("Spi Write %d Byte \r",write_sum);

	}
	//File close
	fclose(fd);


	wait_fpga_init();

}



#endif


