#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/examples/Fast-Diffusers/diffusion-distill/flux-lightning
echo ${work_path}


log_dir=${root_path}/ppdiffusers_log
pip install diffusers
pip install imageio-ffmpeg
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}

cd ${work_path}
exit_code=0
# rm -rf laion-45w
# rm -rf filelist_hwge1024_pwatermarkle0.5.txt
# rm -rf laion-45w.tar.gz
# wget https://dataset.bj.bcebos.com/PaddleMIX/flux-lightning/laion-45w.tar.gz
# tar -xvf laion-45w.tar.gz
# wget https://dataset.bj.bcebos.com/PaddleMIX/flux-lightning/filelist_hwge1024_pwatermarkle0.5.txt

model_name="flux-lightning"


case_name="train_single" 

echo "*******${model_name}_${case_name} begin***********"
(bash train_single.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

case_name="train" 

echo "*******${model_name}_${case_name} begin***********"
(bash train.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

# rm -rf paddle_lora_weights.safetensors
# wget https://dataset.bj.bcebos.com/PaddleMIX/flux-lightning/202507112228_latest/paddle_lora_weights.safetensors

# case_name="infer" 

# echo "*******${model_name}_${case_name} begin***********"
# (bash infer.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******${model_name}_${case_name} end***********"

# case_name="infer_speed" 

# echo "*******${model_name}_${case_name} begin***********"
# (bash infer_speed.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "*******${model_name}_${case_name} end***********"

# rm -rf paddle_lora_weights.safetensors
# rm -rf laion-45w
# rm -rf filelist_hwge1024_pwatermarkle0.5.txt
# rm -rf laion-45w.tar.gz
echo exit_code:${exit_code}
exit ${exit_code}