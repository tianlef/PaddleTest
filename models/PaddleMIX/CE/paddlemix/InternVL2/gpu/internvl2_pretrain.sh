wget https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/LLaVA-Pretrain.tar # 27 G
tar -xf LLaVA-Pretrain.tar
cd LLaVA-Pretrain
wget https://paddlenlp.bj.bcebos.com//datasets/paddlemix/LLaVA/blip_laion_cc_sbu_558k.jsonl

cd ${root_path}/PaddleMIX
sed -i 's|num_train_epochs 1|max_steps=10|' paddlemix/examples/internvl2/shell/internvl2.0/1st_pretrain/internvl2_1b_qwen2_0_5b_dynamic_res_1st_pretrain.sh
sed -i 's|save_steps 1000|save_steps=10|' paddlemix/examples/internvl2/shell/internvl2.0/1st_pretrain/internvl2_1b_qwen2_0_5b_dynamic_res_1st_pretrain.sh
sed -i 's|GPUS:-8|GPUS:-4|' paddlemix/examples/internvl2/shell/internvl2.0/1st_pretrain/internvl2_1b_qwen2_0_5b_dynamic_res_1st_pretrain.sh
sh paddlemix/examples/internvl2/shell/internvl2.0/1st_pretrain/internvl2_1b_qwen2_0_5b_dynamic_res_1st_pretrain.sh

rm -rf LLaVA-Pretrain
rm -rf LLaVA-Pretrain.tar