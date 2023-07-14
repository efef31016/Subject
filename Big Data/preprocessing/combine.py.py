{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "applicable-string",
   "metadata": {},
   "source": [
    "### 把每個股票的Label先存成CSV，再concat起來"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "hourly-proposition",
   "metadata": {},
   "outputs": [],
   "source": [
    "import os\n",
    "\n",
    "fpath = os.listdir('C:/Users/jiao/Desktop/Stock_P/Label_CSV/照時間順序排好的個股新聞')\n",
    "\n",
    "fpath.remove('0000.csv')\n",
    "fpath.remove('1102.csv')\n",
    "fpath.remove('.ipynb_checkpoints')\n",
    "fpath_new = []\n",
    "\n",
    "for i in fpath:\n",
    "    fpath_new.append(int(i[:-4]))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 25,
   "id": "uniform-florist",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "1301"
      ]
     },
     "execution_count": 25,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "fpath_new[0]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "id": "arbitrary-nitrogen",
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "\n",
    "#特徵值\n",
    "\n",
    "df = pd.read_csv('news_label.csv')\n",
    "ddf = df.values\n",
    "\n",
    "for i in fpath_new:\n",
    "    \n",
    "    l = []\n",
    "\n",
    "    for j in range(len(ddf)):\n",
    "        if ddf[j][0] == i:\n",
    "            l.append(ddf[j])\n",
    "    \n",
    "    # 正確答案\n",
    "    \n",
    "    df2 = pd.read_csv('C:/Users/jiao/Desktop/Stock_P/0050成分股歷史漲跌/0050成分股漲跌label/%d.csv'%i)\n",
    "    ddf2 = df2.values\n",
    "    \n",
    "    ll = []\n",
    "\n",
    "    for j in range(len(ddf2)):\n",
    "        for k in range(len(l)):\n",
    "            if l[k][1] == ddf2[j][0]:\n",
    "                want = list(l[k])\n",
    "                if j  != 0:\n",
    "                    want.append(ddf2[j-1][1])\n",
    "                    ll.append(want)\n",
    "                else:\n",
    "                    pass\n",
    "            else:\n",
    "                pass\n",
    "\n",
    "    df3 = pd.DataFrame(ll, columns=['公司代碼','日期','內容','漲跌'])\n",
    "    df3.to_csv('C:/Users/jiao/Desktop/Stock_P/Label_CSV/準備concat的資料/label_%d.csv'%i, encoding = 'utf_8_sig', index = False)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "lasting-playlist",
   "metadata": {},
   "source": [
    "### miss掉的個股可以用下面代碼(只是獨立出來而已)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 32,
   "id": "consecutive-divide",
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "\n",
    "#特徵值\n",
    "\n",
    "df = pd.read_csv('news_label.csv')\n",
    "ddf = df.values\n",
    "\n",
    "l = []\n",
    "\n",
    "for j in range(len(ddf)):\n",
    "    if ddf[j][0] == 1101:\n",
    "        l.append(ddf[j])\n",
    "\n",
    "# 正確答案\n",
    "\n",
    "df2 = pd.read_csv('C:/Users/jiao/Desktop/Stock_P/0050成分股歷史漲跌/0050成分股漲跌label/%d.csv'%1101)\n",
    "ddf2 = df2.values\n",
    "\n",
    "ll = []\n",
    "\n",
    "for j in range(len(ddf2)):\n",
    "    for k in range(len(l)):\n",
    "        if l[k][1] == ddf2[j][0]:\n",
    "            want = list(l[k])\n",
    "            if j  != 0:\n",
    "                want.append(ddf2[j-1][1])\n",
    "                ll.append(want)\n",
    "            else:\n",
    "                pass\n",
    "        else:\n",
    "            pass\n",
    "\n",
    "df3 = pd.DataFrame(ll, columns=['公司代碼','日期','內容','漲跌'])\n",
    "df3.to_csv('C:/Users/jiao/Desktop/Stock_P/Label_CSV/準備concat的資料/label_%d.csv'%1101, encoding = 'utf_8_sig', index = False)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 33,
   "id": "boxed-provider",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "['label_1101.csv',\n",
       " 'label_1301.csv',\n",
       " 'label_1303.csv',\n",
       " 'label_2105.csv',\n",
       " 'label_2207.csv',\n",
       " 'label_2303.csv',\n",
       " 'label_2308.csv',\n",
       " 'label_2317.csv',\n",
       " 'label_2327.csv',\n",
       " 'label_2330.csv',\n",
       " 'label_2357.csv',\n",
       " 'label_2379.csv',\n",
       " 'label_2382.csv',\n",
       " 'label_2395.csv',\n",
       " 'label_2408.csv',\n",
       " 'label_2412.csv',\n",
       " 'label_2474.csv',\n",
       " 'label_2880.csv',\n",
       " 'label_2881.csv',\n",
       " 'label_2882.csv',\n",
       " 'label_2885.csv',\n",
       " 'label_2886.csv',\n",
       " 'label_2887.csv',\n",
       " 'label_2891.csv',\n",
       " 'label_2892.csv',\n",
       " 'label_2912.csv',\n",
       " 'label_3008.csv',\n",
       " 'label_3045.csv',\n",
       " 'label_4904.csv',\n",
       " 'label_9910.csv']"
      ]
     },
     "execution_count": 33,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "cpath = os.listdir('C:/Users/jiao/Desktop/Stock_P/Label_CSV/準備concat的資料')\n",
    "cpath.remove('.ipynb_checkpoints')\n",
    "cpath"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 34,
   "id": "continental-structure",
   "metadata": {},
   "outputs": [],
   "source": [
    "lll = []\n",
    "\n",
    "for i in cpath:\n",
    "    dfdf = pd.read_csv('C:/Users/jiao/Desktop/Stock_P/Label_CSV/準備concat的資料/' + i)\n",
    "    lll.append(dfdf)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 38,
   "id": "enabling-replacement",
   "metadata": {},
   "outputs": [],
   "source": [
    "res = pd.concat(lll,axis=0)\n",
    "res.to_csv('C:/Users/jiao/Desktop/Stock_P/Label_CSV/準備concat的資料/準備做W2V的資料.csv', encoding = 'utf_8_sig', index=False)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 37,
   "id": "informational-giving",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/html": [
       "<div>\n",
       "<style scoped>\n",
       "    .dataframe tbody tr th:only-of-type {\n",
       "        vertical-align: middle;\n",
       "    }\n",
       "\n",
       "    .dataframe tbody tr th {\n",
       "        vertical-align: top;\n",
       "    }\n",
       "\n",
       "    .dataframe thead th {\n",
       "        text-align: right;\n",
       "    }\n",
       "</style>\n",
       "<table border=\"1\" class=\"dataframe\">\n",
       "  <thead>\n",
       "    <tr style=\"text-align: right;\">\n",
       "      <th></th>\n",
       "      <th>公司代碼</th>\n",
       "      <th>日期</th>\n",
       "      <th>內容</th>\n",
       "      <th>漲跌</th>\n",
       "    </tr>\n",
       "  </thead>\n",
       "  <tbody>\n",
       "    <tr>\n",
       "      <th>0</th>\n",
       "      <td>1301</td>\n",
       "      <td>20100105</td>\n",
       "      <td>台塑PE價  調漲逾2%</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>1</th>\n",
       "      <td>1301</td>\n",
       "      <td>20100106</td>\n",
       "      <td>態度逆轉  華亞科聯貸  銀行搶</td>\n",
       "      <td>1</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>2</th>\n",
       "      <td>1301</td>\n",
       "      <td>20100108</td>\n",
       "      <td>全球最大出口商SABIC 突然宣布減半供應  亞洲缺口擴大  PE暴漲  台塑亞聚吃補</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>3</th>\n",
       "      <td>1301</td>\n",
       "      <td>20100114</td>\n",
       "      <td>石化看漲  台塑2 月外銷賣光</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>4</th>\n",
       "      <td>1301</td>\n",
       "      <td>20100121</td>\n",
       "      <td>缺料  台塑再漲PVC 外銷價</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>...</th>\n",
       "      <td>...</td>\n",
       "      <td>...</td>\n",
       "      <td>...</td>\n",
       "      <td>...</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>462</th>\n",
       "      <td>9910</td>\n",
       "      <td>20191111</td>\n",
       "      <td>豐泰10月份合併營收計     6,240,078千元, 比去年同期成長       14....</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>463</th>\n",
       "      <td>9910</td>\n",
       "      <td>20191111</td>\n",
       "      <td>豐泰財務公告 108/10 合併稅前盈餘    72,369萬元，累計 108/01 至 1...</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>464</th>\n",
       "      <td>9910</td>\n",
       "      <td>20191112</td>\n",
       "      <td>豐泰財務公告累計 108/01 至 108 /09合併稅前盈餘   770,267萬元，比去...</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>465</th>\n",
       "      <td>9910</td>\n",
       "      <td>20191209</td>\n",
       "      <td>豐泰11月份合併營收計     6,400,738千元, 比去年同期成長       15....</td>\n",
       "      <td>0</td>\n",
       "    </tr>\n",
       "    <tr>\n",
       "      <th>466</th>\n",
       "      <td>9910</td>\n",
       "      <td>20191210</td>\n",
       "      <td>豐泰財務公告未經會計師核閱數， 108/11 合併稅前盈餘    79,028萬元，累計 1...</td>\n",
       "      <td>1</td>\n",
       "    </tr>\n",
       "  </tbody>\n",
       "</table>\n",
       "<p>132820 rows × 4 columns</p>\n",
       "</div>"
      ],
      "text/plain": [
       "     公司代碼        日期                                                 內容 漲跌\n",
       "0    1301  20100105                                       台塑PE價  調漲逾2%  0\n",
       "1    1301  20100106                                   態度逆轉  華亞科聯貸  銀行搶  1\n",
       "2    1301  20100108        全球最大出口商SABIC 突然宣布減半供應  亞洲缺口擴大  PE暴漲  台塑亞聚吃補  0\n",
       "3    1301  20100114                                    石化看漲  台塑2 月外銷賣光  0\n",
       "4    1301  20100121                                    缺料  台塑再漲PVC 外銷價  0\n",
       "..    ...       ...                                                ... ..\n",
       "462  9910  20191111  豐泰10月份合併營收計     6,240,078千元, 比去年同期成長       14....  0\n",
       "463  9910  20191111  豐泰財務公告 108/10 合併稅前盈餘    72,369萬元，累計 108/01 至 1...  0\n",
       "464  9910  20191112  豐泰財務公告累計 108/01 至 108 /09合併稅前盈餘   770,267萬元，比去...  0\n",
       "465  9910  20191209  豐泰11月份合併營收計     6,400,738千元, 比去年同期成長       15....  0\n",
       "466  9910  20191210  豐泰財務公告未經會計師核閱數， 108/11 合併稅前盈餘    79,028萬元，累計 1...  1\n",
       "\n",
       "[132820 rows x 4 columns]"
      ]
     },
     "execution_count": 37,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "binding-lightweight",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.7"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
