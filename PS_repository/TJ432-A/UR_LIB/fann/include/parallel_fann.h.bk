/*
 * parallel_FANN.h
 *
 *     Author: Alessandro Pietro Bardelli
 */
#ifndef DISABLE_PARALLEL_FANN
#ifndef PARALLEL_FANN_H_
#define PARALLEL_FANN_H_

#include "fann.h"

#ifdef __cplusplus
extern "C"
{
	
#ifndef __cplusplus
} /* to fool automatic indention engines */ 
#endif
#endif	/* __cplusplus */


float fann_train_epoch_batch_parallel(struct fann *ann, struct fann_train_data *data, const unsigned int threadnumb);

float fann_train_epoch_irpropm_parallel(struct fann *ann, struct fann_train_data *data, const unsigned int threadnumb);

float fann_train_epoch_quickprop_parallel(struct fann *ann, struct fann_train_data *data, const unsigned int threadnumb);

float fann_train_epoch_sarprop_parallel(struct fann *ann, struct fann_train_data *data, const unsigned int threadnumb);

float fann_train_epoch_incremental_mod(struct fann *ann, struct fann_train_data *data);

float fann_test_data_parallel(struct fann *ann, struct fann_train_data *data, const unsigned int threadnumb);


#ifdef __cplusplus
#ifndef __cplusplus
/* to fool automatic indention engines */ 
{
	
#endif
} 
#endif	/* __cplusplus */

#endif /* PARALLEL_FANN_H_ */
#endif /* DISABLE_PARALLEL_FANN */
