from huggingface_hub import hf_hub_download
import shutil
import os

os.makedirs("cc3m", exist_ok=True)

def download_and_copy(filename):
    # 下载真实文件（非软链接）
    real_path = hf_hub_download(
        repo_id="pixparse/cc3m-wds",
        repo_type="dataset",
        filename=filename,
        local_dir_use_symlinks=False  # 下载真实文件
    )

    # 拼接目标路径
    dst_path = os.path.join("cc3m", filename)

    # 复制文件到目标文件夹
    shutil.copy(real_path, dst_path)

    print(f"✅ 文件已复制到: {dst_path}")

# 下载并复制
download_and_copy("cc3m-train-0000.tar")
download_and_copy("cc3m-validation-0000.tar")
