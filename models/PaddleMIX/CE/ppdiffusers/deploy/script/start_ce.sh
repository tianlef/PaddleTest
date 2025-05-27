#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/deploy
echo ${work_path}

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
exit_code=0

cd ${work_path}


choose_list=(
    "controlnet"
    "ipadapter/sd15"
    "ipadapter/sdxl"
    "sd15"
    "sdxl"
)
len=${#choose_list[@]}
index=$((RANDOM % len))
echo "Randomly selected model: ${choose_list[$index]}"
random=${choose_list[$index]}
# controlnet
cd ${random}
random_name="${random//\//_}"
(bash scripts/benchmark_paddle_deploy.sh) 2>&1 | tee ${log_dir}/${random_name}_paddle.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${random_name}_paddle  success" >>"${log_dir}/ce_res.log"
else
    echo "${random_name}_paddle  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${random_name}_paddle end***********"


# controlnet_tensorrt
(bash scripts/benchmark_paddle_deploy_tensorrt.sh) 2>&1 | tee ${log_dir}/${random_name}_tensorrt.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${random_name}_tensorrt  success" >>"${log_dir}/ce_res.log"
else
    echo "${random_name}_tensorrt  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${random_name}_tensorrt end***********"

echo exit_code:${exit_code}