import os
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import japanize_matplotlib

gdf_KEN = gpd.read_file(os.path.join(os.getcwd(), 'sources','japan_ver84/japan_ver84.shp'))
gdf_KEN = gdf_KEN.dissolve('KEN').query('KEN in ["茨城県","埼玉県", "千葉県", "東京都", "神奈川県"]')

def plot_gdf(given_gdf, dir, col, unit, format):
    fig = given_gdf.plot(
        column=col,
        legend=True,
        figsize=(8, 8),
        # cmap=plt.cm.Blues,
        legend_kwds={'shrink': 0.65, 'format':format},
        missing_kwds={'color': 'white',"hatch": "///","edgecolor": "black"}
    )
    fig = gdf_KEN.plot(ax=fig, color=(0,0,0,0), edgecolor='black')
    clb = fig.get_figure().axes[-1]
    clb.set_title(col)
    plt.text(140.35, 35.2, unit, horizontalalignment='right',verticalalignment='bottom')
    fig.set_xlim(139.2, 140.2)
    fig.set_ylim(35.2, 36.05)
    plt.savefig(f"images/{dir}/{col}.png", format='png',bbox_inches="tight",pad_inches=0.1)
