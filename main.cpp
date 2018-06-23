#include "mbed.h"

//任务1
Thread ITAC_thread(osPriorityRealtime);
extern void itac_app();


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



	while(1)
	{		
		// if ( 0 == flexbus_test() )
		// {

		// }
		// else
		// {

		// }


	}
	return 0;
}
