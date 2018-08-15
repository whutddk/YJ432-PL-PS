/*
  Fast Artificial Neural Network Library (fann)
  Copyright (C) 2003-2016 Steffen Nissen (steffen.fann@gmail.com)
  
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.
  
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.
  
  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#include "config.h"
#include "fann.h"

/*#define DEBUGTRAIN*/


/* INTERNAL FUNCTION
   Helper function to update the MSE value and return a diff which takes symmetric functions into account
*/
fann_type fann_update_MSE(struct fann *ann, struct fann_neuron* neuron, fann_type neuron_diff)
{
	float neuron_diff2;
	
	switch (neuron->activation_function)
	{
		case FANN_LINEAR_PIECE_SYMMETRIC:
		case FANN_THRESHOLD_SYMMETRIC:
		case FANN_SIGMOID_SYMMETRIC:
		case FANN_SIGMOID_SYMMETRIC_STEPWISE:
		case FANN_ELLIOT_SYMMETRIC:
		case FANN_GAUSSIAN_SYMMETRIC:
		case FANN_SIN_SYMMETRIC:
		case FANN_COS_SYMMETRIC:
			neuron_diff /= (fann_type)2.0;
			break;
		case FANN_THRESHOLD:
		case FANN_LINEAR:
		case FANN_SIGMOID:
		case FANN_SIGMOID_STEPWISE:
		case FANN_GAUSSIAN:
		case FANN_GAUSSIAN_STEPWISE:
		case FANN_ELLIOT:
		case FANN_LINEAR_PIECE:
		case FANN_SIN:
		case FANN_COS:
			break;
	}


		neuron_diff2 =
			(neuron_diff / (float) ann->multiplier) * (neuron_diff / (float) ann->multiplier);

	ann->MSE_value += neuron_diff2;

	/*printf("neuron_diff %f = (%f - %f)[/2], neuron_diff2=%f, sum=%f, MSE_value=%f, num_MSE=%d\n", neuron_diff, *desired_output, neuron_value, neuron_diff2, last_layer_begin->sum, ann->MSE_value, ann->num_MSE); */
	if(fann_abs(neuron_diff) >= ann->bit_fail_limit)
	{
		ann->num_bit_fail++;
	}
	
	return neuron_diff;
}

/* Tests the network.
 */
fann_type *fann_test(struct fann *ann, fann_type * input,
											fann_type * desired_output)
{
	fann_type neuron_value;
	fann_type *output_begin = fann_run(ann, input);
	fann_type *output_it;
	const fann_type *output_end = output_begin + ann->num_output;
	fann_type neuron_diff;
	struct fann_neuron *output_neuron = (ann->last_layer - 1)->first_neuron;

	/* calculate the error */
	for(output_it = output_begin; output_it != output_end; output_it++)
	{
		neuron_value = *output_it;

		neuron_diff = (*desired_output - neuron_value);

		neuron_diff = fann_update_MSE(ann, output_neuron, neuron_diff);
		
		desired_output++;
		output_neuron++;

		ann->num_MSE++;
	}

	return output_begin;
}

/* get the mean square error.
 */
float fann_get_MSE(struct fann *ann)
{
	if(ann->num_MSE)
	{
		return ann->MSE_value / (float) ann->num_MSE;
	}
	else
	{
		return 0;
	}
}

uint32_t fann_get_bit_fail(struct fann *ann)
{
	return ann->num_bit_fail;	
}

/* reset the mean square error.
 */
void fann_reset_MSE(struct fann *ann)
{
/*printf("resetMSE %d %f\n", ann->num_MSE, ann->MSE_value);*/
	ann->num_MSE = 0;
	ann->MSE_value = 0;
	ann->num_bit_fail = 0;
}

FANN_GET_SET(enum fann_train_enum, training_algorithm)
FANN_GET_SET(float, learning_rate)

void fann_set_activation_function_hidden(struct fann *ann,
																enum fann_activationfunc_enum activation_function)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *layer_it;
	struct fann_layer *last_layer = ann->last_layer - 1;	/* -1 to not update the output layer */

	for(layer_it = ann->first_layer + 1; layer_it != last_layer; layer_it++)
	{
		last_neuron = layer_it->last_neuron;
		for(neuron_it = layer_it->first_neuron; neuron_it != last_neuron; neuron_it++)
		{
			neuron_it->activation_function = activation_function;
		}
	}
}

struct fann_layer* fann_get_layer(struct fann *ann, int32_t layer)
{
	if(layer <= 0 || layer >= (ann->last_layer - ann->first_layer))
	{
		fann_error((struct fann_error *) ann, FANN_E_INDEX_OUT_OF_BOUND, layer);
		return NULL;
	}
	
	return ann->first_layer + layer;	
}

struct fann_neuron* fann_get_neuron_layer(struct fann *ann, struct fann_layer* layer, int32_t neuron)
{
	if(neuron >= (layer->last_neuron - layer->first_neuron))
	{
		fann_error((struct fann_error *) ann, FANN_E_INDEX_OUT_OF_BOUND, neuron);
		return NULL;	
	}
	
