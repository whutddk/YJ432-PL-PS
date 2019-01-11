/*
* @File Name include.h
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\TJ432-A\include.h
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-10 17:39:23
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-10 20:11:25
* @Email: 295054118@whut.edu.cn"
*/

#ifndef _INCLUDE_H_
#define _INCLUDE_H_

#include "mbed.h"

#include "mcu_cfg.h"
#include "ITAC.h"
#include "CTL.h"
#include "PL_DEF.h"

#include "SDHCBlockDevice.h"
#include "FATFileSystem.h"


extern SDHCBlockDevice sd;
extern FATFileSystem fs;

#endif



