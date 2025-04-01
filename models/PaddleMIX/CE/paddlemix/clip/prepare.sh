#!/bin/bash


cd ${root_path}/PaddleMIX/paddlemix/external_ops/
# 安装fusedln到python环境
python setup.py install

cd ${root_path}
rm -rf data
mkdir data
cd data
# clip coca evaclip
wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/ILSVRC2012/imagenet-val.tar
tar -xf imagenet-val.tar