#!/usr/bin/env python
#-*- coding: utf-8 -*-

import urllib2
import json
import sys


def get_ipa_name():
    ipa_name = sys.argv[2]
    return "ipa name: " + ipa_name
    pass


def get_app_version():
    return sys.argv[3]
    pass


def get_request_params_str():
    # 项目的 app icon
    cm_icon_image_url = "https://o1wh05aeh.qnssl.com/image/view/app_icons/xxxxxxxxxxx/120"
    # 蒲公英上传安装包后的下载地址
    cm_down_load_url = "https://www.pgyer.com/xxxxx"

    message = get_ipa_name()
    print "版本信息 " + message

    app_version = get_app_version()
    print "App 版本" + app_version

    title = "xxxxApp(iOS)内测版： " + app_version

    params = {
            "msgtype": "link",
            "link": {
                "title": title,
                "text": message,
                "picUrl": cm_icon_image_url,
                "messageUrl": cm_down_load_url
                }
            }
    return json.dumps(params)  #python obj   to json(str)
    pass


def send_ding_talk_request():
    # NOTE: host_url 来自钉钉群的设置
    host_url = "https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxx"

    req = urllib2.Request(host_url)
    req.add_header('Content-Type', 'application/json')

    params_str = get_request_params_str()
    print params_str

    response = urllib2.urlopen(req, params_str)
    print response.read()

    pass


send_ding_talk_request()
