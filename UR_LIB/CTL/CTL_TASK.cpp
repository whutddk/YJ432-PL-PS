#include "mbed.h"

#include "include.h"

AnalogIn pos(PTB3);

struct _ctl ctl;



uint8_t parallel_cnt = 0;

void control()
{
	if ( parallel_cnt == 2 )		//位置控制 位置式
	{
		parallel_cnt = 0;

		ctl.motto.error[0] = ctl.motto.cur = (double)(QEI1 / 1.0);


		// if ( ctl.motto.error[0] < 100.00 && ctl.motto.error[0] > -100.00 )
		// {
		// 	ctl.motto.result = 0;
		// 	ctl.motto.sum = 0 ;
		// }
		// else 
			if ( ctl.motto.error[0] < 300.00 && ctl.motto.error[0] > -300.00 )
		{
			ctl.motto.result = ctl.motto.Kp_s * ctl.motto.error[0];

			ctl.motto.result += ctl.motto.Kd_s * ( ctl.motto.error[0] - ctl.motto.error[1] );
		}
		else if ( ctl.motto.error[0] < 600.00 && ctl.motto.error[0] > -600.00 )
		{
			ctl.motto.result = ctl.motto.Kp_m * ctl.motto.error[0];

			ctl.motto.result += ctl.motto.Kd_m * ( ctl.motto.error[0] - ctl.motto.error[1] );
		}		
		else 
		{
			ctl.motto.result = ctl.motto.Kp_b * ctl.motto.error[0];

			ctl.motto.result += ctl.motto.Kd_b * ( ctl.motto.error[0] - ctl.motto.error[1] );
		}

		ctl.motto.error[3] = ctl.motto.error[2];
		ctl.motto.error[2] = ctl.motto.error[1];
		ctl.motto.error[1] = ctl.motto.error[0];

		push( 4,(int16_t)(ctl.motto.result) );

		if ( ctl.motto.result > 5000.00 )
		{
			ctl.motto.result = 5000.00;
		}
		else if ( ctl.motto.result < -5000.00 )
		{
			ctl.motto.result = -5000.00;
		}


		
	}

		//倒立控制
	{
		parallel_cnt ++;
	
		ctl.pend.cur = (int32_t)(pos.read_u16());

		//简单3分段pid控制(位置式)
		ctl.pend.error[0] = (double)((ctl.pend.cur - ctl.pend.aim) / 1.0);
		if ( (ctl.pend.error[0] < 100 ) && (ctl.pend.error[0] > -100) ) 
		{
			ctl.pend.error[1] = ctl.pend.error[0];
			ctl.pend.result = .0;
		}
		else if( (ctl.pend.error[0] < 3000 ) && (ctl.pend.error[0] > -3000) )
		{
			ctl.pend.result = ctl.pend.Kp_s * ctl.pend.error[0];
			ctl.pend.result += ctl.pend.Kd_s * ( ctl.pend.error[0] - ctl.pend.error[1] );
			ctl.pend.error[1] = ctl.pend.error[0];
		}
		else if( (ctl.pend.error[0] < 5000 ) && (ctl.pend.error[0] > -5000) )
		{
			ctl.pend.result = ctl.pend.Kp_m * ctl.pend.error[0];
			ctl.pend.result += ctl.pend.Kd_m * ( ctl.pend.error[0] - ctl.pend.error[1] );
			ctl.pend.error[1] = ctl.pend.error[0];
		}
		else if( (ctl.pend.error[0] < 10000 ) && (ctl.pend.error[0] > -10000) )
		{
			ctl.pend.result = ctl.pend.Kp_b * ctl.pend.error[0];
			ctl.pend.result += ctl.pend.Kd_b * ( ctl.pend.error[0] - ctl.pend.error[1] );
			ctl.pend.error[1] = ctl.pend.error[0];			
		}
		else
		{
			ctl.pend.result = .0;
		}

		if ( ctl.pend.result > 10000.00 )
		{
			ctl.pend.result = 10000.00;
		}
		else if ( ctl.pend.result < -10000.00 )
		{
			ctl.pend.result = -10000.00;
		}



		push( 3,(int16_t)(ctl.pend.result) );
	}


	ctl.out = (int32_t)( ctl.pend.result - ctl.motto.result ) ;

	

	if ( ctl.flag_end == 1 )
	{	
		* (PWM0_CH0_REG) = 1;
		* (PWM0_CH1_REG) = 1;
	}
	else
	{
		if ( ctl.out >= 10000 )
		{
			* (PWM0_CH0_REG) = 9999;
			* (PWM0_CH1_REG) = 1;
		}
		else if ( ctl.out > 0 )
		{
			* (PWM0_CH0_REG) = (uint32_t)(ctl.out);
			* (PWM0_CH1_REG) = 1;
		}
		else if ( ctl.out > -10000 )
		{
			* (PWM0_CH0_REG) = 1
			* (PWM0_CH1_REG) = (uint32_t)(-ctl.out);
		}
		else
		{
			* (PWM0_CH0_REG) = 1
			* (PWM0_CH1_REG) = 9999;
		}
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
		push(0,QEI1);
		push(1,QEI2);
		push(2,(int16_t)(ctl.pend.error[0]));
		control();

		push(20,timer.read_us() - perf_record);
		wait(0.005);
	}
}


