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

	// YJ_FB_init();
	fc.printf("flexbus INITIALIZATION COMPLETE!");

	bz_set(ready);

	while(1)
	{		
		//bz_set(datarec);
		
		wait(1);


	}
	return 0;
}
