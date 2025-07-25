#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX
echo ${work_path}


log_dir=${root_path}/paddlemix_log
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}

cd ${work_path}
exit_code=0
# bash prepare.sh

model_name="qwen25vl"


case_name="single-infer" 

echo "*******${model_name}_${case_name} begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_5_vl/single_image_infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

case_name="multi-infer"
echo "*******${model_name}_${case_name} begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_5_vl/multi_image_infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="video-infer"
echo "*******${model_name}_${case_name} begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_5_vl/video_infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="batch-infer"
echo "*******${model_name}_${case_name} begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_5_vl/single_image_batch_infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="distributed-infer"
echo "*******${model_name}_${case_name} begin***********"
(sh paddlemix/examples/qwen2_5_vl/shell/distributed_qwen2_5_vl_infer_3B.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="baseline-3b-lora-bs32-1e8-1mp"
echo "*******${model_name}_${case_name} begin***********"
(bash qwen25vl_lora_1mp.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

case_name="baseline-3b-bs32-1e8"
echo "*******${model_name}_${case_name} begin***********"
(sed -i 's|^meta_path=.*|meta_path='paddlemix/examples/qwen2_vl/configs/demo_chartqa_500.json'|' paddlemix/examples/qwen2_5_vl/shell/baseline_3b_bs32_1e8.sh && sh paddlemix/examples/qwen2_5_vl/shell/baseline_3b_bs32_1e8.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="after-infer-3b-bs32-1e8"
echo "*******${model_name}_${case_name} begin***********"
(python paddlemix/examples/qwen2_5_vl/single_image_infer.py --model_path='work_dirs/baseline_330k_3b_bs32_1e8') 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

case_name="baseline-3b-lora-bs32-1e8"
echo "*******${model_name}_${case_name} begin***********"
(sed -i 's|^meta_path=.*|meta_path='paddlemix/examples/qwen2_vl/configs/demo_chartqa_500.json'|' paddlemix/examples/qwen2_5_vl/shell/baseline_3b_lora_bs32_1e8.sh && sh paddlemix/examples/qwen2_5_vl/shell/baseline_3b_lora_bs32_1e8.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"




echo exit_code:${exit_code}
exit ${exit_code}