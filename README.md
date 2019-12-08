# cardioinformatics

[![DOI](https://zenodo.org/badge/144916854.svg)](https://zenodo.org/badge/latestdoi/144916854)

\*Khomtchouk BB, \*Tran DT, Vand KA, Might M, Gozani O, Assimes TL: “Cardioinformatics: the nexus of bioinformatics and precision cardiology." _Briefings in Bioinformatics_. 2019, bbz119. (\* indicates joint-first author) doi: 10.1093/bib/bbz119 

## Reproducing figures

From the base directory of `cardioinformatics` repository, use these commands to generate all figures. Note that Fig 1B-C will make real-time requests to PubMed and thus requires substantial time depending on your internet and the server's response.

```sh
cd scripts/generate_figure
make all
```

To generate individual figures, one can change into the directory and run one of the `make` commands below:

```sh
cd scripts/generate_figure
make fig1a
make fig1bc
make fig2
make fig3
make fig4
```

