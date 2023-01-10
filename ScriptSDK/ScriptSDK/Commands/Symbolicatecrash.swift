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

extension Script {
    /// symbolicatecrash可选项
    public struct SymbolicatecrashOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 详细打印
        public static func verbose() -> Self { SymbolicatecrashOption(rawValue: "--verbose") }
        /// 符号表
        public static func dsyms(_ paths: [String]) -> Self { SymbolicatecrashOption(rawValue: paths.map { "-d \($0)" }.joined(separator: " ")) }
        /// 输出目标位置
        /// - note: 不知为何设置此项无效果、目前使用脚本执行后反馈的output即解析后的完整日志
        public static func output(_ out: Output) -> Self { SymbolicatecrashOption(rawValue: "-o \(out.rawValue)") }
        
        /// 输入类型
        public struct Input: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static func file(_ path: String) -> Self { Input(rawValue: path) }
            public static func stdin(_ input: String) -> Self { Input(rawValue: "- \(input)") }
        }
        /// 输出类型
        public struct Output: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static func file(_ path: String) -> Self { Output(rawValue: path) }
            public static func stdout() -> Self { Output(rawValue: "-") }
        }
    }
    
    /// symbolicatecrash构建基本命令
    /// - Parameters:
    ///    - isIgnoreOutput: 是否忽略输出，默认为false
    ///    - environment: 环境变量，默认为["DEVELOPER_DIR": "/Applications/Xcode.app/Contents/Developer"]
    public class func symbolicatecrash(isIgnoreOutput: Bool = false,
                                       environment: [String: String]? = ["DEVELOPER_DIR": "/Applications/Xcode.app/Contents/Developer"]) -> Script {
        Script(.symbolicatecrash,
               type: .process(isIgnoreOutput: isIgnoreOutput, environment: environment, input: nil))
    }
    
    /// symbolicatecrash通用命令
    /// - Parameters:
    ///   - input: 输入解析文件路径
    ///   - options: SymbolicatecrashOption
    ///   - symbolSearchPaths: 搜索符号表路径列表
    /// - Returns: Self
    public func symbolicatecrash_command(input: SymbolicatecrashOption.Input,
                                         options: [SymbolicatecrashOption]? = nil,
                                         symbolSearchPaths: [String]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let options = options { arguments?.append(contentsOf: options.map { $0.rawValue }) }
        arguments?.append(input.rawValue)
        if let symbolSearchPaths = symbolSearchPaths { arguments?.append(contentsOf: symbolSearchPaths) }
        
        return self
    }
    
}
