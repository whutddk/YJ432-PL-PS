# YJ432-PS

ARM+FPGA borad demo

-----------------------------

## How to Setup Target of Mbed-os

* checkout mbed-os to latest release 
    -  **mbed-os-5.11.1**
    -  commit id : c966348d3f9ca80843be7cdc9b748f06ea73ced0
* cd to ***mbed-os/targets*** and add the following code into ***targets.json***
```
"K64ARM4FPGA": {
        "core": "Cortex-M4F",
        "supported_toolchains": ["ARM", "GCC_ARM", "IAR"],
        "extra_labels": ["Freescale", "MCUXpresso_MCUS", "KSDK2_MCUS", "ARM4FPGA", "KPSDK_MCUS", "KPSDK_CODE", "MCU_K64F"],
        "is_disk_virtual": true,
        "macros": ["CPU_MK64FX512VMD12", "FSL_RTOS_MBED"],
        "inherits": ["Target"],
        "detect_code": ["0240"],
        "device_has": ["USTICKER", "LPTICKER", "RTC", "CRC", "ANALOGIN", "ANALOGOUT", "I2C", "I2CSLAVE", "INTERRUPTIN", "PORTIN", "PORTINOUT", "PORTOUT", "PWMOUT", "SERIAL", "SERIAL_FC", "SERIAL_ASYNCH", "SLEEP", "SPI", "SPI_ASYNCH", "SPISLAVE", "STDIO_MESSAGES", "STORAGE", "TRNG", "FLASH"],
        "features": ["STORAGE"],
        "release_versions": ["2", "5"],
        "device_name": "MK64FX512xxx12",
        "bootloader_supported": true
    }
```

* cd to ***mbed-os/targets/TARGET_Freescale*** and add the floowing code into **mbed_rtx.h**
```
 #elif defined(TARGET_K64ARM4FPGA)
 #ifndef INITIAL_SP
 #define INITIAL_SP              (0x20030000UL)
 #endif
```
* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F*** and duplicate floder ***TARGET_FRDM*** and rename as ***TARGET_ARM4FPGA***

* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/drivers*** and replace the 2 file of sdhc by the file in ***PS_repository/hw_config/mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/drivers***
    - fsl_sdhc.c
    - fsl_sdhc.h

* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/TARGET_ARM4FPGA*** and replace 5 config file by the file in ***PS_repository/hw_config/mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/TARGET_ARM4FPGA***
    - fsl_clock_config.c
    - fsl_clock_config.h
    - PeripheralNames.h
    - PeripheralPins.c
    - PinNames.h

-----------------------------------

## How to Compile multiple Project

* cd to ***PS_repository/demo***
* type ``` mbed compile --source \[projectName\] --source mbed-os --build BUILD/\[projectName\] ```

----------------------

## How to Download PS based on openocd

* copy two file in ***PS_repository/hw_config/download-debug/openocd*** into an acceptable place of openocd
    - check your environment variable
    - check the path in files

----------------------------------------

### Cmsis-Dap
* make sure the fireware in **.hex** has been written into the downloader
* copy ***PS_repository/hw_config/download-debug/CMSIS-DAP/cmsis-dap.cfg*** into a acceptable place of openocd
* uncomment the first line of ***mk64f.cfg*** to select Cmsis-dap interface to be enable

### FT2232
* copy ***PS_repository/hw_config/download-debug/FT2232/ft2232D.cfg*** into an acceptable place of openocd
* uncomment the first line of ***mk64f.cfg*** to select FT2232D interface to be enable
* make sure the EEPROM has already been flash.
    - ***FT_Prog*** provided by [FTDI](https://www.ftdichip.com/) can be used to flash the EEPROM of FT2232 
    - If FT2232**D** is used, the **Hardware** of channel 0 (port A) must be set as **245 FIFO** and the driver must be set as **D2XX Direct**, to function as JTAG.The **Hardware** of channel 1 (port B) must be set as **RS232 UART** and the dirver must be set as **Virtual COM Port** to function as Serial COM Port 
    - Select  **USB Device Descriptor** and change the **Product ID** depending on your setting in **ft2232D.cfg**
    - flash the EEPROM using ***FT_Prog***
* replace the **channel 0** driver firmware of FT2232D to **libusbk**

--------------
* connect your download board to your target board
* launch openocd,if the perious work is correct, openocd will listen loaclhost:3333
* copy **.bin** file which contain your fireware to download into an reachable place of openocd
* launch gnu and connect to openocd (loaclhost:3333)
* type monitor program **[program].bin** can download the program into PS
* the debug way of please refer the User [Manual of GUN (arm)](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm)



------------------------------------------








