#!/bin/bash

cd `dirname $0`
PATH=$PATH:/usr/local/bin
python hexo.py >> hexo.txt
echo "日期,访问量,访问人数" > hexo.csv
tac hexo.txt >> hexo.csv
