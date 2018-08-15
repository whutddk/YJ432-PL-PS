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

#include "config.h"
#include "fann.h"

/*
 * Reads training data from a file. 
 */
struct fann_train_data *fann_read_train_from_file(const char *configuration_file)
{
	struct fann_train_data *data;
	FILE *file = fopen(configuration_file, "r");

	if(!file)
	{
		fann_error(NULL, FANN_E_CANT_OPEN_CONFIG_R, configuration_file);
		return NULL;
	}

	data = fann_read_train_from_fd(file, configuration_file);
	fclose(file);
	return data;
}

/*
 * Save training data to a file 
 */
int32_t fann_save_train(struct fann_train_data *data, const char *filename)
{
	return fann_save_train_internal(data, filename, 0, 0);
}

/*
 * Save training data to a file in fixed point algebra. (Good for testing
 * a network in fixed point) 
 */
int32_t fann_save_train_to_fixed(struct fann_train_data *data, const char *filename,
													 uint32_t decimal_point)
{
	return fann_save_train_internal(data, filename, 1, decimal_point);
}

/*
 * deallocate the train data structure. 
 */
void fann_destroy_train(struct fann_train_data *data)
{
	if(data == NULL)
		return;
	if(data->input != NULL)
		fann_safe_free(data->input[0]);
	if(data->output != NULL)
		fann_safe_free(data->output[0]);
	fann_safe_free(data->input);
	fann_safe_free(data->output);
	fann_safe_free(data);
}

/*
 * Test a set of training data and calculate the MSE 
 */
float fann_test_data(struct fann *ann, struct fann_train_data *data)
{
	uint32_t i;
	if(fann_check_input_output_sizes(ann, data) == -1)
		return 0;
	
	fann_reset_MSE(ann);

	for(i = 0; i != data->num_data; i++)
	{
		fann_test(ann, data->input[i], data->output[i]);
	}

	return fann_get_MSE(ann);
}


/*
 * shuffles training data, randomizing the order 
 */
void fann_shuffle_train_data(struct fann_train_data *train_data)
{
	uint32_t dat = 0, elem, swap;
	fann_type temp;

	for(; dat < train_data->num_data; dat++)
	{
		swap = (uint32_t) (rand() % train_data->num_data);
		if(swap != dat)
		{
			for(elem = 0; elem < train_data->num_input; elem++)
			{
				temp = train_data->input[dat][elem];
				train_data->input[dat][elem] = train_data->input[swap][elem];
				train_data->input[swap][elem] = temp;
			}
			for(elem = 0; elem < train_data->num_output; elem++)
			{
				temp = train_data->output[dat][elem];
				train_data->output[dat][elem] = train_data->output[swap][elem];
				train_data->output[swap][elem] = temp;
			}
		}
	}
}

/*
 * INTERNAL FUNCTION calculates min and max of train data
 */
void fann_get_min_max_data(fann_type ** data, uint32_t num_data, uint32_t num_elem, fann_type *min, fann_type *max)
{
	fann_type temp;
	uint32_t dat, elem;
	*min = *max = data[0][0];

	for(dat = 0; dat < num_data; dat++)
	{
		for(elem = 0; elem < num_elem; elem++)
		{
			temp = data[dat][elem];
			if(temp < *min)
				*min = temp;
			else if(temp > *max)
				*max = temp;
		}
	}
}


fann_type fann_get_min_train_input(struct fann_train_data *train_data)
{
    fann_type min, max;
    fann_get_min_max_data(train_data->input, train_data->num_data, train_data->num_input, &min, &max);
    return min;
}

fann_type fann_get_max_train_input(struct fann_train_data *train_data)
{
    fann_type min, max;
    fann_get_min_max_data(train_data->input, train_data->num_data, train_data->num_input, &min, &max);
    return max;
}

fann_type fann_get_min_train_output(struct fann_train_data *train_data)
{
    fann_type min, max;
    fann_get_min_max_data(train_data->output, train_data->num_data, train_data->num_output, &min, &max);
    return min;
}

