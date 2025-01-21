#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/cinn_log

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

export FLAGS_prim_all=true
export FLAGS_prim_enable_dynamic=true
export FLAGS_use_cinn=true
export MIN_GRAPH_SIZE=0
export FLAGS_prim_forward_blacklist="pd_op.dropout"

echo "*******paddlemix qwen_vl sft***********"
(python  -u check_loss.py "python paddlemix/tools/supervised_finetune.py qwen_vl_v100_sft.json") 2>&1 | tee ${log_dir}/paddlemix_qwen_vl_sft.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix qwen_vl sft run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix qwen_vl sft run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen_vl sft end***********"

echo "*******paddlemix qwen_vl lora***********"

(python -u check_loss.py "python paddlemix/tools/supervised_finetune.py qwen_vl_v100_lora.json") 2>&1 | tee ${log_dir}/paddlemix_qwen_vl_lora.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix qwen_vl lora run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix qwen_vl lora run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix q wen lora end***********"
echo exit_code:${exit_code}

unset FLAGS_prim_all
unset FLAGS_prim_enable_dynamic
unset FLAGS_use_cinn
unset MIN_GRAPH_SIZE
unset FLAGS_prim_forward_blacklist

exit ${exit_code}
