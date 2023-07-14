import tensorflow_hub as hub
import pandas as pd

embed = hub.load("https://tfhub.dev/google/nnlm-en-dim50/2")

df = pd.read_csv('/content/gdrive/MyDrive/0050成分股漲跌label/準備做W2V並訓練的資料.csv')

ddf = df.values

l = []

for i in range(len(ddf)):
  a = ddf[i][2]
  l.append(a)

embeddings = embed(l)
df['內容'] = embeddings