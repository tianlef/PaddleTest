#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/examples/inference/
echo ${work_path}

work_path2=${root_path}/PaddleMIX/ppdiffusers/
echo ${work_path}

log_dir=${root_path}/infer_log


if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
pip install pytest safetensors ftfy fastcore opencv-python einops parameterized requests-mock
pip install ligo-segments
pip install fastdeploy-gpu-python -f https://www.paddlepaddle.org.cn/whl/fastdeploy.html

cd ${work_path}
exit_code=0

cuda_number=${1:-0}
export CUDA_VISIBLE_DEVICES=${cuda_number}

test_list=("class_conditional_image_generation-large_dit_3b"
            "class_conditional_image_generation-large_dit_7b"
            "image_inpainting-repaint"
            "image_to_image_text_guided_generation-deepfloyd_if"
            "image_to_video_generation_stable_video_diffusion"
            "image_variation-stable_diffusion"
            "text_guided_image_inpainting-deepfloyd_if"
            "text_to_audio_generation-audio_ldm2"
            "text_to_image_generation-deepfloyd_if"
            "text_to_image_generation-stable_diffusion_3_controlnet"
            "text_to_image_generation-stable_diffusion_xl_controlnet"
            "text_to_image_generation-vq_diffusion"
            "text_to_image_generation_mixture_tiling-stable_diffusion"
            "text_to_video_generation-lvdm"
            "text_to_video_generation-synth_img2img"
            "text_to_video_generation-zero"
            "text_to_video_generation_animediff"
            "text_variation-unidiffuser"
            "unconditional_audio_generation-spectrogram_diffusion"
            "unconditional_image_generation-latent_diffusion_uncond"
            "unconditional_image_generation-score_sde_ve"
            "unconditional_image_generation-stochastic_karras_ve"
            "unconditional_image_text_joint_generation-unidiffuser"
        )

for item in "${test_list[@]}"; do
   echo "*******infer ${item} begin***********"
   test_name=${item}.py
    (python ${test_name}) 2>&1 | tee ${log_dir}/${item}.log
    tmp_exit_code=${PIPESTATUS[0]}
    exit_code=$(($exit_code + ${tmp_exit_code}))
    if [ ${tmp_exit_code} -eq 0 ]; then
        echo "infer ${item} run success" >>"${log_dir}/infer_res.log"
    else
        echo "infer ${item} run fail" >>"${log_dir}/infer_res.log"
    fi
    echo "*******infer ${item} end***********"
done

echo "*****************infer result********************"
cat ${log_dir}/infer_res.log

echo exit_code:${exit_code}
exit ${exit_code}