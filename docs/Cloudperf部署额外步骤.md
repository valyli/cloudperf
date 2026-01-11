# Cloudperf 部署额外步骤

```
dnf install -y git nodejs
npm install -g aws-cdk
# 配置 aws 权限
aws configure

git clone https://github.com/tansoft/cloudperf
cd cloudperf/
`npm install aws``-``cdk``-``lib constructs`
# 指定其他区域部署
`export`` CDK_DEFAULT_REGION``=``ap``-``northeast``-``1`
cdk bootstrap
cdk synth
cdk deploy


# 注意额外要做的步骤

./script/admin_exec.sh exec_sql init_db
./script/upload_sql.sh src/data/import-sql/init.sql

./script/admin_exec.sh create_user admin

# 注意，因为客户端部署后，如果获取任务发现当前已经没有任务了，会休眠3600秒后再重试，因此部署的先后顺序很关键
# 1. 先导入基础的数据文件
wget https://d.tansoft.org/cloudperf-data-20250715.zip
./script/upload_sql.sh cloudperf-data-20250715.zip

#（可选）下面这个不一定要，是稳定可ping的ip列表，这个列表 fping-pingable 会进行持续刷新的
wget https://d.tansoft.org/cloudperf-stableping-20250715.zip
./script/upload_sql.sh cloudperf-stableping-20250715.zip

# 2. 部署 pingable 任务，这时开始逐个 ASN 进行可ping ip的发现
./script/deploy_detector.sh aws us-east-1 fping-pingable

# 3. 部署普通探测任务 pingjob，建议第2步运行2-3分钟后，才开始部署这个，因为有可ping ip这里的任务才会开始
./script/deploy_detector.sh aws ap-southeast-1
./script/deploy_detector.sh aws all






# 已知问题
有反馈 Debian GNU/Linux 12 (bookworm) 系统运行有问题
```


