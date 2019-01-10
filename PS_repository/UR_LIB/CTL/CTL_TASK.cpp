#include "mbed.h"

#include "include.h"

extern void ann_start_qlearning(int epochs, float gamma, float epsilon);

void CTL_app()
{
	fs.mount(&sd);


	ann_start_qlearning(200000, 0.9, 1.0);

}


