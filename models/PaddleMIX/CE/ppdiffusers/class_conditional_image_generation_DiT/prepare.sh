#!/bin/bash

pip install -r requirements.txt


cd data
sh download_data.sh
tar -xf fastdit_imagenet256.tar
cd ..