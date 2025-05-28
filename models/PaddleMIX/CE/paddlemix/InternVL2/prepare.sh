pip install opencv-python
pip install soundfile
pip install decord




rm -rf playground
mkdir playground
cd playground
mkdir data 
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/data/chartqa.tar
tar -xf chartqa.tar -C data
wget https://paddlenlp.bj.bcebos.com/datasets/paddlemix/playground/opensource.tar
tar -xf opensource.tar

