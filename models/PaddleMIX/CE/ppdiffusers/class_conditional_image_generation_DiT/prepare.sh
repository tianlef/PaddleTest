#!/bin/bash

pip install -r requirements.txt

# 需要特定的PaddleNLP版本
git clone https://github.com/PaddlePaddle/PaddleNLP.git -b release/2.6
cd PaddleNLP/model_zoo/gpt-3/external_ops/
python setup.py install
cd ../../../../

# 下载数据集
cd data
wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/fastdit_features/fastdit_imagenet256.tar
tar -xf fastdit_imagenet256.tar
cd ..