#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
"""
@date: 2021-11-11 09:54:27
@author: dreamhomes.top
@description: Github Actions 自动更新知乎账户统计信息
"""

import requests
import datetime

url = "https://www.zhihu.com/api/v4/members/dreamhomes?include=follower_count,voteup_count,thanked_count,articles_count,favorited_count"

headers = {
    "Host": "www.zhihu.com",
    "Accept-Encoding": "gzip, deflate",
    "Accept": "*/*",
    "User-Agent": "PostmanRuntime/7.17.1",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
}

date = datetime.datetime.now().strftime("%Y-%m-%d")
rsp = requests.request("GET", url, headers=headers).json()
follower_count = rsp["follower_count"]  # 粉丝数
voteup_count = rsp["voteup_count"]  # 赞同数
thanked_count = rsp["thanked_count"]  # 喜欢数
articles_count = rsp["articles_count"]  # 文章数
favorited_count = rsp["favorited_count"]  # 收藏数

print(f"{date},{follower_count},{voteup_count},{thanked_count},{favorited_count},{articles_count}")
