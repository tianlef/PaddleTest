#!/bin/bash

cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleMIX/ppdiffusers
echo ${work_path}

log_dir=${root_path}/ut_log

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

/bin/cp -rf ./* ${work_path}
cd ${work_path}
pip install -e .
pip install -r requirements.txt
pip install pytest
exit_code=0




export http_proxy=${mix_proxy}
export https_proxy=${mix_proxy}


exit_code=0

export HF_ENDPOINT=https://hf-mirror.com
export no_proxy=baidu.com,127.0.0.1,0.0.0.0,localhost,bcebos.com,pip.baidu-int.com,mirrors.baidubce.com,repo.baidubce.com,repo.bcm.baidubce.com,pypi.tuna.tsinghua.edu.cn,aistudio.baidu.com
export USE_PPXFORMERS=True
export RUN_SLOW=True
# tests目前子目录 community models pipelines schedulers others community

echo "*******tests_fixtures begin***********"
(python -m pytest -v tests/fixtures) 2>&1 | tee ${log_dir}/tests_fixtures.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_fixtures run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_fixtures run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_fixtures end***********"

echo "*******tests_schedulers begin***********"
(python -m pytest -v tests/schedulers) 2>&1 | tee ${log_dir}/tests_schedulers.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_schedulers run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_schedulers run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_schedulers end***********"

echo "*******tests_others begin***********"
(python -m pytest -v tests/others) 2>&1 | tee ${log_dir}/tests_others.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_others run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_others run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_others end***********"

echo "*******tests_models begin***********"
(python -m pytest -v tests/models) 2>&1 | tee ${log_dir}/tests_models.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_models run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_models run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_models end***********"

pip install note-seq==0.0.5
pip install torch
echo "*******tests_pipelines begin***********"
(python -m pytest -v tests/pipelines) 2>&1 | tee ${log_dir}/tests_pipelines.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_pipelines run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_pipelines run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_pipelines end***********"

# pip install diffusers transformers
echo "*******tests_community begin***********"
(python -m pytest -v tests/community) 2>&1 | tee ${log_dir}/tests_community.log
tmp_exit_code=${PIPESTATUS[0]}
exit_code=$(($exit_code + ${tmp_exit_code}))
if [ ${tmp_exit_code} -eq 0 ]; then
    echo "tests_community run success" >>"${log_dir}/ce_res.log"
else
    echo "tests_community run fail" >>"${log_dir}/ce_res.log"
fi
echo "*******tests_community end***********"

unset http_proxy
unset https_proxy

# # 查看结果
cat ${log_dir}/ce_res.log

# 查看pip list 
pip list | grep paddle

pip list | grep huggingface
echo exit_code:${exit_code}
