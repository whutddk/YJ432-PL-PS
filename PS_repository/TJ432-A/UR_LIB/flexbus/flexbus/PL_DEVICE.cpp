#include "mbed.h"

#include "PL_DEF.h"


volatile uint32_t * bzled_reg = (uint32_t*)( PL_START_ADDRESS | BZLED_BASE );
volatile uint32_t * pwm0_reg = (uint32_t*)( PL_START_ADDRESS | PWM0_BASE );
volatile uint32_t * qei0_reg = (uint32_t*)( PL_START_ADDRESS | QEI0_BASE );


volatile uint32_t *LED_FRE_REG = bzled_reg + 0;
volatile uint32_t *BZ_FRE_REG = bzled_reg + 1;
volatile uint32_t *RED_DUTY_REG = bzled_reg + 2;
volatile uint32_t *GREEN_DUTY_REG = bzled_reg + 3;
volatile uint32_t *BLUE_DUTY_REG = bzled_reg + 4;

volatile uint32_t *PWM0_FRE_REG = pwm0_reg + 0;
volatile uint32_t *PWM0_CH0_REG = pwm0_reg + 1;
volatile uint32_t *PWM0_CH1_REG = pwm0_reg + 2;

volatile uint32_t *QEI0_CLEAR_REG = qei0_reg + 0;
volatile uint32_t *QEI0_CH0_REG = qei0_reg + 1;





