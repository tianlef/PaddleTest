#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers/deploy
echo ${work_path}
work_path1=${root_path}/PaddleMIX/ppdiffusers/deploy/ipadapter
log_dir=${root_path}/deploy_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

echo "Copying files to ${work_path}"
/bin/cp -rf ./* ${work_path}/
/bin/cp -rf ./* ${work_path1}/
exit_code=0

cd ${work_path}

test_list=(
    "controlnet/"
    "sd15/"
    "sdxl/"
)
for subdir in */; do
  if [ -d "$subdir" ]; then
    echo "Testing $subdir"
    found=false
    for var in "${test_list[@]}"; do 
      if [[ "$subdir" == "$var" ]]; then
        found=true
        break
      fi
    done
    if $found; then
      cd "$subdir"
      echo "Copying test scripts to $subdir"
      cp -f ../test_*.sh .
      clean_name="${subdir%/}"
      bash test_paddle.sh > ${log_dir}/${clean_name}_paddle.log 2>&1
      tmp_exit_code=${PIPESTATUS[0]}
      exit_code=$((exit_code + ${tmp_exit_code}))
      if [ ${tmp_exit_code} -eq 0 ]; then
        echo "${clean_name}_paddle success" >>"${log_dir}/ce_res.log"
      else
        echo "${clean_name}_paddle fail" >>"${log_dir}/ce_res.log"
      fi
      bash test_paddle_tensorrt.sh > ${log_dir}/${clean_name}_paddle_tensorrt.log 2>&1
      tmp_exit_code=${PIPESTATUS[0]}
      exit_code=$((exit_code + ${tmp_exit_code}))
      if [ ${tmp_exit_code} -eq 0 ]; then
        echo "${clean_name}_paddle_tensorrt success" >>"${log_dir}/ce_res.log"
      else
          echo "${clean_name}_paddle_tensorrt fail" >>"${log_dir}/ce_res.log"
      fi
      cd ..
    fi
    else
        echo "subdir is not a test directory: $subdir"
    fi
done

# cd ${work_path}/ipadapter
# for subdir in */; do
#   if [ -d "$subdir" ]; then
#     echo "Testing $subdir"
#     cd "$subdir"
#     echo "Copying test scripts to $subdir"
#     cp -f ../test_*.sh . 
#     clean_name="${subdir%/}"
#     bash test_paddle.sh > ${log_dir}/ipadapter_${clean_name}_paddle.log 2>&1
#     tmp_exit_code=${PIPESTATUS[0]}
#     exit_code=$((exit_code + ${tmp_exit_code}))
#     if [ ${tmp_exit_code} -eq 0 ]; then
#       echo "ipadapter_${clean_name}_paddle success" >>"${log_dir}/ce_res.log"
#     else
#         echo "ipadapter_${clean_name}_paddle fail" >>"${log_dir}/ce_res.log"
#     fi
#     bash test_paddle_tensorrt.sh > ${log_dir}/ipadapter_${clean_name}_paddle_tensorrt.log 2>&1
#     tmp_exit_code=${PIPESTATUS[0]}
#     exit_code=$((exit_code + ${tmp_exit_code}))
#     if [ ${tmp_exit_code} -eq 0 ]; then
#       echo "ipadapter_${clean_name}_paddle_tensorrt success" >>"${log_dir}/ce_res.log"
#     else
#         echo "ipadapter_${clean_name}_paddle_tensorrt fail" >>"${log_dir}/ce_res.log"
#     fi
#     cd ..
#   fi
# done

bash gather_img_video_to_one_file.sh
cat ${log_dir}/ce_res.log
echo exit_code:${exit_code}