#include "include.h"
#include "fann.h"

uint8_t LEDSIT[8] = {0,0,0,0,0,0,0,0};



//get LED states to float vector
static void ann_getLEDs(fann_type *val)
{

	val[3] = val[2];
	val[2] = val[1];
	val[1] = val[0];

	if ( LEDSIT[0] == 1 )
		val[0] = 0.875;
	else if ( LEDSIT[1] == 1 )
		val[0] = 0.625;
	else if ( LEDSIT[2] == 1 )
		val[0] = 0.375;
	else if ( LEDSIT[3] == 1 )
		val[0] = 0.125;
	else if ( LEDSIT[4] == 1 )
		val[0] = -0.125;
	else if ( LEDSIT[5] == 1 )
		val[0] = -0.375;
	else if ( LEDSIT[6] == 1 )
		val[0] = -0.625;
	else if ( LEDSIT[7] == 1 )
		val[0] = -0.875;

}


//get LED states and the states before to a float vector
static fann_type old_led_state[4];

static void ann_getLEDsWithOld(fann_type *val)
{

	// val[0] = LEDSIT[0] ? 1.0 : -1.0;
	val[3] = old_led_state[2];
	val[2] = old_led_state[1];
	val[1] = old_led_state[0];

	if ( LEDSIT[0] == 1 )
		val[0] = 0.875;
	else if ( LEDSIT[1] == 1 )
		val[0] = 0.625;
	else if ( LEDSIT[2] == 1 )
		val[0] = 0.375;
	else if ( LEDSIT[3] == 1 )
		val[0] = 0.125;
	else if ( LEDSIT[4] == 1 )
		val[0] = -0.125;
	else if ( LEDSIT[5] == 1 )
		val[0] = -0.375;
	else if ( LEDSIT[6] == 1 )
		val[0] = -0.625;
	else if ( LEDSIT[7] == 1 )
		val[0] = -0.875;


}

static void show_led()
{
	fc.printf("show:\r\nLED0=%d LED1=%d LED2=%d LED3=%d LED4=%d LED5=%d LED6=%d LED7=%d \n\r"
	,LEDSIT[0],LEDSIT[1],LEDSIT[2],LEDSIT[3],LEDSIT[4],LEDSIT[5],LEDSIT[6],LEDSIT[7]);
}

static void ann_setLEDs(int index)
{
	//save old state internal!
	ann_getLEDs(old_led_state);

	LEDSIT[0] = 0;
	LEDSIT[1] = 0;
	LEDSIT[2] = 0;
	LEDSIT[3] = 0;
	LEDSIT[4] = 0;
	LEDSIT[5] = 0;
	LEDSIT[6] = 0;
	LEDSIT[7] = 0;

	//to switch all LEDs short time off -> if the same LED lights up
	wait(0.3);

	switch(index)
	{
		case 0:
			LEDSIT[0] = 1;
			break;
		case 1:
			LEDSIT[1] = 1;
			break;
		case 2:
			LEDSIT[2] = 1;
			break;
		case 3:
			LEDSIT[3] = 1;
			break;
		case 4:
			LEDSIT[4] = 1;
			break;
		case 5:
			LEDSIT[5] = 1;
			break;
		case 6:
			LEDSIT[6] = 1;
			break;
		case 7:
			LEDSIT[7] = 1;
			break;
		default:
			fc.printf("Action error!\n\r");
			break;
	}
	show_led();

}


