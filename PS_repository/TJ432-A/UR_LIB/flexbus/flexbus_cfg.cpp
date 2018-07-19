#include "mbed.h"
#include "fsl_common.h"
#include "fsl_port.h"
//#include "pin_mux.h"
#include "fsl_flexbus.h"

#include "PL_DEF.h"

#define SOPT2_CLKOUTSEL_FLEXBUS 0x00u /*!<@brief CLKOUT select: FlexBus CLKOUT */


void flexbus_pin_mux()
{
	CLOCK_EnableClock(kCLOCK_PortB);                           /* Port B Clock Gate Control: Clock enabled */
  	CLOCK_EnableClock(kCLOCK_PortC);                           /* Port C Clock Gate Control: Clock enabled */
  	CLOCK_EnableClock(kCLOCK_PortD);                           /* Port D Clock Gate Control: Clock enabled */

	/* PORTB10 (pin E12) is configured as FB_AD19 */
	PORT_SetPinMux(PORTB, 10U, kPORT_MuxAlt5);

	/* PORTB11 (pin E11) is configured as FB_AD18 */
	PORT_SetPinMux(PORTB, 11U, kPORT_MuxAlt5);

	/* PORTB16 (pin E10) is configured as FB_AD17 */
	PORT_SetPinMux(PORTB, 16U, kPORT_MuxAlt5);

	/* PORTB17 (pin E9) is configured as FB_AD16 */
	PORT_SetPinMux(PORTB, 17U, kPORT_MuxAlt5);

	/* PORTB18 (pin D12) is configured as FB_AD15 */
	PORT_SetPinMux(PORTB, 18U, kPORT_MuxAlt5);

	/* PORTB19 (pin D11) is configured as FB_OE_b */
	PORT_SetPinMux(PORTB, 19U, kPORT_MuxAlt5);

	/* PORTB20 (pin D10) is configured as FB_AD31 */
	PORT_SetPinMux(PORTB, 20U, kPORT_MuxAlt5);

	/* PORTB21 (pin D9) is configured as FB_AD30 */
	PORT_SetPinMux(PORTB, 21U, kPORT_MuxAlt5);

	/* PORTB22 (pin C12) is configured as FB_AD29 */
	PORT_SetPinMux(PORTB, 22U, kPORT_MuxAlt5);

	/* PORTB23 (pin C11) is configured as FB_AD28 */
	PORT_SetPinMux(PORTB, 23U, kPORT_MuxAlt5);

	/* PORTB6 (pin F12) is configured as FB_AD23 */
	PORT_SetPinMux(PORTB, 6U, kPORT_MuxAlt5);

	/* PORTB7 (pin F11) is configured as FB_AD22 */
	PORT_SetPinMux(PORTB, 7U, kPORT_MuxAlt5);

	/* PORTB8 (pin F10) is configured as FB_AD21 */
	PORT_SetPinMux(PORTB, 8U, kPORT_MuxAlt5);

	/* PORTB9 (pin F9) is configured as FB_AD20 */
	PORT_SetPinMux(PORTB, 9U, kPORT_MuxAlt5);

	/* PORTC0 (pin B12) is configured as FB_AD14 */
	PORT_SetPinMux(PORTC, 0U, kPORT_MuxAlt5);

	/* PORTC1 (pin B11) is configured as FB_AD13 */
	PORT_SetPinMux(PORTC, 1U, kPORT_MuxAlt5);

	/* PORTC10 (pin C7) is configured as FB_AD5 */
	PORT_SetPinMux(PORTC, 10U, kPORT_MuxAlt5);

	/* PORTC11 (pin B7) is configured as FB_RW_b */
	PORT_SetPinMux(PORTC, 11U, kPORT_MuxAlt5);

	/* PORTC12 (pin A7) is configured as FB_AD27 */
	PORT_SetPinMux(PORTC, 12U, kPORT_MuxAlt5);

	/* PORTC13 (pin D6) is configured as FB_AD26 */
	PORT_SetPinMux(PORTC, 13U, kPORT_MuxAlt5);

	/* PORTC14 (pin C6) is configured as FB_AD25 */
	PORT_SetPinMux(PORTC, 14U, kPORT_MuxAlt5);

	/* PORTC15 (pin B6) is configured as FB_AD24 */
	PORT_SetPinMux(PORTC, 15U, kPORT_MuxAlt5);

	/* PORTC16 (pin A6) is configured as FB_CS5_b */
	PORT_SetPinMux(PORTC, 16U, kPORT_MuxAlt5);

	/* PORTC17 (pin D5) is configured as FB_CS4_b */
	PORT_SetPinMux(PORTC, 17U, kPORT_MuxAlt5);

	/* PORTC18 (pin C5) is configured as FB_CS2_b */
	PORT_SetPinMux(PORTC, 18U, kPORT_MuxAlt5);

	/* PORTC19 (pin B5) is configured as FB_CS3_b */
	PORT_SetPinMux(PORTC, 19U, kPORT_MuxAlt5);

	/* PORTC2 (pin A12) is configured as FB_AD12 */
	PORT_SetPinMux(PORTC, 2U, kPORT_MuxAlt5);

	/* PORTC3 (pin A11) is configured as CLKOUT */
	PORT_SetPinMux(PORTC, 3U, kPORT_MuxAlt5);

	/* PORTC4 (pin A9) is configured as FB_AD11 */
	PORT_SetPinMux(PORTC, 4U, kPORT_MuxAlt5);

	/* PORTC5 (pin D8) is configured as FB_AD10 */
	PORT_SetPinMux(PORTC, 5U, kPORT_MuxAlt5);

	/* PORTC6 (pin C8) is configured as FB_AD9 */
	PORT_SetPinMux(PORTC, 6U, kPORT_MuxAlt5);

	/* PORTC7 (pin B8) is configured as FB_AD8 */
	PORT_SetPinMux(PORTC, 7U, kPORT_MuxAlt5);

	/* PORTC8 (pin A8) is configured as FB_AD7 */
	PORT_SetPinMux(PORTC, 8U, kPORT_MuxAlt5);

	/* PORTC9 (pin D7) is configured as FB_AD6 */
	PORT_SetPinMux(PORTC, 9U, kPORT_MuxAlt5);

	/* PORTD0 (pin A5) is configured as FB_CS1_b */
	PORT_SetPinMux(PORTD, 0U, kPORT_MuxAlt5);

	/* PORTD1 (pin D4) is configured as FB_CS0_b */
	PORT_SetPinMux(PORTD, 1U, kPORT_MuxAlt5);

	/* PORTD2 (pin C4) is configured as FB_AD4 */
	PORT_SetPinMux(PORTD, 2U, kPORT_MuxAlt5);

	/* PORTD3 (pin B4) is configured as FB_AD3 */
	PORT_SetPinMux(PORTD, 3U, kPORT_MuxAlt5);

	/* PORTD4 (pin A4) is configured as FB_AD2 */
	PORT_SetPinMux(PORTD, 4U, kPORT_MuxAlt5);

	/* PORTD5 (pin A3) is configured as FB_AD1 */
	PORT_SetPinMux(PORTD, 5U, kPORT_MuxAlt5);

	/* PORTD6 (pin A2) is configured as FB_AD0 */
	PORT_SetPinMux(PORTD, 6U, kPORT_MuxAlt5);

//输出flexbus时钟：40MHz
	SIM->SOPT2 = ((SIM->SOPT2 &
	/* Mask bits to zero which are setting */
				(~(SIM_SOPT2_CLKOUTSEL_MASK)))
	/* CLKOUT select: FlexBus CLKOUT. */
				| SIM_SOPT2_CLKOUTSEL(SOPT2_CLKOUTSEL_FLEXBUS));
}

