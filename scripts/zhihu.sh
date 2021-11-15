#!/bin/bash

cd `dirname $0`
PATH=$PATH:/usr/local/bin
# sleep 0-99s
sleep $[$RANDOM%100]
python zhihu.py >> zhihu.txt
echo "日期,粉丝数,赞同数,喜欢数,收藏数,文章数" > zhihu.csv
tac zhihu.txt >> zhihu.csv
