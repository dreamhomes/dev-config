#!/bin/bash

cd `dirname $0`
PATH=$PATH:/usr/local/bin
python zhihu.py >> zhihu.txt
echo "日期,粉丝数,赞同数,喜欢数,收藏数,文章数" > zhihu.csv
tac zhihu.txt >> zhihu.csv
