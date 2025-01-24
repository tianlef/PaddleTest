#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/examples/visual_tokenizer/open-magvit2
echo ${work_path}

log_dir=${root_path}/ppdiffusers_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
/bin/cp -rf ../check_loss.py ${work_path}
cd ${work_path}
exit_code=0


bash prepare.sh
model_name=open-magvit2
case_name=train_single_gpu

echo "******* ${model_name}_${case_name} begin***********"
(python -u check_loss.py "python train_tokenizer.py --config configs/gpu/imagenet_lfqgan_128_L.yaml") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=train_multiple_gpu
echo "******* ${model_name}_${case_name} begin***********"
(python -u check_loss.py "python -u  -m paddle.distributed.launch --gpus "0,1,2,3" train_tokenizer.py  --config configs/gpu/imagenet_lfqgan_128_L.yaml") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=train_single_gpu_256
echo "******* ${model_name}_${case_name} begin***********"
(python -u check_loss.py "python train_tokenizer.py --config configs/gpu/imagenet_lfqgan_256_L.yaml") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=train_multiple_gpu_256
echo "******* ${model_name}_${case_name} begin***********"
(python -u check_loss.py "python -u  -m paddle.distributed.launch --gpus "0,1,2,3" train_tokenizer.py  --config configs/gpu/imagenet_lfqgan_256_L.yaml") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=infer_256

echo "******* ${model_name}_${case_name} begin***********"
(wget https://bj.bcebos.com/v1/paddlenlp/models/community/paddlemix/imagenet_256_L.pdparams && sh scripts/inference/reconstruct.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"
exit ${exit_code}
