#include "mbed.h"

float Fix2Float(int32_t Fix_data)
{
	float fl_data;
	bool nege = 0;

	if ( Fix_data < 0 )
	{
		Fix_data = -Fix_data;
		nege = 1;
	}

	fl_data = Fix_data >> 15;
	fl_data += ( Fix_data & 0x7fff ) / 32768.

	if ( nege )
	{
		fl_data = -fl_data;
	}

	return fl_data;
}

int32_t Float2Fix(float fl_data )
{
	int32_t fix_data;
	bool nege = 0;

	if ( fl_data < 0 )
	{
		fl_data = -fl_data;
		nege = 1;
	}

	fix_data = ( (int32_t)(fl_data) ) << 15;
	fix_data += ( fl_data - fix_data ) * 32768 ;


	return fix_data
}


