#ifndef _PL_DEF_
#define _PL_DEF_

// #define PL_ENABLE 1


#define PL_START_ADDRESS 0x60000000U
#define BZLED_BASE  0x00000000U
#define PWM0_BASE   0x00800000U
#define QEI0_BASE	0x01800000U

extern volatile uint32_t *bzled_reg;
extern volatile uint32_t *pwm0_reg;
extern volatile uint32_t *qei0_reg;

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

#endif


