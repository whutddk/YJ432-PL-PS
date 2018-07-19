#ifndef _MCU_CFG_H_
#define _MCU_CFG_H_

#include "mbed.h"
#include "SDHCBlockDevice.h"
#include "FATFileSystem.h"

#ifndef ON
#define ON		1
#endif

#ifndef OFF
#define OFF		0
#endif


#define SPI_CFG ON

extern DigitalIn FPGA_DONE;
extern DigitalIn FPGA_INIT;
extern DigitalOut FPGA_PROG;

extern void wait_fpga_init();

#if SPI_CFG

extern SDHCBlockDevice sd;
extern FATFileSystem fs;
//SPI2 
//SCK = PTD12
//PCS = PTD11
//SIN = PTD14
//SOUT = PTD13
extern SPI spi_config;

extern void spi_cfg_fpga();
#endif

#endif

