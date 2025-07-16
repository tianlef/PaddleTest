pip install -r requirements.txt

rm -rf ./datas
mkdir -p ./datas
export CHECKPOINT_PATH=./datas
wget https://nvlabs-fi-cdn.nvidia.com/edm/fid-refs/imagenet-64x64.npz -O $CHECKPOINT_PATH/imagenet_fid_refs_edm.npz

###### download the imagenet-64x64 lmdb
wget https://huggingface.co/tianweiy/DMD2/resolve/main/data/imagenet/imagenet-64x64_lmdb.zip?download=true -O $CHECKPOINT_PATH/imagenet-64x64_lmdb.zip
unzip $CHECKPOINT_PATH/imagenet-64x64_lmdb.zip -d $CHECKPOINT_PATH

###### 下载edm模型的预训练权重
wget https://paddlenlp.bj.bcebos.com/models/community/ppdiffusers/dmd2/edm-imagenet-64x64-cond-adm.pdparams


# training prompts
wget  https://huggingface.co/tianweiy/DMD2/resolve/main/data/laion/captions_laion_score6.25.pkl?download=true -O $CHECKPOINT_PATH/captions_laion_score6.25.pkl

# evaluation prompts
wget  https://huggingface.co/tianweiy/DMD2/resolve/main/data/coco/captions_coco14_test.pkl?download=true -O $CHECKPOINT_PATH/captions_coco14_test.pkl

export CHECKPOINT_PATH=./ckpts
#lora
mkdir $CHECKPOINT_PATH/sdxl_vae_latents_laion_500k
# real dataset
for INDEX in {0..59}
do
    # Format the index to be zero-padded to three digits
    INDEX_PADDED=$(printf "%03d" $INDEX)

    # Download the file
    wget "https://huggingface.co/tianweiy/DMD2/resolve/main/data/laion_vae_latents/sdxl_vae_latents_laion_500k/vae_latents_${INDEX_PADDED}.pt?download=true" -O "${CHECKPOINT_PATH}/sdxl_vae_latents_laion_500k/vae_latents_${INDEX_PADDED}.pt"
done

# generate the lmdb database from the downloaded files
python main/data/create_lmdb_iterative.py   --data_path $CHECKPOINT_PATH/sdxl_vae_latents_laion_500k/  --lmdb_path $CHECKPOINT_PATH/sdxl_vae_latents_laion_500k_lmdb

# evaluation images
wget https://huggingface.co/tianweiy/DMD2/resolve/main/data/coco/coco10k.zip?download=true -O $CHECKPOINT_PATH/coco10k.zip
unzip $CHECKPOINT_PATH/coco10k.zip -d $CHECKPOINT_PATH