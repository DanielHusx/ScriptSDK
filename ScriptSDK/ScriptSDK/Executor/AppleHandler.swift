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

/// 苹果脚本
class AppleExecutor: ExecutorHandler {
    /// 错误域名
    private static let errorDomain = "com.daniel.appleScript.error"
    /// 锁
    private let lock = NSLock()
    
    /// 下一持有者
    var next: ExecutorHandler?
    
    func execute(_ script: Script) -> ScriptResultAnyOption {
        guard script.type.isApple else {
            return next?.execute(script) ?? .failure(.cannotHandleScript(scriptType: script.type))
        }
        
        if let ret = script.appleCheck() { return ret }
        
        // 用锁因为一旦同一时间有两个命令正在执行NSAppleScript就有可能崩溃
        lock.lock()
        let ret = execute(source: script.source)
        lock.unlock()
        
        return ret
    }
    
    func interrupt() {
        // 瞬发，无法中断
        next?.interrupt()
    }
}


// MARK: - private method
extension AppleExecutor {
    private func execute(source: String) -> ScriptResultAnyOption {
        let scriptor = NSAppleScript(source: source)
        var errorInfo: NSDictionary?
        
        guard let result = scriptor?.executeAndReturnError(&errorInfo) else {
            // 反馈错误
            var errorMessage = "unknow error"
            if let msg = errorInfo?.value(forKey: NSAppleScript.errorMessage) as? String {
                errorMessage = msg
            }
            // 这种情况属于没有输出、对于shell命令来说是正确的
            // 但对于apple script就会抛出错误，所以此处做拦截
            // 返回上层output、error都为空但是 return 为nil
            if errorMessage == "The command exited with a non-zero status." {
                return .success(nil)
            }
            var code: Int = -1
            if let c = errorInfo?.value(forKey: NSAppleScript.errorNumber) as? NSNumber {
                code = c.intValue
            }
            
            let message = "Apple script executed failed with \(errorMessage)"
            let error = NSError(domain: Self.errorDomain,
                                code: code,
                                userInfo: [NSLocalizedFailureReasonErrorKey: message])
            return .failure(.executeFailed(script: source, error: error))
        }
        
        return .success(result.stringValue)
    }
}

extension Script {
    /// Apple脚本完整命令
    public var source: String {
        // eg: do shell script "sudo which git" with administrator privileges
        let shellString = shell
        let administrator = type.isAsAdministrator ? " with administrator privileges" : ""
        return "do shell script \"\(shellString)\"\(administrator)"
    }
    
    /// 检测脚本信息是否有效
    fileprivate func appleCheck() -> ScriptResultAnyOption? {
        // 路径是否有值
        guard let path = path, !path.isEmpty else {
            return .failure(.scriptInvalid(reason: .pathEmpty))
        }
        
        return nil
    }
}
