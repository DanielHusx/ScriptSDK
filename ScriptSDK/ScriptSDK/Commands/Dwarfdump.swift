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

/// dwarfdump解析二进制文件的uuid
extension Script {
    /// dwarfdump选项
    public struct DwarfdumpOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 展示所有系统架构的uuid值
        public static let uuid = DwarfdumpOption(rawValue: "-u")
        /// 简要输出
        public static let quiet = DwarfdumpOption(rawValue: "--quiet")
        /// 详细输出
        public static let verbose = DwarfdumpOption(rawValue: "--verbose")
        /// 展示所有支持的DWARF节点
        public static let all = DwarfdumpOption(rawValue: "-a")
        /// 显示DWARF表单类型
        public static let showForm = DwarfdumpOption(rawValue: "-F")
        /// 忽略大小写，必须配合--name使用
        public static let ignoreCase = DwarfdumpOption(rawValue: "-i")
        /// 脚本版本号
        public static let version = DwarfdumpOption(rawValue: "--version")
        
        /// 限制只输出某一系统架构的输出
        public static func arch(_ architecture: Architecture) -> Self {
            DwarfdumpOption(rawValue: "--arch=\(architecture.rawValue)")
        }
        
        /// 查找地址
        public static func lookup(_ address: String) -> Self {
            DwarfdumpOption(rawValue: "--lookup=\(address)")
        }
        
        /// 重定向输出
        public static func output(_ path: String) -> Self {
            DwarfdumpOption(rawValue: "-o \(path)")
        }
        
        /// 查找关键字
        public static func find(_ name: String) -> Self {
            DwarfdumpOption(rawValue: "--find='\(name)'")
        }
        
        /// 查找并打印关键字信息
        public static func name(_ value: String) -> Self {
            DwarfdumpOption(rawValue: "--name='\(value)")
        }
        
        /// 正则输出，必须与--name配合使用
        public static func regex(_ value: String) -> Self {
            DwarfdumpOption(rawValue: "-x ‘\(value)’")
        }
    }
    
    /// dwarfdump构建基本命令
    public class func dwarfdump() -> Script {
        Script(command: .dwarfdump,
               type: .apple(isAsAdministrator: false))
    }
    
    /// dwarfdump通用命令
    /// - Parameters:
    ///   - inputFilePath: 输入文件路径
    ///   - options: DwarfdumpOption
    /// - Returns: Self
    public func dwarfdump_command(_ inputFilePath: String? = nil,
                                  options: [DwarfdumpOption]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let options = options { arguments?.append(contentsOf: options.map{ $0.rawValue }) }
        if let inputFilePath = inputFilePath { arguments?.append("'" + inputFilePath + "'") }
        
        return self
    }
    
}
