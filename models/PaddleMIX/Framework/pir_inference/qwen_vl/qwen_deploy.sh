#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}/
exit_code=0

cd ${root_path}/PaddleMIX/
export http_proxy=${proxy}
export https_proxy=${proxy}

cd ${work_path}
bash prepare_qwen.sh

export FLAGS_enable_pir_api=0
echo "*******paddlemix deploy qwen_ql begin***********"

#静态图模型导出
(bash qwen_export.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_export.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql export run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql export run fail" >>"${log_dir}/ce_res.log"
fi

#转出静态图推理所需的语言模型
(bash qwen_export_language.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_language.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql language run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql language run fail" >>"${log_dir}/ce_res.log"
fi

export FLAGS_enable_pir_api=1

(bash qwen_export_pir.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_export-pir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql export pir run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql export pir run fail" >>"${log_dir}/ce_res.log"
fi

#转出静态图推理所需的语言模型
(bash qwen_export_language_pir.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_language-pir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql language pir run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql language pir run fail" >>"${log_dir}/ce_res.log"
fi

# predict
cd ${work_path}
#转出静态图推理所需的语言模型
#00
(bash qwen_predict.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_predict.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql predict run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql predict run fail" >>"${log_dir}/ce_res.log"
fi
##01

(bash qwen_predict.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_predict-01.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql predict 01 run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql predict 01 run fail" >>"${log_dir}/ce_res.log"
fi

echo "*******paddlemix deploy qwen_ql end***********"
export FLAGS_enable_pir_api=0
(bash qwen_predict_pir.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_predict-10.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql predict 10 run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql predict 10 run fail" >>"${log_dir}/ce_res.log"
fi

export FLAGS_enable_pir_api=1
echo "*******paddlemix deploy qwen_ql end***********"
(bash qwen_predict_pir.sh) 2>&1 | tee ${log_dir}/run_deploy_qwen_ql_predict-11.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "paddlemix deploy qwen_ql predict 11 run success" >>"${log_dir}/ce_res.log"
else
    echo "paddlemix deploy qwen_ql predict 11 run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deploy qwen_ql end***********"
# 检查命令是否成功执行
if [ ${exit_code} -ne 0 ]; then
    exit 1
fi
