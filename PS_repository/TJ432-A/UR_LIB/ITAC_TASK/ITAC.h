#ifndef _ITAC_H_
#define _ITAC_H_

#include "freecars.h"

enum _bz_style
{
	ready    = 0,
	datarec  = 1,
	warn     = 2,
	norm     = 3,
	fuzzyrec = 4
};

extern DigitalOut buzzer;
extern DigitalOut comled;
extern Timer timer;
extern Serial fc;

#define LED_ON     (comled = 1)
#define LED_OFF    (comled = 0)

#define BZ_ON     //(buzzer = 1)
#define BZ_OFF    (buzzer = 0)

extern enum _bz_style bz_style;



void bzled_init();
void bzled_work();
void bz_set(enum _bz_style bz);
void bz_ready();
void bz_datarec();
void bz_norm();
void bz_warn();
void bz_fuzzyrec();

#endif

