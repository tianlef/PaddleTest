#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log_deploy

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
exit_code=0

cd ${root_path}/PaddleMIX/
export http_proxy=${proxy}
export https_proxy=${proxy}


cd ${work_path}
# 通用
# bash ppboee_prepare.sh

echo "*******paddlemix deploy ppboee begin***********"
cd ${work_path}

(python deploy/ppdocbee/single_image_infer.py \
    --model_name_or_path PaddleMIX/PPDocBee-2B-1129 \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/run_deploy_ppdocbee.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy ppdocbee run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy ppdocbee run fail" >>"${log_dir}/ce_res.log"
fi
cd ${work_path}

# 检查命令是否成功执行
if [ ${exit_code} -ne 0 ]; then
    exit 1
fi
