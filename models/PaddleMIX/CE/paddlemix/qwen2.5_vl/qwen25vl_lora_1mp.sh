sed -i 's|^meta_path=.*|meta_path='paddlemix/examples/qwen2_vl/configs/demo_chartqa_500.json'|' paddlemix/examples/qwen2_5_vl/shell/baseline_3b_bs32_1e8.sh
sed -i 's|num_train_epochs 1|max_steps 10|' paddlemix/examples/qwen2_5_vl/shell/baseline_3b_bs32_1e8.sh
sh paddlemix/examples/qwen2_5_vl/shell/baseline_3b_bs32_1e8.sh