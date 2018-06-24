#include "mbed.h"

#include "fsl_common.h"
#include "fsl_port.h"
#include "fsl_ftm.h"

#include "include.h"

PwmOut motor1_CHA(PTA6);
// PwmOut motor1_CHB(PTA7);
DigitalOut motor_side1(PTA24);
DigitalOut motor_side2(PTA19);

void motor_init()
{
	ftm_config_t ftmInfo;
	ftm_phase_params_t phaseParamsConfigStruct;

	CLOCK_EnableClock(kCLOCK_PortA);                           /* Port B Clock Gate Control: Clock enabled */

	//QEI初始化
	PORT_SetPinMux(PORTA, 8u, kPORT_MuxAlt6);           
	PORT_SetPinMux(PORTA, 9u, kPORT_MuxAlt6);           
	PORT_SetPinMux(PORTA, 10u, kPORT_MuxAlt6);           
	PORT_SetPinMux(PORTA, 11u, kPORT_MuxAlt6);           
 
	/* Initialize FTM module */
	FTM_GetDefaultConfig(&ftmInfo);
	ftmInfo.prescale = kFTM_Prescale_Divide_32;
	FTM_Init(FTM1, &ftmInfo);
	FTM_Init(FTM2, &ftmInfo);

	/* Set the modulo values for Quad Decoder. */
	FTM_SetQuadDecoderModuloValue(FTM1, 0U, 0xFFFF);
	FTM_SetQuadDecoderModuloValue(FTM2, 0U, 0xFFFF);

	/* Enable the Quad Decoder mode. */
	phaseParamsConfigStruct.enablePhaseFilter = true;
	phaseParamsConfigStruct.phaseFilterVal = 15;
	phaseParamsConfigStruct.phasePolarity = kFTM_QuadPhaseNormal;
	FTM_SetupQuadDecode(FTM1, &phaseParamsConfigStruct, /* Phase A. */
						&phaseParamsConfigStruct,                    /* Phase B. */
						kFTM_QuadPhaseEncode);
	FTM_SetupQuadDecode(FTM2, &phaseParamsConfigStruct, /* Phase A. */
						&phaseParamsConfigStruct,                    /* Phase B. */
						kFTM_QuadPhaseEncode);


	motor1_CHA.period_us(100);
	// motor1_CHB.period_us(100);

	motor1_CHA = 0.00;
	// motor1_CHB = 0.90;
	motor_side1 = 0;
	motor_side2 = 0;
}

int16_t QEI1 = 0;
int16_t QEI2 = 0;
void get_qei()
{
	QEI1 = (int16_t)FTM_GetQuadDecoderCounterValue(FTM1);
	/* Clear counter */
	// FTM_ClearQuadDecoderCounterValue(FTM1);

	QEI2 = (int16_t)FTM_GetQuadDecoderCounterValue(FTM2);
	/* Clear counter */
	// FTM_ClearQuadDecoderCounterValue(FTM2);
}





