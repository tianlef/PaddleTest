# 安装示例
git submodule update --init --recursive
cd PaddleNLP
git reset --hard e91c2d3d634b12769c30aa419ddf931c20b7ca9f
pip install -e .
cd csrc
python setup_cuda.py install