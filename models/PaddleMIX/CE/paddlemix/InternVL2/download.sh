#!/bin/bash


URL=$1
FILE=$(basename "$URL")

echo "开始下载：$FILE"

wget -c --quiet "$URL" &
pid=$!

while kill -0 $pid 2>/dev/null; do
    size=$(du -h "$FILE" 2>/dev/null | cut -f1)
    echo "$(date '+%H:%M:%S') 已下载 $size"
    sleep 30
done

echo "✅ 下载完成：$FILE"
