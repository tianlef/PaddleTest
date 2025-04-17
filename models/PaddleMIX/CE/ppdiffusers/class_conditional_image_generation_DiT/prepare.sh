#!/bin/bash

pip install -r requirements.txt


cd data
sh download_data.sh
cd ..