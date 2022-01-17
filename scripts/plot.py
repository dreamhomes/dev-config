#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
"""
@date: 2021-12-09 19:05:53
@author: dreamhomes.top
@description: Plot csv file
"""

import argparse
import pandas as pd
import plotly.express as px

df = pd.read_csv("./hexo/hexo.csv")
fig = px.line(df, x="日期", y=["访问量", "访问人数"])
