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

python -m pip install ml_dtypes
exit_code=0
model_name=qwen25_vl_deploy
case_name=fp16
# infernece
(export CUDA_VISIBLE_DEVICES=0
python deploy/qwen2_5_vl/qwen2_5_vl_infer.py \
    --model_name_or_path Qwen/Qwen2.5-VL-7B-Instruct \
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
    --mode dynamic \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name=wint8
(python deploy/qwen2_5_vl/qwen2_5_vl_infer.py \
    --model_name_or_path Qwen/Qwen2.5-VL-3B-Instruct \
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
    --mode dynamic \
    --dtype bfloat16 \
    --quant_type "weight_only_int8" \
    --benchmark True) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name}  success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name}  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name}  end***********"

case_name=tp
(export CUDA_VISIBLE_DEVICES=0,1,2,3
python -m paddle.distributed.launch --gpus "0,1,2,3" deploy/qwen2_5_vl/qwen2_5_vl_infer.py \
    --model_name_or_path Qwen/Qwen2.5-VL-72B-Instruct \
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
    --mode dynamic \
    --append_attn 1 \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"



case_name=scripts
(sh deploy/qwen2_5_vl/scripts/qwen2_5_vl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
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
