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

/// Shell脚本
class ProcessExecutor: ExecutorHandler {
    /// 错误域名
    private static let errorDomain = "com.daniel.process.error"
    /// 执行的命令池
    private var processes: [Process] = []
    /// 锁
    private let lock = NSLock()
    
    /// 下一持有者
    var next: ExecutorHandler?
    /// 流输出，当isIgnoreOutput为true时方可生效
    var streamSubject: PassthroughSubject<ScriptResultAnyOption, Never> = .init()
    
    func execute(_ script: Script) -> ScriptResultAnyOption {
        guard script.type.isProcess else {
            return next?.execute(script) ?? .failure(.cannotHandleScript(scriptType: script.type))
        }
        
        // 校验脚本有效性
        if let ret = script.processCheck() { return ret }
        
        return execute(process: process(script: script))
    }
    
    /// 中断所有脚本
    func interrupt() {
        for process in processes { interrupt(process: process) }
        next?.interrupt()
    }
}


// MARK: - private method
extension ProcessExecutor {
    /// 执行脚本
    private func execute(process: Process) -> ScriptResultAnyOption {
        append(process)
        
        // 执行脚本
        process.launch()
        // 等待执行完毕
        process.waitUntilExit()
        
        // 执行结果解析
        return result(process: process)
    }
    
