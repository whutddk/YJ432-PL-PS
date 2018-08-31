#include "mbed.h"

#include "PL_DEF.h"


volatile uint32_t * bzled_reg = (uint32_t*)( PL_START_ADDRESS | BZLED_BASE );
// volatile uint32_t * pwm0_reg = (uint32_t*)( PL_START_ADDRESS | PWM0_BASE );
// volatile uint32_t * qei0_reg = (uint32_t*)( PL_START_ADDRESS | QEI0_BASE );
// volatile uint32_t *po3PID0_reg = (uint32_t*)( PL_START_ADDRESS | PO3PID0_BASE );
// volatile uint32_t *po3PID1_reg = (uint32_t*)( PL_START_ADDRESS | PO3PID1_BASE );
volatile uint32_t *TJBMP3_reg = (uint32_t*)( PL_START_ADDRESS | TJBMP3_BASE );


volatile uint32_t *LED_FRE_REG = bzled_reg + 0;
volatile uint32_t *BZ_FRE_REG = bzled_reg + 1;
volatile uint32_t *RED_DUTY_REG = bzled_reg + 2;
volatile uint32_t *GREEN_DUTY_REG = bzled_reg + 3;
volatile uint32_t *BLUE_DUTY_REG = bzled_reg + 4;

// volatile uint32_t *PWM0_FRE_REG = pwm0_reg + 0;
// volatile uint32_t *PWM0_CH0_REG = pwm0_reg + 1;
// volatile uint32_t *PWM0_CH1_REG = pwm0_reg + 2;

// volatile uint32_t *QEI0_CLEAR_REG = qei0_reg + 0;
// volatile uint32_t *QEI0_CH0_REG = qei0_reg + 1;

// //po3_PID0 moudle address
// volatile uint32_t *po3PID0_FREQ_REG = po3PID0_reg + 0;
// volatile uint32_t *po3PID0_AIM_REG = po3PID0_reg + 1;
// volatile uint32_t *po3PID0_CUR_REG = po3PID0_reg + 2;
// volatile uint32_t *po3PID0_ERS_REG = po3PID0_reg + 3;
// volatile uint32_t *po3PID0_KPS_REG = po3PID0_reg + 4;
// volatile uint32_t *po3PID0_KIS_REG = po3PID0_reg + 5;
// volatile uint32_t *po3PID0_KDS_REG = po3PID0_reg + 6;
// volatile uint32_t *po3PID0_ERM_REG = po3PID0_reg + 7;
// volatile uint32_t *po3PID0_KPM_REG = po3PID0_reg + 8;
// volatile uint32_t *po3PID0_KIM_REG = po3PID0_reg + 9;
// volatile uint32_t *po3PID0_KDM_REG = po3PID0_reg + 10;
// volatile uint32_t *po3PID0_ERB_REG = po3PID0_reg + 11;
// volatile uint32_t *po3PID0_KPB_REG = po3PID0_reg + 12;
// volatile uint32_t *po3PID0_KIB_REG = po3PID0_reg + 13;
// volatile uint32_t *po3PID0_KDB_REG = po3PID0_reg + 14;
// volatile uint32_t *po3PID0_OUT_REG = po3PID0_reg + 15;

// //po3_PID1 module address
// volatile uint32_t *po3PID1_FREQ_REG = po3PID1_reg + 0;
// volatile uint32_t *po3PID1_AIM_REG = po3PID1_reg + 1;
// volatile uint32_t *po3PID1_CUR_REG = po3PID1_reg + 2;
// volatile uint32_t *po3PID1_ERS_REG = po3PID1_reg + 3;
// volatile uint32_t *po3PID1_KPS_REG = po3PID1_reg + 4;
// volatile uint32_t *po3PID1_KIS_REG = po3PID1_reg + 5;
// volatile uint32_t *po3PID1_KDS_REG = po3PID1_reg + 6;
// volatile uint32_t *po3PID1_ERM_REG = po3PID1_reg + 7;
// volatile uint32_t *po3PID1_KPM_REG = po3PID1_reg + 8;
// volatile uint32_t *po3PID1_KIM_REG = po3PID1_reg + 9;
// volatile uint32_t *po3PID1_KDM_REG = po3PID1_reg + 10;
// volatile uint32_t *po3PID1_ERB_REG = po3PID1_reg + 11;
// volatile uint32_t *po3PID1_KPB_REG = po3PID1_reg + 12;
// volatile uint32_t *po3PID1_KIB_REG = po3PID1_reg + 13;
// volatile uint32_t *po3PID1_KDB_REG = po3PID1_reg + 14;
// volatile uint32_t *po3PID1_OUT_REG = po3PID1_reg + 15;

volatile uint32_t *TJBMP3_STREAM_REG = (uint32_t*)TJBMP3_reg;	//数据流

volatile uint32_t *TJBMP3_MESSAGE_REG = (uint32_t*)( PL_START_ADDRESS | 0x07810000U );

volatile uint32_t *TJBMP3_VBUFOFFSET_REG = (uint32_t*)( PL_START_ADDRESS | 0x07810004U );

volatile uint32_t *TJBMP3_STATE_REG = (uint32_t*)( PL_START_ADDRESS | 0x07810008U );

volatile uint32_t *TJBMP3_VINDEXOFS_REG = (uint32_t*)( PL_START_ADDRESS | 0x0781000CU );

volatile uint32_t *TJBMP3_FDCTSETTG_REG = (uint32_t*)( PL_START_ADDRESS | 0x07810010U );




