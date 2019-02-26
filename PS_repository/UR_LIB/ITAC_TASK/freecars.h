/*
name��  FreeCars��λ��ʾ��������
author��FreeCars����
Date:   2014-10-22
site:   Http://FreeCars.taobao.com
QQȺ��  384273254��149168724
��Ȩ��  �˴���ΪFreeCars��λ��Э����룬��������ʹ�ã�Ҳ����������ҵ��;�����뱣���˶����֣�
tips:   ǿ�ҽ���С�����ʹ��FreeCars��Ʒ������ģ����װ��������λ�������￪ʼ��
*/

#ifndef _FREECARS_H_
#define _FREECARS_H_

//FreeCars��λ�� ����������ʾ�� ����ͨ������������λ�����øı�
#define UartDataNum      40 //17	    

//���²�Ҫ�޸�
#define UartRxBufferLen  100
#define UartRxDataLen    41           //FreeCars��λ�����͸�������MCU���գ���Ҫ��
#define UartRxCmdLen     7	      //FreeCars��λ�������������ݳ��ȣ���Ҫ��

#define UartCmdNum  SerialPortRx.Buffer[SerialPortRx.Stack-3]//�����
#define UartCmdData SerialPortRx.Buffer[SerialPortRx.Stack-2]//��������
//�������ݵĳ���ֻҪ�����鳤��Ϊ26=22+3+1������Ϊ���뷢���ַ���ȡ��ͳһ
//ȡ���ݵĳ������ַ����ĳ�����ȣ������ڷ��������ǻ�෢����һЩ
//��Чλ������Ӱ�첻���
typedef struct 
{
  int32_t Stack;
  uint8_t Data;
  uint8_t PreData;
  uint8_t Buffer[UartRxBufferLen];
  uint8_t Enable;
  uint8_t Check;
}SerialPortType;

extern uint8_t uSendBuf[UartDataNum*2];
extern SerialPortType SerialPortRx;
extern double UartData[9];

// extern void freecars_isr();//�����ж�
// extern void UartDebug();
// extern void UartCmd(uint8_t cmdnum,uint8_t cmddata);
extern void sendDataToScope();
extern void push(uint8_t,uint16_t);
extern void freecars_init();
// extern void fuzzy_release();

// #if     FUZZY 

// #define UartRxDeltaLen    62
// #define UartRxRuleLen    40
// void send_rule();
// void send_delta();
// #endif



#endif 


