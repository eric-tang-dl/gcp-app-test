#!/bin/bash
set -e  # 遇到任何错误就退出

echo "=== 开始部署 ==="

APP_NAME="myapp"
APP_DIR="/opt/myapp"
BACKUP_DIR="/opt/backups"

# 1. 备份当前版本（如果存在）
echo "备份当前版本..."
sudo mkdir -p 
if [ -d "" ] && [ ".bash_history
.bash_logout
.bashrc
.cache
.config
.kube
.profile
.python_history
.ssh
.viminfo
acert
anthos-service-mesh-packages
cert
curl-test.yaml
django-deploy-svc.yaml
django-deployment.yaml
django-test-svc.yaml
example_certs2
gateway.yaml
gcloud.yaml
helloworld
httproute.yaml
initC.yaml
istio-gateway.yaml
mTLS
my-project
request.json
role.yaml
rolebinding.yaml
sysctl.yaml
test-certificate
virtualservice.yaml" ]; then
    sudo tar -czf /backup_20250924074034.tar.gz -C  .
else
    echo "无现有应用可备份，跳过。"
fi

# 2. 停止当前服务
echo "停止服务..."
sudo systemctl stop  || echo "服务未运行，继续..."

# 3. 清空应用目录（部署包中的文件会解压到这里）
echo "清理应用目录..."
sudo rm -rf /*
sudo mkdir -p 

# 4. 将Cloud Build拷贝到/tmp的部署包解压到应用目录
echo "解压新版本..."
sudo tar -xzf /tmp/app-package.tar.gz -C 

# 5. 安装Python依赖
echo "安装Python依赖..."
cd 
pip3 install -r requirements.txt

# 6. 确保日志文件存在且有权限
sudo touch /var/log/myapp/app.log
sudo touch /var/log/myapp/app-error.log
sudo chown Eric:Eric /var/log/myapp/*.log

# 7. 重新加载并启动服务
echo "启动服务..."
sudo systemctl daemon-reload
sudo systemctl enable 
sudo systemctl start 

# 8. 检查服务状态
echo "检查服务状态..."
sleep 5
sudo systemctl status  --no-pager

echo "=== 部署完成！ ==="
