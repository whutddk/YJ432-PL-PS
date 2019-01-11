/*
* @File Name main.cpp
* @File Path M:\MAS2\mbed\YJ432-PS\main.cpp
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-04 19:54:48
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-04 20:10:20
* @Email: 295054118@whut.edu.cn"
*/#include "mbed.h"

#include "ITAC.h"

#include "include.h"

//人机交互任务
Thread ITAC_thread(osPriorityLow);
extern void itac_app();

//上位机任务
Thread FC_thread(osPriorityBelowNormal);
extern void FC_app();

//实时控制
Thread CTL_thread(osPriorityRealtime);
extern void CTL_app();


extern void YJ_FB_init();
extern int flexbus_test();


extern Serial fc;




int main(void)
{
	// buzzer = 0;
	FPGA_PROG = 1;
	//boot fpga here
	#if SPI_CFG

	fc.printf("Start to Boot Artix-7!!!");
	spi_cfg_fpga();
	
	#endif

	YJ_FB_init();
	fc.printf("flexbus INITIALIZATION IGNORE!");

	bz_set(ready);

	*(bzled_reg + 0) = 1000000;
    wait(0.05);
    *(bzled_reg + 1) = 1000000;
    wait(0.05);
    *(bzled_reg + 2) = 600000;
    wait(0.05);
    *(bzled_reg + 3) = 700000;
    wait(0.05);
    *(bzled_reg + 4) = 600000;
	wait(0.05);

	while(1)
	{		
		//bz_set(datarec);
		
		wait(1);


	}
	return 0;
}
