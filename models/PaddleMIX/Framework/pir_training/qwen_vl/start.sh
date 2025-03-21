#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/pir_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
/bin/cp -f ../../check_loss.py ${work_path}/
exit_code=0

cd ${work_path}

export FLAGS_use_cuda_managed_memory=true
export FLAGS_allocator_strategy=auto_growth
bash prepare.sh

echo "*******qwen_vl sft***********"
(python  -u check_loss.py "python paddlemix/examples/qwen_vl/finetune.py qwen_vl_v100_sft.json") 2>&1 | tee ${log_dir}/qwen_vl_sft.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen_vl sft run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen_vl sft run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen_vl sft end***********"

echo "*******qwen_vl sft***********"

(python -u check_loss.py "python paddlemix/examples/qwen_vl/finetune.py qwen_vl_v100_lora.json") 2>&1 | tee ${log_dir}/qwen_vl_lora.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen_vl lora run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen_vl lora run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen_vl lora end***********"
echo exit_code:${exit_code}


exit ${exit_code}
