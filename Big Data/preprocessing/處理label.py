# 把同支股票與同日新聞整理到一起
import pandas as pd
import numpy as np
import random
import os

dirpath = './gdrive/MyDrive/0050成分股漲跌label'
name = os.listdir(dirpath)
name.remove('0000.csv')   # 存過了

name_new = []
for i in range(len(name)):
  name_new.append(int(name[i][:-4]))  # name 是個股名稱

df1 = pd.read_csv('./gdrive/MyDrive/新聞資料前處理/BERT_上市股票大事紀.csv')
df2 = pd.read_csv('./gdrive/MyDrive/新聞資料前處理/BERT_危機公司大事紀.csv')
df3 = pd.read_csv('./gdrive/MyDrive/新聞資料前處理/BERT_0050金融事件標題.csv')

df3.rename(columns={'新聞標題':'內文'}, inplace=True) #標題不一樣
frames = [df1,df2,df3]
df = pd.concat(frames)
ddf = df.values


for i in name_new:

  l = []
  for j in range(len(ddf)):
    if ddf[j][0] == i:
      l.append(j)
  ll = []

  for j in l:
    ll.append(ddf[j])  

  a = pd.DataFrame(ll,columns=['公司代碼','日期','內文'])
  a = a.sort_values(by=['日期'], ascending=True)
  a.to_csv('%d.csv'%i, encoding="utf_8_sig", index=False)