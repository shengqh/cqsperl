mkdir -p /data/cqs/softwares/dotnet

cd /data/cqs/softwares/dotnet

wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh

./dotnet-install.sh \
  --channel 10.0 \
  --install-dir /data/cqs/softwares/dotnet
  