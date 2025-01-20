#!/bin/bash

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

# 旧IR导出 + 旧IR推理
export FLAGS_enable_pir_api=0
(bash infer_script_old.sh) 2>&1 | tee ${log_dir}/llava_allold.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava infer all old success" >>"${log_dir}/ce_res.log"
else
    echo "llava infer  all old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava all old end***********"


# 旧IR导出 + 新IR推理
export FLAGS_enable_pir_api=1
(bash infer_script_old.sh) 2>&1 | tee ${log_dir}/llava_old_new.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava infer old_new success" >>"${log_dir}/ce_res.log"
else
    echo "llava infer  old_new fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava old_new end***********"

# 新IR导出 + 旧IR推理
export FLAGS_enable_pir_api=0
(bash infer_script_new.sh) 2>&1 | tee ${log_dir}/llava_new_old.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava infer new_old success" >>"${log_dir}/ce_res.log"
else
    echo "llava infer  new_old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava new_old end***********"

# 新IR导出 + 新IR推理
export FLAGS_enable_pir_api=1
(bash infer_script_new.sh) 2>&1 | tee ${log_dir}/llava_new_new.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava infer new_new success" >>"${log_dir}/ce_res.log"
else
    echo "llava infer  new_new fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava new_new end***********"

echo exit_code:${exit_code}
exit ${exit_code}