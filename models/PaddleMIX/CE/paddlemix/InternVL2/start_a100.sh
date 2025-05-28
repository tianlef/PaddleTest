#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/paddlemix_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

tools_path=${root_path}/PaddleTest/models/PaddleMIX/Tools
/bin/cp -rf ./gpu/* ${work_path}
/bin/cp -f ${tools_path}/check_loss.py ${work_path}
cd ${work_path}
exit_code=0

export http_proxy=${mix_proxy}
export https_proxy=${mix_proxy}


exit_code=0
export no_proxy=baidu.com,127.0.0.1,0.0.0.0,localhost,bcebos.com,pip.baidu-int.com,mirrors.baidubce.com,repo.baidubce.com,repo.bcm.baidubce.com,pypi.tuna.tsinghua.edu.cn,aistudio.baidu.com

bash prepare.sh
# 准备图片做物料
echo "*******paddlemix InternVL2_picture_infer begin begin***********"

(python paddlemix/examples/internvl2/chat_demo.py \
    --model_name_or_path "OpenGVLab/InternVL2-1B" \
    --image_path 'paddlemix/demo_images/examples_image1.jpg' \
    --text "Please describe this image in detail.") 2>&1 | tee ${log_dir}/InternVL2_picture_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "InternVL2_picture_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "InternVL2_picture_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix InternVL2_picture_infer end***********"

echo "*******paddlemix InternVL2_video_infer begin begin***********"

(python paddlemix/examples/internvl2/chat_demo_video.py \
    --model_name_or_path "OpenGVLab/InternVL2-1B" \
    --video_path 'paddlemix/demo_images/red-panda.mp4' \
    --text "Please describe this video in detail.") 2>&1 | tee ${log_dir}/InternVL2_video_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "InternVL2_video_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "InternVL2_video_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix InternVL2_video_infer end***********"

model_name="InternVL2"
case_name="pretrain"
(bash internvl2_pretrain.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix ${model_name}_${case_name} end***********"

model_name="InternVL2"
case_name="fintune_internvl2_1b"
(bash internvl2_sft_1b.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix ${model_name}_${case_name} end***********"


echo "*******paddlemix InternVL2_after_train_infer begin begin***********"
(python paddlemix/examples/internvl2/chat_demo.py \
    --model_name_or_path "work_dirs/internvl_chat_v2_5/internvl2_5_2b_dynamic_res_2nd_finetune_full" \
    --image_path 'paddlemix/demo_images/examples_image1.jpg' \
    --text "Please describe this image in detail.") 2>&1 | tee ${log_dir}/InternVL2_after_train_infer.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "InternVL2_after_train_infer run success" >>"${log_dir}/ce_res.log"
else
    echo "InternVL2_after_train_infer run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix InternVL2_after_train_infer end***********"

unset http_proxy
unset https_proxy

# 查看结果
# cat ${log_dir}/ce_res.log

echo exit_code:${exit_code}
exit ${exit_code}