fann_type fann_get_max_train_output(struct fann_train_data *train_data)
{
    fann_type min, max;
    fann_get_min_max_data(train_data->output, train_data->num_data, train_data->num_output, &min, &max);
    return max;
}

/*
 * INTERNAL FUNCTION Scales data to a specific range 
 */
void fann_scale_data(fann_type ** data, uint32_t num_data, uint32_t num_elem,
					 fann_type new_min, fann_type new_max)
{
	fann_type old_min, old_max;
	fann_get_min_max_data(data, num_data, num_elem, &old_min, &old_max);
	fann_scale_data_to_range(data, num_data, num_elem, old_min, old_max, new_min, new_max);
}

/*
 * INTERNAL FUNCTION Scales data to a specific range 
 */
void fann_scale_data_to_range(fann_type ** data, uint32_t num_data, uint32_t num_elem,
					 fann_type old_min, fann_type old_max, fann_type new_min, fann_type new_max)
{
	uint32_t dat, elem;
	fann_type temp, old_span, new_span, factor;

	old_span = old_max - old_min;
	new_span = new_max - new_min;
	factor = new_span / old_span;
	/*printf("max %f, min %f, factor %f\n", old_max, old_min, factor);*/

	for(dat = 0; dat < num_data; dat++)
	{
		for(elem = 0; elem < num_elem; elem++)
		{
			temp = (data[dat][elem] - old_min) * factor + new_min;
			if(temp < new_min)
			{
				data[dat][elem] = new_min;
				/*
				 * printf("error %f < %f\n", temp, new_min); 
				 */
			}
			else if(temp > new_max)
			{
				data[dat][elem] = new_max;
				/*
				 * printf("error %f > %f\n", temp, new_max); 
				 */
			}
			else
			{
				data[dat][elem] = temp;
			}
		}
	}
}


/*
 * Scales the inputs in the training data to the specified range 
 */
void fann_scale_input_train_data(struct fann_train_data *train_data,
														fann_type new_min, fann_type new_max)
{
	fann_scale_data(train_data->input, train_data->num_data, train_data->num_input, new_min,
					new_max);
}

/*
 * Scales the inputs in the training data to the specified range 
 */
void fann_scale_output_train_data(struct fann_train_data *train_data,
														 fann_type new_min, fann_type new_max)
{
	fann_scale_data(train_data->output, train_data->num_data, train_data->num_output, new_min,
					new_max);
}

/*
 * Scales the inputs in the training data to the specified range 
 */
void fann_scale_train_data(struct fann_train_data *train_data,
												  fann_type new_min, fann_type new_max)
{
	fann_scale_data(train_data->input, train_data->num_data, train_data->num_input, new_min,
					new_max);
	fann_scale_data(train_data->output, train_data->num_data, train_data->num_output, new_min,
					new_max);
}

/*
 * merges training data into a single struct. 
 */
struct fann_train_data *fann_merge_train_data(struct fann_train_data *data1,
																	 struct fann_train_data *data2)
{
	uint32_t i;
	fann_type *data_input, *data_output;
	struct fann_train_data *dest =
		(struct fann_train_data *) malloc(sizeof(struct fann_train_data));

	if(dest == NULL)
	{
		fann_error((struct fann_error*)data1, FANN_E_CANT_ALLOCATE_MEM);
		return NULL;
	}

	if((data1->num_input != data2->num_input) || (data1->num_output != data2->num_output))
	{
		fann_error((struct fann_error*)data1, FANN_E_TRAIN_DATA_MISMATCH);
		return NULL;
	}

	fann_init_error_data((struct fann_error *) dest);
	dest->error_log = data1->error_log;

