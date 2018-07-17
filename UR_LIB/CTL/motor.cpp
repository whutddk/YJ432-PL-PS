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

//注册po3_PID0频率
	* (po3PID0_FREQ_REG) = 250000;  	//5ms

//初始化po3_PID0目标和当前值
	* (po3PID0_AIM_REG) = 24200;
	* (po3PID0_CUR_REG) = 0;

//初始化po3_PID0小偏差(CONTROL)
	* (po3PID0_ERS_REG) = 100;
	* (po3PID0_KPS_REG) = Float2Fix(3.00);
	* (po3PID0_KDS_REG) = Float2Fix(462.00);

//初始化po3_PID0中偏差
	* (po3PID0_ERM_REG) = 3000;
	* (po3PID0_KPM_REG) = Float2Fix(4.00);
	* (po3PID0_KDM_REG) = Float2Fix(472.00);

//初始化po3_PID0大偏差
	* (po3PID0_ERB_REG) = 5000;
	* (po3PID0_KPB_REG) = Float2Fix(4.00);
	* (po3PID0_KDB_REG) = Float2Fix(472.00);

//注册po3_PID1频率
	* (po3PID1_FREQ_REG) = 500000;  	//10ms

//初始化po3_PID1目标和当前值
	* (po3PID1_AIM_REG) = 24200;
	* (po3PID1_CUR_REG) = 0;

//初始化po3_PID1小偏差(CONTROL)
	* (po3PID1_ERS_REG) = 10;
	* (po3PID1_KPS_REG) = Float2Fix(2.00);
	* (po3PID1_KDS_REG) = Float2Fix(222.00);

//初始化po3_PID1中偏差
	* (po3PID1_ERM_REG) = 300;
	* (po3PID1_KPM_REG) = Float2Fix(2.00);
	* (po3PID1_KDM_REG) = Float2Fix(222.00);

//初始化po3_PID1大偏差
	* (po3PID1_ERB_REG) = 600;
	* (po3PID1_KPB_REG) = Float2Fix(2.00);
	* (po3PID1_KDB_REG) = Float2Fix(472.00);

}

int32_t QEI1;
void get_qei()
{
	QEI1 = (int32_t)(*(QEI0_CH0_REG));
}





