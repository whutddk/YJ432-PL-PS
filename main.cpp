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

#define PL_START_ADDRESS 0x60000000U
#define BZLED_BASE  0x00000000U
#define PWM0_BASE   0x00800000U
#define QEI0_BASE	0x01800000U

volatile uint32_t *bzled_reg = (uint32_t*)( PL_START_ADDRESS | BZLED_BASE );
volatile uint32_t *pwm0_reg = (uint32_t*)( PL_START_ADDRESS | PWM0_BASE );
volatile uint32_t *qei0_reg = (uint32_t*)( PL_START_ADDRESS | QEI0_BASE );


uint32_t flexbus_data[5];



int main(void)
{
	// buzzer = 0;

	YJ_FB_init();
	fc.printf("flexbus INITIALIZATION COMPLETE!");
	
	ITAC_thread.start(itac_app);
	// FC_thread.start(FC_app);

	bz_set(ready);

	//CTL_thread.start(CTL_app);

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
		flexbus_data[0] = *(qei0_reg + 0);
		flexbus_data[1] = *(qei0_reg + 1);
		flexbus_data[2] = *(qei0_reg + 2);
		flexbus_data[3] = *(qei0_reg + 3);
		flexbus_data[4] = *(qei0_reg + 4);

		fc.printf("reg0 = %d\n\r",flexbus_data[0]);
		fc.printf("reg1 = %d\n\r",flexbus_data[1]);
		fc.printf("reg2 = %d\n\r",flexbus_data[2]);
		fc.printf("reg3 = %d\n\r",flexbus_data[3]);
		fc.printf("reg4 = %d\n\r\n\r",flexbus_data[4]);

		*(qei0_reg ) = 1;
		*(qei0_reg ) = 0;
		//bz_set(datarec);
		

		wait(1);


	}
	return 0;
}
