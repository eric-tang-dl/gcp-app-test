#!/bin/bash
set -e  # 遇到任何错误就退出

echo "=== 开始部署 ==="

APP_NAME="myapp"
APP_DIR="/opt/myapp"
BACKUP_DIR="/opt/backups"

# 1. 备份当前版本（如果存在）
echo "备份当前版本..."
sudo mkdir -p $BACKUP_DIR
if [ -d "$APP_DIR" ] && [ "$(ls -A $APP_DIR)" ]; then
    sudo tar -czf $BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz -C $APP_DIR .
else
    echo "无现有应用可备份，跳过。"
fi

# 2. 停止当前服务
echo "停止服务..."
sudo systemctl stop $APP_NAME || echo "服务未运行，继续..."

# 3. 清空应用目录（部署包中的文件会解压到这里）
echo "清理应用目录..."
sudo rm -rf $APP_DIR/*
sudo mkdir -p $APP_DIR

# 4. 将Cloud Build拷贝到/tmp的部署包解压到应用目录
echo "解压新版本..."
sudo tar -xzf /tmp/app-package.tar.gz -C $APP_DIR

# 5. 安装Python依赖
echo "安装Python依赖..."
cd $APP_DIR

# 删除旧的虚拟环境（如果存在）
if [ -d "$VENV_DIR" ]; then
    rm -rf $VENV_DIR
fi

# 创建新的虚拟环境
python3 -m venv $VENV_DIR

# 在虚拟环境中安装依赖
source $VENV_DIR/bin/activate
pip install -r requirements.txt
deactivate


# 6. 确保日志文件存在且有权限
sudo touch /var/log/myapp/app.log
sudo touch /var/log/myapp/app-error.log
sudo chown $(whoami):$(whoami) /var/log/myapp/*.log

# 7. 重新加载并启动服务
echo "启动服务..."
sudo systemctl daemon-reload
sudo systemctl enable $APP_NAME
sudo systemctl start $APP_NAME

# 8. 检查服务状态
echo "检查服务状态..."
sleep 5
sudo systemctl status $APP_NAME --no-pager

echo "=== 部署完成！ ==="
