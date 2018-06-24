#ifndef _CTL_H_
#define _CTL_H_

#include "mbed.h"

struct _pid
{
	int32_t cur;
	int32_t aim;
	double Kp_s;
	double Ki_s;
	double Kd_s;

	double Kp_m;
	double Ki_m;
	double Kd_m;

	double Kp_b;
	double Ki_b;
	double Kd_b;
    
	double result;
	double out;
	double error[4];
  
};

struct _ctl
{
 struct _pid pend;
 struct _pid motto;
 bool flag_end;
};

extern struct _ctl ctl;

extern PwmOut motor1_CHA;
// extern PwmOut motor1_CHB;
extern DigitalOut motor_side1;
extern DigitalOut motor_side2;

extern int16_t QEI1;
extern int16_t QEI2;

extern void motor_init();
extern void get_qei();




#endif

