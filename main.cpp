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
extern void play_mp3(char* filename);

extern Serial fc;



SDHCBlockDevice sd;
FATFileSystem fs("fs");



//天际系列
int main(void)
{

	fs.mount(&sd);

	// buzzer = 0;
	wait_fpga_init();

	YJ_FB_init();	
	fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	// FC_thread.start(FC_app);

	*(LED_FRE_REG) = 50000;
	*(BZ_FRE_REG) = 1000000000;
	*(RED_DUTY_REG) = 30000;
	*(GREEN_DUTY_REG) = 20000;
	*(BLUE_DUTY_REG) = 40000;

	bz_set(ready);

	play_mp3("MS.wav");
	while(1)
	{		
		//bz_set(datarec);


		wait(1);


	}
	return 0;
}