	dest->num_data = data1->num_data+data2->num_data;
	dest->num_input = data1->num_input;
	dest->num_output = data1->num_output;
	dest->input = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->input == NULL)
	{
		fann_error((struct fann_error*)data1, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	dest->output = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->output == NULL)
	{
		fann_error((struct fann_error*)data1, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	data_input = (fann_type *) calloc(dest->num_input * dest->num_data, sizeof(fann_type));
	if(data_input == NULL)
	{
		fann_error((struct fann_error*)data1, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_input, data1->input[0], dest->num_input * data1->num_data * sizeof(fann_type));
	memcpy(data_input + (dest->num_input*data1->num_data), 
		data2->input[0], dest->num_input * data2->num_data * sizeof(fann_type));

	data_output = (fann_type *) calloc(dest->num_output * dest->num_data, sizeof(fann_type));
	if(data_output == NULL)
	{
		fann_error((struct fann_error*)data1, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_output, data1->output[0], dest->num_output * data1->num_data * sizeof(fann_type));
	memcpy(data_output + (dest->num_output*data1->num_data), 
		data2->output[0], dest->num_output * data2->num_data * sizeof(fann_type));

	for(i = 0; i != dest->num_data; i++)
	{
		dest->input[i] = data_input;
		data_input += dest->num_input;
		dest->output[i] = data_output;
		data_output += dest->num_output;
	}
	return dest;
}

/*
 * return a copy of a fann_train_data struct 
 */
struct fann_train_data *fann_duplicate_train_data(struct fann_train_data
																		 *data)
{
	uint32_t i;
	fann_type *data_input, *data_output;
	struct fann_train_data *dest =
		(struct fann_train_data *) malloc(sizeof(struct fann_train_data));

	if(dest == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		return NULL;
	}

	fann_init_error_data((struct fann_error *) dest);
	dest->error_log = data->error_log;

	dest->num_data = data->num_data;
	dest->num_input = data->num_input;
	dest->num_output = data->num_output;
	dest->input = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->input == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	dest->output = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->output == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	data_input = (fann_type *) calloc(dest->num_input * dest->num_data, sizeof(fann_type));
	if(data_input == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_input, data->input[0], dest->num_input * dest->num_data * sizeof(fann_type));

	data_output = (fann_type *) calloc(dest->num_output * dest->num_data, sizeof(fann_type));
	if(data_output == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_output, data->output[0], dest->num_output * dest->num_data * sizeof(fann_type));

	for(i = 0; i != dest->num_data; i++)
	{
		dest->input[i] = data_input;
		data_input += dest->num_input;
		dest->output[i] = data_output;
		data_output += dest->num_output;
	}
	return dest;
}

struct fann_train_data *fann_subset_train_data(struct fann_train_data
																		 *data, uint32_t pos,
																		 uint32_t length)
{
	uint32_t i;
	fann_type *data_input, *data_output;
	struct fann_train_data *dest =
		(struct fann_train_data *) malloc(sizeof(struct fann_train_data));

	if(dest == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		return NULL;
	}
	
	if(pos > data->num_data || pos+length > data->num_data)
	{
		fann_error((struct fann_error*)data, FANN_E_TRAIN_DATA_SUBSET, pos, length, data->num_data);
		return NULL;
	}

	fann_init_error_data((struct fann_error *) dest);
	dest->error_log = data->error_log;

	dest->num_data = length;
	dest->num_input = data->num_input;
	dest->num_output = data->num_output;
	dest->input = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->input == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	dest->output = (fann_type **) calloc(dest->num_data, sizeof(fann_type *));
	if(dest->output == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}

	data_input = (fann_type *) calloc(dest->num_input * dest->num_data, sizeof(fann_type));
	if(data_input == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_input, data->input[pos], dest->num_input * dest->num_data * sizeof(fann_type));

	data_output = (fann_type *) calloc(dest->num_output * dest->num_data, sizeof(fann_type));
	if(data_output == NULL)
	{
		fann_error((struct fann_error*)data, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(dest);
		return NULL;
	}
	memcpy(data_output, data->output[pos], dest->num_output * dest->num_data * sizeof(fann_type));

	for(i = 0; i != dest->num_data; i++)
	{
		dest->input[i] = data_input;
		data_input += dest->num_input;
		dest->output[i] = data_output;
		data_output += dest->num_output;
	}
	return dest;
}

uint32_t fann_length_train_data(struct fann_train_data *data)
{
	return data->num_data;
}

uint32_t fann_num_input_train_data(struct fann_train_data *data)
{
	return data->num_input;
}

uint32_t fann_num_output_train_data(struct fann_train_data *data)
{
	return data->num_output;
}

/* INTERNAL FUNCTION
   Save the train data structure.
 */
int32_t fann_save_train_internal(struct fann_train_data *data, const char *filename,
							  uint32_t save_as_fixed, uint32_t decimal_point)
{
	int32_t retval = 0;
	FILE *file = fopen(filename, "w");

	if(!file)
	{
		fann_error((struct fann_error *) data, FANN_E_CANT_OPEN_TD_W, filename);
		return -1;
	}
	retval = fann_save_train_internal_fd(data, file, filename, save_as_fixed, decimal_point);
	fclose(file);
	
	return retval;
}

/* INTERNAL FUNCTION
   Save the train data structure.
 */
int32_t fann_save_train_internal_fd(struct fann_train_data *data, FILE * file, const char *filename,
								 uint32_t save_as_fixed, uint32_t decimal_point)
{
	uint32_t num_data = data->num_data;
	uint32_t num_input = data->num_input;
	uint32_t num_output = data->num_output;
	uint32_t i, j;
	int32_t retval = 0;


	fprintf(file, "%u %u %u\n", data->num_data, data->num_input, data->num_output);

	for(i = 0; i < num_data; i++)
	{
		for(j = 0; j < num_input; j++)
		{
			fprintf(file, FANNPRINTF " ", data->input[i][j]);
		}
		fprintf(file, "\n");

		for(j = 0; j < num_output; j++)
		{
			fprintf(file, FANNPRINTF " ", data->output[i][j]);
		}
		fprintf(file, "\n");
	}
	
	return retval;
}

/*
 * Creates an empty set of training data
 */
struct fann_train_data * fann_create_train(uint32_t num_data, uint32_t num_input, uint32_t num_output)
{
	fann_type *data_input, *data_output;
	uint32_t i;
	struct fann_train_data *data =
		(struct fann_train_data *) malloc(sizeof(struct fann_train_data));

	if(data == NULL)
	{
		fann_error(NULL, FANN_E_CANT_ALLOCATE_MEM);
		return NULL;
	}
	
	fann_init_error_data((struct fann_error *) data);

	data->num_data = num_data;
	data->num_input = num_input;
	data->num_output = num_output;
	data->input = (fann_type **) calloc(num_data, sizeof(fann_type *));
	if(data->input == NULL)
	{
		fann_error(NULL, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(data);
		return NULL;
	}

	data->output = (fann_type **) calloc(num_data, sizeof(fann_type *));
	if(data->output == NULL)
	{
		fann_error(NULL, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(data);
		return NULL;
	}

	data_input = (fann_type *) calloc(num_input * num_data, sizeof(fann_type));
	if(data_input == NULL)
	{
		fann_error(NULL, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(data);
		return NULL;
	}

	data_output = (fann_type *) calloc(num_output * num_data, sizeof(fann_type));
	if(data_output == NULL)
	{
		fann_error(NULL, FANN_E_CANT_ALLOCATE_MEM);
		fann_destroy_train(data);
		return NULL;
	}

	for(i = 0; i != num_data; i++)
	{
		data->input[i] = data_input;
		data_input += num_input;
		data->output[i] = data_output;
		data_output += num_output;
	}
	return data;
}

struct fann_train_data * fann_create_train_pointer_array(uint32_t num_data, uint32_t num_input, fann_type **input, uint32_t num_output, fann_type **output)
{
	uint32_t i;
    struct fann_train_data *data;
	data = fann_create_train(num_data, num_input, num_output);

	if(data == NULL)
		return NULL;

    for (i = 0; i < num_data; ++i)
    {
		memcpy(data->input[i], input[i], num_input*sizeof(fann_type));
		memcpy(data->output[i], output[i], num_output*sizeof(fann_type));
    }
    
	return data;
}

struct fann_train_data * fann_create_train_array(uint32_t num_data, uint32_t num_input, fann_type *input, uint32_t num_output, fann_type *output)
{
	uint32_t i;
    struct fann_train_data *data;
	data = fann_create_train(num_data, num_input, num_output);

	if(data == NULL)
		return NULL;

    for (i = 0; i < num_data; ++i)
    {
		memcpy(data->input[i], &input[i*num_input], num_input*sizeof(fann_type));
		memcpy(data->output[i], &output[i*num_output], num_output*sizeof(fann_type));
    }
    
	return data;
}


/*
 * Creates training data from a callback function.
 */
struct fann_train_data * fann_create_train_from_callback(uint32_t num_data,
                                          uint32_t num_input,
                                          uint32_t num_output,
                                          void (*user_function)( uint32_t,
                                                                 uint32_t,
                                                                 uint32_t,
                                                                 fann_type * ,
                                                                 fann_type * ))
{
    uint32_t i;
	struct fann_train_data *data = fann_create_train(num_data, num_input, num_output);
	if(data == NULL)
	{
		return NULL;
	}

    for( i = 0; i != num_data; i++)
    {
        (*user_function)(i, num_input, num_output, data->input[i], data->output[i]);
    }

    return data;
} 

fann_type * fann_get_train_input(struct fann_train_data * data, uint32_t position)
{
	if(position >= data->num_data)
		return NULL;
	return data->input[position];
}

fann_type * fann_get_train_output(struct fann_train_data * data, uint32_t position)
{
	if(position >= data->num_data)
		return NULL;
	return data->output[position];
}


/*
 * INTERNAL FUNCTION Reads training data from a file descriptor. 
 */
struct fann_train_data *fann_read_train_from_fd(FILE * file, const char *filename)
{
	uint32_t num_input, num_output, num_data, i, j;
	uint32_t line = 1;
	struct fann_train_data *data;

	if(fscanf(file, "%u %u %u\n", &num_data, &num_input, &num_output) != 3)
	{
		fann_error(NULL, FANN_E_CANT_READ_TD, filename, line);
		return NULL;
	}
	line++;

	data = fann_create_train(num_data, num_input, num_output);
	if(data == NULL)
	{
		return NULL;
	}

	for(i = 0; i != num_data; i++)
	{
		for(j = 0; j != num_input; j++)
		{
			if(fscanf(file, FANNSCANF " ", &data->input[i][j]) != 1)
			{
				fann_error(NULL, FANN_E_CANT_READ_TD, filename, line);
				fann_destroy_train(data);
				return NULL;
			}
		}
		line++;

		for(j = 0; j != num_output; j++)
		{
			if(fscanf(file, FANNSCANF " ", &data->output[i][j]) != 1)
			{
				fann_error(NULL, FANN_E_CANT_READ_TD, filename, line);
				fann_destroy_train(data);
				return NULL;
			}
		}
		line++;
	}
	return data;
}

/*
 * INTERNAL FUNCTION returns 0 if the desired error is reached and -1 if it is not reached
 */
int32_t fann_desired_error_reached(struct fann *ann, float desired_error)
{
	switch (ann->train_stop_function)
	{
	case FANN_STOPFUNC_MSE:
		if(fann_get_MSE(ann) <= desired_error)
			return 0;
		break;
	case FANN_STOPFUNC_BIT:
		if(ann->num_bit_fail <= (uint32_t)desired_error)
			return 0;
		break;
	}
	return -1;
}

int32_t fann_check_input_output_sizes(struct fann *ann, struct fann_train_data *data)
{
	if(ann->num_input != data->num_input)
    {
    	fann_error((struct fann_error *) ann, FANN_E_INPUT_NO_MATCH,
        	ann->num_input, data->num_input);
        return -1;
    }
        
	if(ann->num_output != data->num_output)
	{
		fann_error((struct fann_error *) ann, FANN_E_OUTPUT_NO_MATCH,
					ann->num_output, data->num_output);
		return -1;
	}
	
	return 0;
}
