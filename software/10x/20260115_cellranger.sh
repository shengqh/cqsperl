cd /data/cqs/softwares/10x
wget -O cellranger-10.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-10.0.0.tar.gz?Expires=1768538052&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=mO0CKLXYuHEJwYnHwW9fDyNLaCp6UCL494IlfNy5jceCHY49AMhtQsghyqV5KBOgJ~ZtkS8qZt8XXsL5ebSxJ44LII8~i5ZEiDNFG6L1eGunA9Nfv0u7vZvFT45f~zxUsbsmm-BlDlzOnTz2cRvJVymn66GgH0~KBfPwM-xBTFq9~eGip1kiEozkQxYvdI0ZeWhFBlyLCZmK3iGzal8Z6OyKeA0Ho43hkikrBvNgVkA5-4NiaYemnk9OApj~BUqw0rO-QpwFRfXZW~B1ih3OvnPeSgqxVPXBuP2D3wfoh~2~m3aTrn4Hcz1ZO0XyN8Vsy0HIYG9DkBK9ik~rD2PRyg__"
tar -xzvf cellranger-10.0.0.tar.gz
rm cellranger-10.0.0.tar.gz


cd /data/cqs/references/10x
wget "https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38_and_GRCm39-2024-A.tar.gz"
tar -xzvf refdata-gex-GRCh38_and_GRCm39-2024-A.tar.gz
rm refdata-gex-GRCh38_and_GRCm39-2024-A.tar.gz
