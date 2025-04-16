#!/bin/bash

exit_code=0

log_dir=${root_path}/ppdiffusers_log


work_path=$(pwd)
echo ${work_path}

bash prepare.sh

cd ${work_path}
test_list=(
    "class_conditional_image_generation/DiT/"
    "controlnet/"
    "consistency_distillation/"
    "dreambooth/"
    "stable_diffusion/"
    "text_to_image/"
    "text_to_image_laion400m/"
    "cogvideo/"
)
# 遍历当前目录下的子目录
for subdir in */; do
  if [ -d "$subdir" ]; then

    echo "subdir: $subdir"
    found=false
    for var in "${test_list[@]}"; do 
      if [[ "$subdir" == "$var" ]]; then
        found=true
        break
      fi
    done

    if $found; then
      start_script_path="$subdir/start.sh"
      if [ -f "$start_script_path" ]; then
        echo "start_script_path: $start_script_path"
        cd $subdir
        bash start.sh
        exit_code=$((exit_code + $?))
        cd ..
      fi
    fi
    else
        echo "subdir is not a test directory: $subdir"
    fi
done

echo "exit code: $exit_code"

# 查看结果
cat ${log_dir}/ce_res.log

exit $exit_code
