#include "mbed.h"
#include "include.h"

#define NUM_BYTE_READ 4096

volatile bool isFinished = true;
short buf_rec1[2304];
short buf_rec2[2304];
uint8_t flag_sw = 0; 
uint8_t buf_read[NUM_BYTE_READ];



void play_mp3(char* filename)
{

	uint32_t temp = 0;

	int32_t offset;
	uint8_t *read_ptr;
	int32_t byte_left = NUM_BYTE_READ;
	uint32_t res_dec;
	uint32_t num_read;


	MP3DecInfo *mp3_dec;

	read_ptr = buf_read;

	mp3_dec = (MP3DecInfo*)MP3InitDecoder();

	FILE* fd;

	
	char mp3file[50] = "/fs/";
	strcat(mp3file,filename);

	fc.printf("open %s!\r\n",mp3file);

	fd = fopen(mp3file,"rb");
	if (fd == NULL)
	{
		fc.printf(" Failure. %d \r\n", errno);
		return;
	}
	else
	{
		fc.printf(" done.\r\n");
	}


	// num_read = 1;

	// while(num_read)
	// {
	// 	num_read = fread((void*)TJBMP3_reg,4,4*NUM_BYTE_READ,fd);
	// 	fc.printf("sent %dB\n\r", num_read);
	// 	while(!(*TJBMP3_IsEMPTY_REG));
	// }
	fread(buf_read,1,NUM_BYTE_READ,fd);
	fc.printf("start to trace\r\n");


	int32_t flag_start = 0;

	while(1)
	{
		offset = MP3FindSyncWord(read_ptr, byte_left);

		if (offset < 0 ) 
		{

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
			flag_start = 1;
			read_ptr += offset;         //data start point
			byte_left -= offset;        //in buffer

			if ( flag_sw == 0 )
			{
				
				res_dec = MP3Decode(mp3_dec, &read_ptr, (int *)&byte_left, buf_rec1, 0);
				
			}
			else
			{
				
				res_dec = MP3Decode(mp3_dec, &read_ptr, (int *)&byte_left, buf_rec2, 0);
				
			}

			if (res_dec != ERR_MP3_NONE)
			{
				fc.printf("MP3Decode error:%d!\n\r",res_dec);
				read_ptr += 2;
				flag_start = 0;
				num_read = fread(buf_read,1,NUM_BYTE_READ,fd);
				if ( num_read == 0 )
				{
					break;
				}
				continue;
			}


		    if ( flag_sw == 0 )
		    {
		        temp = (uint32_t)buf_rec1;
		        flag_sw = 1;
		        // num_read = fread((void*)TJBMP3_reg,4,4*NUM_BYTE_READ,fd);
		        memmove((void*)TJBMP3_reg,(void*)temp,4608);
				//fc.printf("sent %dB\n\r", num_read);
				while(!(*TJBMP3_IsEMPTY_REG));


		    }
		    else
		    {
		        temp = (uint32_t)buf_rec2;
		        flag_sw = 0;

		        memmove((void*)TJBMP3_reg,(void*)temp,4608);
		        //fc.printf("sent %dB\n\r", num_read);
				while(!(*TJBMP3_IsEMPTY_REG));
		    }

		    /********************************

			transfer here!!!

			*******************************/
			if (byte_left < NUM_BYTE_READ) 
			{
				memmove(buf_read,read_ptr,byte_left);

				num_read = fread(buf_read + byte_left,1,NUM_BYTE_READ - byte_left,fd);

				if(num_read == 0) 
				{
					fc.printf("num_read:%d\r\n",num_read);
					break;
				}
				if ( num_read < NUM_BYTE_READ - byte_left )
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

	fc.printf("MP3 file:%s decorder is over!\n\r" ,mp3file);
}




