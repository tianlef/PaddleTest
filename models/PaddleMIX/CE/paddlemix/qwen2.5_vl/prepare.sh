mix_path=${root_path}/PaddleMIX


# 数据集下载
cd ${mix_path}
rm -rf playground LaTeX_OCR
rm -rf playground.tar LaTeX_OCR.tar
wget https://paddlenlp.bj.bcebos.com/models/community/paddlemix/benchmark/playground.tar # 1.0G
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/LaTeX_OCR.tar # 1.7G
tar -xf playground.tar
tar -xf LaTeX_OCR.tar
