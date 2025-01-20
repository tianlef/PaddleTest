#!/bin/bash

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi


export PYTHONPATH=${root_path}/PaddleNLP/:${root_path}/PaddleMIX

export FLAGS_enable_pir_api=0

(python deploy/llava/export_model.py \
    --model_name_or_path "paddlemix/llava/llava-v1.6-vicuna-7b" \
    --save_path "./llava_static_old" \
    --encode_image \
    --fp16) 2>&1 | tee ${log_dir}/llava_export_oldir0.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_export_oldir 0  success" >>"${log_dir}/ce_res.log"
else
    echo "llava_export_oldir 0  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava_export_oldir 0 oldir end***********"

(python deploy/llava/export_model.py \
    --model_name_or_path "paddlemix/llava/llava-v1.6-vicuna-7b" \
    --save_path "./llava_static" \
    --encode_text \
    --fp16) 2>&1 | tee ${log_dir}/llava_export_oldir1.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_export_oldir 1 success" >>"${log_dir}/ce_res.log"
else
    echo "llava_export_oldir 1  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava_export_oldir 1  end***********"

export FLAGS_enable_pir_api=1


(python deploy/llava/export_model.py \
    --model_name_or_path "paddlemix/llava/llava-v1.6-vicuna-7b" \
    --save_path "./llava_static_new" \
    --encode_image \
    --fp16) 2>&1 | tee ${log_dir}/llava_export_new0.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_export_new 0  success" >>"${log_dir}/ce_res.log"
else
    echo "llava_export_new 0  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava_export_new 0 oldir end***********"

(python deploy/llava/export_model.py \
    --model_name_or_path "paddlemix/llava/llava-v1.6-vicuna-7b" \
    --save_path "./llava_static_new" \
    --encode_text \
    --fp16) 2>&1 | tee ${log_dir}/llava_export_new1.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "llava_export_new 1 success" >>"${log_dir}/ce_res.log"
else
    echo "llava_export_new 1  fail" >>"${log_dir}/ce_res.log"
fi
echo "*******llava_export_new 1  end***********"

unset FLAGS_enable_pir_api
echo exit_code:${exit_code}
exit ${exit_code}
