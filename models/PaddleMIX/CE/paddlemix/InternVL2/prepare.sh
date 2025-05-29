pip install opencv-python
pip install soundfile
pip install decord


# pretrain model data
cd ${root_path}/PaddleMIX
wget --quiet https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
tar -xf LLaVA-Pretrain.tar
cd LLaVA-Pretrain
wget --quiet https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl

# sft/lora model data
mkdir playground
cd playground
mkdir data 
wget --quiet https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xf chartqa.tar -C data
wget --quiet https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xf opensource.tar