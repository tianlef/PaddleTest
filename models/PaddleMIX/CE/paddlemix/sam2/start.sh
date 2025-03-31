#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX
tools_path=${root_path}/PaddleTest/models/PaddleMIX/Tools
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
/bin/cp -rf ${tools_path}/check_loss.py ${work_path}

# 下载数据集
cd ${work_path}
bash prepare.sh
exit_code=0


export http_proxy=${mix_proxy}
export https_proxy=${mix_proxy}

export HF_ENDPOINT=https://hf-mirror.com
export no_proxy=baidu.com,127.0.0.1,0.0.0.0,localhost,bcebos.com,pip.baidu-int.com,mirrors.baidubce.com,repo.baidubce.com,repo.bcm.baidubce.com,pypi.tuna.tsinghua.edu.cn,aistudio.baidu.com
export USE_PPXFORMERS=true


cd ${work_path}

model_name=sam2

case_name=predict

echo "*******paddlemix ${model_name}_${case_name} begin begin***********"
(python paddlemix/examples/sam2/grounded_sam2_tracking_demo.py \
       --sam2_config configs/sam2.1_hiera_l.yaml \
       --sam2_checkpoint sam2.1_hiera_large.pdparams \
       --input_path input.mp4 \
       --output_path output.mp4 \
       --prompt "input your prompt here") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix ${model_name}_${case_name} end***********"


echo exit_code:${exit_code}
exit ${exit_code}

