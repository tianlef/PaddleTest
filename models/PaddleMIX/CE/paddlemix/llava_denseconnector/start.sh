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

model_name=llava_denseconnector

case_name=predict

cd ${work_path}
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/examples/llava_denseconnector/run_predict_denseconnector.py \
    --model-path "HuanjinYao/DenseConnector-v1.5-7B" \
    --image-file "https://bj.bcebos.com/v1/paddlenlp/models/community/GroundingDino/000000004505.jpg") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
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
