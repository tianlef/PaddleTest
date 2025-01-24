pip install -r requirements.txt
pip install paddlex==3.0.0b2

#创建vctrl-canny模型权重目录
rm -rf weights/canny
mkdir -p weights/Canny

#下载PP-VCtrl-5b-Canny-v1模型权重
wget -P weights/canny https://bj.bcebos.com/v1/dataset/PaddleMIX/vctrl/paddle_weights/vctrl_canny_5b_i2v_vctrl-tiny.pdparams
wget -P weights/canny https://bj.bcebos.com/v1/dataset/PaddleMIX/vctrl/paddle_weights/vctrl_canny_5b_t2v.pdparams

#创建vctrl-mask模型权重目录
rm -rf weights/mask
mkdir -p weights/mask

#下载PP-VCtrl-5b-Mask-v1模型权重
wget -P weights/mask https://bj.bcebos.com/v1/dataset/PaddleMIX/vctrl/paddle_weights/vctrl_5b_i2v_mask.pdparams
wget -P weights/mask https://bj.bcebos.com/v1/dataset/PaddleMIX/vctrl/paddle_weights/vctrl_5b_t2v_mask.pdparams


#创建vctrl-poses模型权重目录
mkdir -p weights/poses

#下载PP-VCtrl-5b-Pose-v1模型权重
wget -P weights/poses https://bj.bcebos.com/v1/dataset/PaddleMIX/vctrl/paddle_weights/vctrl_pose_5b_i2v.pdparams