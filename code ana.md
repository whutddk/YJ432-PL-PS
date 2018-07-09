
--------------------

# fann 代码分析

* 执行部分核心算力聚集在
>>fann_run()

## fann_run()



-------------------

* 训练部分核心算力聚集在
>>fann_train()

## fann_train(ann,input,desired_output)
    
>>{
>>  * fann_run(ann,input)
>>  * fann_compute_MSE(ann,desired_output)
>>  * fann_backpropagate_MSE(ann)
>>  * fann_update_weights(ann)
>>}

用于反向传递算法

1. 先按现有网络执行一次，得到输出
2. 计算均方差
3. 均方差后向传递
4. 为增强学习更新权重



----------------------------

## ann结构体

* errno_f       上一个错误号
* error_log     错误日志
* errstr         上一个错误内容
* learning_rate     学习速度
* learning_momentum     后向学习动量
* connection_rate       连接率 0~1 1为全连接
* network_type          网络类型：1 快速连接 跳过层 0 其他
* first_layer 输入层指针
* last_layer 下一层指针
* **total_neurons**    总神经元数
* num_input         输入神经元数
* num_output        输出神经元数
* weights           权重数组
* fann_neuron **connections ·连接数组
* train_errors      用于训练中收集偏差，在第一次训练时分配，如果不训练则不分配
* training_algorithm    训练的算法 在调用fann_train_on_..时赋值

-----------------------------------
`定点类`
* decimal_point     十进制小数点位置，Q级数移位用
* multiplier        乘法器，在特殊情况下使用，用于乘定点数
* S函数类
    - fann_type sigmoid_results[6];
    - fann_type sigmoid_values[6];
    - fann_type sigmoid_symmetric_results[6];
    - fann_type sigmoid_symmetric_values[6];

--------------------------------------

* **total_connections** 总连接数
* output                用于保存输出
* num_MSE               用于计算均方根的数据数量
* MSE_value             总偏差（还没用平均的。。。）
* num_bit_fail          失败的输出数量（用于分类问题）
* bit_fail_limit        最大。。。没看懂
* train_error_function  训练过程中使用的偏差方程
* train_stop_function   训练中的停止方程选择，默认FANN_STOPFUNC_MSE
* callback              训练过程中的回调函数
* user_data             用户定义数据指针？？？
* cascade_output_change_fraction        Cascade中最小有效改变分数
* cascade_output_stagnation_epochs      这个时间点上没有改变将会导致训练停滞
* cascade_candidate_change_fraction     Cascade中最小有效改变小数
* cascade_candidate_stagnation_epochs   这个时间点上没有改变将会导致训练停滞
* cascade_best_candidate                当前最好的候选，将会被安装？
* cascade_candidate_limit               上限值 candidate score

    /* Scale of copied candidate output weights
     */
* cascade_weight_multiplier;
    
    /* Maximum epochs to train the output neurons during cascade training
     */
* cascade_max_out_epochs;
    
    /* Maximum epochs to train the candidate neurons during cascade training
     */
* cascade_max_cand_epochs;   

    /* Minimum epochs to train the output neurons during cascade training
     */
* cascade_min_out_epochs;
    
    /* Minimum epochs to train the candidate neurons during cascade training
     */
* cascade_min_cand_epochs;   

    /* An array consisting of the activation functions used when doing
     * cascade training.
     */
* cascade_activation_functions;
    
    /* The number of elements in the cascade_activation_functions array.
    */
* cascade_activation_functions_count;
    
    /* An array consisting of the steepnesses used during cascade training.
    */
* cascade_activation_steepnesses;

    /* The number of elements in the cascade_activation_steepnesses array.
    */
* cascade_activation_steepnesses_count;
    
    /* The number of candidates of each type that will be present.
     * The actual number of candidates is then 
     * cascade_activation_functions_count * 
     * cascade_activation_steepnesses_count *
     * cascade_num_candidate_groups
    */
* cascade_num_candidate_groups;
    
    /* An array consisting of the score of the individual candidates,
     * which is used to decide which candidate is the best
     */
* cascade_candidate_scores;
    
    /* The number of allocated neurons during cascade correlation algorithms.
     * This number might be higher than the actual number of neurons to avoid
     * allocating new space too often.
     */
* total_neurons_allocated;

    /* The number of allocated connections during cascade correlation algorithms.
     * This number might be higher than the actual number of neurons to avoid
     * allocating new space too often.
     */
* total_connections_allocated;

    /* Variables for use with Quickprop training */

    /* Decay is used to make the weights not go so high */
    float quickprop_decay;

    /* Mu is a factor used to increase and decrease the stepsize */
* quickprop_mu;

    /* Variables for use with with RPROP training */

    /* Tells how much the stepsize should increase during learning */
* rprop_increase_factor;

    /* Tells how much the stepsize should decrease during learning */
* rprop_decrease_factor;

    /* The minimum stepsize */
* rprop_delta_min;

    /* The maximum stepsize */
* rprop_delta_max;

    /* The initial stepsize */
* rprop_delta_zero;
        
    /* Defines how much the weights are constrained to smaller values at the beginning */
* sarprop_weight_decay_shift;

    /* Decides if the stepsize is too big with regard to the error */
* sarprop_step_error_threshold_factor;

    /* Defines how much the stepsize is influenced by the error */
* sarprop_step_error_shift;

    /* Defines how much the epoch influences weight decay and noise */
* sarprop_temperature;

    /* Current training epoch */
* sarprop_epoch;

    /* Used to contain the slope errors used during batch training
     * Is allocated during first training session,
     * which means that if we do not train, it is never allocated.
     */
* train_slopes;

    /* The previous step taken by the quickprop/rprop procedures.
     * Not allocated if not used.
     */
* prev_steps;

    /* The slope values used by the quickprop/rprop procedures.
     * Not allocated if not used.
     */
* prev_train_slopes;
        
    /* The last delta applied to a connection weight.
     * This is used for the momentum term in the backpropagation algorithm.
     * Not allocated if not used.    
     */
* prev_weights_deltas;


------------------------------
`浮点类`   
* scale_mean_in         除去输入中的直流分量
* scale_deviation_in    标准差用于归一化输入数据到-1~1
* scale_new_min_in      用户定义最小输入值比例
* scale_factor_in       用户定义最大输入值比例
* scale_mean_out        用于出去输出中的直流分量
* scale_deviation_out   标准差用于归一化输出数据到-1~1
* scale_new_min_out     用户定义最小输出值比例
* scale_factor_out      用户定义最大输出值比例
----------------------------------



