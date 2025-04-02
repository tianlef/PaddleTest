#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}
log_dir=${root_path}/paddlemix_log_deploy
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

export PYTHONPATH=$PYTHONPATH:${cur_path}/PaddleMIX


work_path2=${root_path}/PaddleMIX
echo ${work_path2}

cd ${root_path}/PaddleMIX/PaddleNLP
cd csrc
python setup_cuda.py install

cd ${cur_path}
/bin/cp -rf ./* ${work_path2}/

cd ${work_path2}


exit_code=0
model_name=deepseek_vl2
case_name=fp16
# infernece
(export CUDA_VISIBLE_DEVICES=0 && 
export FLAGS_cascade_attention_max_partition_size=163840 && 
export FLAGS_mla_use_tensorcore=1 &&
python deploy/deepseek_vl2/deepseek_vl2_infer.py \
    --model_name_or_path deepseek-ai/deepseek-vl2-small \
    --question "Describe this image." \
    --image_file paddlemix/demo_images/examples_image1.jpg \
    --min_length 128 \
    --max_length 128 \
    --top_k 1 \
    --top_p 0.001 \
    --temperature 0.1 \
    --repetition_penalty 1.05 \
    --block_attn True \
    --inference_model True \
    --append_attn True \
    --mode dynamic \
    --dtype bfloat16 \
    --mla_use_matrix_absorption) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name=wint8
(export CUDA_VISIBLE_DEVICES=0 && 
export FLAGS_cascade_attention_max_partition_size=163840 &&
export FLAGS_mla_use_tensorcore=1 &&
python deploy/deepseek_vl2/deepseek_vl2_infer.py \
    --model_name_or_path deepseek-ai/deepseek-vl2-small \
    --question "Describe this image." \
    --image_file paddlemix/demo_images/examples_image1.jpg \
    --min_length 128 \
    --max_length 128 \
    --top_k 1 \
    --top_p 0.001 \
    --temperature 0.1 \
    --repetition_penalty 1.05 \
    --block_attn True \
    --inference_model True \
    --append_attn True \
    --mode dynamic \
    --dtype bfloat16 \
    --mla_use_matrix_absorption \
    --quant_type "weight_only_int8") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name}  success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name}  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name}  end***********"



case_name=scripts
(sh deploy/deepseek_vl2/shell/run.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


echo exit_code:${exit_code}

exit ${exit_code}
