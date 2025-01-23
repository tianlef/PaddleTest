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


# 下载数据集

bash prepare.sh
exit_code=0

# cd ${work_path}
# model_name=GOT_OCR_2_0

# case_name=plain_texts_OCR
# echo "******* ${model_name}_${case_name} begin***********"
# (python paddlemix/examples/GOT_OCR_2_0/got_ocr2_0_infer.py \
#   --model_name_or_path stepfun-ai/GOT-OCR2_0 \
#   --image_file paddlemix/demo_images/hospital.jpeg \
#   --ocr_type ocr \
#   --dtype "bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "******* ${model_name}_${case_name} end***********"


# case_name=format_texts_OCR
# echo "******* ${model_name}_${case_name} begin***********"
# (python paddlemix/examples/GOT_OCR_2_0/got_ocr2_0_infer.py \
#   --model_name_or_path stepfun-ai/GOT-OCR2_0 \
#   --image_file paddlemix/demo_images/hospital.jpeg \
#   --ocr_type format \
#   --dtype "bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "******* ${model_name}_${case_name} end***********"



# case_name=multi_crop_plain_texts_OCR
# echo "******* ${model_name}_${case_name} begin***********"
# (python paddlemix/examples/GOT_OCR_2_0/got_ocr2_0_infer.py \
#   --model_name_or_path stepfun-ai/GOT-OCR2_0 \
#   --image_file paddlemix/demo_images/hospital.jpeg \
#   --ocr_type ocr \
#   --multi_crop \
#   --dtype "bfloat16") 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "******* ${model_name}_${case_name} end***********"

# case_name=train
# echo "******* ${model_name}_${case_name} begin***********"
# (sh paddlemix/examples/GOT_OCR_2_0/run_train.sh) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "******* ${model_name}_${case_name} end***********"

# case_name=after_train_infer
# echo "******* ${model_name}_${case_name} begin***********"
# (python paddlemix/examples/GOT_OCR_2_0/got_ocr2_0_infer.py \
#   --model_name_or_path work_dirs/got_ocr_20/ \
#   --image_file paddlemix/demo_images/hospital.jpeg \
#   --ocr_type ocr) 2>&1 | tee ${log_dir}/${model_name}_${case_name}.log
# tmp_exit_code=${PIPESTATUS[0]}
# exit_code=$(($exit_code + ${tmp_exit_code}))
# if [ ${tmp_exit_code} -eq 0 ]; then
#     echo "${model_name}_${case_name} run success" >>"${log_dir}/ce_res.log"
# else
#     echo "${model_name}_${case_name} run fail" >>"${log_dir}/ce_res.log"
# fi
# echo "******* ${model_name}_${case_name} end***********"

# echo exit_code:${exit_code}

# # cat ${log_dir}/ce_res.log
# exit ${exit_code}