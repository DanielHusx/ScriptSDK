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

extension Script {
    /// 通用信息存储数据格式
    public typealias KeyValueType = [String: AnyHashable]
    /// 通用存储BuildSetting数据格式
    public typealias BuildSettingKeyValueType = [Script.BuildSetting: AnyHashable]
    
}

extension Script {
    /// 配置模式
    public struct Configuration: Hashable, Codable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let debug = Configuration(rawValue: "Debug")
        public static let release = Configuration(rawValue: "Release")
    }
    
    /// 渠道
    public struct Channel: Hashable, Codable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        /// App Store Connect
        /// Distribute on TestFlight and App Store
        public static let app_store = Channel(rawValue: "app-store")
        /// Ad Hoc
        /// Install on designated devices
        public static let ad_hoc = Channel(rawValue: "ad-hoc")
        /// Enterprise
        /// Distribute to your organization
        public static let enterprise = Channel(rawValue: "enterprise")
        /// Development
        /// Distribute to members of your team
        public static let development = Channel(rawValue: "development")
    }
    
    /// 系统架构
    public struct Architecture: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 真机64位处理器
        public static let arm64 = Architecture(rawValue: "arm64")
        /// 真机64位处理器（iPhone 6/6s/7/8）
        public static let arm64e = Architecture(rawValue: "arm64e")
        
        /// 真机32位处理器（iPhone 4/4s, iPad 1/2/3/mini）
        public static let armv7 = Architecture(rawValue: "armv7")
        /// 真机32位处理器（iPhone 5/5c, iPad 4）
        public static let armv7s = Architecture(rawValue: "armv7s")
        
        /// 模拟器32位处理器
        public static let i386 = Architecture(rawValue: "i386")
        /// 模拟器64位处理器
        public static let x86_64 = Architecture(rawValue: "x86_64")
    }
    
    /// 编译设置key
    /// 原文网站参考：https://help.apple.com/xcode/mac/current/#/itcaec37c2a6
    public struct BuildSetting: Hashable, Codable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let PRODUCT_BUNDLE_IDENTIFIER = BuildSetting(rawValue: "PRODUCT_BUNDLE_IDENTIFIER")
        public static let PRODUCT_NAME = BuildSetting(rawValue: "PRODUCT_NAME")
        public static let MARKETING_VERSION = BuildSetting(rawValue: "MARKETING_VERSION")
    }
}
