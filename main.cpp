#include "mbed.h"

#include "ITAC.h"

#include "include.h"

//人机交互任务
Thread ITAC_thread(osPriorityLow);
extern void itac_app();

//上位机任务
Thread FC_thread(osPriorityBelowNormal);
extern void FC_app();

extern void YJ_FB_init();


extern Serial fc;


//天际系列
int main(void)
{
	// buzzer = 0;

	YJ_FB_init();	
	fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	// FC_thread.start(FC_app);

	bz_set(ready);


	while(1)
	{		
		//bz_set(datarec);

		wait(1);


	}
	return 0;
}
