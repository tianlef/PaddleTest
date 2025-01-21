pip install opencv-python
pip install soundfile
pip install decord

mix_path=${root_path}/PaddleMIX
# 数据集下载
cd ${mix_path}
rm -rf playground
mkdir playground
cd playground
mkdir data 
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xvf chartqa.tar -C data
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xvf opensource.tar




