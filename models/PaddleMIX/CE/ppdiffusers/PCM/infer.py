import os
os.environ["USE_PEFT_BACKEND"] = "True"
import paddle
import numpy as np
from PIL import Image
from pcm_fm_deterministic_scheduler import PCMFMDeterministicScheduler
from ppdiffusers import StableDiffusion3Pipeline

path_to_lora = "./pcm_deterministic_4step_shift3.pdparams"
step = 4
shift = 3
num_pcm_timesteps = 50

pipe = StableDiffusion3Pipeline.from_pretrained(
    "stabilityai/stable-diffusion-3-medium-diffusers",
    scheduler=PCMFMDeterministicScheduler(1000, shift, num_pcm_timesteps),
    map_location="cpu",
    paddle_dtype=paddle.float16
)
pipe.load_lora_weights(path_to_lora)
prompt = "portrait photo of a girl, photograph, highly detailed face, depth of field, moody light, golden hour, style by Dan Winters, Russell James, Steve McCurry, centered, extremely detailed, Nikon D850, award winning photography"

with paddle.no_grad():
    result_image = pipe(
        prompt=prompt,
        negative_prompt="",
        num_inference_steps=step,
        guidance_scale=1.2,
        generator=paddle.Generator().manual_seed(42),
        joint_attention_kwargs={"scale": 0.25}  # for lora scaling
    ).images[0]
result_image.save(prompt[:5] + prompt[-5:] + ".png")
