#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

exit_code=0

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

echo "qwen_vl deploy old ir" >> ${log_dir}/ce_res.log
export FLAGS_enable_pir_api=0
bash qwen_deploy.sh
exit_code=$(($exit_code + $?))

echo "qwen_vl deploy pir" >> ${log_dir}/ce_res.log
export FLAGS_enable_pir_api=1
bash qwen_deploy.sh
exit_code=$(($exit_code + $?))
cat ${log_dir}/ce_res.log

unset FLAGS_enable_pir_api
echo exit_code:${exit_code}
exit ${exit_code}
