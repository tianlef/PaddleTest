#!/bin/bash

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

export FLAGS_use_cuda_managed_memory=true
export USE_PPXFORMERS=False

rm -rf infer_op_raw_fp16
rm -rf infer_op_zero_copy_infer_fp16

# 旧IR导出 + 旧IR推理
export FLAGS_enable_pir_api=0
(python infer.py 
    --model_dir static_model/stable-diffusion-v1-5-canny-old \
    --scheduler "ddim" \
    --backend paddle \
    --device gpu \
    --task_name all \
    --width 512 \
    --height 512 \
    --inference_steps 50 \
    --tune False \
    --use_fp16 True \
    --benchmark_steps 10) 2>&1 | tee ${log_dir}/controlnet_inference_allold.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_inference_all old success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_inference_all old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_inference_all old end***********"

export FLAGS_enable_pir_api=1
(python infer.py 
    --model_dir static_model/stable-diffusion-v1-5-canny-old \
    --scheduler "ddim" \
    --backend paddle \
    --device gpu \
    --task_name all \
    --width 512 \
    --height 512 \
    --inference_steps 50 \
    --tune False \
    --use_fp16 True \
    --benchmark_steps 10) 2>&1 | tee ${log_dir}/controlnet_inference_old_export_pir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_inference_old_export_pir success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_inference_old_export_pir fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_inference_old_export_pir end***********"


export FLAGS_enable_pir_api=0
(python infer.py 
    --model_dir static_model/stable-diffusion-v1-5-canny-new \
    --scheduler "ddim" \
    --backend paddle \
    --device gpu \
    --task_name all \
    --width 512 \
    --height 512 \
    --inference_steps 50 \
    --tune False \
    --use_fp16 True \
    --benchmark_steps 10) 2>&1 | tee ${log_dir}/controlnet_inference_pir_export_old_ir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_inference_pir_export_old_ir success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_inference_pir_export_old_ir fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_inference_pir_export_old_ir end***********"

export FLAGS_enable_pir_api=1
(python infer.py 
    --model_dir static_model/stable-diffusion-v1-5-canny-new \
    --scheduler "ddim" \
    --backend paddle \
    --device gpu \
    --task_name all \
    --width 512 \
    --height 512 \
    --inference_steps 50 \
    --tune False \
    --use_fp16 True \
    --benchmark_steps 10) 2>&1 | tee ${log_dir}/controlnet_inference_allnew.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_inference_allnew success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_inference_allnew fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_inference_allnew end***********"
unset FLAGS_enable_pir_api
echo exit_code:${exit_code}
exit ${exit_code}
