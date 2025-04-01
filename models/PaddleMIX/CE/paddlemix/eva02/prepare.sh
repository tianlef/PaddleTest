#!/bin/bash

rm -rf /root/.paddlemix/datasets/*

cd ${root_path}/
rm -rf dataset
mkdir dataset
cd dataset
# eva02 

wget https://bj.bcebos.com/v1/paddlenlp/datasets/paddlemix/ILSVRC2012/ILSVRC2012_tiny.tar
tar -xf ILSVRC2012_tiny.tar

cd ${root_path}/PaddleMIX/paddlemix/examples/eva02/
wget https://bj.bcebos.com/v1/paddlenlp/models/community/paddlemix/EVA/EVA02/eva02_Ti_pt_in21k_p14/model_state.pdparams
