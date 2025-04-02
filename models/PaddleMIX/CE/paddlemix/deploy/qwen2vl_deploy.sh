#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}
log_dir=${root_path}/paddlemix_log_deploy
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

export PYTHONPATH=$PYTHONPATH:${cur_path}/PaddleMIX


work_path2=${root_path}/PaddleMIX
echo ${work_path2}

cd ${root_path}/PaddleMIX/PaddleNLP
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
(python deploy/qwen2_vl/single_image_infer.py\
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --question "Describe this image." \
    --image_file paddlemix/demo_images/examples_image1.jpg \
    --min_length 128 \
    --max_length 128 \
    --top_k 1 \
    --top_p 0.001 \
    --temperature 0.1 \
    --repetition_penalty 1.05 \
    --block_attn True \
    --inference_model True \
    --mode dynamic \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_single_image_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_single_image_infer success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_single_image_infer fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_single_image_infer end***********"

### 3.2. 文本&视频输入高性能推理
(CUDA_VISIBLE_DEVICES=0 python deploy/qwen2_vl/video_infer.py \
    --model_name_or_path Qwen/Qwen2-VL-2B-Instruct \
    --dtype bfloat16 \
    --benchmark True) 2>&1 | tee ${log_dir}/qwen2vl_video_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_video_infer success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_video_infer fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_video_infer end***********"


(sh deploy/qwen2_vl/scripts/qwen2_vl.sh) 2>&1 | tee ${log_dir}/qwen2vl_inference_scripts.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "qwen2vl_inference_scripts success" >>"${log_dir}/ce_res.log"
else
    echo "qwen2vl_inference_scripts fail" >>"${log_dir}/ce_res.log"
fi
echo "*******qwen2vl_inference_scripts end***********"

unset FLAGS_enable_pir_api

echo exit_code:${exit_code}

exit ${exit_code}
