
/*
* @File Name main.cpp
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\demo\demo_flexbus_register\main.cpp
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-04 19:54:48
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-11 16:40:45
* @Email: 295054118@whut.edu.cn"
*/

#include "mbed.h"

#include "PL_def.h"
#include "mcu_cfg.h"

extern void flexbus_init();


int main(void)
{
	wait_fpga_init();

	//flexbus initialization
	flexbus_init();

	*(LED_FRE_REG) = 1000000;
	wait(0.05);

	while(1)
	{		

		*(BZ_FRE_REG) = 500000;
		*(RED_DUTY_REG) = 100000;
		*(GREEN_DUTY_REG) = 100000;
		*(BLUE_DUTY_REG) = 900000;		
		wait(1);

		*(BZ_FRE_REG) = 1000000;
		*(RED_DUTY_REG) = 100000;
		*(GREEN_DUTY_REG) = 900000;
		*(BLUE_DUTY_REG) = 100000;		
		wait(1);

		*(BZ_FRE_REG) = 2000000;
		*(RED_DUTY_REG) = 900000;
		*(GREEN_DUTY_REG) = 100000;
		*(BLUE_DUTY_REG) = 100000;		
		wait(1);

		*(BZ_FRE_REG) = 3000000;
		*(RED_DUTY_REG) = 700000;
		*(GREEN_DUTY_REG) = 800000;
		*(BLUE_DUTY_REG) = 900000;		
		wait(1);

		*(BZ_FRE_REG) = 6000000;
		*(RED_DUTY_REG) = 500000;
		*(GREEN_DUTY_REG) = 100000;
		*(BLUE_DUTY_REG) = 700000;		
		wait(1);


	}
	return 0;
}

