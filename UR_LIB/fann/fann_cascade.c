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

#include "config.h"
#include "fann.h"
#include "string.h"


uint32_t fann_get_cascade_num_candidates(struct fann *ann)
{
	return ann->cascade_activation_functions_count *
		ann->cascade_activation_steepnesses_count *
		ann->cascade_num_candidate_groups;
}

FANN_GET_SET(float, cascade_output_change_fraction)
FANN_GET_SET(uint32_t, cascade_output_stagnation_epochs)
FANN_GET_SET(float, cascade_candidate_change_fraction)
FANN_GET_SET(uint32_t, cascade_candidate_stagnation_epochs)
FANN_GET_SET(uint32_t, cascade_num_candidate_groups)
FANN_GET_SET(fann_type, cascade_weight_multiplier)
FANN_GET_SET(fann_type, cascade_candidate_limit)
FANN_GET_SET(uint32_t, cascade_max_out_epochs)
FANN_GET_SET(uint32_t, cascade_max_cand_epochs)
FANN_GET_SET(uint32_t, cascade_min_out_epochs)
FANN_GET_SET(uint32_t, cascade_min_cand_epochs)

FANN_GET(uint32_t, cascade_activation_functions_count)
FANN_GET(enum fann_activationfunc_enum *, cascade_activation_functions)

void fann_set_cascade_activation_functions(struct fann *ann,
														 enum fann_activationfunc_enum *
														 cascade_activation_functions,
														 uint32_t 
														 cascade_activation_functions_count)
{
	if(ann->cascade_activation_functions_count != cascade_activation_functions_count)
	{
		ann->cascade_activation_functions_count = cascade_activation_functions_count;
		
		/* reallocate mem */
		ann->cascade_activation_functions = 
			(enum fann_activationfunc_enum *)realloc(ann->cascade_activation_functions, 
			ann->cascade_activation_functions_count * sizeof(enum fann_activationfunc_enum));
		if(ann->cascade_activation_functions == NULL)
		{
			fann_error((struct fann_error*)ann, FANN_E_CANT_ALLOCATE_MEM);
			return;
		}
	}
	
	memmove(ann->cascade_activation_functions, cascade_activation_functions, 
		ann->cascade_activation_functions_count * sizeof(enum fann_activationfunc_enum));
}

FANN_GET(uint32_t, cascade_activation_steepnesses_count)
FANN_GET(fann_type *, cascade_activation_steepnesses)

void fann_set_cascade_activation_steepnesses(struct fann *ann,
														   fann_type *
														   cascade_activation_steepnesses,
														   uint32_t 
														   cascade_activation_steepnesses_count)
{
	if(ann->cascade_activation_steepnesses_count != cascade_activation_steepnesses_count)
	{
		ann->cascade_activation_steepnesses_count = cascade_activation_steepnesses_count;
		
		/* reallocate mem */
		ann->cascade_activation_steepnesses = 
			(fann_type *)realloc(ann->cascade_activation_steepnesses, 
			ann->cascade_activation_steepnesses_count * sizeof(fann_type));
		if(ann->cascade_activation_steepnesses == NULL)
		{
			fann_error((struct fann_error*)ann, FANN_E_CANT_ALLOCATE_MEM);
			return;
		}
	}
	
	memmove(ann->cascade_activation_steepnesses, cascade_activation_steepnesses, 
		ann->cascade_activation_steepnesses_count * sizeof(fann_type));
}