    /// 组装脚本运行对象
    private func process(script: Script) -> Process {
        let ignoreOutput = script.type.isIgnoreOutput
        
        let process = Process()
        
        process.executableURL = URL(fileURLWithPath: script.path!)
        process.arguments = script.arguments ?? []
        // 未设置环境时不能设置env，不然其内部无法继承内部的env，从而可能导致xcodebuild archive异常
        if let env = script.type.environment { process.environment = env }
        
        process.sc_ignoreOutput = ignoreOutput
        
        // terminationHandler并不一定在waitUtilExit()之后回调
        process.terminationHandler = { [weak self] p in
            // 结束时清除输入输出，不然会导致CPU暴增
            self?.cleanStream(process: p)
            self?.remove(p)
        }
        
        // 存在输入文件，读取文件内容为数据
        if let input = script.type.inputFile,
           let contents = try? String(contentsOfFile: input).data(using: .utf8),
           !contents.isEmpty {
            // 输入管道
            let inPipe = Pipe()
            inPipe.fileHandleForWriting.writeabilityHandler = { handler in
                try? handler.write(contentsOf: contents)
            }

            process.standardInput = inPipe
        }
        
        // 正常输出管道
        let outPipe = Pipe()
        outPipe.fileHandleForReading.readabilityHandler = { [weak streamSubject, weak process] handler in
            guard let s = String(data: handler.availableData, encoding: String.Encoding.utf8),
                  !s.isEmpty else { return }
            
            streamSubject?.send(.success(s))
            
            // 不忽略则加入到缓存中
            guard !ignoreOutput else { return }
            
            if process?.sc_outputStream == nil { process?.sc_outputStream = "" }
            process?.sc_outputStream?.append(s.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        process.standardOutput = outPipe
        
        // 错误输出管道
        let errPipe = Pipe()
        errPipe.fileHandleForReading.readabilityHandler = { [weak streamSubject, weak process] handler in
            guard let s = String(data: handler.availableData, encoding: String.Encoding.utf8),
                  !s.isEmpty else { return }
            
            let error = NSError(domain: Self.errorDomain, code: -1, userInfo: [NSLocalizedFailureReasonErrorKey: s])
            streamSubject?.send(.failure(.executeFailed(script: process?.shell ?? "", error: error)))
            
            // 不忽略则加入到缓存中
            guard !ignoreOutput else { return }
            
            if process?.sc_errorStream == nil { process?.sc_errorStream = "" }
            process?.sc_errorStream?.append(s.trimmingCharacters(in: .whitespacesAndNewlines))
            
        }
        
        process.standardError = errPipe
        
        return process
    }
    
    /// 解析结果
    private func result(process: Process) -> ScriptResultAnyOption {
        // 判断是否是非正常结束，算执行失败
        guard process.sc_isSuccess else {
            let code = Int(process.terminationStatus)
            let errMessage: String = process.sc_errorStream ?? ""
            let reason = process.terminationReason.sc_reason
            
            let message = "Shell script executed failed with termination reason: \(reason), code: \(code) which is non-zero and error output: \(errMessage)"
            
            let error = NSError(domain: Self.errorDomain,
                                code: code,
                                userInfo: [NSLocalizedFailureReasonErrorKey: message])
            let script = process.shell
            return .failure(.executeFailed(script: script, error: error))
        }
        
        // 正常结束下的输出与错误打印，理论上不会有错误打印，即便有也忽略它
        let output: String? = process.sc_outputStream
        
        return .success(output)
    }
    
    /// 中断
    private func interrupt(process: Process?) {
        guard process?.isRunning ?? false else { return }
        
        process?.interrupt()
    }
    
    /// 清理流
    private func cleanStream(process: Process?) {
        if let pipe = process?.standardOutput as? Pipe {
            try? pipe.fileHandleForReading.close()
            pipe.fileHandleForReading.readabilityHandler = nil
        }
        
        if let pipe = process?.standardError as? Pipe {
            try? pipe.fileHandleForReading.close()
            pipe.fileHandleForReading.readabilityHandler = nil
        }
        
        if let pipe = process?.standardInput as? Pipe {
            try? pipe.fileHandleForWriting.close()
            pipe.fileHandleForWriting.writeabilityHandler = nil
        }
    }
    
    /// 添加缓存
    private func append(_ process: Process) {
        lock.lock()
        processes.append(process)
        lock.unlock()
    }
    
    /// 移除缓存
    private func remove(_ process: Process?) {
        guard let process = process else { return }
        
        lock.lock()
        processes.removeAll(where: { process == $0 })
        lock.unlock()
    }
}

// MARK: - Process Extension
extension Process {
    internal struct AssociateKeys {
        static var sc_ignoreOutput = "sc_ignoreOutput"
        static var sc_outputStream = "sc_outputStream"
        static var sc_errorStream = "sc_errorStream"
    }
    
    /// 执行结果是否成功
    internal var sc_isSuccess: Bool { terminationStatus == 0 }
    
    /// 是否忽略输出
    internal var sc_ignoreOutput: Bool {
        get {
            guard let ret = objc_getAssociatedObject(self, &AssociateKeys.sc_ignoreOutput) as? Bool else {
                return false
            }
            return ret
        }
        set { objc_setAssociatedObject(self, &AssociateKeys.sc_ignoreOutput, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    /// 输出流
    internal var sc_outputStream: String? {
        get {
            guard let ret = objc_getAssociatedObject(self, &AssociateKeys.sc_outputStream) as? String else {
                return nil
            }
            return ret
        }
        set { objc_setAssociatedObject(self, &AssociateKeys.sc_outputStream, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 错误流
    internal var sc_errorStream: String? {
        get {
            guard let ret = objc_getAssociatedObject(self, &AssociateKeys.sc_errorStream) as? String else {
                return nil
            }
            return ret
        }
        set { objc_setAssociatedObject(self, &AssociateKeys.sc_errorStream, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// Shell完整命令
    internal var shell: String {
        let pathString = executableURL?.absoluteString ?? ""
        let argumentsString = arguments?.joined(separator: " ") ?? ""
        
        return pathString + " " + argumentsString
    }
}

extension Process.TerminationReason {
    internal var sc_reason: String {
        switch self {
        case .exit: return "exited normally"
        case .uncaughtSignal: return "exited due to an uncatchedSignal"
        default: return "unknow reason"
        }
    }
}


// MARK: - Script Extension
extension Script {
    /// 检测脚本信息是否有效
    fileprivate func processCheck() -> ScriptResultAnyOption? {
        // 路径是否有值
        guard let path = path, !path.isEmpty else {
            return .failure(.scriptInvalid(reason: .pathEmpty))
        }
        
        // 校验脚本文件是否存在且是否是非文档路径
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            return .failure(.scriptInvalid(reason: .pathNotExistOrIsDirectory(path: path)))
        }
        
        // 判断脚本是否有执行权限
        guard FileManager.default.isExecutableFile(atPath: path) else {
            return .failure(.scriptInvalid(reason: .pathPermissionDenied(path: path)))
        }
        
        return nil
    }
}
