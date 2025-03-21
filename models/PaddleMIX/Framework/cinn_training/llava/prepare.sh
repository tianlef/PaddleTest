# 下载数据集

rm -rf llava_bench_data.tar
rm -rf /root/.paddlemix/datasets/llava_bench_data
# dataset
wget https://paddlenlp.bj.bcebos.com/models/community/paddlemix/benchmark/llava_bench_data.tar
tar -xf llava_bench_data.tar
mv llava_bench_data /root/.paddlemix/datasets/
rm -rf llava_bench_data.tar
ln -s /root/.paddlemix/datasets/llava_bench_data ./

rm -rf ScienceQA.tar
if [ -e "ScienceQA.tar" ]; then
    tar -xf ScienceQA.tar
    echo "文件存在"
else
    wget https://bj.bcebos.com/v1/paddlenlp/datasets/examples/ScienceQA.tar
    tar -xf ScienceQA.tar
    echo "文件不存在，已下载解压"
fi

