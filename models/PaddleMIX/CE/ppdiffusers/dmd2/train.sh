#!/bin/bash
cd ops
python setup.py install
cd ..
wandb offline
CUDA_VISIBLE_DEVICES=1,2,3,4,5,6,7 python -m paddle.distributed.launch edm/train_edm.py \
    --generator_lr 2e-6 \
    --guidance_lr 2e-6 \
    --train_iters 100 \
    --output_path output/imagenet_gan_classifier_genloss3e-3_diffusion1000_lr2e-6_scratch \
    --batch_size 24 \
    --initialie_generator \
    --log_iters 500 \
    --resolution 64 \
    --label_dim 1000 \
    --dataset_name "imagenet" \
    --seed 1 \
    --model_id datas/edm-imagenet-64x64-cond-adm.pdparams \
    --wandb_iters 100 \
    --wandb_entity dmd2 \
    --wandb_project dmd2_imagenet \
    --wandb_name "imagenet_gan_classifier_genloss3e-3_diffusion1000_lr2e-6_scratch" \
    --real_image_path datas/imagenet-64x64_lmdb \
    --dfake_gen_update_ratio 5 \
    --cls_loss_weight 1e-2 \
    --gan_classifier \
    --gen_cls_loss_weight 3e-3 \
    --diffusion_gan \
    --diffusion_gan_max_timestep 1000 \
    --delete_ckpts \
    --max_checkpoint 500 \
    --use_fp16