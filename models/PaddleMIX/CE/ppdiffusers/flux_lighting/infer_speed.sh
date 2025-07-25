export FLAGS_use_cuda_managed_memory=true
export FLAGS_prim_enable_dynamic=true
export FLAGS_prim_all=true
export FLAGS_use_cinn=1
python text_to_image_generation_flux_lightning_cinn.py \
    --path_to_lora ./paddle_lora_weights.safetensors \
    --prompt "a beautiful girl" \
    --output_dir ./ \
    --inference_optimize \