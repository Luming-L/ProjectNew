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

# Switch to the environment
source activate mypython
# Deactivate the environment
source deactivate
```
# Install Snakemake
```bash
# specify --user
pip install --user --upgrade pip
pip install --user snakemake

# get snakemake path
which snakemake # ~/.local/bin/snakemake

# add snakemake path
cd ~  
vim .bashrc
# in .bashrc, add
export PATH="$PATH:/home/s1949868/.local/bin/"
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTI1NDYwOTI4MiwtMTU2NDc3NDI0MSwyMD
c2NjQ1NTUzLC0xMzY5NzI4MTE1LC03NzgxMzU3MzMsLTI0Nzc3
MjkzNSwtMTA3MzIwODk3MywtMTg1NDI2NjE0M119
-->