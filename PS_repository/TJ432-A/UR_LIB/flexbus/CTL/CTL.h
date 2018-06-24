#ifndef _CTL_H_
#define _CTL_H_

#include "mbed.h"


extern PwmOut motor1_CHA;
extern PwmOut motor1_CHB;

extern int16_t QEI1;
extern int16_t QEI2;

extern void motor_init();
extern void get_qei();




#endif

