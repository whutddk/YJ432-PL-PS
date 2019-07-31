/* mbed Microcontroller Library
 * Copyright (c) 2018 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */

#include "mbed.h"
#include "stats_report.h"

DigitalOut led1(LED1);
DigitalOut led2(LED2);
DigitalOut Ring1(PTE26);
DigitalIn sw1(PS_SW1);
DigitalIn sw2(PS_SW2);
DigitalIn key1(PS_KEY);

int main()
{
    while(1)
    {
        if ( sw1.read() == 1 )
        {
            led1 = 0;
        }
        else 
        {
            led1 = 1;
        }
        if ( sw2.read() == 1 )
        {
            led2 = 0;
        }
        else 
        {
            led2 = 1;
        }
        if ( key1.read() == 1 )
        {
            Ring1 = 0;
        }
        else 
        {
            Ring1 = 1;
        }  
    }
   
}
