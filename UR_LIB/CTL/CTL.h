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
	double sum;
	
	double error[11];
  
};

struct _ctl
{
 struct _pid pend;
 struct _pid motto;
 bool flag_end;
 int32_t out;
};

extern struct _ctl ctl;

extern int32_t QEI1;


extern void motor_init();
extern void get_qei();




#endif

