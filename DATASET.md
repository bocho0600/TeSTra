# DATASET

```bash
# since the artifacts have been migrated to google drive, use gdown
pip install gdown
```

## THUMOS14
```bash
gdown "https://drive.google.com/uc?id=1L6I1x6J5YORL9H6Gc4193GGbdBSNo34k"
gdown "https://drive.google.com/uc?id=1G7d4wpoeGVNEhW9RQhpgF1nHNmDkwCGD"
gdown "https://drive.google.com/uc?id=1bXKrUtrXcIOOod1fuwqHtVzceGEORb-q"
gdown "https://drive.google.com/uc?id=14nlFB4tRagdPzOu5wUxZwd1nNIR33MvN"
unzip target_perframe.zip -d target_perframe/ && rm target_perframe.zip
unzip rgb_kinetics_resnet50.zip -d rgb_kinetics_resnet50/ && rm rgb_kinetics_bninception.zip
unzip flow_kinetics_bninception.zip -d flow_kinetics_bninception/ && rm flow_kinetics_bninception.zip
unzip flow_nv_kinetics_bninception.zip -d flow_nv_kinetics_bninception/ && rm flow_nv_kinetics_bninception.zip
```

## THUMOS14 (ANet-1.3)
```bash
gdown "https://drive.google.com/uc?id=1td6sRku-uGN0OEA2R7ApK4kp0tudVNdj"
gdown "https://drive.google.com/uc?id=1F-fWEOFpdAEbPzkugTQdJBIHych5iRMZ"
unzip rgb_anet_resnet50.zip -d rgb_anet_resnet50/ && rm rgb_anet_resnet50.zip
unzip flow_anet_resnet50.zip -d flow_anet_resnet50/ && rm flow_anet_resnet50.zip
```

## EK100
```bash
gdown "https://drive.google.com/uc?id=1yHm_kOk5gTnYesl_hTld2uT_awmRJt4O"
gdown "https://drive.google.com/uc?id=1Kf-3CwSqpQeKRz8sBQr7QDZTHUhL71nZ"
gdown "https://drive.google.com/uc?id=1BGv9gW8gIbYhD3yLx5YB7X7GaLjrhKbi"
gdown "https://drive.google.com/uc?id=10CGWNLscdq1YdAKOAlx8Y-LfdMrB1zHj"
gdown "https://drive.google.com/uc?id=1j8HOCpmVpoFcXXCWBa-H-0gd5K4oOOYM"
unzip rgb_kinetics_bninception.zip -d rgb_kinetics_bninception/ && rm rgb_kinetics_bninception.zip
unzip flow_kinetics_bninception.zip -d flow_kinetics_bninception/ && rm flow_kinetics_bninception.zip
unzip target_perframe.zip -d target_perframe/ && rm target_perframe.zip
unzip verb_perframe.zip -d verb_perframe/ && rm verb_perframe.zip
unzip noun_perframe.zip -d noun_perframe/ && rm noun_perframe.zip
```
