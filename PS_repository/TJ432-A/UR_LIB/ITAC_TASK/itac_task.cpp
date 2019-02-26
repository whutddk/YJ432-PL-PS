#include "mbed.h"
#include "ITAC.h"


void itac_app()
{
	
	fc.printf("FREECARS INITIALIZATION COMPLETE!");
	while(1)
	{
		bzled_work();
	}

}

void FC_app()
{
	freecars_init();

	while(1)
	{
		// sendDataToScope();
		wait(0.01);
	}
}





