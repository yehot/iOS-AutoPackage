[iOS 项目 自动打包+上传蒲公英+推送到钉钉群](https://www.jianshu.com/p/ca9496c00dda)

## 一、需求

目前公司项目规模较小，还没有自动构建体系，新项目需求排期也比较紧，一直没时间搞自动化，简单的写了个打包脚本先满足基本需求，功能如下：

1. 自动打包；
2. 打出的 `ipa` 包上传到蒲公英；
3. 上传成功后，通知到钉钉开发群；

### 依赖：

1. `fastlane` 的 `gym` 模块 (包 ipa 文件)；
2. `fastlane` 的 `sign` 模块 (非必须)；
3. 蒲公英和钉钉提供的 `webhook`；
4. `PlistBuddy` 解析 `plist` 文件（Mac 系统自带）;

脚本都比较简单，推送到钉钉群用 curl 命令拼接 `json param` 时一直有问题，就改用 `python` 写了。

## 二、使用

使用此脚本的的话，需要修改以下地方：

1. `auto_package_ipa.sh` 文件中的 `CM_SCHEME` 和 `CM_WORKSPACE` 两个变量，分别对应项目的 `YourProjiec.xcodeproj` 和 `YourProjiec.xcworkspace`

2. `auto_package_ipa.sh` 文件中打包证书对应的 `AppleID` （用于公司或个人账号添加了测试设备后，自动更新打包证书，非必须）;
3. `auto_upload_pyg.sh` 文件中蒲公英的 userKey 和 api_key `PGY_USER_KEY` 和 `PGY_API_KEY`
4. `auto_push_ding_talk.sh` 文件中钉钉的 webhook url: `host_url`，上传后蒲公英后的下载地址 `cm_down_load_url` 和 app icon `cm_icon_image_url`。（不过除了杭州以外，办公用钉钉的也不会很多吧）
5. `auto_package_ipa.sh` 文件中的 `CM_EXPORT_METHOD` ，demo 项目没有 `app id` 设置的是打 `development` ，正常开发阶段选择 `ad-hoc` 打包

## 三、show me code

核心代码就一行，详见：[auto_package_ipa.sh](https://github.com/yehot/iOS-AutoPackage-Demo/blob/master/ipa_script/auto_package_ipa.sh)

```shell
NOW=$(date +"%Y_%m_%d_%H_%M_%S")

# directory path
readonly CURRENT_DIR=$(pwd)
readonly PROJECT_DIR=$(dirname $(pwd))
readonly OUTPUT_DIR=${PROJECT_DIR}/fastlane_build_${NOW}

# project scheme、workspace name
readonly CM_SCHEME="AutoPackageDemo"
readonly CM_WORKSPACE="AutoPackageDemo"
readonly CM_WORKSPACE_PATH="${PROJECT_DIR}/${CM_WORKSPACE}.xcworkspace"

# product
readonly CM_ARCHIVE_PATH="${OUTPUT_DIR}/${CM_SCHEME}${NOW}.xcarchive"
readonly CM_IPA_NAME="${CM_SCHEME}${NOW}.ipa"
readonly CM_IPA_PATH="${OUTPUT_DIR}/${CM_IPA_NAME}"

# 打包方式 Debug 、Release
readonly CM_BUILD_CONFIGURATION="Debug"
# 指定打包所使用的输出方式
# 目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数

# -----------------------------
# demo 项目没有 app id，打包方式选择 development 才能打出 ipa
readonly CM_EXPORT_METHOD="development"
# 正常开发阶段选择 ad-hoc 打包，发布目前是手动打包
# readonly CM_EXPORT_METHOD="ad-hoc"
# -----------------------------

fastlane gym --workspace ${CM_WORKSPACE_PATH} \
            --scheme ${CM_SCHEME} --clean \
            --configuration ${CM_BUILD_CONFIGURATION} \
            --archive_path ${CM_ARCHIVE_PATH} \
            --export_method ${CM_EXPORT_METHOD} \
            --output_directory ${OUTPUT_DIR} \
            --output_name ${CM_IPA_NAME}
```

上传到蒲公英 和 推送到钉钉群的代码，见 demo

## 四、Tips:

1. 项目的 `.gitignore` 文件中加入：

```
# fastlane
fastlane_build_*
*.mobileprovision
*.ipa
typescript
```

2. 打包依赖 `fastlane、gym` 安装：

```shell
# fastlane 安装：
sudo gem install fastlane --verbose
xcode-select --install
gem cleanup

# gym 安装：
sudo gem install gym
xcode-select --install
```

3. 使用 `fastlane` 全套完成以上需求的话，可以参考：

[@czj_warrior](https://www.jianshu.com/p/d247d40e56fc) 的  [使用 fastlane 实现自动化打包](https://mp.weixin.qq.com/s/ByFxXKvsyS1fajES9SLInA)


## 五、Demo

[Demo 戳这里](https://github.com/yehot/iOS-AutoPackage-Demo)

注：

1. demo 项目中需要修改以下配置

![配置](https://upload-images.jianshu.io/upload_images/332029-ba0ec66023df6f46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. cd 到 `ipa_script` 目录下，执行 `sh auto_package_ipa.sh`

3. done!

