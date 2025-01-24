#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/examples/ppvctrl/
echo ${work_path}

log_dir=${root_path}/ppdiffusers_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}

cd ${work_path}
exit_code=0

bash prepare.sh
model_name=ppvctrl
case_name=extract_canny

echo "******* ${model_name}_${case_name} begin***********"
(bash anchor/extract_canny.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

#下载SAM2模型权重
rm -rf anchor/checkpoints/SAM2
mkdir -p anchor/checkpoints/SAM2
wget -P anchor/checkpoint/mask https://bj.bcebos.com/v1/paddlenlp/models/community/Sam/Sam2/sam2.1_hiera_large.pdparams
#提取蒙版控制条件

case_name=extract_mask
echo "******* ${model_name}_${case_name} begin***********"
(bash anchor/extract_mask.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


#下载检测模型权重
rm -rf anchor/checkpoints
mkdir -p anchor/checkpoints
wget -P anchor/checkpoints/paddle3.0_hrnet_w48_coco_wholebody_384x288 https://bj.bcebos.com/v1/dataset/PaddleMIX/xiaobin/pose_checkpoint/paddle3.0_hrnet_w48_coco_wholebody_384x288/model.pdiparams
wget -P anchor/checkpoints/PP-YOLOE_plus-S_infer https://bj.bcebos.com/v1/dataset/PaddleMIX/xiaobin/pose_checkpoint/PP-YOLOE_plus-S_infer/inference.pdiparams

#提取人体姿态控制条件

case_name=extract_pose
echo "******* ${model_name}_${case_name} begin***********"
(bash anchor/extract_pose.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"



case_name=i2v_canny
echo "******* ${model_name}_${case_name} begin***********"
(mkdir -p infer_outputs/canny/i2v && bash scripts/infer_cogvideox_i2v_canny_vctrl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"



case_name=t2v_canny
echo "******* ${model_name}_${case_name} begin***********"
(mkdir -p infer_outputs/canny/t2v && bash scripts/infer_cogvideox_t2v_canny_vctrl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=i2v_mask
echo "******* ${model_name}_${case_name} begin***********"
(mkdir -p infer_outputs/mask/i2v && bash scripts/infer_cogvideox_i2v_mask_vctrl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

case_name=t2v_mask
echo "******* ${model_name}_${case_name} begin***********"
(mkdir -p infer_outputs/mask/t2v && bash scripts/infer_cogvideox_t2v_mask_vctrl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"


case_name=i2v_pose
echo "******* ${model_name}_${case_name} begin***********"
(mkdir -p infer_outputs/pose/i2v && bash scripts/infer_cogvideox_i2v_pose_vctrl.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
else
    echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
fi
echo "******* ${model_name}_${case_name} end***********"

echo exit_code:${exit_code}
exit ${exit_code}
