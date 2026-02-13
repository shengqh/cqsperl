# Path to the dynamic linker in the sysroot (used for --set-interpreter option with patchelf)
export VSCODE_SERVER_CUSTOM_GLIBC_LINKER=/data1/shengq2/.vscode-server/sysroot/lib/ld-linux-x86-64.so.2
# Path to the library locations in the sysroot (used as --set-rpath option with patchelf)
export VSCODE_SERVER_CUSTOM_GLIBC_PATH=/data1/shengq2/.vscode-server/sysroot/usr/lib:/data1/shengq2/.vscode-server/sysroot/lib
# Path to the patchelf binary on the remote host
export VSCODE_SERVER_PATCHELF_PATH=/data1/shengq2/.vscode-server/sysroot/usr/bin/patchelf
