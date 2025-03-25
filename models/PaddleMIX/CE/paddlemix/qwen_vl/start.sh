#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
/bin/cp -f ../check_loss.py ${work_path}/
exit_code=0

cd ${work_path}

export FLAGS_use_cuda_managed_memory=true
export FLAGS_allocator_strategy=auto_growth
bash prepare.sh

cd paddlemix/external_ops
python setup.py install

cd ${work_path}
# qwen_vl 单轮预测和多轮预测需要手动测试暂时没有自动化脚本
# echo "*******qwen_vl single_infer***********"
# (python paddlemix/examples/qwen_vl/run_predict.py \
#     --model_name_or_path "qwen-vl/qwen-vl-7b" \
#     --input_image "https://bj.bcebos.com/v1/paddlenlp/models/community/GroundingDino/000000004505.jpg" \
#     --prompt "Generate the caption in English with grounding:" \
#     --dtype "bfloat16") 2>&1 | tee ${log_dir}/qwen_vl_single_infer.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "qwen_vl single_infer run success" >>"${log_dir}/ce_res.log"
# else
#     echo "qwen_vl single_infer run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******qwen_vl single_infer end***********"

# echo "*******qwen_vl multi_infer***********"
# (python paddlemix/examples/qwen_vl/chat_demo.py) 2>&1 | tee ${log_dir}/qwen_vl_multi_infer.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "qwen_vl multi_infer run success" >>"${log_dir}/ce_res.log"
# else
#     echo "qwen_vl multi_infer run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******qwen_vl multi_infer end***********"

# echo "*******qwen_vl appflow_infer***********"
# (python appflow_infer.py) 2>&1 | tee ${log_dir}/qwen_vl_appflow_infer.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "qwen_vl appflow_infer run success" >>"${log_dir}/ce_res.log"
# else
#     echo "qwen_vl appflow_infer run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******qwen_vl appflow_infer end***********"



(bash qwen_vl_v100_sft.sh) 2>&1 | tee ${log_dir}/qwen_vl_fintune.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen_vl finetune run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen_vl finetune run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen_vl finetune end***********"
echo exit_code:${exit_code}

(bash qwen_vl_single_train.sh) 2>&1 | tee ${log_dir}/qwen_vl_single_finetune.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen_vl single finetune run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen_vl single finetune run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen_vl single finetune end***********"
echo exit_code:${exit_code}
# cat ${log_dir}/ce_res.log
exit ${exit_code}
