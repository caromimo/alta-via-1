import marimo

__generated_with = "0.18.0"
app = marimo.App(width="medium")


@app.cell
def _():
    import duckdb
    import marimo as mo
    import pandas as pd
    import numpy as np
    import plotly.express as px
    import fsspec
    return duckdb, mo, px


@app.cell
def _(mo):
    path = mo.notebook_location() / "public" / "data" / "interim" / "*.json"
    print(path)
    return (path,)


@app.cell
def _(duckdb, path):
    refugi = duckdb.read_json(path).to_df()
    return (refugi,)


@app.cell
def _(mo, refugi):
    df = mo.sql(
        f"""
        select title, geo.coordinates[1] as lon, geo.coordinates[2] as lat from refugi;
        """,
        output=False
    )
    return (df,)


@app.cell
def _(df, px):
    # create the map
    fig = px.scatter_map(
        df,
        text="title", 
        lat="lat",
        lon="lon",
        map_style="open-street-map",
        zoom=8,
        height=800
    )
    return (fig,)


@app.cell
def _(fig, mo):
    # wrap it in a Marimo UI element
    map_widget = mo.ui.plotly(fig)
    return (map_widget,)


@app.cell
def _(map_widget, mo):
    # display it
    mo.vstack([
        mo.md("### Select points on the map to filter the table below"),
        map_widget,
        # This table updates automatically when you select points on the map!
        # map_widget.value 
    ])
    return


if __name__ == "__main__":
    app.run()
