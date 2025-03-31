prepare_path=${root_path}/PaddleMIX/ppdiffusers/examples/visual_tokenizer

cd $prepare_path
rm -rf open-magvitv2.tar
wget ${base_url}/mix_data/open-magvitv2.tar
tar -xf open-magvitv2.tar

