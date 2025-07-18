python -u edm/test_folder_edm.py \
    --folder output/imagenet_gan_classifier_genloss3e-3_diffusion1000_lr2e-6_scratch/time_1752837990_seed1 \
    --wandb_name test_imagenet_gan_classifier_genloss3e-3_diffusion1000_lr2e-6_scratch \
    --wandb_entity jll-none \
    --wandb_project dmd2 \
    --resolution 64 \
    --label_dim 1000 \
    --ref_path datas/imagenet_fid_refs_edm.npz