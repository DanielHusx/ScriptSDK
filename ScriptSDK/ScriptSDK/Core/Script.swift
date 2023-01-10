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
import Combine

/// 脚本模型
open class Script {
    /// 脚本路径
    open var path: String?
    /// 脚本参数集
    open var arguments: [String]?
    /// 脚本类型
    open var type: ScriptType = .unknown
    
    /// 初始化
    /// - Parameters:
    ///   - path: 脚本在本地的完整路径
    ///   - arguments: 脚本参数
    ///   - type: 脚本类型
    public init(path: String?,
                arguments: [String]? = nil,
                type: ScriptType = .unknown) {
        self.path = path
        self.arguments = arguments
        self.type = type
    }
    
    /// 新的命令基于缓存脚本路径进行初始化
    /// - Parameters:
    ///   - command: 命令类型，通过PathCacher读取缓存的路径
    ///   - script: 获取命令路径的脚本，nil则默认用which获取
    ///   - arguments: 参数集
    ///   - type: 脚本类型
    public init(command: ScriptPathCacher.Command,
                fetchBy script: Script? = nil,
                arguments: [String]? = nil,
                type: ScriptType? = nil) {
        if let path = ScriptPathCacher.shared[command] {
            self.path = path
        } else {
            ScriptPathCacher.shared[script: command] = script
            self.path = ScriptPathCacher.shared[command]
        }
        
        self.arguments = arguments
        if let typt_ = type {
            self.type = typt_
        }
    }
    
    /// 新的命令基于缓存脚本路径进行初始化
    /// - Parameters:
    ///   - command: 命令对象封装获取方式与类型
    ///   - arguments: 参数集
    ///   - type: 脚本类型
    public init(_ command: Script.Command,
                arguments: [String]? = nil,
                type: ScriptType = .unknown) {
        self.path = command.path
        self.arguments = arguments
        self.type = type
    }
}

extension Script {
    /// 脚本执行
    public func execute() -> ScriptResultAnyOption {
        Executor.shared.execute(self)
    }
    
    /// 中断所有脚本执行
    public class func interrupt() {
        Executor.shared.interrupt()
    }
    
    /// process流输出，当isIgnoreOutput为true时，此subject方能生效
    public class func streamResultSubject() -> PassthroughSubject<ScriptResultAnyOption, Never>? {
        Executor.shared.streamResultSubject
    }
}

extension Script {
    
    /// 命令结合
    /// - Parameters:
    ///   - other: 其他命令
    ///   - separator: 结合符号
    /// - Returns: Self
    public func combine(_ other: Script, separatedBy separator: String) -> Self {
        if arguments == nil { arguments = [] }
        else { arguments?.append(separator) }
        
        if let otherPath = other.path { arguments?.append(otherPath) }
        if let otherArguments = other.arguments { arguments?.append(contentsOf: otherArguments) }
        
        return self
    }
    
    /// 终端shell命令
    public var shell: String {
        let pathString = path ?? ""
        let argumentsString = arguments?.joined(separator: " ") ?? ""
        return pathString + " " + argumentsString
    }
    
}
