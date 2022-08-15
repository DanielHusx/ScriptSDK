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

/// 脚本执行者
class Executor {
    /// 单例对象
    static let shared = Executor()
    /// 执行处理者
    private lazy var handler: ExecutorHandler = {
        let root = RootHandler()
        let apple = AppleExecutor()
        let process = ProcessExecutor()
        let unknown = UnknownExecutor()
        
        root.next = apple
        apple.next = process
        process.next = unknown
        
        return root
    }()
    
    /// process流输出，当isIgnoreOutput为true时，此subject方能生效
    lazy var streamResultSubject: PassthroughSubject<ScriptResultAnyOption, Never>? = {
        var executor: ExecutorHandler? = handler
        while let next = executor?.next {
            guard let process = next as? ProcessExecutor else {
                executor = executor?.next
                continue
            }
            
            return process.streamSubject
        }
        return nil
    }()
    
    /// 执行脚本
    func execute(_ script: Script) -> ScriptResultAnyOption {
        handler.execute(script)
    }
    
    /// 中断脚本
    func interrupt() {
        handler.interrupt()
    }
    
    private init() {}
}
