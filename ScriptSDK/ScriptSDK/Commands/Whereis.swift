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
//  Created by Daniel.Hu on 2022/8/12.
//
//  NOTE:
//  U R NEVER WRONG TO DO THE RIGHT THING.
//
//  Copyright (c) 2022 Daniel.Hu. All rights reserved.
//
    

import Foundation

extension Script {
    /// whereis可选项
    public struct WhereisOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 搜索手册
        public static let manual = WhereisOption(rawValue: "-m")
        /// 搜索二进制
        public static let binary = WhereisOption(rawValue: "-b")
        /// 减少输出
        public static let quiet = WhereisOption(rawValue: "-q")
        
    }
    
    
    /// 构建whereis基本命令
    public class func whereis() -> Script {
        Script(path: "/usr/bin/whereis",
               type: .apple(isAsAdministrator: false))
    }
    
    
    /// whereis通用命令
    /// - Parameters:
    ///   - value: 搜索的字段，可以是命令的名称，比如 echo；也可以是搜索某个文档路径，比如 /usr/bin/*
    ///   - options: 可选项
    /// - Returns: Script
    public func whereis_command(_ value: String,
                                options: [Script.WhereisOption]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let options = options { arguments?.append(contentsOf: options.compactMap({ $0.rawValue })) }
        arguments?.append(value)
        
        return self
    }
}
