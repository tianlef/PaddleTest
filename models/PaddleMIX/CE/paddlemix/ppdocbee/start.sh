#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
/bin/cp -rf ../check_loss.py ${work_path}

# 下载数据集
cd ${work_path}
bash prepare.sh
exit_code=0

model_name=ppdocbee


# 安装额外的算子

cd ${work_path}/paddlemix/external_ops

echo "*******ops_install begin begin***********"
(python setup.py install) 2>&1 | tee ${log_dir}/ppdocbee_ops_install.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "ppdocbee_ops_install run success" >>"${log_dir}/ce_res.log"
else
    echo "ppdocbee_ops_install run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******ppdocbee_ops_install end***********"

cd ${work_path}
case_name=infer
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/ppdocbee/ppdocbee_infer.py \
  --model_path "PaddleMIX/PPDocBee-2B-1129" \
  --image_file "paddlemix/demo_images/medal_table.png" \
  --question "识别这份表格的内容") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=distributed_train_sft_2B
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/ppdocbee/shell/ppdocbee_sft.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=distributed_train_2B
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/ppdocbee/shell/ppdocbee_lora.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=train_sft_2B
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/ppdocbee/shell/ppdocbee_sft.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=train_lora_2B
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/ppdocbee/shell/ppdocbee_lora.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=infer_after_sft
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/ppdocbee/ppdocbee_infer.py \
  --model_path "work_dirs/ppdocbee_public_dataset" \
  --image_file "paddlemix/demo_images/medal_table.png" \
  --question "识别这份表格的内容") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=infer_after_lora
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/ppdocbee/ppdocbee_infer.py \
  --model_path "work_dirs/ppdocbee_public_dataset_lora" \
  --image_file "paddlemix/demo_images/medal_table.png" \
  --question "识别这份表格的内容") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


echo exit_code:${exit_code}

# cat ${log_dir}/ce_res.log
exit ${exit_code}
