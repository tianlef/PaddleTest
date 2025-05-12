# tiny
python paddlemix/examples/deepseek_vl2/lora_merge.py \
    --model_name_or_path deepseek-ai/deepseek-vl2-tiny \
    --lora_path work_dirs/deepseekvl2_tiny_lora_bs16_1e5/checkpoint-10 \
    --merge_model_path work_dirs/lora_merge_deepseekvl2_tiny_lora_bs16_1e5 \
    --device "gpu"