# cardioinformatics

[![DOI](https://zenodo.org/badge/144916854.svg)](https://zenodo.org/badge/latestdoi/144916854)

[Citation coming soon]

## Reproducing figures

From the base directory of `cardioinformatics` repository, use these commands to generate all figures. Note that Fig 1B-C will make real-time requests to Pubmed and requires substantial time depending on your internet and the server's response.

```sh
cd scripts/generate_figure
make all
```

To generate individual figure, one can change into the directory and run one of the `make` commands below

```sh
cd scripts/generate_figure
make fig1a
make fig1bc
make fig2
make fig3
make fig4
```

