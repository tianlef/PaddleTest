#!/bin/bash

# 脚本名称：daily_dir_cleaner.sh
# 功能：每天定时删除指定目录及其内容
# 使用方法：1. 修改下面的配置部分 2. 添加到cron定时任务

# ---------------------- 配置部分 ----------------------
# 要删除的目录路径（修改为你需要删除的目录）
TARGET_DIR="./workspace"

# 日志文件路径（记录删除操作）
LOG_FILE="./daily_dir_cleaner.log"

# 删除前检查目录是否存在（1=启用，0=禁用）
CHECK_DIR_EXISTENCE=1

# 删除前检查目录是否挂载（1=启用，0=禁用）
CHECK_MOUNT_STATUS=1

# 最大日志文件大小（KB），超过将轮转
MAX_LOG_SIZE=1024  # 1MB

# ---------------------- 函数定义 ----------------------

# 记录日志函数
log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# 日志轮转函数
rotate_log() {
    if [ -f "$LOG_FILE" ]; then
        local log_size=$(du -k "$LOG_FILE" | cut -f1)
        if [ "$log_size" -gt "$MAX_LOG_SIZE" ]; then
            mv "$LOG_FILE" "${LOG_FILE}.old"
            log "日志文件已轮转"
        fi
    fi
}

# ---------------------- 主程序 ----------------------

# 初始化日志
rotate_log
log "=== 开始目录清理任务 ==="

# 检查目标目录是否配置
if [ -z "$TARGET_DIR" ]; then
    log "错误：未配置目标目录"
    exit 1
fi

# 检查目录是否存在
if [ "$CHECK_DIR_EXISTENCE" -eq 1 ] && [ ! -d "$TARGET_DIR" ]; then
    log "错误：目录不存在 - $TARGET_DIR"
    exit 1
fi

# 检查目录是否挂载点（防止误删挂载目录）
if [ "$CHECK_MOUNT_STATUS" -eq 1 ]; then
    if mountpoint -q "$TARGET_DIR"; then
        log "错误：目录是挂载点 - $TARGET_DIR"
        exit 1
    fi
fi

# 执行删除操作
log "开始删除目录: $TARGET_DIR"
if rm -rf "$TARGET_DIR"; then
    log "目录删除成功: $TARGET_DIR"
    
    # 可选：重新创建目录（如果需要）
    # mkdir -p "$TARGET_DIR"
    # log "已重新创建目录: $TARGET_DIR"
else
    log "错误：目录删除失败: $TARGET_DIR"
    exit 1
fi

log "=== 目录清理任务完成 ==="
exit 0