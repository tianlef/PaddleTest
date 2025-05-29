pip install opencv-python
pip install soundfile
pip install decord


# pretrain model data
cd ${root_path}/PaddleMIX
bash download.sh https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
# wget --progress=dot:mega -O internvl2_download.log https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
tar -xf LLaVA-Pretrain.tar
cd LLaVA-Pretrain
bash download.sh https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl # 2.5 G
# wget --progress=dot:mega -O internvl2_download.log   https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl

# sft/lora model data
mkdir playground
cd playground
mkdir data 
bash download.sh https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
# wget --progress=dot:mega -O internvl2_download.log  https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xf chartqa.tar -C data
bash download.sh https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
# wget --progress=dot:mega -O internvl2_download.log  https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xf opensource.tar