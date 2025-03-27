#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX
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


export http_proxy=${mix_proxy}
export https_proxy=${mix_proxy}

export HF_ENDPOINT=https://hf-mirror.com
export no_proxy=baidu.com,127.0.0.1,0.0.0.0,localhost,bcebos.com,pip.baidu-int.com,mirrors.baidubce.com,repo.baidubce.com,repo.bcm.baidubce.com,pypi.tuna.tsinghua.edu.cn,aistudio.baidu.com
export USE_PPXFORMERS=true


# 安装额外的算子

cd ${work_path}/paddlemix/external_ops

echo "*******paddlemix ops_install begin begin***********"
(python setup.py install) 2>&1 | tee ${log_dir}/qwen2_vl_ops_install.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_ops_install run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_ops_install run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_ops_install end***********"


cd ${work_path}

# infer 部分需要A100的显卡 Tesla V100的显卡 不支持

echo "*******paddlemix qwen2_vl_infer begin begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_vl/single_image_infer.py) 2>&1 | tee ${log_dir}/qwen2_vl_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_infer end***********"


echo "*******paddlemix qwen2_vl_multi_image_infer begin begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_vl/multi_image_infer.py) 2>&1 | tee ${log_dir}/qwen2_vl_multi_image_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_multi_image_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_multi_image_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_multi_image_infer end***********"


echo "*******paddlemix qwen2_vl_video begin begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_vl/video_infer.py) 2>&1 | tee ${log_dir}/qwen2_vl_video.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_video run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_video run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_video end***********"

model_name=qwen2_vl

case_name=batch_inference
echo "******* ${model_name}_${case_name} begin***********"
(CUDA_VISIBLE_DEVICES=0 python paddlemix/examples/qwen2_vl/single_image_batch_infer.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=distributed_inference
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/qwen2_vl/shell/distributed_qwen2_vl_infer_2B.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


echo "*******paddlemix qwen2_vl_sft_train begin begin***********"
(sh paddlemix/examples/qwen2_vl/shell/baseline_2b_bs32_1e8.sh) 2>&1 | tee ${log_dir}/qwen2_vl_sft_train.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_sft_train run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_sft_train run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_sft_train end***********"


echo "*******paddlemix qwen2_vl_train_infer begin begin***********"
(CUDA_VISIBLE_DEVICES=0 python qwen2vl_after_train_infer.py) 2>&1 | tee ${log_dir}/qwen2_vl_train_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2_vl_train_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2_vl_train_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix qwen2_vl_train_infer end***********"


case_name=auto_2b_bs32_1e8
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/qwen2_vl/shell/auto_2b_bs32_1e8.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=merge_auto_2b_bs32_1e8
echo "******* ${model_name}_${case_name} begin***********"
(python merge_auto.py) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=lora_train
echo "******* ${model_name}_${case_name} begin***********"
(sh paddlemix/examples/qwen2_vl/shell/baseline_2b_lora_bs32_1e8.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=merge_lora
echo "******* ${model_name}_${case_name} begin***********"
(python paddlemix/tools/merge_lora_params.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --lora_path  work_dirs/baseline_330k_2b_bs32_1e8 \
    --merge_model_path ./checkpoints/merged_model
) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
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

