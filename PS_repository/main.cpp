
#include "mbed.h"

#include "ITAC.h"

#include "include.h"

SDHCBlockDevice sd;
FATFileSystem fs("fs");

//人机交互任务
Thread ITAC_thread(osPriorityLow);
extern void itac_app();

//上位机任务
// Thread FC_thread(osPriorityBelowNormal);
// extern void FC_app();

//实时控制
Thread CTL_thread(osPriorityRealtime);
extern void CTL_app();


// extern void YJ_FB_init();
// extern int flexbus_test();


extern Serial fc;




int main(void)
{
	// buzzer = 0;

	// YJ_FB_init();
	// fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	// FC_thread.start(FC_app);
	CTL_thread.start(CTL_app);
	bz_set(ready);



	// while(1)
	// {		


	// 	wait(1);


	// }
	return 0;
}
