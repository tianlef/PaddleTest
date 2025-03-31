#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/examples/cogvideo/
work_path1=${root_path}/PaddleMIX/ppdiffusers
echo ${work_path}

log_dir=${root_path}/ppdiffusers_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
/bin/cp -rf ./* ${work_path1}

cd ${work_path}
exit_code=0

bash prepare.sh


model_name="cogvideo"
case_name="infer"

echo "******* ${model_name}_${case_name} begin***********"
(python scripts/infer.py \
  --prompt "a bear is walking in a zoon" \
  --model_path THUDM/CogVideoX-2b \
  --generate_type "t2v" \
  --dtype "float16" \
  --seed 42) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"

cd ${work_path1}
case_name="lora_train"

echo "******* ${model_name}_${case_name} begin***********"
(bash lora.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"


case_name="lora_train_afer_infer"

echo "******* ${model_name}_${case_name} begin***********"
(python examples/cogvideo/scripts/lora_infer.py \
      --model_path THUDM/CogVideoX-2b \
      --prompt "a bear is walking in a zoon" \
      --lora_path ./cogvideox-lora \
      --output_path output.mp4) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******${model_name}_${case_name} end***********"




# # 查看结果
# cat ${log_dir}/ce_res.log
rm -rf ${work_path}/ubcNbili_data/*

echo exit_code:${exit_code}
exit ${exit_code}
