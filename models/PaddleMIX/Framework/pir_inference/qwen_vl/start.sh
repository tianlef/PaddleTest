#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

exit_code=0

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi



bash qwen_deploy.sh
exit_code=$(($exit_code + $?))



unset FLAGS_enable_pir_api
echo exit_code:${exit_code}
exit ${exit_code}
