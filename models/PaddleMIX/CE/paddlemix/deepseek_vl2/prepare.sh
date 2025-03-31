cd ${root_path}/PaddleMIX

rm -rf playground.tar
rm -rf playground
wget https://paddlenlp.bj.bcebos.com/models/community/paddlemix/benchmark/playground.tar # 1.0G
tar -xvf playground.tar