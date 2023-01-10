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

/// 结果元组
public typealias ScriptResult<Success> = Result<Success, ScriptError>
public typealias ScriptResultAnyOption = ScriptResult<Any?>

/// 脚本错误
public enum ScriptError: Error {
    /// 脚本路径失效原因
    public enum ScriptInvalidReason {
        /// 路径为空
        case pathEmpty
        /// 脚本路径不存在或路径为文档路径
        case pathNotExistOrIsDirectory(path: String)
        /// 脚本无权限访问
        case pathPermissionDenied(path: String)
    }
    
    /// 未知脚本类型错误
    case unknowScriptTypeError
    /// 无法处理脚本
    case cannotHandleScript(scriptType: ScriptType)
    /// 脚本无效
    case scriptInvalid(reason: ScriptInvalidReason)
    /// 脚本执行失败
    case executeFailed(script: String, error: Error)
    /// unix脚本构建失败
    case unixScriptCreateFailed(script: String)
}


// MARK: - 扩展结果类型
extension Result {
    /// 返回类型是否是 .success
    public var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }
    
    /// 返回类型是否是 .failure
    public var isFailure: Bool {
        !isSuccess
    }
    
    /// 返回成功关联值
    public var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    /// 返回失败关联值
    public var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
    
    /// 成功时的结果反馈为字符串
    public var string: String? {
        guard isSuccess, let ret = success as? String else { return nil }
        return ret
    }
}
