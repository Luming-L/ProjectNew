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

cd ~  
vim .bashrc

```
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE1NjQ3NzQyNDEsMjA3NjY0NTU1MywtMT
M2OTcyODExNSwtNzc4MTM1NzMzLC0yNDc3NzI5MzUsLTEwNzMy
MDg5NzMsLTE4NTQyNjYxNDNdfQ==
-->