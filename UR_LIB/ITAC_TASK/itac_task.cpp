#include "mbed.h"
#include "ITAC.h"


void itac_app()
{
	// freecars_init();
	fc.printf("FREECARS INITIALIZATION COMPLETE!");
	while(1)
	{
		bzled_work();
	}

}





