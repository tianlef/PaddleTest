#!/bin/bash

pip install -r requirements.txt


mkdir data
rm -rf fastdit_imagenet256_tiny/
wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/fastdit_features/fastdit_imagenet256_tiny.tar
tar -xf fastdit_imagenet256_tiny.tar
rm -rf fastdit_imagenet256_tiny.tar
mv fastdit_imagenet256_tiny ./data/fastdit_imagenet256

