#ifndef _PL_DEF_
#define _PL_DEF_

// #define PL_ENABLE 1


#define PL_START_ADDRESS 0x60000000U
#define BZLED_BASE  0x00000000U
#define PWM0_BASE   0x00800000U
#define QEI0_BASE	0x01800000U
#define PO3PID0_BASE 0x03400000U
#define PO3PID1_BASE 0x03800000U

extern volatile uint32_t *bzled_reg;
extern volatile uint32_t *pwm0_reg;
extern volatile uint32_t *qei0_reg;
extern volatile uint32_t *po3PID0_reg;

extern volatile uint32_t *LED_FRE_REG;
extern volatile uint32_t *BZ_FRE_REG;
extern volatile uint32_t *RED_DUTY_REG;
extern volatile uint32_t *GREEN_DUTY_REG;
extern volatile uint32_t *BLUE_DUTY_REG;

extern volatile uint32_t *PWM0_FRE_REG;
extern volatile uint32_t *PWM0_CH0_REG;
extern volatile uint32_t *PWM0_CH1_REG;

extern volatile uint32_t *QEI0_CLEAR_REG;
extern volatile uint32_t *QEI0_CH0_REG;

extern volatile uint32_t *po3PID0_FREQ_REG;
extern volatile uint32_t *po3PID0_AIM_REG;
extern volatile uint32_t *po3PID0_CUR_REG;
extern volatile uint32_t *po3PID0_ERS_REG;
extern volatile uint32_t *po3PID0_KPS_REG;
extern volatile uint32_t *po3PID0_KIS_REG;
extern volatile uint32_t *po3PID0_KDS_REG;
extern volatile uint32_t *po3PID0_ERM_REG;
extern volatile uint32_t *po3PID0_KPM_REG;
extern volatile uint32_t *po3PID0_KIM_REG;
extern volatile uint32_t *po3PID0_KDM_REG;
extern volatile uint32_t *po3PID0_ERB_REG;
extern volatile uint32_t *po3PID0_KPB_REG;
extern volatile uint32_t *po3PID0_KIB_REG;
extern volatile uint32_t *po3PID0_KDB_REG;
extern volatile uint32_t *po3PID0_OUT_REG;

extern volatile uint32_t *po3PID1_FREQ_REG;
extern volatile uint32_t *po3PID1_AIM_REG;
extern volatile uint32_t *po3PID1_CUR_REG;
extern volatile uint32_t *po3PID1_ERS_REG;
extern volatile uint32_t *po3PID1_KPS_REG;
extern volatile uint32_t *po3PID1_KIS_REG;
extern volatile uint32_t *po3PID1_KDS_REG;
extern volatile uint32_t *po3PID1_ERM_REG;
extern volatile uint32_t *po3PID1_KPM_REG;
extern volatile uint32_t *po3PID1_KIM_REG;
extern volatile uint32_t *po3PID1_KDM_REG;
extern volatile uint32_t *po3PID1_ERB_REG;
extern volatile uint32_t *po3PID1_KPB_REG;
extern volatile uint32_t *po3PID1_KIB_REG;
extern volatile uint32_t *po3PID1_KDB_REG;
extern volatile uint32_t *po3PID1_OUT_REG;

#endif


