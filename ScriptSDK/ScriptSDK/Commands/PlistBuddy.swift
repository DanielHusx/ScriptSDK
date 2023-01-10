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
    /// PlistBuddy增删查改指令
    public struct PlistBuddyCURDCommand: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let add = PlistBuddyCURDCommand(rawValue: "Add")
        public static let delete = PlistBuddyCURDCommand(rawValue: "Delete")
        public static let set = PlistBuddyCURDCommand(rawValue: "Set")
        public static let print = PlistBuddyCURDCommand(rawValue: "Print")
        
    }
    
    /// PlistBuddy支持的数据类型
    public struct PlistBuddyDataType: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let string = PlistBuddyDataType(rawValue: "string")
        public static let array = PlistBuddyDataType(rawValue: "array")
        public static let dict = PlistBuddyDataType(rawValue: "dict")
        public static let bool = PlistBuddyDataType(rawValue: "bool")
        public static let real = PlistBuddyDataType(rawValue: "real")
        public static let integer = PlistBuddyDataType(rawValue: "integer")
        public static let date = PlistBuddyDataType(rawValue: "date")
        public static let data = PlistBuddyDataType(rawValue: "data")
        
        /// AnyHashable => PlistBuddyDataType?
        public static var type = { (_ value: KeyValueType.Value) -> Self? in
            switch value {
            case is String: return .string
            case is Int: return .integer
            case is Double, is Float: return .real
            case is Data: return .data
            case is Date: return .date
            case is Bool: return .bool
            case is [KeyValueType.Value]: return .array
            case is KeyValueType: return .dict
            default: return nil
            }
        }
        
        /// 是否是集合类型
        public var isCollectionType: Bool {
            switch self {
            case .array, .dict: return true
            default: return false
            }
        }
    }
    
    /// PlistBuddy基础命令
    ///
    /// 用于操作.plist文件
    /// - Note: 优点：速度快；缺点：打印格式是JavaScript-object-literal-like格式，swift无法解析集合类型（Array, Dictionary）
    /// - Returns: Script
    public class func plistBuddy() -> Script {
        Script(.plistBuddy,
               type: .apple(isAsAdministrator: false))
    }
    
    /// 支持PlistBuddyCURDCommand的命令合成
    /// - Parameters:
    ///   - command: PlistBuddyCURDCommand
    ///   - entry: 键值序列，以 : 表示层级
    ///   - type: PlistBuddyDataTypes
    ///   - value: 设置的属性值
    /// - Returns: Self
    public func plistBuddy_curd(command: PlistBuddyCURDCommand,
                                entry: String,
                                type: PlistBuddyDataType? = nil,
                                value: String? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        arguments?.append("-c")
        arguments?.append("'\(command.rawValue) :\(entry) \(type?.rawValue ?? "") \(value ?? "")'")
        
        return self
    }
    
    /// 格式化数组输出
    public func plistBuddy_formatArray() -> Self {
        if arguments == nil { arguments = [] }
        
        arguments?.append("|")
        arguments?.append("sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'")
        
        return self
    }
    
    /// 设置输入文件
    /// - Parameter input: 完整文件路径（不限于.plist)
    public func plistBuddy_input(input: String) -> Self {
        if arguments == nil { arguments = [] }
        arguments?.append(input)
        
        return self
    }
    
    /// 设置输入脚本
    /// - Parameter input: 输入脚本
    public func plistBuddy_input(input: Script) -> Self {
        if arguments == nil { arguments = [] }
        
        arguments?.append("/dev/stdin")
        arguments?.append("<<<")
        arguments?.append("$(\(input.shell))")
        
        return self
    }
}
