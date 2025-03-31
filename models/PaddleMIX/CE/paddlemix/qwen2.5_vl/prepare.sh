mix_path=${root_path}/PaddleMIX


# 数据集下载
cd ${mix_path}
rm -rf playground
rm -rf playground.tar
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground.tar --no-proxy
tar -xf playground.tar

cd playground
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource_json.tar --no-proxy
tar -xf opensource_json.tar


