cd ${root_path}/PaddleMIX/ppdiffusers

rm -rf davis_validation_for_cogvideox.tar
rm -rf davis_validation_fps30_frames49
wget https://bj.bcebos.com/v1/dataset/PaddleMIX/davis_validation_for_cogvideox.tar
tar -xvf davis_validation_for_cogvideox.tar

python prompt.py