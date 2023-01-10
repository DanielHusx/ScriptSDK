//
//  MIT License
//
//  Copyright (c) 2022 Daniel
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  ScriptSDK
//
//  Created by Daniel.Hu on 2022/8/11.
//
//  NOTE:
//  U R NEVER WRONG TO DO THE RIGHT THING.
//
//  Copyright (c) 2022 Daniel.Hu. All rights reserved.
//
    

import Foundation

/*
 NOTE: 记录一个错误处理: [Xcodeproj] Unknown object version. (RuntimeError)
 解决方案：sudo gem install cocoapods --pre
 即可
 
 只要ruby环境正常，理论上不会有任何问题~ 
 */
/// ruby脚本语言
extension Script {
    /// ruby可选项
    public struct RubyOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 设置警告级别 0=silence, 1=medium, 2=verbose (default)
        public static func warningLevel(_ level: WarningLevel) -> Self {
            Self(rawValue: "-W\(level.rawValue)")
        }
        
        /// 警告级别
        public enum WarningLevel: Int {
            case silence = 0
            case medium = 1
            case verbose = 2
        }
    }
    
    /// Ruby本地脚本
    public struct RubyScript {
        /// 本地ruby脚本
        ///
        ///     $ruby PBXProjScript.rb /path/to/xxx.xcodeproj Debug '{"targetName":{"CODE_SIGN_STYLE":"Manual"}}'
        ///
        public static let PBXProjScript: String? = Bundle(for: Script.self).path(forResource: "PBXProjScript", ofType: "rb")
    }
    
    /// ruby构建基本命令
    /// - Returns: Script
    public class func ruby() -> Script {
        return Script(.ruby,
                      type: .process(isIgnoreOutput: false, environment: ["LANG": "en_US.UTF-8"], input: nil))
    }
    
    /// ruby通用命令
    /// - Parameters:
    ///   - options: RubyOption
    ///   - programFile: .rb程序路径，默认为RubyScript.PBXProjScript
    ///   - programOptions: .rb程序参数
    /// - Returns: Self
    public func ruby_command(options: [RubyOption]? = nil,
                             programFile: String? = RubyScript.PBXProjScript,
                             programOptions: [String]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let options = options { arguments?.append(contentsOf: options.compactMap { $0.rawValue }) }
        if let programFile = programFile { arguments?.append(programFile) }
        if let programOptions = programOptions { arguments?.append(contentsOf: programOptions) }
        
        return self
    }
    
    /// 设置BuildSettings的值
    /// - Parameters:
    ///   - xcodeproj: .xcodeproj文件路径
    ///   - configuration: Debug/Release
    ///   - buildSettings: [String: AnyHashable]
    /// - Returns: Self
    public func ruby_setBuildSettings(xcodeproj: String,
                                      configuration: String,
                                      buildSettings: Script.KeyValueType) -> Self {
        var programOptions: [String] = [
            xcodeproj,
            configuration
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: buildSettings, options: []),
           let json = String(data: data, encoding: .utf8) {
            programOptions.append(json)
        }
        
        return ruby_command(options: [.warningLevel(.silence)],
                            programOptions: programOptions)
    }
    
    /// 设置BuildSettings的值
    /// - Parameters:
    ///   - xcodeproj: .xcodeproj文件路径
    ///   - targetName: scheme名称
    ///   - configuration: Debug/Release
    ///   - buildSettings: [Script.BuildSetting: AnyHashable]
    /// - Returns: Self
    public func ruby_setBuildSettings(xcodeproj: String,
                                      targetName: String,
                                      configuration: Script.Configuration,
                                      buildSettings: Script.BuildSettingKeyValueType) -> Self {
        ruby_setBuildSettings(xcodeproj: xcodeproj, configuration: configuration, buildSettings: [targetName: buildSettings])
    }
    
    /// 设置BuildSettings的值
    /// - Parameters:
    ///   - xcodeproj: .xcodeproj文件路径
    ///   - targetName: scheme名称
    ///   - configuration: Debug/Release
    ///   - buildSettings: [Script.BuildSetting: AnyHashable]
    /// - Returns: Self
    public func ruby_setBuildSettings(xcodeproj: String,
                                      targetName: String,
                                      configuration: Script.Configuration,
                                      buildSettings: Script.KeyValueType) -> Self {
        ruby_setBuildSettings(xcodeproj: xcodeproj, configuration: configuration.rawValue, buildSettings: [targetName: buildSettings])
    }
    
    /// 设置BuildSettings的值
    /// - Parameters:
    ///   - xcodeproj: .xcodeproj文件路径
    ///   - configuration: Debug/Release
    ///   - buildSettings: [String: [Script.BuildSetting: AnyHashable]]
    /// - Returns: Self
    public func ruby_setBuildSettings(xcodeproj: String,
                                      configuration: Script.Configuration,
                                      buildSettings: [String: Script.BuildSettingKeyValueType]) -> Self {
        let transformed = buildSettings.mapValues({ $0.mapKey({ $0.rawValue })})
        return ruby_setBuildSettings(xcodeproj: xcodeproj, configuration: configuration.rawValue, buildSettings: transformed)
    }
    
}
