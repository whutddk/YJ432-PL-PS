/* mbed Microcontroller Library
 * Copyright (c) 2018 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */

#include "mbed.h"
#include "stats_report.h"

PwmOut pwm1(PTB0);
int main()
{
    pwm1.period(4.0f);
        //pwm1 = 0.5;
    pwm1.write(0.5f);    
    while(1);  
}