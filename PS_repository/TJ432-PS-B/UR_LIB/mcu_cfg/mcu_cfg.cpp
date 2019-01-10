#include "mbed.h"

#include "include.h"



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
	FPGA_PROG = 1;
	fc.printf("Wait until Done Goes HIGH\r\n");
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
		fc.printf("File FPGA_boot.bin Open Failure. \r\n");
		return;
	}
	else
	{
		fc.printf("File FPGA_boot.bin Open done.\r\n");
	}

	spi_config.format(8, 0);
	spi_config.frequency(5000000);


	/*pull down PROG to reset*/
	fc.printf("Pull Down PROG to Reset\r\n");
	FPGA_PROG = 0;
	/*wait until INIT goes LOW*/
	fc.printf("Wait until INIT Goes LOW\r\n");
	// while(FPGA_INIT);
	fc.printf("Pull Up PROG \r\n");
	FPGA_PROG = 1;

	/*wait until INIT goes HIGH*/
	fc.printf("Wait until INIT Goes HIGH \r\n");
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
		fc.printf("Spi Write %d Byte \r",write_sum);

	}
	fc.printf("\r\n File close\r\n");
	fclose(fd);


	wait_fpga_init();

}



#endif


