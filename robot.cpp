#include "include.h"


int auto_checkout(int lednum)
{
	static int pre_num = 0;

	if ( ( 		lednum == 0 && pre_num == 1 ) 
		|| ( 	lednum == 1 && pre_num == 2 )
		|| ( 	lednum == 2 && pre_num == 3 )
		|| ( 	lednum == 3 && pre_num == 4 ) 
		|| (	lednum == 4 && pre_num == 5 ) 
		|| (	lednum == 5 && pre_num == 6 )
		|| (	lednum == 6 && pre_num == 7 )
		|| (	lednum == 7 && pre_num == 0 )
		)
	{
		pre_num = lednum;
		return 1;
	}
	else
	{
		pre_num = lednum;
		return 0;
	}
}