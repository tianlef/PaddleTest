pip install opencv-python
pip install soundfile
pip install decord


# pretrain model data
cd ${root_path}/PaddleMIX
rm -rf LLaVA-Pretrain
rm -rf LLaVA-Pretrain.tar
bash download.sh https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
# wget --progress=dot:mega -O internvl2_download.log https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
tar -xf LLaVA-Pretrain.tar
cd LLaVA-Pretrain
wget https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl

cd ${root_path}/PaddleMIX
# sft/lora model data
bash download.sh https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar 
bash download.sh https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
rm -rf playground
mkdir -p playground/data
# wget --progress=dot:mega -O internvl2_download.log  https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xf chartqa.tar -C playground/data

# wget --progress=dot:mega -O internvl2_download.log  https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xf opensource.tar -C playground