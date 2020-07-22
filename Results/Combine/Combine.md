# Create a 'conda' environment
```bash
# load
module load anaconda/5.0.1
# configure environments directory path
conda config --add envs_dirs /exports/eddie/scratch/s1949868/anaconda/envs
# configure "packages" directory path
conda config --add pkgs_dirs /exports/eddie/scratch/s1949868/anaconda/pkgs
# creates an environment
conda create -n mypython python=3.7.4 numpy=1.9 scipy=0.14
```
Install Snakemake
```bash
# Install via Conda

```
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY2NDI3OTgzNSwtMjQ3NzcyOTM1LC0xMD
czMjA4OTczLC0xODU0MjY2MTQzXX0=
-->