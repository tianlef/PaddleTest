#!/bin/bash

pip install visualdl
# cd examples/dreambooth
pip install -r requirements_sd3.txt


rm -rf dog.zip
rm -rf dog
wget https://paddlenlp.bj.bcebos.com/models/community/westfish/develop-sdxl/dog.zip
unzip -o dog.zip
