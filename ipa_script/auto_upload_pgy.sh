#!/bin/bash
# 上传 ipa 到蒲公英

# echo util
readonly COLOR_Cyan='\033[0;36m'
readonly COLOR_Red='\033[41;37m'
readonly COLOR_Default='\033[0;m'

function echo_log() {
    echo "${COLOR_Cyan}$1${COLOR_Default}"
}

function echo_error() {
    echo "${COLOR_Red}$1${COLOR_Default}"
}

echo_log "===== 打包完成，开始上传到蒲公英 ====="

readonly CURRENT_PATH="`pwd`/"

NOW=$1
CM_IPA_PATH=$2
CM_IPA_NAME=$3

if [ ! -n "${NOW}" ] ;then
    echo_error "auto-upload 入参 'now' 有误！"
    exit 1
else
    echo "build_time: ${NOW}"
fi

if [ ! -n "${CM_IPA_PATH}" ] ;then
    echo_error "auto-upload 入参 'ipa_path' 有误！"
    exit 1
else
    if [ ! -f "${CM_IPA_PATH}" ]; then
        echo_error "${CM_IPA_PATH} 文件不存在"
        exit 1
    fi
    echo_log "ipa 文件 path 为 ${CM_IPA_PATH}"
fi



# 测试 demo
# 采蜜 蒲公英 上传 key
readonly PGY_USER_KEY="xxxxxxx"
readonly PGY_API_KEY="xxxxxxx"

readonly PGY_UPLOAD_SERVER="https://qiniu-storage.pgyer.com/apiv1/app/upload"

# 接收键盘输入
# read -p "请输入蒲公英更新 log:" pgy_upload_log
# echo_log "更新 log 为：${pgy_upload_log}"
readonly PGY_upload_log="build_time_${NOW}"

# 上传到蒲公英，并接收 Response
PGY_RESPONSE=`curl -F "file=@/${CM_IPA_PATH}" -F "uKey=${PGY_USER_KEY}" -F "_api_key=${PGY_API_KEY}" -F "updateDescription=${PGY_upload_log}" ${PGY_UPLOAD_SERVER}`

if [ "$?" -ne "0" ]; then
    echo_error "upload error"
    exit 1
fi

# 推送到钉钉机器人时显示打包的版本号
CM_APP_Version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ../CaiMi/Info.plist`
CM_APP_Build_Version=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ../CaiMi/Info.plist`
CM_Version="${CM_APP_Version}.${CM_APP_Build_Version}"

echo_log ${CM_Version}

# (以上调试完成后，再打开以下注释)
# python auto_push_ding_talk.py "下载地址xxxx" ${CM_IPA_NAME} ${CM_Version}
