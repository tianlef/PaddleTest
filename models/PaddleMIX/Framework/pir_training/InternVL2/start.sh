#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/
echo ${work_path}

log_dir=${root_path}/pir_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi


/bin/cp -rf ./* ${work_path}
/bin/cp -f ../../check_loss.py ${work_path}
cd ${work_path}
exit_code=0


export http_proxy=${mix_proxy}
export https_proxy=${mix_proxy}


exit_code=0
export no_proxy=baidu.com,127.0.0.1,0.0.0.0,localhost,bcebos.com,pip.baidu-int.com,mirrors.baidubce.com,repo.baidubce.com,repo.bcm.baidubce.com,pypi.tuna.tsinghua.edu.cn,aistudio.baidu.com

bash prepare.sh


echo "*******paddlemix InternVL2_train begin begin***********"
# 只测2B模型即可 32G以下显存
(bash train_internvl2.sh) 2>&1 | tee ${log_dir}/InternVL2_train.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "InternVL2_train run success" >>"${log_dir}/ce_res.log"
else
    echo "InternVL2_train run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******paddlemix InternVL2_train end***********"


unset http_proxy
unset https_proxy

rm -rf examples_image1.jpg
rm -rf red-panda.mp4
# 查看结果
# cat ${log_dir}/ce_res.log

echo exit_code:${exit_code}
exit ${exit_code}
