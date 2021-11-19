#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
"""
@date: 2021-11-15 15:33:28
@author: dreamhomes.top
@description: 爬取网站统计值
"""
import datetime

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

driver = webdriver.Chrome(executable_path="./chromedriver_linux", options=chrome_options)
date = datetime.datetime.now().strftime("%Y-%m-%d")
# 不蒜子服务不生效则请求 100 次，超过 100 次不再访问
MAX_COUNT = 100
count = 0

while True:
    driver.get("https://dreamhomes.top")
    pv = driver.find_element(By.ID, "busuanzi_value_site_pv")
    uv = driver.find_element(By.ID, "busuanzi_value_site_uv")
    count += 1
    if (pv.text != "" and uv.text != "") or count > MAX_COUNT:
        break
print(f"{date},{pv.text},{uv.text}")
