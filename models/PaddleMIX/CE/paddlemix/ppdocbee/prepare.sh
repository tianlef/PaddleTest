mix_path=${root_path}/PaddleMIX


# 数据集下载
cd ${mix_path}
rm -rf playground.tar
rm -rf playground

wget https://paddlenlp.bj.bcebos.com/models/community/paddlemix/benchmark/playground.tar
tar -xf playground.tar

