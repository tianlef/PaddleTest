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