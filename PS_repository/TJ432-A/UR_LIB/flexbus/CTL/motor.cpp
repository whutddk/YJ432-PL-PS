#include "mbed.h"

#include "fsl_common.h"
#include "fsl_port.h"
#include "fsl_ftm.h"

#include "include.h"



void motor_init()
{
	* (PWM0_FRE_REG) = 10000;
	* (PWM0_CH0_REG) = 1;
	* (PWM0_CH1_REG) = 1;

	* (QEI0_CLEAR_REG) = 1;
	* (QEI0_CLEAR_REG) = 0;
}


void get_qei()
{
	QEI1 = (int32_t)(*(QEI0_CH0_REG));
}





