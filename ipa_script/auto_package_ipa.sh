#!/bin/bash
# 使用 fastlane gym 自动打包 ipa

# echo util
COLOR_Cyan='\033[0;36m'
COLOR_Red='\033[41;37m'
COLOR_Default='\033[0;m'

# todo: 打包前先执行 pod install

# 计时
SECONDS=0
NOW=$(date +"%Y_%m_%d_%H_%M_%S")

# DIR path
readonly CURRENT_DIR=$(pwd)
readonly PROJECT_DIR=$(dirname $(pwd))
readonly OUTPUT_DIR=${PROJECT_DIR}/fastlane_build_${NOW}

# project scheme、workspace name
readonly CM_SCHEME="Your_Project_Scheme_Name"
readonly CM_WORKSPACE="Your_Project_Workspace_Name"
readonly CM_WORKSPACE_PATH="${PROJECT_DIR}/${CM_WORKSPACE}.xcworkspace"

# product
readonly CM_ARCHIVE_PATH="${OUTPUT_DIR}/${CM_SCHEME}${NOW}.xcarchive"
readonly CM_IPA_NAME="${CM_SCHEME}${NOW}.ipa"
readonly CM_IPA_PATH="${OUTPUT_DIR}/${CM_IPA_NAME}"

# 打包方式 Debug 、Release
readonly CM_BUILD_CONFIGURATION="Debug"
# 指定打包所使用的输出方式
# 目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
readonly CM_EXPORT_METHOD="ad-hoc"


function echo_log() {
    echo "${COLOR_Cyan}$1${COLOR_Default}"
}

function echo_error() {
    echo "${COLOR_Red}$1${COLOR_Default}"
}

#输出设定的变量值
echo_log "============ config list =============="
echo_log "1 build configuration = ${CM_BUILD_CONFIGURATION}"
echo_log "2 export method = ${CM_EXPORT_METHOD}"
echo_log "3 workspace path = ${CM_WORKSPACE_PATH}"
echo_log "4 scheme name = ${CM_SCHEME}"
echo_log "5 archive path = ${CM_ARCHIVE_PATH}"
echo_log "6 ipa path = ${CM_IPA_PATH}"
echo_log "7 ipa name = ${CM_IPA_NAME}"
echo_log "======================================="

# 强制更新证书 (非必须)
readonly APPLE_ID="your_apple_id@xxxx.com"
# fastlane sigh download_all -u ${APPLE_ID} --adhoc --force

# 先清空前一次build
fastlane gym --workspace ${CM_WORKSPACE_PATH} \
            --scheme ${CM_SCHEME} --clean \
            --configuration ${CM_BUILD_CONFIGURATION} \
            --archive_path ${CM_ARCHIVE_PATH} \
            --export_method ${CM_EXPORT_METHOD} \
            --output_directory ${OUTPUT_DIR} \
            --output_name ${CM_IPA_NAME}

if [ "$?" -ne "0" ]; then
    echo "build error 停止自动构建"
    exit 1
fi

echo_log "===== 打包耗时：${SECONDS}s ====="
echo "===== 包路径：${CM_IPA_PATH} ====="

# 上传到蒲公英 (以上调试完成后，再打开以下注释)
# sh ./auto_upload_pgy.sh ${NOW} ${CM_IPA_PATH} ${CM_IPA_NAME}
