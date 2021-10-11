import seaborn as sns
import pandas as pd

def visualize_cluster(data, x, y, hue):
    pd_df = data.toPandas()
    pd_df = pd_df.sample(frac=0.1)
    sns.set_style("whitegrid")
    sns.lmplot(x=x, y=y, data=pd_df, fit_reg=False, hue=hue, height=10, scatter_kws={"s":100})

def visualize_map(data, x, y):
    pd_df = data.toPandas()
    pd_df.plot.scatter(x=x, y=y)