cd ${root_path}/ppdiffusers

rm -rf davis_validation_for_cogvideox.tar
rm -rf davis_validation_for_cogvideox
wget https://bj.bcebos.com/v1/dataset/PaddleMIX/davis_validation_for_cogvideox.tar
tar -xvf davis_validation_for_cogvideox.tar