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


/// Security解析配置文件信息
extension Script {
    /// Security选项
    public struct SecurityOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 详细输出
        public static let verbose = SecurityOption(rawValue: "-v")
        /// 简要输出
        public static let quiet = SecurityOption(rawValue: "-q")
        /// 以交互模式运行安全性。 将显示提示（默认情况下为 security>），并且用户将能够在 stdin 上键入命令，直到遇到 EOF。
        public static let interactive = SecurityOption(rawValue: "-i")
        /// 在安全性退出之前，对自身运行 /usr/bin/leaks -nocontext 以查看您执行的命令是否有任何泄漏。
        public static let leak = SecurityOption(rawValue: "-l")
        /// 此选项暗含 -i 选项，但将默认提示改为指定的参数。
        public static func prompt(_ value: String) -> Self {
            SecurityOption(rawValue: "-p \(value)")
        }
    }
    
    /// Security指令
    public struct SecurityCommand: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// Show all commands, or show usage for a command.
        public static let help = SecurityCommand(rawValue: "help")
        /// Display or manipulate the keychain search list.
        public static let list_keychains = SecurityCommand(rawValue: "list-keychains")
        /// Display available smartcards.
        public static let list_smartcards = SecurityCommand(rawValue: "list-smartcards")
        /// Display or set the default keychain.
        public static let default_keychain = SecurityCommand(rawValue: "default-keychain")
        /// Display or set the login keychain.
        public static let login_keychain = SecurityCommand(rawValue: "login-keychain")
        /// Create keychains and add them to the search list.
        public static let create_keychain = SecurityCommand(rawValue: "create-keychain")
        /// Delete keychains and remove them from the search list.
        public static let delete_keychain = SecurityCommand(rawValue: "delete-keychain")
        /// Lock the specified keychain.
        public static let lock_keychain = SecurityCommand(rawValue: "lock-keychain")
        /// Unlock the specified keychain.
        public static let unlock_keychain = SecurityCommand(rawValue: "unlock-keychain")
        /// Set settings for a keychain.
        public static let set_keychain_settings = SecurityCommand(rawValue: "set-keychain-settings")
        /// Set password for a keychain.
        public static let set_keychain_password = SecurityCommand(rawValue: "set-keychain-password")
        /// Show the settings for keychain.
        public static let show_keychain_info = SecurityCommand(rawValue: "show-keychain-info")
        /// Dump the contents of one or more keychains.
        public static let dump_keychain = SecurityCommand(rawValue: "dump-keychain")
        /// Create an asymmetric key pair.
        public static let create_keypair = SecurityCommand(rawValue: "create-keypair")
        /// Add a generic password item.
        public static let add_generic_password = SecurityCommand(rawValue: "add-generic-password")
        /// Add an internet password item.
        public static let add_internet_password = SecurityCommand(rawValue: "add-internet-password")
        /// Add certificates to a keychain.
        public static let add_certificates = SecurityCommand(rawValue: "add-certificates")
        /// Find a generic password item.
        public static let find_generic_password = SecurityCommand(rawValue: "find-generic-password")
        /// Delete a generic password item.
        public static let delete_generic_password = SecurityCommand(rawValue: "delete-generic-password")
        /// Set the partition list of a generic password item.
        public static let set_generic_password_partition_list = SecurityCommand(rawValue: "set-generic-password-partition-list")
        /// Find an internet password item.
        public static let find_internet_password = SecurityCommand(rawValue: "find-internet-password")
        /// Delete an internet password item.
        public static let delete_internet_password = SecurityCommand(rawValue: "delete-internet-password")
        /// Set the partition list of a internet password item.
        public static let set_internet_password_partition_list = SecurityCommand(rawValue: "set-internet-password-partition-list")
        /// Find keys in the keychain
        public static let find_key = SecurityCommand(rawValue: "find-key")
        /// Set the partition list of a key.
        public static let set_key_partition_list = SecurityCommand(rawValue: "set-key-partition-list")
        /// Find a certificate item.
        public static let find_certificate = SecurityCommand(rawValue: "find-certificate")
        /// Find an identity (certificate + private key).
        public static let find_identity = SecurityCommand(rawValue: "find-identity")
        /// Delete a certificate from a keychain.
        public static let delete_certificate = SecurityCommand(rawValue: "delete-certificate")
        /// Delete an identity (certificate + private key) from a keychain.
        public static let delete_identity = SecurityCommand(rawValue: "delete-identity")
        /// Set the preferred identity to use for a service.
        public static let set_identity_preference = SecurityCommand(rawValue: "set-identity-preference")
        /// Get the preferred identity to use for a service.
        public static let get_identity_preference = SecurityCommand(rawValue: "get-identity-preference")
        /// Create a db using the DL.
        public static let create_db = SecurityCommand(rawValue: "create-db")
        /// Export items from a keychain.
        public static let export = SecurityCommand(rawValue: "export")
        /// Import items into a keychain.
        public static let `import` = SecurityCommand(rawValue: "import")
        /// Export items from a smartcard.
        public static let export_smartcard = SecurityCommand(rawValue: "export-smartcard")
        /// Encode or decode CMS messages.
        public static let cms = SecurityCommand(rawValue: "cms")
        /// Install (or re-install) the MDS database.
        public static let install_mds = SecurityCommand(rawValue: "install-mds")
        /// Add trusted certificate(s).
        public static let add_trusted_cert = SecurityCommand(rawValue: "add-trusted-cert")
        /// Remove trusted certificate(s).
        public static let remove_trusted_cert = SecurityCommand(rawValue: "remove-trusted-cert")
        /// Display contents of trust settings.
        public static let dump_trust_settings = SecurityCommand(rawValue: "dump-trust-settings")
        /// Display or manipulate user-level trust settings.
        public static let user_trust_settings_enable = SecurityCommand(rawValue: "user-trust-settings-enable")
        /// Export trust settings.
        public static let trust_settings_export = SecurityCommand(rawValue: "trust-settings-export")
        /// Import trust settings.
        public static let trust_settings_import = SecurityCommand(rawValue: "trust-settings-import")
        /// Verify certificate(s).
        public static let verify_cert = SecurityCommand(rawValue: "verify-cert")
        /// Perform authorization operations.
        public static let authorize = SecurityCommand(rawValue: "authorize")
        /// Make changes to the authorization policy database.
        public static let authorizationdb = SecurityCommand(rawValue: "authorizationdb")
        /// Execute tool with privileges.
        public static let execute_with_privileges = SecurityCommand(rawValue: "execute-with-privileges")
        /// Run /usr/bin/leaks on this process.
        public static let leaks = SecurityCommand(rawValue: "leaks")
        /// Display a descriptive message for the given error code(s).
        public static let error = SecurityCommand(rawValue: "error")
        /// Create a keychain containing a key pair for FileVault recovery use.
        public static let create_filevaultmaster_keychain = SecurityCommand(rawValue: "create-filevaultmaster-keychain")
        /// Enable, disable or list disabled smartcard tokens.
        public static let smartcards = SecurityCommand(rawValue: "smartcards")
        /// Create a translocation point for the provided path
        public static let translocate_create = SecurityCommand(rawValue: "translocate-create")
        /// Check whether a path would be translocated.
        public static let translocate_policy_check = SecurityCommand(rawValue: "translocate-policy-check")
        /// Check whether a path is translocated.
        public static let translocate_status_check = SecurityCommand(rawValue: "translocate-status-check")
        /// Find the original path for a translocated path.
        public static let translocate_original_path = SecurityCommand(rawValue: "translocate-original-path")
        /// Evaluate a requirement against a cert chain.
        public static let requirement_evaluate = SecurityCommand(rawValue: "requirement-evaluate")
    }
    
    
    
    
    /// security基本命令
    public class func security() -> Script {
        Script(.security,
               type: .apple(isAsAdministrator: false))
    }
    
    /// security构建通用命令
    /// security [-hilqv] [-p prompt] [command] [command_options] [command_args]
    /// - Parameters:
    ///   - options: SecurityOption security选项
    ///   - command: SecurityCommand 命令
    ///   - commandOptions: SecurityOption子选项
    ///   - reserve: 保留字
    /// - Returns: Script
    public func security_command(options: [SecurityOption]? = nil,
                                 command: SecurityCommand? = nil,
                                 commandOptions: [SecurityOption]? = nil,
                                 reserve: [String]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let options = options { arguments?.append(contentsOf: options.map { $0.rawValue }) }
        if let command = command { arguments?.append(command.rawValue) }
        if let commandOptions = commandOptions { arguments?.append(contentsOf: commandOptions.map { $0.rawValue }) }
        if let reserve = reserve { arguments?.append(contentsOf: reserve) }
        
        return self
    }
    
    /// 输出重定向
    public func security_output(_ filePath: String) -> Self {
        if arguments == nil { arguments = [] }
        
        arguments?.append(">")
        arguments?.append(filePath)
        
        return self
    }
    
    /// 解析.mobileprovision文件
    /// - Parameters:
    ///   - mobileprovisionFile: 描述文件路径
    /// - Returns: Self
    public func security_parseMobileprovision(_ mobileprovisionFile: String) -> Self {
        security_command(options: nil,
                         command: .cms,
                         commandOptions: [
                            .cms_option(.decode),
                            .cms_option(.infile(mobileprovisionFile))
                         ],
                         reserve: nil)
    }
    
    public func security_findIdentity(findIdentityOptions: [SecurityOption.FindIdentityOption]? = nil,
                                      reserve: [String]? = nil) -> Self {
        security_command(options: nil,
                         command: .find_identity,
                         commandOptions: findIdentityOptions?.compactMap({ .find_identity_option($0) }),
                         reserve: reserve)
    }
    
    /// 查找钥匙串中有效的证书
    /// 1) A9466121C16D415C3C3B2245D4FA871C2D4F5FA3 "Apple Development: someone  (TAH423742D)"
    public func security_keychainValidCertificates() -> Self {
        security_findIdentity(findIdentityOptions: [.valid, .policy(.codesigning)],
                              reserve: nil)
    }
}

