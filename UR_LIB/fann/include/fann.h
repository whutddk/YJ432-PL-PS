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
	
/* This file defines the user interface to the fann library.
   It is included from fixedfann.h, floatfann.h and doublefann.h and should
   NOT be included directly. If included directly it will react as if
   floatfann.h was included.
*/ 

/* Section: FANN Creation/Execution
   
   The FANN library is designed to be very easy to use. 
   A feedforward ann can be created by a simple <fann_create_standard> function, while
   other ANNs can be created just as easily. The ANNs can be trained by <fann_train_on_file>
   and executed by <fann_run>.
   
   All of this can be done without much knowledge of the internals of ANNs, although the ANNs created will
   still be powerful and effective. If you have more knowledge about ANNs, and desire more control, almost
   every part of the ANNs can be parametrized to create specialized and highly optimal ANNs.
 */
/* Group: Creation, Destruction & Execution */
	
#ifndef FANN_INCLUDE
/* just to allow for inclusion of fann.h in normal stuations where only floats are needed */ 
#ifdef FIXEDFANN
#include "fixedfann.h"
#else
#include "floatfann.h"
#endif	/* FIXEDFANN  */
	
#else
	
#include <sys/time.h>

		
#ifndef __fann_h__
#define __fann_h__
	
#ifdef __cplusplus
extern "C"
{
	
#ifndef __cplusplus
} /* to fool automatic indention engines */ 
#endif
#endif	/* __cplusplus */
 
#ifndef NULL
#define NULL 0
#endif	/* NULL */

#include "fann_error.h"
#include "fann_activation.h"
#include "fann_data.h"
#include "fann_internal.h"
#include "fann_train.h"
#include "fann_cascade.h"
#include "fann_io.h"

/* Function: fann_create_standard
	
	Creates a standard fully connected backpropagation neural network.

	There will be a bias neuron in each layer (except the output layer),
	and this bias neuron will be connected to all neurons in the next layer.
	When running the network, the bias nodes always emits 1.
	
	To destroy a <struct fann> use the <fann_destroy> function.

	Parameters:
		num_layers - The total number of layers including the input and the output layer.
		... - Integer values determining the number of neurons in each layer starting with the 
			input layer and ending with the output layer.
			
	Returns:
		A pointer to the newly created <struct fann>.
			
	Example:
		> // Creating an ANN with 2 input neurons, 1 output neuron, 
		> // and two hidden layers with 8 and 9 neurons
		> struct fann *ann = fann_create_standard(4, 2, 8, 9, 1);
		
	See also:
		<fann_create_standard_array>, <fann_create_sparse>, <fann_create_shortcut>		
		
	This function appears in FANN >= 2.0.0.
*/ 
struct fann *fann_create_standard(uint32_t num_layers, ...);

/* Function: fann_create_standard_array
   Just like <fann_create_standard>, but with an array of layer sizes
   instead of individual parameters.

	Example:
		> // Creating an ANN with 2 input neurons, 1 output neuron, 
		> // and two hidden layers with 8 and 9 neurons
		> uint32_t layers[4] = {2, 8, 9, 1};
		> struct fann *ann = fann_create_standard_array(4, layers);

	See also:
		<fann_create_standard>, <fann_create_sparse>, <fann_create_shortcut>

	This function appears in FANN >= 2.0.0.
*/ 
struct fann *fann_create_standard_array(uint32_t num_layers,
													           const uint32_t *layers);

/* Function: fann_create_sparse

	Creates a standard backpropagation neural network, which is not fully connected.

	Parameters:
		connection_rate - The connection rate controls how many connections there will be in the
   			network. If the connection rate is set to 1, the network will be fully
   			connected, but if it is set to 0.5 only half of the connections will be set.
			A connection rate of 1 will yield the same result as <fann_create_standard>
		num_layers - The total number of layers including the input and the output layer.
		... - Integer values determining the number of neurons in each layer starting with the 
			input layer and ending with the output layer.
			
	Returns:
		A pointer to the newly created <struct fann>.

	See also:
		<fann_create_sparse_array>, <fann_create_standard>, <fann_create_shortcut>

	This function appears in FANN >= 2.0.0.
*/
struct fann *fann_create_sparse(float connection_rate, 
	                                                   uint32_t num_layers, ...);


