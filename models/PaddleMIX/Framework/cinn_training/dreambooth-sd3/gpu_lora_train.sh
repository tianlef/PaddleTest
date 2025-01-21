export MODEL_NAME="stabilityai/stable-diffusion-3-medium-diffusers"
export INSTANCE_DIR="dog"
export OUTPUT_DIR="trained-sd3-lora"
export USE_PEFT_BACKEND=True
wandb offline

export FLAGS_prim_all=true;export FLAGS_prim_enable_dynamic=true;export FLAGS_use_cinn=true;export MIN_GRAPH_SIZE=0;export FLAGS_prim_forward_blacklist="pd_op.dropout"

python train_dreambooth_lora_sd3.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --output_dir=$OUTPUT_DIR \
  --mixed_precision="fp16" \
  --instance_prompt="a photo of sks dog" \
  --resolution=512 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=4 \
  --learning_rate=5e-5 \
  --report_to="wandb" \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --max_train_steps=50 \
  --validation_prompt="A photo of sks dog in a bucket" \
  --validation_epochs=25 \
  --seed="0" \
  --checkpointing_steps=250
unset FLAGS_prim_all
unset FLAGS_prim_enable_dynamic
unset FLAGS_use_cinn
unset MIN_GRAPH_SIZE
unset FLAGS_prim_forward_blacklist