extension Script.SecurityOption {
    /// 命令cms子选项
    public static func cms_option(_ option: CmsOption) -> Self {
        Script.SecurityOption(rawValue: option.rawValue)
    }
    
    /// cms子选项
    public struct CmsOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        // NOTE: cms [-C|-D|-E|-S] [options...]
        // - 加解密CMS信息
        /// 创建CMS加密信息
        public static let create = CmsOption(rawValue: "-C")
        /// 解密CMS信息
        public static let decode = CmsOption(rawValue: "-D")
        /// 创建CMS包裹信息
        public static let enveloped = CmsOption(rawValue: "-E")
        /// 创建CMS标记信息
        public static let signed = CmsOption(rawValue: "-S")
        
        // - 解密选项
        /// 禁止输出内容
        public static let not_output = CmsOption(rawValue: "-n")
        /// 用此检测内容文件
        public static func content(_ value: String) -> Self {
            CmsOption(rawValue: "-c \(value)")
        }
        
        // - 加密选项
        /// create envelope for comma-delimited list of recipients, where id can be a certificate nickname or email address
        public static func recipients(_ ids: [String]) -> Self {
            CmsOption(rawValue: "-r \(ids.joined(separator: ","))")
        }
        /// include a signing time attribute
        public static let signingTime = CmsOption(rawValue: "-G")
        /// hash = MD2|MD4|MD5|SHA1|SHA256|SHA384|SHA512 (default: SHA1)
        public static func hash(_ value: String) -> Self {
            CmsOption(rawValue: "-H \(value)")
        }
        /// use certificate named "nick" for signing
        public static func nick(_ name: String) -> Self {
            CmsOption(rawValue: "-N \(name)")
        }
        /// include a SMIMECapabilities attribute
        public static let SMIMECapabilities = CmsOption(rawValue: "-P")
        /// do not include content in CMS message
        public static let noContent = CmsOption(rawValue: "-T")
        /// include an EncryptionKeyPreference attribute with certificate (use "NONE" to omit)
        public static func nick(EncryptionKeyPreference: String) -> Self {
            CmsOption(rawValue: "-Y \(EncryptionKeyPreference)")
        }
        /// find a certificate by subject key ID
        public static func find(_ id: String) -> Self {
            CmsOption(rawValue: "-Z \(id)")
        }
        
