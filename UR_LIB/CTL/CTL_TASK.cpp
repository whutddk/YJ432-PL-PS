#include "mbed.h"

#include "include.h"

void CTL_app()
{

	motor_init();


	while(1)
	{
		get_qei();
		push(0,QEI1);
		push(1,QEI2);
		push(2,200);
		wait(0.05);
	}
}