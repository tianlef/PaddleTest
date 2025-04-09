pip install opencv-python
pip install soundfile
pip install decord





# 数据集下载
cd ${mix_path}
rm -rf playground
mkdir playground
cd playground
mkdir data 
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xf chartqa.tar -C data
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xf opensource.tar

rm -rf LLaVA-Pretrain
wget https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
tar LLaVA-Pretrain.tar
cd LLaVA-Pretrain
wget https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl # 下载放置于 LLaVA-Pretrain/ 下


