/*
* @File Name main.cpp
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\demo\demo_mcu_boot\main.cpp
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-04 19:54:48
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-11 14:06:39
* @Email: 295054118@whut.edu.cn"
*/

#include "mbed.h"

#include "mcu_cfg.h"

int main(void)
{	
	
	#if SPI_CFG
		//Start to Boot Artix-7
		spi_cfg_fpga();
	#endif

	wait_fpga_init();

	while(1)
	{		
		wait(1);
	}
	return 0;
}
