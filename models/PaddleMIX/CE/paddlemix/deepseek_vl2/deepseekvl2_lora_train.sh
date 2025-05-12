sed -i 's|num_train_epochs 1|max_steps 10|' paddlemix/examples/deepseek_vl2/shell/deepseek_vl2_tiny_lora_bs16_1e5.sh
sed -i 's|save_steps 1000|save_steps 10|' paddlemix/examples/deepseek_vl2/shell/deepseek_vl2_tiny_lora_bs16_1e5.sh
sh paddlemix/examples/deepseek_vl2/shell/deepseek_vl2_tiny_lora_bs16_1e5.sh