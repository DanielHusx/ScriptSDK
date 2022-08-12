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

/// 脚本命令路径缓存者
public class ScriptPathCacher {
    /// 路径缓存
    internal private(set) var paths: [Command: String] = [:]
    /// 获取路径的脚本缓存
    private var scripts: [Command: Script] = [:]
    
    public static let shared = ScriptPathCacher()
    private init() {
        prepare()
        setup()
    }
    
}

extension ScriptPathCacher {
    /// 可支持命令类型
    public struct Command: Hashable, CaseIterable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let xcodebuild = Command(rawValue: "xcodebuild")
        public static let security = Command(rawValue: "security")
        public static let lipo = Command(rawValue: "lipo")
        public static let codesign = Command(rawValue: "codesign")
        public static let ruby  = Command(rawValue: "ruby")
        public static let git = Command(rawValue: "git")
        public static let otool = Command(rawValue: "otool")
        public static let pod = Command(rawValue: "pod")
        public static let xcrun = Command(rawValue: "xcrun")
        public static let rm = Command(rawValue: "rm")
        public static let unzip = Command(rawValue: "unzip")
        public static let chmod = Command(rawValue: "chmod")
        public static let atos = Command(rawValue: "atos")
        public static let mdfind = Command(rawValue: "mdfind")
        public static let dwarfdump = Command(rawValue: "dwarfdump")
        public static let diff = Command(rawValue: "diff")
        public static let plutil = Command(rawValue: "plutil")
        public static let openssl = Command(rawValue: "openssl")
        public static let find = Command(rawValue: "find")
        public static let sh = Command(rawValue: "sh")
        
        // 默认路径
        public static let which = Command(rawValue: "which")
        public static let eval = Command(rawValue: "eval")
        public static let plistBuddy = Command(rawValue: "PlistBuddy")
        public static let echo = Command(rawValue: "echo")
        public static let grep = Command(rawValue: "grep")
        
        // 内置
        public static let symbolicatecrash = Command(rawValue: "symbolicatecrash")
        
        public static var allCases: [ScriptPathCacher.Command] = [
            .xcodebuild,
            .security,
            .lipo,
            .codesign,
            .ruby,
            .git,
            .otool,
            .pod,
            .xcrun,
            .rm,
            .unzip,
            .chmod,
            .atos,
            .mdfind,
            .dwarfdump,
            .diff,
            .plutil,
            .openssl,
            .find,
            .sh,
            .which,
            .eval,
            .plistBuddy,
            .echo,
            .grep,
            .symbolicatecrash
        ]
    }
    
}

extension ScriptPathCacher {
    private func prepare() {
        paths[.eval] = "eval `/usr/libexec/path_helper -s`;"
        paths[.symbolicatecrash] = Bundle(for: ScriptPathCacher.self).path(forResource: "symbolicatecrash", ofType: nil)
        
        // whereis -b -q pod在终端就能得到正确反馈，在此处不论用AppleScript还是Process都反馈为空就很神奇～
        // 不直接用which是因为可能环境存在多个ruby时读取的路径会乱，而默认期望的是/usr/local/bin/pod，目前找到的方案就是用eval相对比较稳定
        scripts[.pod] = eval(.pod)
        // ruby虽然用whereis可以得到，但也存在可能多个ruby乱的情况，eval稳定点
        scripts[.ruby] = eval(.ruby)
        
        for cmd in Command.allCases {
            guard paths[cmd] == nil, scripts[cmd] == nil else { continue }
            
            /*
             whereis似乎比which相对更管用
             只不过某些路径得到的不太一样
             比如:
             which git => /Applications/Xcode.app/Contents/Developer/usr/bin/git
             whereis -b -q git => /usr/bin/git
             
             atos, xcodebuild 结果同上类似
             */
            scripts[cmd] = whereis(cmd)
        }
    }
    
    private func setup() {
        for (c, s) in scripts {
            guard let path = execute(s) else { continue }
            
            paths[c] = path
        }
    }
    
    private func execute(_ script: Script) -> String? {
        let ret = script.execute()
        guard let path = ret.success as? String, !path.isEmpty else { return nil }
        
        return path.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension ScriptPathCacher {
    /// 通用初始化
    public class func config() {
        _ = ScriptPathCacher.shared
    }
    
    /// 通过特有命令设置缓存路径，如不提供script，则默认使用which
    public subscript(script command: Command) -> Script? {
        get { scripts[command] }
        set {
            let script = newValue ?? which(command)
            scripts[command] = script
            
            guard let path = execute(script) else { return }
            self[command] = path
        }
    }
    
    /// 下标读取修改缓存
    public subscript(command: Command) -> String? {
        get { paths[command] }
        set { paths[command] = newValue }
    }
    
    /// which构建查找命令
    public func which(_ command: Command) -> Script {
        Script(path: paths[.which],
               arguments: [command.rawValue],
               type: .apple(isAsAdministrator: false))
    }
    /// eval `/usr/libexec/path_helper -s`; which 构建查找命令
    public func eval(_ command: Command) -> Script {
        Script(path: paths[.eval],
               arguments: [
                    paths[.which] ?? "which",
                    command.rawValue
               ],
               type: .apple(isAsAdministrator: false))
    }
    /// whereis查找命令
    public func whereis(_ command: Command) -> Script {
        Script.whereis().whereis_command(command.rawValue, options: [.binary, .quiet])
    }
}
