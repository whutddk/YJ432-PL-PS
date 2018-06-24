#include "mbed.h"
#include "ITAC.h"

enum _bz_style bz_style = norm;

DigitalOut buzzer(BZ, 0);
DigitalOut comled(LED1, 1);
Timer timer;

static int32_t begin;
static int32_t bz_cnt;

void bzled_work()
{
	bz_cnt = timer.read_ms() - begin;

	switch (bz_style) {
		case (ready): bz_ready(); break;

		case (datarec): bz_datarec(); break;

		case (warn): bz_warn(); break;

		case (norm): bz_norm(); break;

		case (fuzzyrec): bz_fuzzyrec(); break;
	}
}

void bz_ready()
{

	if ( bz_cnt < 100 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 200 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 300 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 400 ) {
		BZ_OFF;
		LED_OFF;
	}

	else if ( bz_cnt < 500 ) {
		BZ_ON;
		LED_ON;
	}

	else if ( bz_cnt < 1000 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 1500 )
	{
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 2000 ) {

		BZ_OFF;
		LED_OFF;
	} else {
		bz_style = norm;
	}
}

void bz_datarec()
{
	if ( bz_cnt < 50 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 100 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 150 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 200 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 250 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 300 ) {
		BZ_OFF;
		LED_OFF;
	} else {
		bz_style = norm;
	}
}

void bz_fuzzyrec()
{
	if ( bz_cnt < 100 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 200 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 250 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 300 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 350 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 400 ) {
		BZ_OFF;
		LED_OFF;
	} else {
		bz_style = norm;
	}
}


void bz_norm()
{
	if ( bz_cnt < 100 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 5000 ) {
		BZ_OFF;
		LED_OFF;
	} else
	{
		bz_style = norm;
		timer.start();
		begin = timer.read_ms();
	}

}

void bz_warn()
{
	if ( bz_cnt < 500 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 1000 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 1500 ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 2000 ) {
		BZ_OFF;
		LED_OFF;
	} else if ( bz_cnt < 2500  ) {
		BZ_ON;
		LED_ON;
	} else if ( bz_cnt < 3000 ) {
		BZ_OFF;
		LED_OFF;
	} else {
		bz_style = norm;
	}
}

void bz_set(enum _bz_style bz)
{
	bz_style = bz;
	timer.start();
	begin = timer.read_ms();
}


