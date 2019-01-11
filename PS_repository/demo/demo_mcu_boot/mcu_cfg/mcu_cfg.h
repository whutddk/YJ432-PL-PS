/*
* @File Name mcu_cfg.h
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\demo\demo_mcu_boot\mcu_cfg\mcu_cfg.h
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-11 10:56:50
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-11 11:20:37
* @Email: 295054118@whut.edu.cn"
*/

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


	//SPI2  SCK = PTD12 PCS = PTD11 SIN = PTD14 SOUT = PTD13
	extern SPI spi_config;

	extern void spi_cfg_fpga();

#endif

#endif

