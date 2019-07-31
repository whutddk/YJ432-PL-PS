# Demo-mcu-blinky

- Demonstration of dip switch Control led Lamp and Key Control Buzzer

***

### How to implement
- Burn the program into Flash through Openocd.:
-			(gdb) monitor program mbed-os-example-blinky.bin
- Hardware reset：
-			（gdb）monitor reset init
- GDB debugging

### What's the use
- When sw1 is pressed, led1 is on. 
- When sw2 is pressed, led2 is on.
- Press s3 and the buzzer will sound.

