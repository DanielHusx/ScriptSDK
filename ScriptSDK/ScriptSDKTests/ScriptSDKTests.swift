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

import XCTest
import Combine
@testable import ScriptSDK

class ScriptSDKTests: XCTestCase {
    let pather = ScriptPathCacher.shared
    let executor = Executor.shared
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Executor.shared.streamResultSubject?.sink(receiveValue: { output in
            print("[Stream] \(output)")
        })
        .store(in: &cancellable)
        ScriptPathCacher.config()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

// MARK: - 测试缓存脚本路径是否存在
extension ScriptSDKTests {
    func common(cmd: ScriptPathCacher.Command, aspect: String) {
        guard let path = self.pather[cmd] else {
            XCTFail("缓存中无\(cmd.rawValue)值，期望: \(aspect)")
            return
        }
        
        XCTAssertEqual(path, aspect, "\(cmd.rawValue)脚本路径: \(path) 与期望路径不符: \(aspect)")
    }
    
    func testPathCache() {
        common(cmd: .security, aspect: "/usr/bin/security")
        common(cmd: .lipo, aspect: "/usr/bin/lipo")
        common(cmd: .codesign, aspect: "/usr/bin/codesign")
        common(cmd: .ruby, aspect: "/usr/bin/ruby")
        common(cmd: .git, aspect: "/Applications/Xcode.app/Contents/Developer/usr/bin/git")
        common(cmd: .otool, aspect: "/usr/bin/otool")
        common(cmd: .pod, aspect: "/usr/local/bin/pod")
        common(cmd: .xcrun, aspect: "/usr/bin/xcrun")
        common(cmd: .unzip, aspect: "/usr/bin/unzip")
        common(cmd: .chmod, aspect: "/bin/chmod")
        common(cmd: .atos, aspect: "/Applications/Xcode.app/Contents/Developer/usr/bin/atos")
        common(cmd: .mdfind, aspect: "/usr/bin/mdfind")
        common(cmd: .dwarfdump, aspect: "/usr/bin/dwarfdump")
        common(cmd: .xcodebuild, aspect: "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild")
        common(cmd: .rm, aspect: "/bin/rm")
    }
}

// MARK: - Commands
extension ScriptSDKTests {
    func testSecurity() {
        let ret = Script.security()
                        .security_keychainValidCertificates()
                        .execute()
        guard let keychainValidCertificates = ret.success as? String else {
            XCTFail("\(ret)")
            return
        }
        print("钥匙串有效证书列表: \(keychainValidCertificates)")
    }
    
    func testGit() {
        let ret = Script.git()
                        .git_command(options: [.version])
                        .execute()
        guard let version = ret.success as? String else {
            XCTFail("\(ret)")
            return
        }
        print("git版本: \(version)")
    }
    
    func testPod() {
        let ret = Script.pod()
                        .pod_command(options: [.version])
                        .execute()
        guard let env = ret.success as? String else {
            XCTFail("\(ret)")
            return
        }
        print("pod版本: \(env)")
    }
    
    func testDwarfdump() {
        let binaryFile = Bundle(for: ScriptSDKTests.self).path(forResource: "EmptyIOS", ofType: nil)
        let ret = Script.dwarfdump()
                        .dwarfdump_command(binaryFile, options: [.uuid])
                        .execute()
        guard let uuid = ret.success as? String else {
            XCTFail("\(ret)")
            return
        }
        print("uuid: \(uuid)")
    }
    
    func testSh() {
        guard let script = Bundle(for: ScriptSDKTests.self).path(forResource: "test", ofType: "sh") else {
            XCTFail("找不到测试脚本test.sh")
            return
        }
        let ret = Script.sh()
                        .sh_command(script, args: ["testSh"])
                        .execute()
        guard ret.isSuccess else {
            XCTFail("\(ret)")
            return
        }
        
    }
}

// MARK: - 多脚本测试
extension ScriptSDKTests {
    func testMultiGit() {
        measure {
            for _ in 0..<50 {
                testGit()
            }
        }
    }
    
    func testMultiSh() {
        guard let script = Bundle(for: ScriptSDKTests.self).path(forResource: "test", ofType: "sh") else {
            XCTFail("找不到测试脚本test.sh")
            return
        }
        
        measure {
            for i in 0..<50 {
                let ret = Script.sh()
                                .sh_command(script, args: ["\(i)"])
                                .execute()
                guard ret.isSuccess else {
                    XCTFail("\(ret)")
                    return
                }
            }
        }
    }
}


// MARK: - 中断
extension ScriptSDKTests {
    func testInterrupt() {
        guard let script = Bundle(for: ScriptSDKTests.self).path(forResource: "test", ofType: "sh") else {
            XCTFail("找不到测试脚本test.sh")
            return
        }
        
        let ret = Script.sh()
                        .sh_command(script, args: ["interrupt"])
                        .execute()
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            Executor.shared.interrupt()
        }
        
        guard ret.isSuccess else {
            XCTFail("\(ret)")
            return
        }
    }
}
