#install aws
mkdir /data/cqs/software/aws
cd /data/cqs/software/aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i /data/cqs/softwares/aws-cli -b /data/cqs/softwares/local/bin/
cd
rm -rf /data/cqs/software/aws
