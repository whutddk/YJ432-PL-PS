# YJ432-PL
ARM+FPGA borad demo

-------------------------------------

## how to config your fpga

* firstly **synthesiz**-**implementation**-**generate bitstream** of your project


### JTAG mode
* switch your jumpter to any mode
* connect xilinx jtag 
* click **open hardware manager** in vivado
* click **open target**
* click **Program device**
* select the bitstream file (*.bit*) your generate and click **Program**

###### be careful, if your mcu will reset the artix-7 (draw **FPGA_INIT** Pin low) when booting, the bitstream you downloaded will be earsed


### QSPI mode

* go to ***tool -> setting -> bitstream*** and select ***bin_file*** option to gererate *.bin* format bitstream to write into the flash
* generate bitstream again
* switch your jumpter to QSPI mode
* connect xilinx jtag 
* click **open hardware manager** in vivado
* click **open target**
* Right click your device and select ***Add Configuration Memory Device*** 
* select **n25q32-3.3v-spi_x1_x2_x4** as QSPI flash
* right click the QSPI in device list and select ***Program Configuration Memory Device***
* select the *.bin* file and comfirm to config
* push the fpga reset butoon to boot fpga


### CPU mode

* go to ***tool -> setting -> bitstream*** and select ***bin_file*** option to gererate *.bin* format bitstream to write into the flash
* generate bitstream again
* switch your jumpter to CPU mode
* rename the *.bin* file as you set in your **mcu_boot** software and copy it into your TF card
* insert the TF card and boot MCU

------------------------------------------



