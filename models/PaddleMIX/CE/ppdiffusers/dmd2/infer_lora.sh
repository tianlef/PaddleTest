export PYTHONPATH=./:$PWD/../../scripts/fid_clip_score/:$PYTHONPATH USE_PEFT_BACKEND=1
python -u sdxl/test_sdxl_single_ckpt.py  \
    --checkpoint_path output/sdxl_cond999_8node_lr5e-7_denoising4step_diffusion1000_gan5e-3_guidance8_noinit_noode_backsim_scratch \
    --conditioning_timestep 999 \
    --num_step 4 \
    --wandb_entity dmd2 \
    --wandb_project dmd2 \
    --num_train_timesteps 1000 \
    --seed 10 \
    --eval_res 512 \
    --ref_dir ckpts/coco10k/subset \
    --anno_path  ckpts/coco10k/all_prompts.pkl \
    --total_eval_samples 10000 \
    --wandb_name dmd2 \
    --generator_lora