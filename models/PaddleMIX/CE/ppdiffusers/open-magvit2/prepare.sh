prepare_path=${root_path}/PaddleMIX/ppdiffusers/examples/visual_tokenizer

cd $prepare_path
rm -rf open-magvitv2.tar
wget http://10.138.35.186:8009/mix_data/open-magvitv2.tar
tar -xf open-magvitv2.tar

