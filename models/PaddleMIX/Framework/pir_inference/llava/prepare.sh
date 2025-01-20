cur_path=$(pwd)
echo ${cur_path}

work_path=${root_path}/PaddleNLP
echo ${work_path}
cd ${work_path}
cd csrc
python setup_cuda.py install