#define num_inputs  4
#define num_outputs 1
extern int auto_checkout(int lednum);
void ann_start_qlearning(int epochs, float gamma, float epsilon)
{

	//create ann -> 1 hidden layer with 4 neurons


	struct fann *ann = fann_create_standard(10, num_inputs, 50, 50, 50, 50, 50, 50, 50, 50, num_outputs);

	//stepwise is more then two times faster

	//use symmetric to deal with -1.0 and 1.0 or normal for 0.0 to 1.0

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);

	fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);

	//register two buffers and two pointers, to swap the buffers fast

	fann_type new_inputs[num_inputs];
	fann_type old_inputs[num_inputs];

	fann_type *new_in_p = new_inputs;
	fann_type *old_in_p = old_inputs;


	//set the LEDs the first time
	ann_setLEDs(0);

	//fill the buffer with the LED states
	ann_getLEDsWithOld(old_in_p); //fill array;

	for(int i = 0; i < epochs; i++ )
	{
		int action;
		//run ann network
		fann_type *qval_p = fann_run(ann, old_in_p);

		//copy output data -> later use
		//because qval_p is just a pointer no allocated mem
		fann_type qval[num_outputs];

		for(int x = 0; x < num_outputs; x++)
		{
			qval[x] = qval_p[x];
		}
		//if epsilon is high, we use random actions
		//we should make all possible actions to train this

		// produce a random data
		if((float)rand() / RAND_MAX < epsilon)
		{
			action = rand() % num_outputs;
			fc.printf("Use random action\n");
		} 
		else  //use fann data
		{
			fc.printf("Use a winner action\n");

			action = 0;
		
			if ( qval_p[0] > 0.7500 )
			{
				action = 0;
			}
			else if ( qval_p[0] > 0.5000 )
			{
				action = 1;
			}
			else if ( qval_p[0] > 0.2500 )
			{
				action = 2;
			}
			else if ( qval_p[0] > 0.0000 )
			{
				action = 3;
			}
			else if ( qval_p[0] > -0.2500 )
			{
				action = 4;
			}
			else if ( qval_p[0] > -0.5000 )
			{
				action = 5;
			}
			else if ( qval_p[0] > -0.7500 )
			{
				action = 6;
			}
			else 
			{
				action = 7;
			}
			
			fc.printf("result is %f\n\r", qval_p[0]);
			fc.printf("Index: %d\n", action);
		}



		//do the action that the ann predict...
		//let light up a LED (only one, but could be the same)
		ann_setLEDs(action);
		
		//waiting for user reward!
		fann_type reward = 0.0;
		fc.printf("Reinforce now!\n");

		if ( auto_checkout(action) )
		{
			reward = 1.0;
			fc.printf("comfirm!\n\r");
		}
		else
		{
			reward = -1.0;
			fc.printf("veto!\n\r");
		}
		wait(0.1);

		//display reward decision

		fc.printf("reward: %f\n", reward);

		//fill array with new state
		ann_getLEDsWithOld(new_in_p);

		//debug output


		//run ann with new inputs

		fann_type *newQ = fann_run(ann, new_in_p);

		fann_type maxQ;
		
		maxQ = newQ[0];

		//debug outputs

		fc.printf("MaxNewQ: %f\n", maxQ);

		//set the old values as train data (output) - use new max in equation

		qval[0] = (reward < 0.0) ? (reward + (gamma * maxQ)) : reward;

		//this function use always backpropagation algorithm!
		//fann_set_training_algorithm has no effect!
		//or same as fann_set_training_algorithm = incremental and train epoch
		//train ann   , input, desired outputs
		fann_train(ann, old_in_p, qval);

		//switch pointer -> new data, to old data
		fann_type *temp = old_in_p;
		old_in_p = new_in_p;
		new_in_p = temp;

		//Decrease epsilon
		if(epsilon > 0.1)
		{
			epsilon -= ( 1.0 / epochs );
		}
	}



	//mark that we go to the execution state

	//set all LEDs

	// HAL_GPIO_WritePin(LD3_GPIO_Port, LD3_Pin, 1);
	// HAL_GPIO_WritePin(LD4_GPIO_Port, LD4_Pin, 1);
	// HAL_GPIO_WritePin(LD5_GPIO_Port, LD5_Pin, 1);
	// HAL_GPIO_WritePin(LD6_GPIO_Port, LD6_Pin, 1);
	// HAL_Delay(500);



	//fun fact... ann starts from unseen training data (all leds on)
	//display pattern after training
	//execute forever
	while(1)
	{
		//get position
		ann_getLEDs(new_in_p);
		//execute ann
		fann_type *exec_out = fann_run(ann, new_in_p);
		//search the maximum in the output array
		int index = 0;

		if ( exec_out[0] > 0.7500 )
			{
				index = 0;
			}
			else if ( exec_out[0] > 0.5000 )
			{
				index = 1;
			}
			else if ( exec_out[0] > 0.2500 )
			{
				index = 2;
			}
			else if ( exec_out[0] > 0.0000 )
			{
				index = 3;
			}
			else if ( exec_out[0] > -0.2500 )
			{
				index = 4;
			}
			else if ( exec_out[0] > -0.5000 )
			{
				index = 5;
			}
			else if ( exec_out[0] > -0.7500 )
			{
				index = 6;
			}
			else 
			{
				index = 7;
			}

		//set next LED
		ann_setLEDs(index);
		//delay a bit
		wait(0.1);
	}
}


