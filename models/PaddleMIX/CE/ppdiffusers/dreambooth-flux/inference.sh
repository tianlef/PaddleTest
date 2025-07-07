from ppdiffusers import FluxPipeline
import paddle

pipe = FluxPipeline.from_pretrained(
    "black-forest-labs/FLUX.1-dev", paddle_dtype=paddle.bfloat16
)
pipe.load_lora_weights('trained-flux-lora')

image = pipe("A picture of a sks dog in a bucket", num_inference_steps=25).images[0]
image.save("sks_dog_dreambooth_lora.png")