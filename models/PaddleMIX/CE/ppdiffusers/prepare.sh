#!/bin/bash
python -m pip install --upgrade pip

pip install pytest safetensors ftfy fastcore opencv-python einops parameterized requests-mock
pip install ligo-segments

pip install fastdeploy-gpu-python -f https://www.paddlepaddle.org.cn/whl/fastdeploy.html
work_path2=${root_path}/PaddleMIX/ppdiffusers/
echo ${work_path2}/

cd ${work_path2}

python -m pip install --upgrade pip
pip install -e .
pip install -r requirements.txt

