#!/bin/bash
pip install visualdl


wget https://paddlenlp.bj.bcebos.com/models/community/junnyu/develop/dogs.tar.gz
tar -xf dogs.tar.gz
rm -rf dogs.tar.gz
