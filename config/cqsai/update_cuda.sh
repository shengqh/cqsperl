wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda-repo-rhel8-12-2-local-12.2.2_535.104.05-1.x86_64.rpm

sudo rpm --erase gpg-pubkey-7fa2af80*
sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo
sudo rpm -i cuda-repo-rhel8-12-2-local-12.2.2_535.104.05-1.x86_64.rpm
sudo dnf clean all
sudo dnf -y module install nvidia-driver:latest-dkms
sudo dnf -y install cuda-12-2

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo dnf install -y nvidia-container-toolkit
sudo systemctl restart docker