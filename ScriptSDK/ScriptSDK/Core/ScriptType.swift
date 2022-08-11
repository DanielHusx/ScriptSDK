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

/// 脚本类型
public enum ScriptType {
    /// 未知类型
    case unknown
    /// 终端Shell类型
    /// - Parameters:
    ///    - isIgnoreOutput: 是否忽略输出。如果为true，则通过Exector.xxxStreamNotify输出
    ///    - environment: 环境变量。一般为需要先以export定义某变量才能正确执行的脚本才设置
    ///    - input: 输入文件路径。脚本需要输入文件时有效
    case process(isIgnoreOutput: Bool, environment: [String: String]?, input: String?)
    /// 系统Apple类型
    /// - note: arguments内的参数如果存在 "（能用'代替最好，就无需反斜杠）或其他需要转义的字符，需要使用2+1反斜杠+转义字符，例如： git -C \\\"path/to/destination\\\"
    /// - Parameters:
    ///    - isAsAdministrator: 是否以管理员身份执行
    case apple(isAsAdministrator: Bool)
}

extension ScriptType {
    /// 是否是终端shell类型
    public var isProcess: Bool {
        guard case .process = self else { return false }
        return true
    }
    
    /// 是否是系统Apple
    public var isApple: Bool {
        guard case .apple = self else { return false }
        return true
    }
    
    /// 是否以管理员执行
    public var isAsAdministrator: Bool {
        guard case let .apple(admin) = self else { return false }
        return admin
    }
    
    /// 是否忽略输出
    public var isIgnoreOutput: Bool {
        switch self {
        case .process(isIgnoreOutput: let ret, environment: _, input: _): return ret
        default: return false
        }
    }
    
    /// 输入文件
    public var inputFile: String? {
        switch self {
        case .process(isIgnoreOutput: _, environment: _, input: let ret): return ret
        default: return nil
        }
    }
    
    /// 环境变量
    public var environment: [String: String]? {
        guard case let .process(_, env, _) = self else { return nil }
        return env
    }
}
