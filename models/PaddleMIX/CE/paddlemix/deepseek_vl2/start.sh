#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX
echo ${work_path}

tools_path=${root_path}/PaddleTest/models/PaddleMIX/Tools
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


# 安装额外的算子

cd ${work_path}/paddlemix/external_ops

echo "*******paddlemix ops_install begin begin***********"
(python setup.py install) 2>&1 | tee ${log_dir}/deepssek_vl2_ops_install.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "deepssek_vl2_ops_install run success" >>"${log_dir}/ce_res.log"
else
    echo "deepssek_vl2_ops_install run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deepssek_vl2_ops_install end***********"


cd ${work_path}


echo "*******paddlemix deepssek_vl2_infer begin begin***********"
(python paddlemix/examples/deepseek_vl2/single_image_infer.py \
    --model_path="deepseek-ai/deepseek-vl2-tiny" \
    --image_file="paddlemix/demo_images/examples_image2.jpg" \
    --question="The Panda" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/deepssek_vl2_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "deepssek_vl2_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "deepssek_vl2_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deepssek_vl2_infer end***********"


echo "*******paddlemix deepssek_vl2_multi_image_infer begin begin***********"
(python paddlemix/examples/deepseek_vl2/multi_image_infer.py \
    --model_path="deepseek-ai/deepseek-vl2-tiny" \
    --image_file_1="paddlemix/demo_images/examples_image1.jpg" \
    --image_file_2="paddlemix/demo_images/examples_image2.jpg" \
    --image_file_3="paddlemix/demo_images/twitter3.jpeg" \
    --question="Can you tell me what are in the images?" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/deepssek_vl2_multi_image_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "deepssek_vl2_multi_image_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "deepssek_vl2_multi_image_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deepssek_vl2_multi_image_infer end***********"


echo "*******paddlemix deepssek_vl2_increment_prefilling_kv_cache begin begin***********"
(python paddlemix/examples/deepseek_vl2/increment_prefilling_infer.py \
    --model_path="deepseek-ai/deepseek-vl2-tiny" \
    --image_file_1="paddlemix/demo_images/examples_image1.jpg" \
    --image_file_2="paddlemix/demo_images/examples_image2.jpg" \
    --image_file_3="paddlemix/demo_images/twitter3.jpeg" \
    --question="Can you tell me what are in the images?" \
    --dtype="bfloat16") 2>&1 | tee ${log_dir}/deepssek_vl2_increment_prefilling_kv_cache.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "deepssek_vl2_increment_prefilling_kv_cache run success" >>"${log_dir}/ce_res.log"
else
    echo "deepssek_vl2_increment_prefilling_kv_cache run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deepssek_vl2_increment_prefilling_kv_cache end***********"

model_name=deepssek_vl2


echo "*******paddlemix deepssek_vl2_sft_train begin begin***********"
(python -u check_loss.py "sh paddlemix/examples/deepseek_vl2/shell/deepseek_vl2_tiny_sft_bs16_1e5.sh") 2>&1 | tee ${log_dir}/deepssek_vl2_sft_train.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "deepssek_vl2_sft_train run success" >>"${log_dir}/ce_res.log"
else
    echo "deepssek_vl2_sft_train run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix deepssek_vl2_sft_train end***********"



case_name=lora_train
echo "******* ${model_name}_${case_name} begin***********"
(bash deepseekvl2_lora_train.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=lora_merge
echo "******* ${model_name}_${case_name} begin***********"
(bash deepseekvl2_lora_merge.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"



# # 查看结果
# cat ${log_dir}/ce_res.log
echo exit_code:${exit_code}
exit ${exit_code}