/* Function: fann_create_sparse_array
   Just like <fann_create_sparse>, but with an array of layer sizes
   instead of individual parameters.

	See <fann_create_standard_array> for a description of the parameters.

	See also:
		<fann_create_sparse>, <fann_create_standard>, <fann_create_shortcut>

	This function appears in FANN >= 2.0.0.
*/
struct fann *fann_create_sparse_array(float connection_rate, 
	                                                         uint32_t num_layers, 
															 const uint32_t *layers);

/* Function: fann_create_shortcut

	Creates a standard backpropagation neural network, which is fully connected and which
	also has shortcut connections.

 	Shortcut connections are connections that skip layers. A fully connected network with shortcut 
	connections is a network where all neurons are connected to all neurons in later layers. 
	Including direct connections from the input layer to the output layer.

	See <fann_create_standard> for a description of the parameters.

	See also:
		<fann_create_shortcut_array>, <fann_create_standard>, <fann_create_sparse>, 

	This function appears in FANN >= 2.0.0.
*/ 
struct fann *fann_create_shortcut(uint32_t num_layers, ...);

/* Function: fann_create_shortcut_array
   Just like <fann_create_shortcut>, but with an array of layer sizes
   instead of individual parameters.

	See <fann_create_standard_array> for a description of the parameters.

	See also:
		<fann_create_shortcut>, <fann_create_standard>, <fann_create_sparse>

	This function appears in FANN >= 2.0.0.
*/
struct fann *fann_create_shortcut_array(uint32_t num_layers,
															   const uint32_t *layers);
/* Function: fann_destroy
   Destroys the entire network, properly freeing all the associated memory.

	This function appears in FANN >= 1.0.0.
*/ 
void fann_destroy(struct fann *ann);


/* Function: fann_copy
   Creates a copy of a fann structure. 
   
   Data in the user data <fann_set_user_data> is not copied, but the user data pointer is copied.

	This function appears in FANN >= 2.2.0.
*/ 
struct fann * fann_copy(struct fann *ann);


/* Function: fann_run
	Will run input through the neural network, returning an array of outputs, the number of which being 
	equal to the number of neurons in the output layer.

	See also:
		<fann_test>

	This function appears in FANN >= 1.0.0.
*/ 
fann_type * fann_run(struct fann *ann, fann_type * input);

/* Function: fann_randomize_weights
	Give each connection a random weight between *min_weight* and *max_weight*
   
	From the beginning the weights are random between -0.1 and 0.1.

	See also:
		<fann_init_weights>

	This function appears in FANN >= 1.0.0.
*/ 
void fann_randomize_weights(struct fann *ann, fann_type min_weight,
												   fann_type max_weight);

/* Function: fann_init_weights
  	Initialize the weights using Widrow + Nguyen's algorithm.
	
 	This function behaves similarly to fann_randomize_weights. It will use the algorithm developed 
	by Derrick Nguyen and Bernard Widrow to set the weights in such a way 
	as to speed up training. This technique is not always successful, and in some cases can be less 
	efficient than a purely random initialization.

	The algorithm requires access to the range of the input data (ie, largest and smallest input), 
	and therefore accepts a second argument, data, which is the training data that will be used to 
	train the network.

	See also:
		<fann_randomize_weights>, <fann_read_train_from_file>

	This function appears in FANN >= 1.1.0.
*/ 
void fann_init_weights(struct fann *ann, struct fann_train_data *train_data);

