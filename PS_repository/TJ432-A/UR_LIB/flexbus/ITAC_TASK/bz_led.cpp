#include "mbed.h"
#include "ITAC.h"

enum _bz_style bz_style = norm;

DigitalOut buzzer(BZ, 0);
DigitalOut comled(LED1,1);
Timer timer;
 // *     timer.start();
 // *     begin = timer.read_us();
 //  *     end = timer.read_us();
void bzled_work()
{
	switch(bz_style)
	{
		case(ready): bz_ready();break;
		case(datarec): bz_datarec();break;
		case(warn):bz_warn(); break;
		case(norm):bz_norm(); break;
		case(fuzzyrec):bz_fuzzyrec();break;
	}
}

void bz_ready()
{

	BZ_ON;
	LED_ON;
	wait(0.1);

	BZ_OFF;
	LED_OFF;
	wait(0.1);

	BZ_ON;
	LED_ON;
	wait(0.1);

	BZ_OFF;
	LED_OFF;
	wait(0.1); 

	BZ_ON;
	LED_ON;
	wait(0.1);

	BZ_OFF;
	LED_OFF;
	wait(0.5);

	BZ_ON;
	LED_ON;
	wait(0.5);

	BZ_OFF;
	LED_OFF;
	bz_style = norm;

}

void bz_datarec()
{
	BZ_ON;
	LED_ON;
	wait(0.05);

	BZ_OFF;
	LED_OFF;
	wait(0.05);

	BZ_ON;
	LED_ON;
	wait(0.05);

	BZ_OFF;
	LED_OFF;
	wait(0.05);

	BZ_ON;
	LED_ON;
	wait(0.05);

	BZ_OFF;
	LED_OFF;
	bz_style = norm;	
}
 
void bz_fuzzyrec()
{
	BZ_ON;
	LED_ON;
	wait(0.1);

	BZ_OFF;
	LED_OFF;
	wait(0.1);

	BZ_ON;
	LED_ON;
	wait(0.05);

	BZ_OFF;
	LED_OFF;
	wait(0.05);

	BZ_ON;
	LED_ON;
	wait(0.05);

	BZ_OFF;
	LED_OFF;
	bz_style = norm;
	
}


void bz_norm()
{
	BZ_ON;
	LED_ON;
	wait(0.1);

	BZ_OFF;
	LED_OFF;
	wait(5);		

}

void bz_warn()
{
	BZ_ON;
	LED_ON;
	wait(0.5);

	BZ_OFF;
	LED_OFF;
	wait(0.5);

	BZ_ON;
	LED_ON;
	wait(0.5);

	BZ_OFF;
	LED_OFF;
	wait(0.5);

	BZ_ON;
	LED_ON;
	wait(0.5);

	BZ_OFF;
	LED_OFF;
	bz_style = norm;
}

void bz_set(enum _bz_style bz)
{
	bz_style = bz; 
}


