#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
exit_code=0

cd ${work_path}

# 下载依赖、数据集和权重
bash prepare.sh

# infer
export FLAGS_use_cuda_managed_memory=true
export FLAGS_allocator_strategy=auto_growth


echo "*******paddlemix llava finetune***********"
# llava pretain 有报错
(python  -u check_loss.py "python paddlemix/examples/llava/pretrain.py llava_v100_pretrain.json") 2>&1 | tee ${log_dir}/llava_finetune.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_finetune run success" >>"${log_dir}/ce_res.log"
else
    echo "llava_finetune run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava finetune end***********"

echo "*******paddlemix llava sft***********"
(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_sft.json") 2>&1 | tee ${log_dir}/llava_sft.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_sft run success" >>"${log_dir}/ce_res.log"
else
    echo "llava_sft run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava sft end***********"

echo "*******paddlemix llava lora***********"

(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_lora.json") 2>&1 | tee ${log_dir}/llava_lora.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_lora run success" >>"${log_dir}/ce_res.log"
else
    echo "llava_lora run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava lora end***********"

echo "*******paddlemix llava sft 1.5***********"
(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_sft_1.5.json") 2>&1 | tee ${log_dir}/llava_sft_1.5.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_sft_1.5 run success" >>"${log_dir}/ce_res.log"
else
    echo "llava_sft_1.5  run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava 1.5 sft end***********"

echo "*******paddlemix llava lora 1.5 ***********"

(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_lora_1.5.json") 2>&1 | tee ${log_dir}/llava_lora.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_lora run success" >>"${log_dir}/ce_res.log"
else
    echo "llava_lora run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava lora 1.5 end***********"

# model_name=llava
# case_name=merge_lora

# (python paddlemix/examples/llava/merge_lora_params.py \
#     --model_name_or_path paddlemix/llava/llava-v1.5-7b \
#     --lora_path ./checkpoints/llava_sft_ckpts \
#     --merge_model_path ./checkpoints/merge_lora ) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******${model_name}_${case_name} end***********"

unset FLAGS_use_cuda_managed_memory
unset FLAGS_allocator_strategy

echo exit_code:${exit_code}
exit ${exit_code}