/* Function: fann_print_connections
	Will print the connections of the ann in a compact matrix, for easy viewing of the internals 
	of the ann.

	The output from fann_print_connections on a small (2 2 1) network trained on the xor problem
	>Layer / Neuron 012345
	>L   1 / N    3 BBa...
	>L   1 / N    4 BBA...
	>L   1 / N    5 ......
	>L   2 / N    6 ...BBA
	>L   2 / N    7 ......
		  
	This network has five real neurons and two bias neurons. This gives a total of seven neurons 
	named from 0 to 6. The connections between these neurons can be seen in the matrix. "." is a 
	place where there is no connection, while a character tells how strong the connection is on a 
	scale from a-z. The two real neurons in the hidden layer (neuron 3 and 4 in layer 1) have 
	connections from the three neurons in the previous layer as is visible in the first two lines. 
	The output neuron (6) has connections from the three neurons in the hidden layer 3 - 5 as is 
	visible in the fourth line.

	To simplify the matrix output neurons are not visible as neurons that connections can come from, 
	and input and bias neurons are not visible as neurons that connections can go to.

	This function appears in FANN >= 1.2.0.
*/ 
void fann_print_connections(struct fann *ann);

/* Group: Parameters */
/* Function: fann_print_parameters

  	Prints all of the parameters and options of the ANN 

	This function appears in FANN >= 1.2.0.
*/ 
void fann_print_parameters(struct fann *ann);


/* Function: fann_get_num_input

   Get the number of input neurons.

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_num_input(struct fann *ann);


/* Function: fann_get_num_output

   Get the number of output neurons.

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_num_output(struct fann *ann);


/* Function: fann_get_total_neurons

   Get the total number of neurons in the entire network. This number does also include the 
	bias neurons, so a 2-4-2 network has 2+4+2 +2(bias) = 10 neurons.

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_total_neurons(struct fann *ann);


/* Function: fann_get_total_connections

   Get the total number of connections in the entire network.

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_total_connections(struct fann *ann);

/* Function: fann_get_network_type

    Get the type of neural network it was created as.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

	Returns:
        The neural network type from enum <fann_network_type_enum>

    See Also:
        <fann_network_type_enum>

   This function appears in FANN >= 2.1.0
*/
enum fann_nettype_enum fann_get_network_type(struct fann *ann);

/* Function: fann_get_connection_rate

    Get the connection rate used when the network was created

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

	Returns:
        The connection rate

   This function appears in FANN >= 2.1.0
*/
float fann_get_connection_rate(struct fann *ann);

/* Function: fann_get_num_layers

    Get the number of layers in the network

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.
			
	Returns:
		The number of layers in the neural network
			
	Example:
		> // Obtain the number of layers in a neural network
		> struct fann *ann = fann_create_standard(4, 2, 8, 9, 1);
        > uint32_t num_layers = fann_get_num_layers(ann);

   This function appears in FANN >= 2.1.0
*/
uint32_t fann_get_num_layers(struct fann *ann);

/*Function: fann_get_layer_array

    Get the number of neurons in each layer in the network.

    Bias is not included so the layers match the fann_create functions.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    The layers array must be preallocated to at least
    sizeof(uint32_t) * fann_num_layers() long.

   This function appears in FANN >= 2.1.0
*/
void fann_get_layer_array(struct fann *ann, uint32_t *layers);

/* Function: fann_get_bias_array

    Get the number of bias in each layer in the network.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    The bias array must be preallocated to at least
    sizeof(uint32_t) * fann_num_layers() long.

   This function appears in FANN >= 2.1.0
*/
void fann_get_bias_array(struct fann *ann, uint32_t *bias);

/* Function: fann_get_connection_array

    Get the connections in the network.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    The connections array must be preallocated to at least
    sizeof(struct fann_connection) * fann_get_total_connections() long.

   This function appears in FANN >= 2.1.0
*/
void fann_get_connection_array(struct fann *ann,
    struct fann_connection *connections);

/* Function: fann_set_weight_array

    Set connections in the network.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    Only the weights can be changed, connections and weights are ignored
    if they do not already exist in the network.

    The array must have sizeof(struct fann_connection) * num_connections size.

   This function appears in FANN >= 2.1.0
*/
void fann_set_weight_array(struct fann *ann,
    struct fann_connection *connections, uint32_t num_connections);

