# YJ432-PL-PS

ARM+FPGA borad demo

### Introduction

Based on NXP-Kinetis (*K64*) and Xilinx-Aritx-7 (*XC7A35T*), it's an *Arm + FPGA* evaluation board.
The Arm is developed based on *Arm mbed-OS*. FPGA is regarded as an accelerating peripheral which is mount on Arm.
It's very simular to **ZYNQ**, but it's much more accessible for a beginner in university.

-----------------------

### Feature

* Arm
    - Flexbus
    - TF Card File System

* FPGA
    - Three color LEDs
    - Buzzer
    - Three Boot method
        + TF Card Boot based on Arm
        + QSPI Flash Boot
        + JTAG Boot
    - Porject in TCL Script

--------------

### Construction

[PCB Board](https://github.com/whutddk/MK64F-platform/releases/tag/mkPF3.0.0)

* PS
    - demo (demo project)
    - hw_config (configuration file of mbed-OS to support this evaluation board)
    - Template (demo source files)
* PL
    - bitstream (prebuild bitstream file to test demo software)
    - Template
        + constrs (constraint file of this evaluation board)
        + tclProject (tcl script in non-project mode of vivado)
        + testbench (simulator file)
        + TODO (necessary demo but not finished yet)
        + untest (complete file but not tested yet)
        + verilog ( the verilog file can be used )