        // - 通用选项
        /// 详细信息打印
        public static let verbose = CmsOption(rawValue: "-v")
        /// 忽略单字节
        public static let single = CmsOption(rawValue: "-s")
        /// 指定包裹文件（只对-D、-E有效）
        public static func envelop(_ path: String) -> Self {
            CmsOption(rawValue: "-e \(path)")
        }
        /// 指定钥匙串使用
        public static func keychain(_ value: String) -> Self {
            CmsOption(rawValue: "-k \(value)")
        }
        /// 使用输入文件（默认为stdin）
        public static func infile(_ path: String) -> Self {
            // 对于AppleScript 不使用''包裹时对于存在空格的路径会解析路径失败
            CmsOption(rawValue: "-i '\(path)'")
        }
        /// 使用输出文件（默认为stdout）
        public static func outfile(_ path: String) -> Self {
            CmsOption(rawValue: "-o \(path)")
        }
        /// 使用密码作为数据库秘钥（默认为prompt）
        public static func password(_ value: String) -> Self {
            CmsOption(rawValue: "-p \(value)")
        }
        /// 设置证书使用类型（默认为certUsageEmailSigner）
        public static func certusage(_ value: String) -> Self {
            CmsOption(rawValue: "-u \(value)")
        }
        
    }
}

