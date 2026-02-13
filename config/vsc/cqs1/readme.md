CQS1 is running centos7 which is not supported by VSC anymore.

Based on introduction below, we can still run VSC on cqs1

https://github.com/ursetto/vscode-sysroot/tree/main

We want to use /data1/shengq2/.vscode-server to avoid conflict with cqs4.

```bash
mkdir -p /data1/shengq2/.vscode-server 
```

Build singularity image.

```bash
cd /data/cqs/softwares/singularity
singularity build --disable-cache vscode-sysroot.20260212.sif docker://ichn/vscode-sysroot:latest
```

Extract vscode-sysroot-x86_64-linux-gnu.tgz from singularity image to .vscode-server folder.

```bash
singularity exec -c -e -B /panfs,/data,/dors,/nobackup,/tmp,/home/shengq1 -H `pwd` vscode-sysroot.20260212.sif cp /src/vscode-sysroot-x86_64-linux-gnu.tgz .
tar zxf vscode-sysroot-x86_64-linux-gnu.tgz -C /data1/shengq2/.vscode-server
rm zxf vscode-sysroot-x86_64-linux-gnu.tgz
```

Copy the modified sysroot.sh to .vscode-server folder.

```bash
cp /nobackup/h_cqs/shengq2/program/cqsperl/config/vsc/cqs1/sysroot.sh /data1/shengq2/.vscode-server
```

source /data1/shengq2/.vscode-server/sysroot.sh from your .bashrc or other login script

```bash
if [[ $HOSTNAME == "cqs1.vampire" ]]; then
  source /data1/shengq2/.vscode-server/sysroot.sh
fi
```

In VSC, ctrl-shift-p, performance->open user settings (json), add the following lines. 

```json
    "remote.SSH.serverInstallPath": {
        "cqs1": "/data1/shengq2"
    }  
```

In VSC, add the following setting to remote ssh settings (.ssh\config)

```
Host cqs1
  HostName cqs1.accre.vanderbilt.edu
  User shengq1
  IdentityFile C:/Users/shengq2/Dropbox/program/key/id_rsa
  IdentitiesOnly yes
  ForwardX11 true
  ForwardX11Trusted true
```
