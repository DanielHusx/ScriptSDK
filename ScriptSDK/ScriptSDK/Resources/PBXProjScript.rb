#!/usr/bin/ruby
#encoding: utf-8

require 'xcodeproj'
require 'json'

# 此文件用于设置BuildSettings的属性

# 参数校验
def check_valid (path_, configuration_, json_string_)
    if path_ == nil || configuration_ == nil || path_.length == 0 || configuration_.length == 0
        raise "Missing require parameters: project directory, configuration name"
    end
    # 未提供设置buildSettings参数，默认为设置成功
    if json_string_ == nil || json_string_.length == 0
        exit_with_message 0
    end
end

# 设置buildSettings
def buildsettings_setter (path_, configuration_, json_)
    # 是否设置成功 1失败；0成功
    is_setup = 1
    
    # 参考：https://www.rubydoc.info/gems/xcodeproj/Xcodeproj
    # 读取项目
    project = Xcodeproj::Project.open(path_)
    
    # 遍历指定的配置进行设置
    project.targets.each do |target|
        target_json_ = json_[target.name]
        if target_json_ != nil && target_json_.length != 0
            # target配置（即便是targe的依赖也依然会targets中遍历到）
            target.build_configurations.each do |config|
                if config.name == configuration_
                    target_json_.each do |key, value|
                        is_setup = 0
                        config.build_settings[key] = value
                    end
                end
            end
        end
    end
    
    if is_setup == 0
        # 设置成功后保存
        project.save
    end
    
    # 没必要反馈的is_setup
    # 设置异常，在遍历的时候就会抛出中断了，这里默默反馈成功为0即可
    return 0
end

# 主函数
def run (path_, configuration_, json_string_)
    # 校验参数
    check_valid path_, configuration_, json_string_
    
    # json string => hash dictionary
    json_ = Hash.new
    if json_string_ != nil && json_string_.length != 0
        json_ = JSON.parse json_string_
    end
    
    # setup buildSettings
    ret = buildsettings_setter path_, configuration_, json_
    
    exit_with_message ret
end

# 退出并打印
def exit_with_message (message)
    puts message
    
    exit
end



# 读取输入参数
# .xcodeproj
PROJECT_PATH = ARGV[0]
# Debug/Release
CONFIGURATION_NAME = ARGV[1]
# 需要设置BuildSettings的json字符串，样例: {"targetname":{"version":"1"}}
BUILDSETTINGS_JSON_STRING = ARGV[2]

# 运行主函数
run PROJECT_PATH, CONFIGURATION_NAME, BUILDSETTINGS_JSON_STRING

# example:
# $ruby PBXProjScript.rb /path/to/xxx.xcodeproj Debug '{"targetName":{"CODE_SIGN_STYLE":"Manual"}}'
# 成功则反馈：0
# 失败则会抛出异常

