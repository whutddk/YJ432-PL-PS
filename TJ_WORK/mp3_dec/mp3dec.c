/* ***** BEGIN LICENSE BLOCK *****
 * Version: RCSL 1.0/RPSL 1.0
 *
 * Portions Copyright (c) 1995-2002 RealNetworks, Inc. All Rights Reserved.
 *
 * The contents of this file, and the files included with this file, are
 * subject to the current version of the RealNetworks Public Source License
 * Version 1.0 (the "RPSL") available at
 * http://www.helixcommunity.org/content/rpsl unless you have licensed
 * the file under the RealNetworks Community Source License Version 1.0
 * (the "RCSL") available at http://www.helixcommunity.org/content/rcsl,
 * in which case the RCSL will apply. You may also obtain the license terms
 * directly from RealNetworks.  You may not use this file except in
 * compliance with the RPSL or, if you have a valid RCSL with RealNetworks
 * applicable to this file, the RCSL.  Please see the applicable RPSL or
 * RCSL for the rights, obligations and limitations governing use of the
 * contents of the file.
 *
 * This file is part of the Helix DNA Technology. RealNetworks is the
 * developer of the Original Code and owns the copyrights in the portions
 * it created.
 *
 * This file, and the files included with this file, is distributed and made
 * available on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND REALNETWORKS HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 *
 * Technology Compatibility Kit Test Suite(s) Location:
 *    http://www.helixcommunity.org/content/tck
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */


/**************************************************************************************
 * Fixed-point MP3 decoder
 * Jon Recker (jrecker@real.com), Ken Cooke (kenc@real.com)
 * June 2003
 *
 * mp3dec.c - platform-independent top level MP3 decoder API
 **************************************************************************************/

#include "string.h" // J.Sz. 21/04/2006
// #include "hlxclib/string.h"		/* for memmove, memcpy (can replace with different implementations if desired) */
#include "mp3common.h"	/* includes mp3dec.h (public API) and internal, platform-independent API */

/**************************************************************************************
 * Function:    MP3InitDecoder
 *
 * Description: allocate memory for platform-specific data
 *              clear all the user-accessible fields
 *
 * Inputs:      none
 *
 * Outputs:     none
 *
 * Return:      handle to mp3 decoder instance, 0 if malloc fails
 **************************************************************************************/
HMP3Decoder MP3InitDecoder(void)
{
	MP3DecInfo *mp3DecInfo;

	mp3DecInfo = AllocateBuffers();

	return (HMP3Decoder)mp3DecInfo;
}

/**************************************************************************************
 * Function:    MP3FreeDecoder
 *
 * Description: free platform-specific data allocated by InitMP3Decoder
 *              zero out the contents of MP3DecInfo struct
 *
 * Inputs:      valid MP3 decoder instance pointer (HMP3Decoder)
 *
 * Outputs:     none
 *
 * Return:      none
 **************************************************************************************/
void MP3FreeDecoder(HMP3Decoder hMP3Decoder)
{
	MP3DecInfo *mp3DecInfo = (MP3DecInfo *)hMP3Decoder;

	if (!mp3DecInfo)
		return;

	FreeBuffers(mp3DecInfo);
}

/**************************************************************************************
 * Function:    MP3FindSyncWord
 *
 * Description: locate the next byte-alinged sync word in the raw mp3 stream
 *
 * Inputs:      buffer to search for sync word
 *              max number of bytes to search in buffer
 *
 * Outputs:     none
 *
 * Return:      offset to first sync word (bytes from start of buf)
 *              -1 if sync not found after searching nBytes
 **************************************************************************************/
int MP3FindSyncWord(unsigned char *buf, int nBytes)
{
	int i;

	/* find byte-aligned syncword - need 12 (MPEG 1,2) or 11 (MPEG 2.5) matching bits */
	for (i = 0; i < nBytes - 1; i++) {
		if ( (buf[i+0] & SYNCWORDH) == SYNCWORDH && (buf[i+1] & SYNCWORDL) == SYNCWORDL )
			return i;
	}
	
	return -1;
}


/**************************************************************************************
 * Function:    MP3ClearBadFrame
 *
 * Description: zero out pcm buffer if error decoding MP3 frame
 *
 * Inputs:      mp3DecInfo struct with correct frame size parameters filled in
 *              pointer pcm output buffer
 *
 * Outputs:     zeroed out pcm buffer
 *
 * Return:      none
 **************************************************************************************/
static void MP3ClearBadFrame(MP3DecInfo *mp3DecInfo, short *outbuf)
{
	int i;

	if (!mp3DecInfo)
		return;

	for (i = 0; i < mp3DecInfo->nGrans * mp3DecInfo->nGranSamps * mp3DecInfo->nChans; i++)
		outbuf[i] = 0;
}

/**************************************************************************************
 * Function:    MP3Decode
 *
 * Description: decode one frame of MP3 data
 *
 * Inputs:      valid MP3 decoder instance pointer (HMP3Decoder)
 *              double pointer to buffer of MP3 data (containing headers + mainData)
 *              number of valid bytes remaining in inbuf
 *              pointer to outbuf, big enough to hold one frame of decoded PCM samples
 *              flag indicating whether MP3 data is normal MPEG format (useSize = 0)
 *                or reformatted as "self-contained" frames (useSize = 1)
 *
 * Outputs:     PCM data in outbuf, interleaved LRLRLR... if stereo
 *                number of output samples = nGrans * nGranSamps * nChans
 *              updated inbuf pointer, updated bytesLeft
 *
 * Return:      error code, defined in mp3dec.h (0 means no error, < 0 means error)
 *
 * Notes:       switching useSize on and off between frames in the same stream 
 *                is not supported (bit reservoir is not maintained if useSize on)
 **************************************************************************************/