	return layer->first_neuron + neuron;
}

struct fann_neuron* fann_get_neuron(struct fann *ann, uint32_t layer, int32_t neuron)
{
	struct fann_layer *layer_it = fann_get_layer(ann, layer);
	if(layer_it == NULL)
		return NULL;
	return fann_get_neuron_layer(ann, layer_it, neuron);
}

enum fann_activationfunc_enum fann_get_activation_function(struct fann *ann, int32_t layer, int32_t neuron)
{
	struct fann_neuron* neuron_it = fann_get_neuron(ann, layer, neuron);
	if (neuron_it == NULL)
    {
		return (enum fann_activationfunc_enum)-1; /* layer or neuron out of bounds */
    }
    else
    {
	    return neuron_it->activation_function;
    }
}

void fann_set_activation_function(struct fann *ann,
																enum fann_activationfunc_enum
																activation_function,
																int32_t layer,
																int32_t neuron)
{
	struct fann_neuron* neuron_it = fann_get_neuron(ann, layer, neuron);
	if(neuron_it == NULL)
		return;

	neuron_it->activation_function = activation_function;
}

void fann_set_activation_function_layer(struct fann *ann,
																enum fann_activationfunc_enum
																activation_function,
																int32_t layer)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *layer_it = fann_get_layer(ann, layer);
	
	if(layer_it == NULL)
		return;

	last_neuron = layer_it->last_neuron;
	for(neuron_it = layer_it->first_neuron; neuron_it != last_neuron; neuron_it++)
	{
		neuron_it->activation_function = activation_function;
	}
}


void fann_set_activation_function_output(struct fann *ann,
																enum fann_activationfunc_enum activation_function)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *last_layer = ann->last_layer - 1;

	last_neuron = last_layer->last_neuron;
	for(neuron_it = last_layer->first_neuron; neuron_it != last_neuron; neuron_it++)
	{
		neuron_it->activation_function = activation_function;
	}
}

void fann_set_activation_steepness_hidden(struct fann *ann,
																 fann_type steepness)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *layer_it;
	struct fann_layer *last_layer = ann->last_layer - 1;	/* -1 to not update the output layer */

	for(layer_it = ann->first_layer + 1; layer_it != last_layer; layer_it++)
	{
		last_neuron = layer_it->last_neuron;
		for(neuron_it = layer_it->first_neuron; neuron_it != last_neuron; neuron_it++)
		{
			neuron_it->activation_steepness = steepness;
		}
	}
}

fann_type fann_get_activation_steepness(struct fann *ann, int32_t layer, int32_t neuron)
{
	struct fann_neuron* neuron_it = fann_get_neuron(ann, layer, neuron);
	if(neuron_it == NULL)
    {
		return -1; /* layer or neuron out of bounds */
    }
    else
    {
        return neuron_it->activation_steepness;
    }
}

void fann_set_activation_steepness(struct fann *ann,
																fann_type steepness,
																int32_t layer,
																int32_t neuron)
{
	struct fann_neuron* neuron_it = fann_get_neuron(ann, layer, neuron);
	if(neuron_it == NULL)
		return;

	neuron_it->activation_steepness = steepness;
}

void fann_set_activation_steepness_layer(struct fann *ann,
																fann_type steepness,
																int32_t layer)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *layer_it = fann_get_layer(ann, layer);
	
	if(layer_it == NULL)
		return;

	last_neuron = layer_it->last_neuron;
	for(neuron_it = layer_it->first_neuron; neuron_it != last_neuron; neuron_it++)
	{
		neuron_it->activation_steepness = steepness;
	}
}

void fann_set_activation_steepness_output(struct fann *ann,
																 fann_type steepness)
{
	struct fann_neuron *last_neuron, *neuron_it;
	struct fann_layer *last_layer = ann->last_layer - 1;

	last_neuron = last_layer->last_neuron;
	for(neuron_it = last_layer->first_neuron; neuron_it != last_neuron; neuron_it++)
	{
		neuron_it->activation_steepness = steepness;
	}
}

FANN_GET_SET(enum fann_errorfunc_enum, train_error_function)
FANN_GET_SET(fann_callback_type, callback)
FANN_GET_SET(float, quickprop_decay)
FANN_GET_SET(float, quickprop_mu)
FANN_GET_SET(float, rprop_increase_factor)
FANN_GET_SET(float, rprop_decrease_factor)
FANN_GET_SET(float, rprop_delta_min)
FANN_GET_SET(float, rprop_delta_max)
FANN_GET_SET(float, rprop_delta_zero)
FANN_GET_SET(float, sarprop_weight_decay_shift)
FANN_GET_SET(float, sarprop_step_error_threshold_factor)
FANN_GET_SET(float, sarprop_step_error_shift)
FANN_GET_SET(float, sarprop_temperature)
FANN_GET_SET(enum fann_stopfunc_enum, train_stop_function)
FANN_GET_SET(fann_type, bit_fail_limit)
FANN_GET_SET(float, learning_momentum)
