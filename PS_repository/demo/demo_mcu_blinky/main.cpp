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

#define SLEEP_TIME                  500 // (msec)
#define PRINT_AFTER_N_LOOPS         20

// main() runs in its own thread in the OS
//int main()
//{   
//    SystemReport sys_state( SLEEP_TIME * PRINT_AFTER_N_LOOPS /* Loop delay time in ms */);

//    int count = 0;
//    while (true) {
        // Blink LED and wait 0.5 seconds
//       led1 = !led1;
//        wait_ms(SLEEP_TIME);

//       if ((0 == count) || (PRINT_AFTER_N_LOOPS == count)) {
            // Following the main thread wait, report on the current system status
//            sys_state.report_state();
//       }
//        ++count;
//  }
//}


int main()
{
   while(1){
        if (sw1.read()==1)
            led1=0;
        else led1=1;
        if (sw2.read()==1/* condition */)
            led2=0;
        else led2=1;
        if (key1.read()==1)
            Ring1=0;
        else Ring1=1;  
        }
   
}
