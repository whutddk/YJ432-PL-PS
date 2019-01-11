/*
* @File Name mbed_rtx.h
* @File Path M:\MAS2\YJ432-PL-PS\PS_repository\hw_config\mbed-os\targets\TARGET_Freescale\mbed_rtx.h
* @Author: WUT_Ruige_Lee
* @Date:   2019-01-10 22:04:28
* @Last Modified by:   WUT_Ruige_Lee
* @Last Modified time: 2019-01-11 11:54:32
* @Email: 295054118@whut.edu.cn"
*/

/* mbed Microcontroller Library
 * Copyright (c) 2016 ARM Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef MBED_MBED_RTX_H
#define MBED_MBED_RTX_H

#if defined(TARGET_K20D50M)

#ifndef INITIAL_SP
#define INITIAL_SP              (0x10008000UL)
#endif


#elif defined(TARGET_K64F)

#ifndef INITIAL_SP
#define INITIAL_SP              (0x20030000UL)
#endif

#elif defined(TARGET_K64USB)

#ifndef INITIAL_SP
#define INITIAL_SP              (0x20030000UL)
#endif

#elif defined(TARGET_K64WUT135)

#ifndef INITIAL_SP
#define INITIAL_SP              (0x20030000UL)
#endif

#elif defined(TARGET_K64ARM4FPGA)

#ifndef INITIAL_SP
#define INITIAL_SP              (0x20030000UL)
#endif

#endif

#endif  // MBED_MBED_RTX_H
