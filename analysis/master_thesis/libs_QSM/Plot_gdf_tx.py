import os
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.colors as colors
from matplotlib.colors import Normalize
import japanize_matplotlib

gdf_KEN = gpd.read_file(os.path.join(os.getcwd(), 'sources','japan_ver84/japan_ver84.shp'))
gdf_KEN = gdf_KEN.dissolve('KEN').query('KEN in ["茨城県","埼玉県", "千葉県", "東京都", "神奈川県"]')
gdf_ln = gpd.read_file(os.path.join(os.getcwd(), 'sources', 'tx_line.geojson'))
gdf_st = gpd.read_file(os.path.join(os.getcwd(), 'sources', 'tx_station.geojson'))

def plot_gdf_tx(given_gdf, dir, col, unit, min, max, format):
    if min < 0 :
        norm = Normalize(vmin=min, vmax=max)
        cmap = 'seismic'
    else: 
        norm = Normalize(vmin=min, vmax=max)
        cmap = 'Blues'
    fig = given_gdf.plot(
        column=col,
        norm = norm,
        legend=True,
        edgecolor='black',  # 境界線の色
        linewidth=0.5,   
        figsize=(8, 8),
        cmap=cmap,
        legend_kwds={'shrink': 0.65, 'format':format},
        missing_kwds={'color': 'white', "hatch": "///", "edgecolor": "black"}
    )
    fig = gdf_KEN.plot(ax=fig, color=(0,0,0,0), edgecolor='black')
    fig = gdf_ln.plot(ax=fig, color='orange', linewidth=2)
    fig = gdf_st.plot(ax=fig, color='#E83E2F', edgecolor='black')
    clb = fig.get_figure().axes[-1]
    clb.set_title(col)
    plt.text(140.35, 35.2, unit, horizontalalignment='right',verticalalignment='bottom')
    fig.set_xlim(139.2, 140.2)
    fig.set_ylim(35.25, 36.25)
    plt.savefig(f"images/{dir}/{col}.png", format='png',bbox_inches="tight",pad_inches=0.1)
