#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
/bin/cp -rf ../check_loss.py ${work_path}

# 下载数据集
cd ${work_path}
# bash prepare.sh
exit_code=0

model_name=janus

case_name=understanding
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/janus/run_understanding_inference.py \
    --model_path="deepseek-ai/Janus-1.3B" \
    --image_file="paddlemix/demo_images/examples_image1.jpg" \
    --question="What is shown in this image?" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=generation
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/janus/run_generation_inference.py \
    --model_path="deepseek-ai/Janus-1.3B" \
    --prompt="A stunning princess from kabul in red, white traditional clothing, blue eyes, brown hair" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=JanusFlow_generation
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/janus/run_generation_inference_janusflow.py \
    --model_path="deepseek-ai/JanusFlow-1.3B" \
    --inference_step=30 \
    --prompt="A stunning princess from kabul in red, white traditional clothing, blue eyes, brown hair" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=interactivechat
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/janus/run_interactivechat.py \
    --model_path="deepseek-ai/Janus-1.3B" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

echo exit_code:${exit_code}

# cat ${log_dir}/ce_res.log
exit ${exit_code}