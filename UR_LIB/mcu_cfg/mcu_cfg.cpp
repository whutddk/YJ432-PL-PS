#include "mbed.h"

#include "mcu_cfg.h"



//确定初始化时是否使用SPI配置FPGA

//验证IO信号

//尽量使用底层来写，少用封装
//文件系统
//SPI系统
//I/O系统
//
//

DigitalIn FPGA_DONE(DONE_IO);
DigitalIn FPGA_INIT(INIT_IO);
DigitalOut FPGA_PROG(PROG_IO);

void wait_fpga_init()
{
	//wait until done goes high
	while(!FPGA_DONE)
	{
		;
	}
}


#if SPI_CFG

SDHCBlockDevice sd;
FATFileSystem fs("fs");
//SPI2 
//SCK = PTD12
//PCS = PTD11
//SIN = PTD14
//SOUT = PTD13
SPI SPI_CFG(PTD13, PTD14, PTD12);

void spi_cfg_fpga()
{
	FILE* fd;
	uint32_t num_read = 0;
	uint8_t buf_read[512] = {0};

	fs.mount(&sd);

	fd = fopen("/fs/FPGA_boot.bin","rb");

	if (fd == NULL)
	{
		//fc.printf(" Failure. %d \r\n", errno);
		return;
	}
	else
	{
		//fc.printf(" done.\r\n");
	}

	SPI_CFG.format(8, 0);
	SPI_CFG.frequency(1000000);


	//pull down PROG to reset
	FPGA_PROG = 0;
	//wait until INIT goes LOW
	while(FPGA_INIT);

	FPGA_PROG = 1;

	//wait until INIT goes HIGH
	while(!FPGA_INIT);

	while(1)
	{
		memset(buf_read, 0, 512);
		num_read = fread(buf_read,1,512,fd);	

		if ( num_read == 0 )
		{
			break;
		}

		SPI_CFG.write(buf_read, num_read, NULL, 0);


	}

	fclose(fd);

	wait_fpga_init();

}



#endif


