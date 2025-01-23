cd ${root_path}/PaddleMIX/paddlemix/examples/GOT_OCR_2_0
pwd
pip install -r requirement.txt

mix_path=${root_path}/PaddleMIX
rm -rf synthdog_en.tar 
rm -rf synthdog_en
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/synthdog_en.tar # 2.4G
tar -xvf synthdog_en.tar
# 数据集下载
cd ${mix_path}