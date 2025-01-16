If you use the system R:

```bash
module load GCC/11.3.0  
module load OpenMPI/4.1.4
module load R/4.2.1
module load Perl/5.34.1
module load git/2.36.0-nodocs
```

In /home/$USER/.vscode-server/data/Machine/settings.json

```json
{
  "python.autoComplete.extraPaths": [],
  "perl.perlCmd": "/accre/arch/easybuild/software/Compiler/GCCcore/10.2.0/Perl/5.32.0/bin/perl",
  "r.plot.useHttpgd": true,
  "r.rpath.linux": "/accre/arch/easybuild/software/MPI/GCC/11.3.0/OpenMPI/4.1.4/R/4.2.1/bin/R",
  "r.rterm.linux": "/accre/arch/easybuild/software/MPI/GCC/11.3.0/OpenMPI/4.1.4/R/4.2.1/bin/R"
}
```

Set Rlib path

```bash
mkdir -p ~/R/x86_64-pc-linux-gnu-library
mkdir -p /nobackup/h_cqs/rlibs_4.2/$USER
cd ~/R/x86_64-pc-linux-gnu-library
ln -s /nobackup/h_cqs/rlibs_4.2/$USER 4.2
```

In R:

```r
install.packages('BiocManager')
BiocManager::install('nx10/unigd')
BiocManager::install('nx10/httpgd')
```