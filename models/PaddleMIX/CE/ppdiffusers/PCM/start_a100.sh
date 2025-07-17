#!/bin/bash


cur_path=$(pwd)
echo ${cur_path}


work_path=${root_path}/PaddleMIX/ppdiffusers/examples/Fast-Diffusers/diffusion-distill/phased_consistency_distillation
echo ${work_path}

log_dir=${root_path}/ppdiffusers_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}


cd ${work_path}
exit_code=0

bash prepare.sh

model_name="PCM"
case_name="train"

echo "*******${model_name}_${case_name} begin***********"
(bash train.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

case_name="infer"
echo "*******${model_name}_${case_name} begin***********"
(python infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
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