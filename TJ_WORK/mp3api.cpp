#include "mbed.h"
#include "include.h"
#include "BSP.h"
#include "ctl.h"

volatile bool isFinished = true;
short buf_rec1[2304];
short buf_rec2[2304];
unsigned char flag_sw = 0; 
unsigned char buf_read[NUM_BYTE_READ];
extern DigitalOut BZ;	
// void trigger() 
// {
// 	isFinished = true;
// 	printf("triggered!\n");
// }


void play_mp3(char* filename)
{

	uint32_t temp = 0;

	int32_t offset;
	uint8_t *read_ptr;
	int byte_left = NUM_BYTE_READ;
	uint32_t res_dec;
	unsigned int num_read;
	MP3DecInfo *mp3_dec;

	read_ptr = buf_read;

	mp3_dec = (MP3DecInfo*)MP3InitDecoder();

	FILE* fd;

	
	char mp3file[50] = "/fs/";
	strcat(mp3file,filename);
	uartpc.printf("open %s!\r\n",mp3file);
	fd = fopen(mp3file,"rb");
	if (fd == NULL)
	{
		uartpc.printf(" Failure. %d \r\n", errno);
		return;
	}
	else
	{
		uartpc.printf(" done.\r\n");
	}

	

	fread(buf_read,1,NUM_BYTE_READ,fd);
	uartpc.printf("start to trace\r\n");
	int flag_start = 0;
	wait(1);
	BZ =1 ;
	// LCRK.fall(&trigger);
	isTransferCompleted = true;
	isFinished = true;

	while(1)
	{
		// if ( VETO.read() == 0 )
		// {
		// 	G_Light = 0;
		// 	R_Light = 1;
		// 	B_Light = 1;
		// 	while(VETO.read() == 0);
		// 	wait(1);
		// 	G_Light = 1;
		// 	R_Light = 0;
		// 	B_Light = 0;
		// 	uartpc.printf("Next Song!\r\n");
		// 	break;
		// }

		// if ( COFM.read() == 0 )
		// {
		// 	wait(0.01);
		// 	while(COFM.read() == 0);
		// 	G_Light = 1;
			
		// 	B_Light = 0;
		// 	R_Light = download_enable;
		// 	download_enable ^= 0x01;
			
		// 	uartpc.printf("Download enable = %d\r\n",download_enable);
		// }
		//uartpc.printf("\r\n\r\n%s\r\n%d\r\n",read_ptr,sizeof(buf_read));
		offset = MP3FindSyncWord(read_ptr, byte_left);
		if (offset < 0 ) 
		{
			//uartpc.printf("offset:%d\r\n",offset);
			if( flag_start == 0 )
			{
				fread(buf_read,1,NUM_BYTE_READ,fd);
				if ( num_read == 0 )
				{
					break;
				}
				continue;
			}
			else
			{
				break;
			}
		} 
		else 
		{
			BZ = 0;
			flag_start = 1;
			read_ptr += offset;         //data start point
			byte_left -= offset;        //in buffer
// uartpc.printf("GO0\r\n");
			if ( flag_sw == 0 )
			{
				
				res_dec = MP3Decode(mp3_dec, &read_ptr, (int *)&byte_left, buf_rec1, 0);
				
			}
			else
			{
				
				res_dec = MP3Decode(mp3_dec, &read_ptr, (int *)&byte_left, buf_rec2, 0);
				
			}
// uartpc.printf("GO0.5\r\n");
			if (res_dec != ERR_MP3_NONE)
			{
				uartpc.printf("MP3Decode error:%d!\n\r",res_dec);
				read_ptr += 2;
				flag_start = 0;
				num_read = fread(buf_read,1,NUM_BYTE_READ,fd);
				if ( num_read == 0 )
				{
					break;
				}
				continue;
			}
		// uartpc.printf("GO1\r\n");
			// led1 = 1;



			while( isTransferCompleted == false )//|| isFinished == false )
			{
				;
			}
			 while(!LCRK.read());
   //      	while(!LCRK.read());
			// led1 = 0;
			// isFinished = false;
			isTransferCompleted = false;
			// uartpc.printf("GO2\r\n");
			// while(!LCRK.read());
			// while(LCRK.read());

		    if ( flag_sw == 0 )
		    {
		        temp = (uint32_t)buf_rec1;
		        flag_sw = 1;
		    }
		    else
		    {
		        temp = (uint32_t)buf_rec2;
		        flag_sw = 0;
		    }

		    // /*  xfer structure */
		    // xfer.data = (uint8_t *)temp;
		    // xfer.dataSize = 4608;
		    // SAI_TransferSendEDMA(I2S0, &txHandle, &xfer);

		    masterXfer.txData = (uint8_t *)temp;
		    masterXfer.rxData = NULL;
		    masterXfer.dataSize = 4608;
		    masterXfer.configFlags = kDSPI_MasterCtar0 | kDSPI_MasterPcs0 | kDSPI_MasterPcsContinuous;
		    // uartpc.printf("GO3\r\n");
		    if (kStatus_Success !=
		        DSPI_MasterTransferEDMA(SPI0, &g_dspi_edma_m_handle, &masterXfer))
		    {
		        uartpc.printf("There is error when start DSPI_MasterTransferEDMA \r\n ");
		    }
		    else
		    {
		        // uartpc.printf(" start DSPI_MasterTransferEDMA DONE\r\n ");
		    }


			if (byte_left < NUM_BYTE_READ) 
			{
				memmove(buf_read,read_ptr,byte_left);

				num_read = fread(buf_read + byte_left,1,NUM_BYTE_READ - byte_left,fd);

				if(num_read == 0) 
				{
					uartpc.printf("num_read:%d\r\n",num_read);
					break;
				}
				if (num_read < NUM_BYTE_READ - byte_left)
				{
					memset(buf_read + byte_left + num_read, 0, NUM_BYTE_READ - byte_left - num_read);
				}
				byte_left = NUM_BYTE_READ;
				read_ptr = buf_read;
			}
		}
	}
	MP3FreeDecoder(mp3_dec);
	fclose(fd);

	uartpc.printf("MP3 file:%s decorder is over!\n\r" ,mp3file);
}


void playlist_init()
{
	uartpc.printf("\r\nCreate Play List\r\n");

	struct list *lists = NULL;
	lists = (struct list *)malloc(sizeof(struct list));
	if ( NULL == lists )
	{
		uartpc.printf("\r\nPlay List Init Error!\r\n");
	}


	DIR* dir = opendir("/fs");
	errno_error(dir);

	struct dirent* de;
	// uartpc.printf("Printing all filenames:\r\n");

	// if ( ( de = readdir(dir)) != NULL )
	// {
	// 	strcat(lists -> data, &(de->d_name)[0]);
	// 	lists -> next = NULL;
	// 	Playlist_HEAD = lists;
	// 	Playlist_END = lists;
	// 	uartpc.printf("Add %s into Play List\r\n", &(de->d_name)[0]);
	// }


	while((de = readdir(dir)) != NULL)
	{
		
		//uartpc.printf("Format %d \r\n", de->d_type);
		if ( de->d_type == 5 )
		{
			list_add(1,&(de->d_name)[0]);
			uartpc.printf("Add %s into Play List\r\n", &(de->d_name)[0]);
		}
	}

	uartpc.printf("\r\nCloseing root directory. \r\n");
	closedir(dir);
	// return_error(error);

}