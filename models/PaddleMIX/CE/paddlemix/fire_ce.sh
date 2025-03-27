#!/bin/bash

exit_code=0

log_dir=${root_path}/paddlemix_log
work_path=$(pwd)
echo ${work_path}

# 动态获取当前路径下的子目录名称作为所有模型
all_models=()
for subdir in */; do
  subdir=${subdir%/}  # 去掉末尾的斜杠
  all_models+=("$subdir")
done

echo "所有模型: ${all_models[@]}"

fixed_run_list=(
  "llava"
  "qwen2_vl"
  "InternVL2"
)

# 从所有模型中排除固定模型，得到剩余的模型
remaining_models=()
for model in "${all_models[@]}"; do
  if [[ ! " ${fixed_run_list[@]} " =~ " ${model} " ]]; then
    remaining_models+=("$model")
  fi
done

# 随机选择一些剩余的模型
num_random_models=5 # 每次随机运行的额外模型数量
random_run_list=($(shuf -e "${remaining_models[@]}" -n ${num_random_models}))

# 合并固定模型和随机模型
run_list=("${fixed_run_list[@]}" "${random_run_list[@]}")


echo "固定运行的模型: ${fixed_run_list[@]}"
echo "随机选择的模型: ${random_run_list[@]}"
echo "最终运行的模型: ${run_list[@]}"

cp check_loss.py ${root_path}/PaddleMIX/
cd ${root_path}
rm -rf data
mkdir data
cd data
# clip coca evaclip
wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/ILSVRC2012/imagenet-val.tar
tar -xf imagenet-val.tar

cd ${root_path}/
rm -rf dataset
mkdir dataset
cd dataset
# eva02 

wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/ILSVRC2012/ILSVRC2012_tiny.tar
tar -xf ILSVRC2012_tiny.tar

cd ${root_path}/PaddleMIX/

# 测试环境需要
pip install pexpect
pip install einops
cd ppdiffusers
pip install -e .
pip install -r requirements.txt
cd ..
pip install -e .
pip install -r requirements.txt


cd ${work_path}


# 将数组转换为字符串，以便使用正则匹配
# 遍历当前目录下的子目录
for subdir in */; do
  found=0
  for item in "${run_list[@]}"; do
    # echo "$item"
    # echo "$subdir"
    if [[ "${item}/" == "$subdir" ]]; then
      # echo "start $subdir"
      found=1
    fi
  done
  if [ $found -eq 1 ]; then
    if [ "$subdir" == "deploy/" ]; then
      continue
    fi
    if [ "$subdir" == "cogvlm/" ]; then
      continue
    fi
    if [ "$subdir" == "llava_next_interleave/" ]; then
      continue
    fi
    if [ "$subdir" == "llava_denseconnector/" ]; then
      continue
    fi
    if [ "$subdir" == "llava_onevision/" ]; then
      continue
    fi
    if [ "$subdir" == "ut/" ]; then
      continue
    fi
    echo "start $subdir"
    start_script_path="${subdir}start.sh"
    echo $start_script_path
    if [ -f "$start_script_path" ]; then
      cd $subdir
      bash start.sh
      exit_code=$((exit_code + $?))
      cd ..
    fi
  else
    echo "skip $subdir"
  fi
done

# 查看结果
cat ${log_dir}/ce_res.log


cd ${root_path}
rm -rf imagenet-val.tar
rm -rf ILSVRC2012_tiny.tar
rm -rf data




