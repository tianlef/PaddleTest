wandb offline
rm -rf output/sdxl_cond999_8node_lr5e-7_denoising4step_diffusion1000_gan5e-3_guidance8_noinit_noode_backsim_scratch
USE_PEFT_BACKEND=1 CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
python -m paddle.distributed.launch train_sd.py \
    --generator_lr 5e-5 \
    --guidance_lr 5e-5 \
    --train_iters 100 \
    --output_path  output/sdxl_cond999_8node_lr5e-7_denoising4step_diffusion1000_gan5e-3_guidance8_noinit_noode_backsim_scratch \
    --batch_size 1 \
    --grid_size 1 \
    --initialie_generator \
    --log_iters 100 \
    --resolution 1024 \
    --latent_resolution 128 \
    --seed 10 \
    --real_guidance_scale 8 \
    --fake_guidance_scale 1.0 \
    --max_grad_norm 10.0 \
    --model_id "stabilityai/stable-diffusion-xl-base-1.0" \
    --wandb_iters 100 \
    --wandb_entity dmd2 \
    --wandb_project sdxl \
    --wandb_name "sdxl_cond999_8node_lr5e-7_denoising4step_diffusion1000_gan5e-3_guidance8_noinit_noode_backsim_scratch" \
    --dfake_gen_update_ratio 5 \
    --sdxl \
    --gsp \
    --max_step_percent 0.98 \
    --cls_on_clean_image \
    --gen_cls_loss \
    --gen_cls_loss_weight 5e-3 \
    --guidance_cls_loss_weight 1e-2 \
    --diffusion_gan \
    --diffusion_gan_max_timestep 1000 \
    --denoising \
    --num_denoising_step 4 \
    --denoising_timestep 1000 \
    --backward_simulation \
    --train_prompt_path ckpts/captions_laion_score6.25.pkl \
    --real_image_path ckpts \
    --generator_lora