#include "mbed.h"

#include "include.h"



void CTL_app()
{
	fs.mount(&sd);

	
	ann_start_qlearning(200, 0.9, 1.0);

}


