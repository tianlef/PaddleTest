#!/bin/bash

log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

export FLAGS_use_cuda_managed_memory=true
export USE_PPXFORMERS=False

export FLAGS_enable_pir_api=0
(python export_model.py \
    --pretrained_model_name_or_path runwayml/stable-diffusion-v1-5 \
    --output_path static_model/stable-diffusion-v1-5-oldir) 2>&1 | tee ${log_dir}/deploy_sd15_export_model_oldir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/sd15 sd15_export_model oldir success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/sd15 sd15_export_model oldir fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/sd15 sd15_export_model oldir end***********"

export FLAGS_enable_pir_api=1
(python export_model.py \
    --pretrained_model_name_or_path runwayml/stable-diffusion-v1-5 \
    --output_path static_model/stable-diffusion-v1-5-pir) 2>&1 | tee ${log_dir}/deploy_sd15_export_model_pir.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/sd15 sd15_export_model pir success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/sd15 sd15_export_model pir fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/sd15 sd15_export_model pir end***********"
echo exit_code:${exit_code}
exit ${exit_code}
