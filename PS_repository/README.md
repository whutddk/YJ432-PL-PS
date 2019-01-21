# YJ432-PS

ARM+FPGA borad demo

-----------------------------

## How to Setup Target of Mbed-os

* checkout mbed-os to latest release 
    -  **mbed-os-5.11.1**
    -  commit id : c966348d3f9ca80843be7cdc9b748f06ea73ced0
* cd to ***mbed-os/targets*** and add the following code into ***targets.json***
>   "K64ARM4FPGA": {
>        "core": "Cortex-M4F",
>        "supported_toolchains": ["ARM", "GCC_ARM", "IAR"],
>        "extra_labels": ["Freescale", "MCUXpresso_MCUS", "KSDK2_MCUS", "ARM4FPGA", "KPSDK_MCUS", "KPSDK_CODE", "MCU_K64F"],
>        "is_disk_virtual": true,
>        "macros": ["CPU_MK64FX512VMD12", "FSL_RTOS_MBED"],
>        "inherits": ["Target"],
>        "detect_code": ["0240"],
>        "device_has": ["USTICKER", "LPTICKER", "RTC", "CRC", "ANALOGIN", "ANALOGOUT", "I2C", "I2CSLAVE", "INTERRUPTIN", "PORTIN", "PORTINOUT", "PORTOUT", "PWMOUT", "SERIAL", "SERIAL_FC", "SERIAL_ASYNCH", "SLEEP", "SPI", "SPI_ASYNCH", "SPISLAVE", "STDIO_MESSAGES", "STORAGE", "TRNG", "FLASH"],
>        "features": ["STORAGE"],
>        "release_versions": ["2", "5"],
>        "device_name": "MK64FX512xxx12",
>        "bootloader_supported": true
    }

* cd to ***mbed-os/targets/TARGET_Freescale*** and add the floowing code into **mbed_rtx.h***
> #elif defined(TARGET_K64ARM4FPGA)

> #ifndef INITIAL_SP

> #define INITIAL_SP              (0x20030000UL)

> #endif

* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F*** and duplicate floder ***TARGET_FRDM*** and rename as ***TARGET_ARM4FPGA***

* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/drivers*** and replace the 2 file of sdhc by the file in ***PS_repository/hw_config/mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/drivers***
    - fsl_sdhc.c
    - fsl_sdhc.h

* cd to ***mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/TARGET_ARM4FPGA*** and replace 5 config file by the file in ***PS_repository/hw_config/mbed-os/targets/TARGET_Freescale/TARGET_MCUXpresso_MCUS/TARGET_MCU_K64F/TRAGET_ARM4FPGA***
    - fsl_clock_config.c
    - fsl_clock_config.h
    - PeripheralNames.h
    - PeripheralPins.c
    - PinNames.h

-----------------------------------

## How to Compile multiple Project

* cd to ***PS_repository/demo***
* type 
> mbed compile --source \[projectName\] --source mbed-os --build BUILD/\[projectName\]

----------------------






