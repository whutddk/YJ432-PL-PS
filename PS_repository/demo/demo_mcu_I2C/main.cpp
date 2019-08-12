/* mbed Microcontroller Library
 * Copyright (c) 2018 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */

#include "mbed.h"
//#include "stats_report.h"

I2C i2c(PTA11 , PTA12);//I2C_SDA=PTA11,I2C_SCL=PTA12
int main() 
{
    char cmd[2];
    while (1) 
    {
        cmd[0] = 0x01;
        cmd[1] = 0x00;
        // read and write takes the 8-bit version of the address.
        // set up configuration register (at 0x01)
        i2c.write(0x00, cmd, 2);
        wait(0.1);
        // read temperature register
        cmd[0] = 0x00;
        i2c.write(0x00, cmd, 1);
    }
}
