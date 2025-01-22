#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}
log_dir=${root_path}/deploy_log
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

export PYTHONPATH=$PYTHONPATH:${cur_path}/PaddleMIX


work_path2=${root_path}/PaddleMIX
echo ${work_path2}

cd ${root_path}/PaddleNLP
cd csrc
python setup_cuda.py install

cd ${cur_path}
/bin/cp -rf ./* ${work_path2}/

cd ${work_path2}



export FLAGS_use_cuda_managed_memory=true
export USE_PPXFORMERS=False
export FLAGS_allocator_strategy=auto_growth
export FLAGS_embedding_deterministic=1
export FLAGS_cudnn_deterministic=1

export FLAGS_enable_pir_api=0
exit_code=0
# infernece
(CUDA_VISIBLE_DEVICES=0 python deploy/qwen2_vl/single_image_infer.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_inference_old.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_inference_old success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_inference_old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_inference_old end***********"

# 多卡推理
(CUDA_VISIBLE_DEVICES=0 python deploy/qwen2_vl/video_infer.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_inference_visual_old.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_inference_visual_old success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_inference_visual_old fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_inference_visual_old end***********"



export FLAGS_enable_pir_api=1
(CUDA_VISIBLE_DEVICES=0 python deploy/qwen2_vl/single_image_infer.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_inference_new.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_inference_new success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_inference_new fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_inference_new end***********"

# 多卡推理
(CUDA_VISIBLE_DEVICES=0 python deploy/qwen2_vl/video_infer.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_inference_visual_new.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_inference_visual_new success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_inference_visual_new fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_inference_visual_new end***********"

unset FLAGS_enable_pir_api

echo exit_code:${exit_code}

exit ${exit_code}
