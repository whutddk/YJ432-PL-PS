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

//注册PID频率
	* (po3PID0_FREQ_REG) = 250000;  	//5ms

//初始化目标和当前值
	* (po3PID0_AIM_REG) = 24200;
	* (po3PID0_CUR_REG) = 0;

//初始化小偏差(CONTROL)
	* (po3PID0_ERS_REG) = 3000;
	* (po3PID0_KPS_REG) = Float2Fix(3.00);
	* (po3PID0_KDS_REG) = Float2Fix(462.00);

//初始化中偏差
	* (po3PID0_ERM_REG) = 10000;
	* (po3PID0_KPM_REG) = Float2Fix(4.00);
	* (po3PID0_KDM_REG) = Float2Fix(472.00);

//初始化大偏差(NOT CONTROL)
	* (po3PID0_ERB_REG) = 20000;
	* (po3PID0_KPB_REG) = 0;
	* (po3PID0_KDB_REG) = 0;

}

int32_t QEI1;
void get_qei()
{
	QEI1 = (int32_t)(*(QEI0_CH0_REG));
}





