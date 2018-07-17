#include "mbed.h"
#include "CTL.h"
float Fix2Float(int32_t Fix_data)
{
	float fl_data;

	fl_data = Fix_data / 32768.;

	return fl_data;
}

int32_t Float2Fix(float fl_data )
{
	int32_t fix_data;

	fix_data = fl_data * 32768 ;

	return fix_data;
}


