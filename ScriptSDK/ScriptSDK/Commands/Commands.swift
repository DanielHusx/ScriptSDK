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

extension Script.Command {
    public static let xcodebuild = Self("xcodebuild")
    public static let security = Self("security")
    public static let lipo = Self("lipo")
    public static let codesign = Self("codesign")
    public static let git = Self("git")
    public static let otool = Self("otool")
    public static let rm = Self("rm")
    public static let unzip = Self("unzip")
    public static let chmod = Self("chmod")
    public static let atos = Self("atos")
    public static let mdfind = Self("mdfind")
    public static let dwarfdump = Self("dwarfdump")
    public static let diff = Self("diff")
    public static let plutil = Self("plutil")
    public static let openssl = Self("openssl")
    public static let find = Self("find")
    public static let sh = Self("sh")
    public static let plistBuddy = Self("PlistBuddy")
    public static let grep = Self("grep")
    public static let hdiutil = Self("hdiutil")
    public static let cp = Self("cp")
    public static let xcrun = Self("xcrun")
    
    /// ruby虽然用whereis可以得到，但也存在可能多个ruby乱的情况，eval稳定点
    public static let ruby  = Self("ruby", fetcher: fetchBy(eval:))
    /// `whereis -b -q pod`在终端就能得到正确反馈
    /// 但在此处不论用AppleScript还是Process都反馈为空就很神奇～
    /// 至于不直接用which是因为可能环境存在多个ruby时读取的路径会乱的莫名其妙
    /// 其中默认期望的是/usr/local/bin/pod
    /// 目前找到的方案就是用eval相对比较稳定
    public static let pod = Self("pod", fetcher: fetchBy(eval:))
}
