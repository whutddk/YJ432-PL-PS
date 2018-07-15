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
	* (po3PID0_FREQ_REG) = ;

//初始化目标和当前值
	* (po3PID0_AIM_REG) = ;
	* (po3PID0_CUR_REG) = ;

//初始化小偏差
	* (po3PID0_ERS_REG) = ;
	* (po3PID0_KPS_REG) = ;
	* (po3PID0_KDS_REG) = ;

//初始化中偏差
	* (po3PID0_ERM_REG) = ;
	* (po3PID0_KPM_REG) = ;
	* (po3PID0_KDM_REG) = ;

//初始化大偏差
	* (po3PID0_ERB_REG) = ;
	* (po3PID0_KPB_REG) = ;
	* (po3PID0_KDB_REG) = ;


}

int32_t QEI1;
void get_qei()
{
	QEI1 = (int32_t)(*(QEI0_CH0_REG));
}





