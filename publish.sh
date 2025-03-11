#!/bin/bash

# 清理任何旧的缓存
flutter clean
flutter pub cache clean
rm -rf ~/.pub-cache/credentials.json 2>/dev/null

# 重新登录
flutter pub login

# 设置更长的超时时间
export PUB_TIMEOUT=600

# 尝试发布
flutter pub publish --timeout 600

# 如果上述命令失败，给出建议
if [ $? -ne 0 ]; then
  echo "发布失败，请尝试以下解决方案:"
  echo "1. 请检查您的网络连接"
  echo "2. 使用移动热点或其他网络"
  echo "3. 尝试使用GitHub Actions自动发布"
  echo "  - 在GitHub上设置PUB_DEV_CREDENTIALS密钥"
  echo "  - 推送v0.0.2标签触发自动发布"
  echo "4. 暂时使用Git依赖方式分享您的包"
fi 