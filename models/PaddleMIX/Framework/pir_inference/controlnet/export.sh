#!/bin/bash
log_dir=${root_path}/deploy_log

export FLAGS_use_cuda_managed_memory=true
export USE_PPXFORMERS=False


export FLAGS_enable_pir_api=0
(python export_model.py \
    --pretrained_model_name_or_path runwayml/stable-diffusion-v1-5 \
    --controlnet_pretrained_model_name_or_path lllyasviel/sd-controlnet-canny \
    --output_path static_model/stable-diffusion-v1-5-canny-old --width 512 --height 512) 2>&1 | tee ${log_dir}/deploy_controlnet_export_model_old.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_export_model old success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_export_model  old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_export_model old  end***********"


export FLAGS_enable_pir_api=1
(python export_model.py \
    --pretrained_model_name_or_path runwayml/stable-diffusion-v1-5 \
    --controlnet_pretrained_model_name_or_path lllyasviel/sd-controlnet-canny \
    --output_path static_model/stable-diffusion-v1-5-canny-new --width 512 --height 512) 2>&1 | tee ${log_dir}/deploy_controlnet_export_model_new.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdiffusers/deploy/controlnet controlnet_export_model new success" >>"${log_dir}/ce_res.log"
else
    echo "ppdiffusers/deploy/controlnet controlnet_export_model  new fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdiffusers/deploy/controlnet controlnet_export_model new  end***********"

echo exit_code:${exit_code}
exit ${exit_code}
