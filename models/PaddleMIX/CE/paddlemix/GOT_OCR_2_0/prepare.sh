cd ${root_path}/paddlemix/examples/GOT_OCR_2_0
pip install -r requirements.txt

mix_path=${root_path}/PaddleMIX
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/synthdog_en.tar # 2.4G
tar -xvf synthdog_en.tar
# 数据集下载
cd ${mix_path}