/* Function: fann_set_weight

    Set a connection in the network.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    Only the weights can be changed. The connection/weight is
    ignored if it does not already exist in the network.

   This function appears in FANN >= 2.1.0
*/
void fann_set_weight(struct fann *ann,
    uint32_t from_neuron, uint32_t to_neuron, fann_type weight);

/* Function: fann_get_weights

    Get all the network weights.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.
		weights - A fann_type pointer to user data. It is the responsibility
			of the user to allocate sufficient space to store all the weights.

   This function appears in FANN >= x.y.z
*/
void fann_get_weights(struct fann *ann, fann_type *weights);


/* Function: fann_set_weights

    Set network weights.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.
		weights - A fann_type pointer to user data. It is the responsibility
			of the user to make the weights array sufficient long 
			to store all the weights.

   This function appears in FANN >= x.y.z
*/
void fann_set_weights(struct fann *ann, fann_type *weights);


/* Function: fann_set_user_data

    Store a pointer to user defined data. The pointer can be
    retrieved with <fann_get_user_data> for example in a
    callback. It is the user's responsibility to allocate and
    deallocate any data that the pointer might point to.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.
		user_data - A void pointer to user defined data.

   This function appears in FANN >= 2.1.0
*/
void fann_set_user_data(struct fann *ann, void *user_data);

/* Function: fann_get_user_data

    Get a pointer to user defined data that was previously set
    with <fann_set_user_data>. It is the user's responsibility to
    allocate and deallocate any data that the pointer might point to.

    Parameters:
		ann - A previously created neural network structure of
            type <struct fann> pointer.

    Returns:
        A void pointer to user defined data.

   This function appears in FANN >= 2.1.0
*/
void * fann_get_user_data(struct fann *ann);

/* Function: fann_disable_seed_rand

   Disables the automatic random generator seeding that happens in FANN.

   Per default FANN will always seed the random generator when creating a new network,
   unless FANN_NO_SEED is defined during compilation of the library. This method can
   disable this at runtime.

   This function appears in FANN >= 2.3.0
*/
void fann_disable_seed_rand();

/* Function: fann_enable_seed_rand

   Enables the automatic random generator seeding that happens in FANN.

   Per default FANN will always seed the random generator when creating a new network,
   unless FANN_NO_SEED is defined during compilation of the library. This method can
   disable this at runtime.

   This function appears in FANN >= 2.3.0
*/
void fann_enable_seed_rand();


#ifdef FIXEDFANN
	
/* Function: fann_get_decimal_point

	Returns the position of the decimal point in the ann.

	This function is only available when the ANN is in fixed point mode.

	The decimal point is described in greater detail in the tutorial <Fixed Point Usage>.

	See also:
		<Fixed Point Usage>, <fann_get_multiplier>, <fann_save_to_fixed>, <fann_save_train_to_fixed>

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_decimal_point(struct fann *ann);


/* Function: fann_get_multiplier

    returns the multiplier that fix point data is multiplied with.

	This function is only available when the ANN is in fixed point mode.

	The multiplier is the used to convert between floating point and fixed point notation. 
	A floating point number is multiplied with the multiplier in order to get the fixed point
	number and visa versa.

	The multiplier is described in greater detail in the tutorial <Fixed Point Usage>.

	See also:
		<Fixed Point Usage>, <fann_get_decimal_point>, <fann_save_to_fixed>, <fann_save_train_to_fixed>

	This function appears in FANN >= 1.0.0.
*/ 
uint32_t fann_get_multiplier(struct fann *ann);

#endif	/* FIXEDFANN */

#ifdef __cplusplus
#ifndef __cplusplus
/* to fool automatic indention engines */ 
{
	
#endif
} 
#endif	/* __cplusplus */
	
#endif	/* __fann_h__ */
	
#endif /* NOT FANN_INCLUDE */
