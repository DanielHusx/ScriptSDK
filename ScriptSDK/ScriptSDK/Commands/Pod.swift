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


/// Cocoapods第三方依赖库管理工具
extension Script {
    /// pod指令
    public struct PodCommand: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 当前文档路径下创建Podfile
        public static let initial = PodCommand(rawValue: "init")
        /// 通过Podfile.lock的版本信息安装项目依赖
        public static let install = PodCommand(rawValue: "install")
        /// 更新已过期的项目依赖并创建新的Podfile.lock
        public static let update = PodCommand(rawValue: "update")
        /// 展示已过期的项目依赖
        public static let outdated = PodCommand(rawValue: "outdated")
        /// 展示可用的cocoapods配置
        public static let plugins = PodCommand(rawValue: "plugins")
        /// 搜索pods
        public static let search = PodCommand(rawValue: "search")
        /// 设置cocoapods环境
        public static let setup = PodCommand(rawValue: "setup")
        /// 显示cocoapods环境配置
        public static let environment = PodCommand(rawValue: "env")
        /// 管理pod仓库
        public static let spec = PodCommand(rawValue: "spec")
        /// 显示pods列表
        public static let list = PodCommand(rawValue: "list")
        /// 开发pods
        public static let lib = PodCommand(rawValue: "lib")
        /// 从项目中分解cocoapods
        public static let deintegrate = PodCommand(rawValue: "deintegrate")
        /// 操作cocoapods缓存
        public static let cache = PodCommand(rawValue: "cache")
        /// 尝试pod项目依赖
        public static let `try` = PodCommand(rawValue: "try")
    }
    
    /// pod选项
    /// - note: 针对不同command可选项不一样、参照具体命令
    public struct PodOptions: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 不显示输出
        public static let silent = PodOptions(rawValue: "--silent")
        /// 更新仓库
        public static let repoUpdate = PodOptions(rawValue: "--repo-update")
        /// 详细输出
        public static let verbose = PodOptions(rawValue: "--verbose")
        /// 忽略项目缓存，专注pod安装（只限于项目允许增量安装的情况下使用）
        public static let cleanInstall = PodOptions(rawValue: "--clean-install")
        
        /// 项目文档路径
        public static func projectDirectory(_ directory: String) -> Self {
            PodOptions(rawValue: "--project-directory='\(directory)'")
        }
        /// 版本
        public static let version = PodOptions(rawValue: "--version")
        
    }
    
    /// pod基础脚本命令
    /// - Returns: Script
    public class func pod() -> Script {
        Script(command: .pod,
               type: .apple(isAsAdministrator: false))
    }
    
    /// pod构建通用命令
    /// - Parameters:
    ///   - command: PodCommand
    ///   - options: PodOptions
    ///   - reserve: 保留参数
    /// - Returns: Script
    public func pod_command(commands: [PodCommand]? = nil, options: [PodOptions]? = nil, reserve: [String]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let commands = commands { arguments?.append(contentsOf: commands.map { $0.rawValue }) }
        if let options = options { arguments?.append(contentsOf: options.map { $0.rawValue }) }
        if let reserve = reserve { arguments?.append(contentsOf: reserve) }
        return self
    }
}
