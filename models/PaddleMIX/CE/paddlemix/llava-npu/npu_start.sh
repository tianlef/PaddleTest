#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

tool_path=${root_path}/PaddleTest/models/PaddleMIX/Tools
/bin/cp -rf ./* ${work_path}/
/bin/cp -f ${tool_path}/check_loss.py ${work_path}/
exit_code=0

cd ${work_path}

# 下载依赖、数据集和权重
bash prepare.sh

# infer
export FLAGS_use_cuda_managed_memory=true
export FLAGS_allocator_strategy=auto_growth
export ASCEND_RT_VISIBLE_DEVICES=8
export FLAGS_npu_storage_format=0
export FLAGS_use_stride_kernel=0
export FLAGS_npu_jit_compile=0
export FLAGS_npu_scale_aclnn=True
export FLAGS_npu_split_aclnn=True
export FLAGS_allocator_strategy=auto_growth
export CUSTOM_DEVICE_BLACK_LIST=set_value,set_value_with_tensor


(python paddlemix/examples/llava/run_predict_multiround.py \
    --model-path "liuhaotian/llava-v1.6-vicuna-7b" \
    --image-file "https://bj.bcebos.com/v1/paddlenlp/models/community/GroundingDino/000000004505.jpg" \
    --fp16) 2>&1 | tee ${log_dir}/paddlemix_llava_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix llava infer run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix llava infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava infer end***********"

echo "*******paddlemix llava finetune***********"

echo "*******paddlemix llava sft 1.5***********"
(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_sft_1.5.json") 2>&1 | tee ${log_dir}/paddlemix_llava_sft_1.5.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix llava sft 1.5 run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix llava sft 1.5  run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava 1.5 sft end***********"

echo "*******paddlemix llava lora 1.5 ***********"

(python  -u check_loss.py "python paddlemix/examples/llava/supervised_finetune.py llava_v100_lora_1.5.json") 2>&1 | tee ${log_dir}/paddlemix_llava_lora.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix llava lora 1.5 run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix llava lora 1.5 run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix llava lora 1.5 end***********"

unset FLAGS_use_cuda_managed_memory
unset FLAGS_allocator_strategy

echo exit_code:${exit_code}
exit ${exit_code}