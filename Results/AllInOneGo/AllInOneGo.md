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
# load module
```bash
qlogin -l h_vmem=8G
cd /exports/eddie/scratch/s1949868/AllInOneGo

module load igmm/apps/MACS2/2.1.1
module load python/3.4.3
module load igmm/apps/BEDTools/2.27.1
module load igmm/apps/meme/4.11.1
```
```bash
# -pn: `p` display the actual shell commands as it runs them; `n` means just do a dry-run, without actually doing it all
snakemake -s Snakefile1 ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg -j1
```
```bash
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls
mkdir sorted
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/sorted/${file}.sorted; done
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQ2Mzg4OTQ4OCwzMjMyMjYyNDYsLTIwNj
AyOTM5NDcsMjE3OTcxMTkyLC01ODI0NTIwMjUsLTExNzc0NTI1
MywtMTc1NjQ4NzY2MV19
-->