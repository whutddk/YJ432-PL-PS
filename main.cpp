#include "mbed.h"

#include "ITAC.h"

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

// void delay(uint32_t i)
// {
// 	uint32_t j;
// 	for ( ;i>0;i-- )
// 		for (j = 500;j>0;j--)
// 		{
// 			__NOP();
// 		}
// }

// #define DELAY_CNT 1000

int main(void)
{
	// buzzer = 0;

	//YJ_FB_init();
	fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	FC_thread.start(FC_app);

	bz_set(ready);

	CTL_thread.start(CTL_app);

	

	while(1)
	{		
		wait(100);
		// if ( 0 == flexbus_test() )
		// {

		// }
		// else
		// {

		// }


	}
	return 0;
}