int MP3Decode(HMP3Decoder hMP3Decoder, unsigned char **inbuf, int *bytesLeft, short *outbuf, int useSize)
{
	int offset, bitOffset, mainBits, gr, ch, fhBytes, siBytes, freeFrameBytes;
	int prevBitOffset, sfBlockBits, huffBlockBits;
	unsigned char *mainPtr;
	MP3DecInfo *mp3DecInfo = (MP3DecInfo *)hMP3Decoder;

	if (!mp3DecInfo)
		return ERR_MP3_NULL_POINTER;

	/* unpack frame header */
	fhBytes = UnpackFrameHeader(mp3DecInfo, *inbuf);
	if (fhBytes < 0)	
		return ERR_MP3_INVALID_FRAMEHEADER;		/* don't clear outbuf since we don't know size (failed to parse header) */
	*inbuf += fhBytes;
	
	/* unpack side info */
	siBytes = UnpackSideInfo(mp3DecInfo, *inbuf);
	if (siBytes < 0) 
	{
		MP3ClearBadFrame(mp3DecInfo, outbuf);
		return ERR_MP3_INVALID_SIDEINFO;
	}
	*inbuf += siBytes;
	*bytesLeft -= (fhBytes + siBytes);
		
	/* out of data - assume last or truncated frame */
	if (mp3DecInfo->nSlots > *bytesLeft) 
	{
		MP3ClearBadFrame(mp3DecInfo, outbuf);
		return ERR_MP3_INDATA_UNDERFLOW;	
	}


	/* fill main data buffer with enough new data for this frame */
	if (mp3DecInfo->mainDataBytes >= mp3DecInfo->mainDataBegin) 
	{
		/* adequate "old" main data available (i.e. bit reservoir) */
		memmove(mp3DecInfo->mainBuf, mp3DecInfo->mainBuf + mp3DecInfo->mainDataBytes - mp3DecInfo->mainDataBegin, mp3DecInfo->mainDataBegin);
		memcpy(mp3DecInfo->mainBuf + mp3DecInfo->mainDataBegin, *inbuf, mp3DecInfo->nSlots);

		mp3DecInfo->mainDataBytes = mp3DecInfo->mainDataBegin + mp3DecInfo->nSlots;
		*inbuf += mp3DecInfo->nSlots;
		*bytesLeft -= (mp3DecInfo->nSlots);
		mainPtr = mp3DecInfo->mainBuf;
	} 
	// else 
	// {
	// 	/* not enough data in bit reservoir from previous frames (perhaps starting in middle of file) */
	// 	memcpy(mp3DecInfo->mainBuf + mp3DecInfo->mainDataBytes, *inbuf, mp3DecInfo->nSlots);
	// 	mp3DecInfo->mainDataBytes += mp3DecInfo->nSlots;
	// 	*inbuf += mp3DecInfo->nSlots;
	// 	*bytesLeft -= (mp3DecInfo->nSlots);
	// 	MP3ClearBadFrame(mp3DecInfo, outbuf);
	// 	return ERR_MP3_MAINDATA_UNDERFLOW;
	// }
	
	bitOffset = 0;
	mainBits = mp3DecInfo->mainDataBytes * 8;

	/* decode one complete frame */
	for (gr = 0; gr < 2; gr++) 
	{
		for (ch = 0; ch < 2; ch++) 
		{
			/* unpack scale factors and compute size of scale factor block */
			prevBitOffset = bitOffset;
			offset = UnpackScaleFactors(mp3DecInfo, mainPtr, &bitOffset, mainBits, gr, ch);

			sfBlockBits = 8*offset - prevBitOffset + bitOffset;
			huffBlockBits = mp3DecInfo->part23Length[gr][ch] - sfBlockBits;
			mainPtr += offset;
			mainBits -= sfBlockBits;

			if (offset < 0 || mainBits < huffBlockBits) 
			{
				MP3ClearBadFrame(mp3DecInfo, outbuf);
				return ERR_MP3_INVALID_SCALEFACT;
			}

			/* decode Huffman code words */
			prevBitOffset = bitOffset;
			offset = DecodeHuffman(mp3DecInfo, mainPtr, &bitOffset, huffBlockBits, gr, ch);
			if (offset < 0) 
			{
				MP3ClearBadFrame(mp3DecInfo, outbuf);
				return ERR_MP3_INVALID_HUFFCODES;
			}

			mainPtr += offset;
			mainBits -= (8*offset - prevBitOffset + bitOffset);
		}
		/* dequantize coefficients, decode stereo, reorder short blocks */
		if (Dequantize(mp3DecInfo, gr) < 0) 
		{
			MP3ClearBadFrame(mp3DecInfo, outbuf);
			return ERR_MP3_INVALID_DEQUANTIZE;			
		}

		/* alias reduction, inverse MDCT, overlap-add, frequency inversion */
		for (ch = 0; ch < 2; ch++)
		{
			if (IMDCT(mp3DecInfo, gr, ch) < 0) 
			{
				MP3ClearBadFrame(mp3DecInfo, outbuf);
				return ERR_MP3_INVALID_IMDCT;			
			}
		}
		/* subband transform - if stereo, interleaves pcm LRLRLR */
		if (Subband(mp3DecInfo, outbuf + gr*mp3DecInfo->nGranSamps*mp3DecInfo->nChans) < 0) 
		{
			MP3ClearBadFrame(mp3DecInfo, outbuf);
			return ERR_MP3_INVALID_SUBBAND;			
		}
	}
	return ERR_MP3_NONE;
}
