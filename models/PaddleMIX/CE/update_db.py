import os
import requests
from datetime import datetime
from zoneinfo import ZoneInfo
class update_db(object):
    def __init__(self):
        self.task_name = os.environ.get('task_name')
        self.model_name = os.environ.get('model_name')
        self.log_address = os.environ.get('tar_name')
        self.log_path = os.environ.get('log_path')
        beijing_tz = ZoneInfo('Asia/Shanghai')
        beijing_time = datetime.now(beijing_tz)
        self.date = beijing_time.strftime('%Y-%m-%d')
        self.paddle_commit = os.environ.get('paddle_commit')
        self.mix_commit = os.environ.get('mix_commit')
        self.nlp_commit = os.environ.get('nlp_commit')
        self.upload_url = os.environ.get('upload_url')
        self.success_case = ""
        self.failure_case = ""
        self.status = True
        self.env = self.get_env_info()
        print("start to gen result...")
        print("task name is {}, model name is {}".format(self.task_name, self.model_name))
        print("log address is {}".format(self.log_address))
        print("date is {}".format(self.date))
        print("paddle commit id is {}".format(self.paddle_commit))
        print("mix commit id is {}".format(self.mix_commit))
        print("nlp commit id is {}".format(self.nlp_commit))
        print("upload url is {}".format(self.upload_url))
    
    def get_update_info(self):
        with open(self.log_path, 'r', encoding='utf8') as f:
            for line in f.readlines():
                line_list = line.split(' ')
                try:
                   model_name = '_'.join(line_list[0:-2])
                except:
                    model_name = line_list[0]
                if 'success' in line.lower():
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
            "fail_case": self.failure_case,
            "env": self.env
        }
        print("params is ", params)
        proxies = {"http": None, "https": None}
        res = requests.post(self.upload_url, data=params, proxies=proxies)
        result = res.json()
        if result["code"] == 200 and result["message"] == "success":
            pass
            print("gen result success ")
        else:
            print("gen sreuslt failed, error info {}".format(result["message"]))


if __name__ == "__main__":
    update_db = update_db()
    update_db.get_update_info()
    try:
        update_db.upload()
    except Exception as e:
        print(e)
    

    

                