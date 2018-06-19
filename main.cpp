#include "mbed.h"

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



uint32_t flexbus_data[5];



int main(void)
{
	// buzzer = 0;

	YJ_FB_init();
	fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	FC_thread.start(FC_app);

	bz_set(ready);

	CTL_thread.start(CTL_app);

	// *(bzled_reg + 0) = 50000;
	// *(bzled_reg + 1) = 50000;
	// *(bzled_reg + 2) = 50000;
	// *(bzled_reg + 3) = 70000;
	// *(bzled_reg + 4) = 20000;
	// 
	// wait(0.05);
	// 	*(pwm0_reg + 0) = 10000;
	// 	wait(0.05);
	// 	*(pwm0_reg + 1) = 9000;
	// 	wait(0.05);
	// 	*(pwm0_reg + 2) = 8000;
	// 	wait(0.05);
	// 	*(pwm0_reg + 3) = 7000;
	// 	wait(0.05);
	// 	*(pwm0_reg + 4) = 6000;
	while(1)
	{		
		//bz_set(datarec);
		

		wait(1);


	}
	return 0;
}
