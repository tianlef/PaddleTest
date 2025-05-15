import json
import glob
import paddle
from paddlenlp.trainer import set_seed

from ppdiffusers import DDIMScheduler, DiTPipeline

# 合并json文件
merged_json = {}
with open("output_trainer/DiT_XL_patch2_trainer/checkpoint-10/model_index.json", "r") as f:
    model_json = json.load(f)
    merged_json.update(model_json)
with open("tools/ImageNet_id2label.json", "r") as f:
    label_json = json.load(f)
    merged_json.update(label_json)

with open("output_trainer/DiT_XL_patch2_trainer/checkpoint-10/model_index.json", "w") as f:
    json.dump(merged_json, f, indent=4, ensure_ascii=False)

# 执行推理
dtype = paddle.float32
pipe = DiTPipeline.from_pretrained("output_trainer/DiT_XL_patch2_trainer/checkpoint-10", paddle_dtype=dtype)
pipe.scheduler = DDIMScheduler.from_config(pipe.scheduler.config)

words = ["golden retriever"]  # class_ids [207]
class_ids = pipe.get_label_ids(words)

set_seed(42)
generator = paddle.Generator().manual_seed(0)
image = pipe(class_labels=class_ids, num_inference_steps=25, generator=generator).images[0]
image.save("result_DiT_golden_retriever.png")