#include "mbed.h"

DigitalOut buzzer(BZ, 0);

extern void YJ_FB_init();
extern int flexbus_test();
DigitalOut LEDR(LED_RED,1);
DigitalOut LEDG(LED_GREEN,1);
DigitalOut LEDB(LED_BLUE,1);

Serial uartpc(USBTX,USBRX);

void delay(uint32_t i)
{
	uint32_t j;
	for ( ;i>0;i-- )
		for (j = 500;j>0;j--)
		{
			__NOP();
		}
}

#define DELAY_CNT 1000

int main(void)
{
	buzzer = 0;
	YJ_FB_init();
	LEDG = 1;
	LEDB = 1;
	while(1)
	{
		
		LEDG = 0;
		if ( 0 == flexbus_test() )
		{
			buzzer = 1;
			LEDG = 0;
			delay(DELAY_CNT);
			buzzer = 0;
			LEDG = 1;
			delay(DELAY_CNT);
			buzzer = 1;
			LEDG = 0;
			delay(DELAY_CNT);
			buzzer = 0;
			LEDG = 1;
			delay(DELAY_CNT);
			buzzer = 1;
			LEDG = 0;
			delay(DELAY_CNT);
			buzzer = 0;
			LEDG = 1;
			delay(DELAY_CNT);

		}
		else
		{
			buzzer = 1;
			delay(DELAY_CNT * 10);
			buzzer = 0;
			delay(DELAY_CNT * 10);
			buzzer = 1;
			delay(DELAY_CNT * 10);
			buzzer = 0;
			delay(DELAY_CNT * 10);

			//LEDB=0;
			//break;
		}

		delay(DELAY_CNT*100);
	}
	return 0;
}
