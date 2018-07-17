#include "mbed.h"

#include "include.h"

AnalogIn pos(PTB2);

struct _ctl ctl;



uint8_t parallel_cnt = 0;

void get_pos()
{
	uint32_t pos_raw[2];
	uint8_t i;
	pos_raw[0] = pos.read_u16();

	for ( i = 0; i < 9 ;i++ )
	{
		pos_raw[1] = pos.read_u16();
		pos_raw[0] = ( pos_raw[0] + pos_raw[1] ) / 2;
	}
	ctl.pend.cur = pos_raw[0];
}



void control()
{
	* (po3PID0_CUR_REG) = ctl.pend.cur;
	* (po3PID1_CUR_REG) = QEI1;

	
	//GET PID1 RESULT
	ctl.motto.result = Fix2Float( *po3PID1_OUT_REG );

	push( 4,(int16_t)(ctl.motto.result) );

	// if ( ctl.motto.result > 5000.00 )
	// {
	// 	ctl.motto.result = 5000.00;
	// }
	// else if ( ctl.motto.result < -5000.00 )
	// {
	// 	ctl.motto.result = -5000.00;
	// }

	
	//GET PID0 RESULT
	ctl.pend.result =  Fix2Float( *po3PID0_OUT_REG ); 
	ctl.out = (int32_t)( ctl.pend.result - ctl.motto.result ) ;

	

// OUTPUT PWM0
	if ( ctl.flag_end == 1 )
	{	
		*(po3PID0_KPS_REG) = * (po3PID0_KDS_REG) = * (po3PID0_KPM_REG) = * (po3PID0_KDM_REG)
		= * (po3PID0_KPB_REG) = * (po3PID0_KDB_REG) = *(po3PID1_KPS_REG) = *(po3PID1_KPM_REG) = *(po3PID1_KPB_REG) = 
		*(po3PID1_KDS_REG) = *(po3PID1_KDM_REG) = *(po3PID1_KDB_REG) = 0;
	}
	else
	{
		
	}


}



void CTL_app()
{
	int32_t perf_record = 0;



	motor_init();

	ctl.pend.aim = 24400;
	ctl.pend.error[1] = 0;
	ctl.pend.error[0] = 0;


	ctl.motto.aim = 0;
	ctl.motto.error[1] = 0;
	ctl.motto.error[0] = 0;
	ctl.flag_end = 1;

	while(1)
	{
		timer.start();
		perf_record = timer.read_us();

		get_qei();
		get_pos();
		push(0,QEI1);
		// push(1,QEI2);
		push(2,(int16_t)(*(po3PID0_CUR_REG) - *(po3PID0_AIM_REG) ));
		control();
		push(3,(int16_t)(ctl.pend.result));
		push(20,timer.read_us() - perf_record);


		wait(0.005);
	}
}


