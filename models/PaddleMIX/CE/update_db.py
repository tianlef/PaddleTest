import os
import requests
from datetime import datetime

class update_db(object):
    def __init__(self):
        self.task_name = os.environ.get('task_name')
        self.model_name = os.environ.get('model_name')
        self.log_address = os.environ.get('tar_name')
        self.log_path = os.environ.get('log_path')
        self.date = datetime.now().strftime('%Y-%m-%d')
        self.paddle_commit = os.environ.get('paddle_commit')
        self.mix_commit = os.environ.get('mix_commit')
        self.nlp_commit = os.environ.get('nlp_commit')
        self.uplod_url = os.environ.get('upload_url')
        self.success_case = ""
        self.failure_case = ""
        self.status = True
    
    def get_update_info(self):
        with open(self.log_path, 'r', encoding='utf8') as f:
            for line in f.readlines():
                line_list = line.split(' ')
                model_name = line_list[0]
                if 'success' in line:
                    self.success_case += " " + model_name
                else:
                    self.status = False
                    self.failure_case += " " + model_name
    
    def get_env_info(self):
        return {
            "paddle": self.paddle_commit,
            "mix": self.mix_commit,
            "nlp": self.nlp_commit
        }
    
    def upload(self):
        params = {
            "date": self.date,
            "task_name": self.task_name,
            "model_name": self.model_name,
            "log_address": self.log_address,
            "success_case": self.success_case,
            "failure_case": self.failure_case,
            "env_info": self.get_env_info()
        }

        proxies = {"http": None, "https": None}
        res = requests.post(self.uplod_url, data=params, proxies=proxies)
        result = res.json()
        if result["code"] == 200 and result["message"] == "success":
            pass
            print("gen result success ")
        else:
            print("gen sreuslt failed, error info {}".format(result["message"]))

    

                