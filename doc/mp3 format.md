# mp3 format analyze

## frameHeader
* 32 bit
* [31:20] = 12'hfff         检查帧头
* [19] = 1                  ID 表示MPEG1
* [18:17] = 01                   LAYER  3
* [16]  = X                 CRC 
* [15:12] = XXXX            比特率索引   Kbps
* [11:10] = 00              采样率 44.1Khz
* [9] = X                   填充位
* [8] = X                   私有位
* [7:6] = XX                模式：00立体声 01联合立体声 10双声道 11单声道
* [5:4] =XX                 拓展模式
* [3]                       版权
* [2]                       拷贝
* [1:0]                     解码加重类型

FF FB 90 64


fh->ver = 0;
fh->layer = 3
fh->brIdx = ?15选1  (9)
fh->srIdx = 00;
fh->crc = 1

1. 出现几个保留选项，抛弃
2. sfBand 查表得到，通过10（MPEG1）和采样频率00（44.1khz）
>> 选定
>>   {
>>           { 0,  4,  8, 12, 16, 20, 24, 30, 36, 44, 52, 62, 74, 90,110,134,162,196,238,288,342,418,576 },
>>             { 0,  4,  8, 12, 16, 22, 30, 40, 52, 66, 84,106,136,192 }
>>         }
3. MP3decinfo 从文件头获取参数
    * 通道只区分单双   nchans = 2
    * 读取采样率 samprate = 44100
    * nGrans = 2
    * nGranSamps = 1152 / nGrans（2）
    * layer = 3
    * version = MPEG1（0）

4. 查表获取比特率和nslots ，除非为变比特率（尽量避免这种情况）,
     bitrate = 15选1 *1000
>> {  0, 32, 40, 48, 56, 64, 80, 96,112,128,160,192,224,256,320},

>>  mp3DecInfo->nSlots = (int)slotTab[0][0][15选1] - 
            (int)sideBytesTab[0][1] - 
            4 - (fh->crc ? 2 : 0) + (fh->paddingBit ? 1 : 0);
5. 如果带CRC 指针前移 6个byte 没有CRC 只移动帧头大小（4byte）

-----------------------------------------------


## sideinfo 256 bits = 32 bytes

* getbits就是从流中取n bits，流的大小由SetBitstreamPointer决定

1. 取maindatabegin   9bits
2. 取privatebits 5bits
3. 取scfsi 8bits
    4. part2_3_length 12bits
    5. nBigvals 9bits
    6. globalGain 8bits
    7. sfCompress 4bits
    8. winSwitchFlag 1bits
    9. 。。。。。

------------------------------------------

# 帧准备
1. mainDataBytes 之前记录的buff数据量，由指针计算得来，mainBuf 流式缓冲区

注意：*可以考虑从这里切入* 1940*8bit
* 数据是从inbuf压入MP3decinfo->MAINBUF中进行解码的，可以考虑只传送需要压入mainbuf中的数据，只需参考mainbuf的大小
-----------------------------------------

#核心运算

1. gr：2倍计算
    2. ch：2倍计算
        3. 解包比例系数
            + 押入比特流（从buf中压入mainbit，bitoffset +7 ？）
            + 取出offset个位（抛弃？）
            + 根据&si->sis[gr][ch], &sfi->sfis[gr][ch], si->scfsi[ch], gr, &sfi->sfis[0][ch]解包边信息
                * 基本就是查表，流中按位取数据
            + 看用了多少个bit
            + 偏置 = 用了的加上位offset /8
            + 位偏置 += 使用了的bit mod 7
            + 返回buf的偏移量
        4. 计算位置
        5. 霍夫曼解码
            * 根据切换标志和块类型给r1Start r2Start赋值
            * rend0-3赋值
            * 3倍计算解码霍夫曼对
                - 查表
                - 。。。
            * 1倍解霍夫曼4对
        6. Dequantize反向量化
        *可以考虑从这里切入hi->huffDecBuf* 1152*32bit
        7. imdct
        * 从这里切入 1152* 32bit 每26ms，每次压入64*32bit同步两次FDCT32+POLYPHASE,拍18下
        8. subband












