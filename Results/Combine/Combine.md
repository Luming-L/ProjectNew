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
# list your conda environments
conda info --envs

# 
source activate mypython

```
Install Snakemake
```bash
# Install via Conda

```
<!--stackedit_data:
eyJoaXN0b3J5IjpbNjgzMDcxMzQyLC03NzgxMzU3MzMsLTI0Nz
c3MjkzNSwtMTA3MzIwODk3MywtMTg1NDI2NjE0M119
-->