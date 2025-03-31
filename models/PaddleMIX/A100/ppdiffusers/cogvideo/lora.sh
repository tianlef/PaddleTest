#!/bin/bash

export USE_PEFT_BACKEND=True

python examples/cogvideo/scripts/train_cogvideox_lora.py \
  --pretrained_model_name_or_path THUDM/CogVideoX-2b \
  --instance_data_root ./cogvideo_lora \
  --caption_column ./davis_validation_fps30_frames49/prompts.txt \
  --video_column ./davis_validation_fps30_frames49/videos.txt \
  --id_token DISNEY \
  --validation_prompt "a bear is walking in a zoon" \
  --validation_prompt_separator ::: \
  --num_validation_videos 1 \
  --validation_epochs 1 \
  --seed 42 \
  --rank 64 \
  --lora_alpha 64 \
  --mixed_precision bf16 \
  --fp16_opt_level O2 \
  --output_dir ./cogvideox-lora \
  --height 480 --width 720 --fps 8 --max_num_frames 49 --skip_frames_start 0 --skip_frames_end 0 \
  --train_batch_size 1 \
  --num_train_epochs 1 \
  --checkpointing_steps 10 \
  --gradient_accumulation_steps 1 \
  --learning_rate 1e-3 \
  --lr_scheduler cosine_with_restarts \
  --lr_warmup_steps 200 \
  --lr_num_cycles 1 \
  --enable_slicing \
  --enable_tiling \
  --optimizer Adam \
  --adam_beta1 0.9 \
  --adam_beta2 0.95 \
  --max_grad_norm 1.0
