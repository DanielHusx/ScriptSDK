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
//  Created by Daniel.Hu on 2023/1/5.
//
//  NOTE:
//  U R NEVER WRONG TO DO THE RIGHT THING.
//
//  Copyright (c) 2022 Daniel.Hu. All rights reserved.
//
    

import Foundation


extension Script {
    /*
     每种命令初始化时，提供命令类型，获取脚本路径的方式（可能直接路径，可能是脚本），参数
     那么获取脚本的方式 可以封装在 命令类型 对象中，从而定义静态获取方式，进而简化命令初始化
     此方式初始化时，可通过优先级存取
     1. 用户字典    优先级 中
     2. 内存缓存    优先级 高
     3. fetch block 优先级 低
     为保险起见，取用户字典的情况下，需校验路径是否存在
     */
    public struct Command {
        /// 命令标识（脚本名）
        public let rawValue: String
        /// 获取命令方式，默认以`whereis`命令获取
        public var fetcher: (String) -> String?
        
        
        /// 初始化
        /// - Parameters:
        ///   - rawValue: 脚本名
        ///   - fetcher: 获取脚本路径的方式，默认使用`whereis`获取
        public init(_ rawValue: String,
                    fetcher: @escaping (String) -> String? = fetchBy(whereis:)) {
            self.rawValue = rawValue
            self.fetcher = fetcher
        }
        
        
        /// 以自定义脚本路径的方式初始化
        /// - Parameters:
        ///   - rawValue: 脚本名
        ///   - path: 默认脚本路径
        public init(_ rawValue: String, path: String?) {
            self.rawValue = rawValue
            self.fetcher = { _ in path }
        }
    }
}


extension Script.Command: Hashable {
    public static func == (lhs: Script.Command, rhs: Script.Command) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}


extension Script.Command {
    /// 缓存已获取的脚本
    private static var scriptPaths: [Self: String] = [:]
    /// 用户字典存取的脚本列表键
    private static let kPathInUserDefaultsKey = "Serendipity_ScriptCommands"
    
    /// 脚本路径
    public var path: String? {
        // 读缓存
        if let ret = Self.scriptPaths[self] { return ret }
        // 读用户字典
        // 此处做路径检查，是为了防止脚本路径相较之前不一致后无法重新更新
        // 不正常的脚本路径存不存字典内无关紧要
        if let commandDict = UserDefaults.standard.dictionary(forKey: Script.Command.kPathInUserDefaultsKey),
           let ret = commandDict[rawValue] as? String,
           FileManager.default.fileExists(atPath: ret) {
            return ret
        }
        
        // 自定义获取脚本路径
        // 此处不做路径检查，是为了让path更简单
        guard let ret = fetcher(rawValue) else { return nil }
        
        // 写缓存
        Self.scriptPaths[self] = ret
        // 写用户字典
        var dict: [String: Any] = UserDefaults.standard.dictionary(forKey: Script.Command.kPathInUserDefaultsKey) ?? [:]
        dict[rawValue] = ret
        UserDefaults.standard.set(dict, forKey: Script.Command.kPathInUserDefaultsKey)
        
        return ret
    }
    
}

// MARK: - 基础查找脚本路径方法
extension Script.Command {
    /// `whereis`查找命令
    public static func fetchBy(whereis commandString: String) -> String? {
        Script.whereis()
              .whereis_command(commandString,
                               options: [.binary, .quiet])
              .execute()
              .string
    }
    
    /// ```eval `/usr/libexec/path_helper -s`; which``` 构建查找命令
    /// 主要用于`ruby`类的命令查找
    public static func fetchBy(eval commandString: String) -> String? {
        Script(path: eval.path,
               arguments: ["which", commandString],
               type: .apple(isAsAdministrator: false))
            .execute()
            .string
    }
    
}

// MARK: - 基础命令定义
extension Script.Command {
    public static let eval = Self("eval", path: "eval `/usr/libexec/path_helper -s`;")
    
    public static let whereis = Self("whereis", path: "/usr/bin/whereis")
    
    public static let which = Self("which")
    
    /// `echo`理论上的脚本路径：`/bin/echo`
    /// 但是存在打印不会自动转码的问题，所以固定用`echo`
    /// 这样也同样限制了此命令只能用`AppleScript`调用
    public static let echo = Self("eval", path: "echo")
    
    /// 内置`symbolicatecrash`
    public static let symbolicatecrash = Self("symbolicatecrash", path: Bundle(for: Script.self).path(forResource: "symbolicatecrash", ofType: nil))
    

}
