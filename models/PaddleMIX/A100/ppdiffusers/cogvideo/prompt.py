
import os

fw = open('./davis_validation_fps30_frames49/prompts.txt','w')

f = open('./davis_validation_fps30_frames49/videos.txt','r')
for line in f:
    video_name = line.strip()
    index = video_name.split('.')[0].split('_')[-1]
    prompt_file_name = 'prompt_{}.txt'.format(index)
    if not os.path.exists(os.path.join('./davis_validation_fps30_frames49',prompt_file_name)):
        fw.write('prompt is gone' + '\n')
    with open(os.path.join('./davis_validation_fps30_frames49',prompt_file_name),'r') as pf:
        for pline in pf:
            fw.write(pline)
