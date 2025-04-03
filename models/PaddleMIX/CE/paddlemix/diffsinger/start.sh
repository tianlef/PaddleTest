#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/paddlemix/examples/diffsinger
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}

cd ${root_path}/PaddleMIX

bash prepare.sh

exit_code=0

model_name=diffsinger

case_name=predict

cd ${work_path}
pip install -r requirements.txt
echo "******* ${model_name}_${case_name} begin***********"
(bash run_predict.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

echo exit_code:${exit_code}

rm -rf openvpi.tar
rm -rf openvpi
exit ${exit_code}