extension Script.SecurityOption {
    /// 命令find-identity子选项
    public static func find_identity_option(_ option: FindIdentityOption) -> Self {
        Script.SecurityOption(rawValue: option.rawValue)
    }
    
    /// find-identity子选项
    public struct FindIdentityOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// Show valid identities only (default is to show all identities)
        public static let valid = FindIdentityOption(rawValue: "-v")
        /// Specify policy to evaluate (multiple -p options are allowed). Supported policies: basic, ssl-client, ssl-server, smime, eap, ipsec, ichat, codesigning, sys-default, sys-kerberos-kdc
        public static func policy(_ value: Policy) -> Self {
            FindIdentityOption(rawValue: "-p \(value.rawValue)")
        }
        /// Specify optional policy-specific string (e.g. a DNS hostname for SSL, or RFC822 email address for S/MIME)
        public static func string(_ value: String) -> Self {
            FindIdentityOption(rawValue: "-s \(value)")
        }
        
        /// 策略
        public struct Policy: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let basic = Policy(rawValue: "basic")
            public static let ssl_client = Policy(rawValue: "ssl-client")
            public static let ssl_server = Policy(rawValue: "ssl-server")
            public static let smime = Policy(rawValue: "smime")
            public static let eap = Policy(rawValue: "eap")
            public static let ipsec = Policy(rawValue: "ipsec")
            public static let ichat = Policy(rawValue: "ichat")
            /// 签名证书 （如存在 CSSMERR_TP_CERT_REVOKED 标记表示已失效）
            /// 输出格式：x) uuid "signingCertificate: TeamName (TeamID)"
            /// eg:
            /// 1) 3B716FF604CFD63C9AECC1C3FCC05F1F59B76D "Apple Development: TeamName (TeamID)" (CSSMERR_TP_CERT_REVOKED)
            /// 1) 3B716FF604CFD63C9AECC1C3FCC05F1FBAE76D "Apple Distribution: TeamName (TeamID)"
            public static let codesigning = Policy(rawValue: "codesigning")
            public static let sys_default = Policy(rawValue: "sys-default")
            public static let sys_kerberos_kdc = Policy(rawValue: "sys-kerberos-kdc")
            
        }
    }
}
