import random
import os
import shutil
import subprocess
import sys
import json
import pexpect
import traceback
import select
# 假设我们有一个脚本列表
def generate_all_inference_scripts():
    with open('./all.json', 'r', encoding='utf8') as f:
        script_list = json.load(f)
        keys = list(script_list.keys())
    return keys

def select_random_scripts(scripts, model_num, executed_log_path):
    if model_num == 'all':
        return scripts
    # 随机选择要执行的脚本数量（假设选择5个脚本）
    if os.path.isfile(executed_log_path):
        try:
            with open(executed_log_path, "r") as file:
                record = json.load(file)
                executed_dirs = set(record.get("executed_dirs", []))
                current_epoch = record.get("epoch", 1)
        except Exception as e:
            print(f"Error loading the executed directory record from {executed_log_path}: {str(e)}")
            executed_dirs = set()
            current_epoch = 1
    else:
        executed_dirs = set()
        current_epoch = 1
    remaining_dirs = list(set(scripts) - executed_dirs)
    if not remaining_dirs:
        print(f"All directories have been covered in epoch {current_epoch}. Starting a new epoch.")
        executed_dirs = set()
        remaining_dirs = list(scripts)
        current_epoch += 1
    selected_dirs = random.sample(remaining_dirs, min(model_num, len(remaining_dirs)))
    # 打印选择的目录
    executed_dirs.update(selected_dirs)
    print(f"Epoch {current_epoch}: Selected directories: {selected_dirs}")
    # 更新已执行的目录记录
    with open(executed_log_path, "w") as file:
        json.dump({"executed_dirs": list(executed_dirs), "epoch": current_epoch}, file)
        print(f"Epoch {current_epoch}: Selected directories: {selected_dirs}")
        print(f"Executed models in this epoch {executed_dirs}")
    return selected_dirs

def infer_process(selected_dirs):
    # 定义路径
    root_path = os.getenv('root_path')  # 获取root_path环境变量
    work_path = os.path.join(root_path, 'PaddleMIX/ppdiffusers/examples/inference/')
    work_path2 = os.path.join(root_path, 'PaddleMIX/ppdiffusers/')
    work_path3 = os.path.join(root_path, 'PaddleTest/models/PaddleMIX/CE/ppdiffusers')
    log_dir = os.path.join(root_path, 'infer_log')

    # 打印路径
    print(f"Current work path: {work_path}")
    print(f"Secondary work path: {work_path2}")
    print(f"Log directory: {log_dir}")

    # 创建日志目录
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)
    # 复制文件
    # 执行的时候不再对paddlenlp的脚本进行更改 只在环境设置中更改paddlenlp的脚本
   
    command = f"cp -rf ./* {work_path}/"
    subprocess.run(command, shell=True, check=True)

    # 安装依赖
    os.chdir(work_path2)

    subprocess.run(['python', '-m', 'pip', 'install', '--upgrade', 'pip'], check=True)
    

    subprocess.run(['pip', 'install', 'pytest', 'safetensors', 'ftfy', 'fastcore', 'opencv-python', 'einops', 'parameterized', 'requests-mock'], check=True)
    subprocess.run(['pip', 'install', 'ligo-segments'], check=True)
    subprocess.run(['pip', 'install', 'fastdeploy-gpu-python', '-f', 'https://www.paddlepaddle.org.cn/whl/fastdeploy.html'], check=True)
    subprocess.run(['pip', 'install', '-e', '.'], check=True)
    subprocess.run(['pip', 'install', '-r', 'requirements.txt'], check=True)
    
    # 返回工作路径
    os.chdir(work_path)

    # 设置环境变量
    os.environ['FLAGS_use_cuda_managed_memory'] = 'true'
    os.environ['FLAGS_allocator_strategy'] = 'auto_growth'
    os.environ['FLAGS_embedding_deterministic'] = '1'
    os.environ['FLAGS_cudnn_deterministic'] = '1'

    # 执行接下来的操作（如模型推理等）
    exit_code = 0
    

    # 你可以继续根据需要添加其他的 脚本执行或操作
    # 例如运行某些 文件
    # subprocess.run(['python', 'your_script.py'], check=True)

    print(f"Exit code: {exit_code}")


    for script in selected_dirs:
        print(f"******* Running {script} ***********")
        process_log = os.path.join(log_dir, f"{script}.log")
        tmp_exit_code = -1  # 初始化为默认值

        try:
            # 打开日志文件以记录输出
            with open(process_log, "w") as log_process:
                # 启动子进程
                child = pexpect.spawn(f"python {script}", encoding="utf-8", logfile=log_process, env={"PYTHONUNBUFFERED": "1"})

                # 等待子进程输出
                while True:
                    rlist, _, _ = select.select([child.ptyproc.fd], [], [], 0.1)
                    if rlist:
                        # 读取一行输出
                        line = child.readline().strip()
                        if line:
                            print(line, flush=True)
                            log_process.write(line + "\n")
                    if child.isalive() == False:
                        break

                # 等待子进程退出并获取退出状态
                child.wait()
                tmp_exit_code = child.exitstatus

        except Exception as e:
            print(f"Error running script {script}: {e}")

        finally:
            # 记录运行结果
            with open(f"{log_dir}/infer_res.log", "a") as log_file:
                if tmp_exit_code == 0:
                    log_file.write(f"{script} run success\n")
                else:
                    log_file.write(f"{script} run fail\n")
            print(f"******* Finished running {script} ***********")
    
    # 保存更新后的已执行目录和轮次
    # 输出最终的 exit_code
    print(f"Final exit code: {exit_code}")
     # 查看结果
    ce_res_log_path = os.path.join(log_dir, "infer_res.log")
    if os.path.isfile(ce_res_log_path):
        with open(ce_res_log_path, "r") as log_file:
            print(log_file.read())
    # 退出脚本
    exit(exit_code)


if __name__ == '__main__':
    try:
        print("Starting script...")
        scripts = generate_all_inference_scripts()
        # print(scripts)
        print(f"Total number of inference scripts found: {len(scripts)}")
        record_path = sys.argv[1]
        model_num = sys.argv[2]
        selected_scripts = select_random_scripts(scripts, model_num, record_path)
        print(f"Selected scripts: {selected_scripts}")
        infer_process(selected_scripts)
    except Exception as e:
        traceback.print_exc()