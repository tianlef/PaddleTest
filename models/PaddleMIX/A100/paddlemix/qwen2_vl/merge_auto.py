import paddle
import paddle.distributed as dist
ckpt_path='work_dirs/auto_330k_2b_bs32_1e8'# 你的自动并行权重路径文件夹
# offload=1, 参数 offload 到 CPU，减少显存占用
# prefix="model" 参数可用于过滤掉非模型参数，例如 optimizer 状态等
merged_state_dict = dist.checkpoint.load_state_dict.load_merged_state_dict(ckpt_path, offload=0, prefix="model")
paddle.save(merged_state_dict, 'model_state.pdparams')# 合并后的权重，与4.3手动并行一致