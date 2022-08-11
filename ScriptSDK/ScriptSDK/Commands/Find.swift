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
    /// find命令可选项
    public struct FindOption: Hashable {
        public let rawValue: [String]
        public init(rawValue: String...) { self.rawValue = rawValue }
        
        public static func name(_ value: String) -> Self {
            FindOption(rawValue: "-name", value)
        }
        
        public static func maxdepth(_ n: Int) -> Self {
            FindOption(rawValue: "-maxdepth", "\(n)")
        }
        
        public static func type(_ value: String) -> Self {
            FindOption(rawValue: "-type", value)
        }
        
        public static let print = Self(rawValue: "-print")
    }
    
    /// 构建find基本命令
    public class func find() -> Script {
        Script(command: .find,
               type: .apple(isAsAdministrator: false))
    }
    
    /// find命令参数构建
    /// - Parameters:
    ///   - path: 查找路径根目录
    ///   - options: find可选项
    /// - Returns: Script
    public func find_command(_ path: String?,
                             options: [Script.FindOption]?) -> Self {
        if arguments == nil { arguments = [] }
        
        if let path = path { arguments?.append(path) }
        if let options = options { arguments?.append(contentsOf: options.flatMap({ $0.rawValue })) }
        
        return self
    }
    
}