//天际系列，采用流式传输
void TJ_FB_init()
{
	uint32_t j = 0;

	flexbus_config_t flexbusUserConfig;

	flexbus_pin_mux();

    FLEXBUS_GetDefaultConfig(&flexbusUserConfig);

	flexbusUserConfig.byteEnableMode = 1;
	flexbusUserConfig.autoAcknowledge = true;
	flexbusUserConfig.extendTransferAddress = 0;
	flexbusUserConfig.secondaryWaitStates = 0;
	flexbusUserConfig.byteLaneShift = kFLEXBUS_Shifted;
	flexbusUserConfig.writeAddressHold = kFLEXBUS_Hold1Cycle;
	flexbusUserConfig.readAddressHold = kFLEXBUS_Hold1Or0Cycles;
	flexbusUserConfig.addressSetup = kFLEXBUS_FirstRisingEdge;
	flexbusUserConfig.portSize = kFLEXBUS_4Bytes;
	flexbusUserConfig.group1MultiplexControl = kFLEXBUS_MultiplexGroup1_FB_ALE;
	flexbusUserConfig.group2MultiplexControl = kFLEXBUS_MultiplexGroup2_FB_BE_31_24;
	flexbusUserConfig.group3MultiplexControl = kFLEXBUS_MultiplexGroup3_FB_BE_23_16;
	flexbusUserConfig.group4MultiplexControl = kFLEXBUS_MultiplexGroup4_FB_BE_15_8;
	flexbusUserConfig.group5MultiplexControl = kFLEXBUS_MultiplexGroup5_FB_BE_7_0;

    /* Configure some parameters when using MRAM */
    flexbusUserConfig.chip = 0;
    flexbusUserConfig.waitStates = 0U;                      /* Wait 2 states */
    flexbusUserConfig.chipBaseAddress = PL_START_ADDRESS; /* MRAM address for using FlexBus */
    flexbusUserConfig.chipBaseAddressMask = 0x3FFFFFU;             /* 512 Kbytes memory size */

    // PRINTF("\r\nInitialize FLEXBUS.\r\n");
    /* Initialize and configure FLEXBUS module */
    // FLEXBUS_Init(FB, &flexbusUserConfig);
    
    flexbusUserConfig.chip = 0;
    flexbusUserConfig.waitStates = 0U;                      /* Wait 2 states */
    flexbusUserConfig.chipBaseAddress = 0x60000000U; /* MRAM address for using FlexBus */
    flexbusUserConfig.chipBaseAddressMask = 0x3FFFFFU;             /* 512 Kbytes memory size */

    // PRINTF("\r\nInitialize FLEXBUS.\r\n");
    /* Initialize and configure FLEXBUS module */
    FLEXBUS_Init(FB, &flexbusUserConfig);
    
    // PRINTF("\r\nStart write/read MRAM.\r\n");

    /* Waiting some times */
    for (j = 0; j < 0xFFFFFFU; j++)
    {
        __NOP();
    }

}

