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

/// Git版本管理
extension Script {
    /// git命令
    public struct GitCommand: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 克隆仓库到一个新的目录
        public static let clone = GitCommand(rawValue: "clone")
        /// 创建一个空的 Git 仓库或重新初始化一个已存在的仓库
        public static let initial = GitCommand(rawValue: "init")
        
        /// 添加文件内容至索引
        public static let add = GitCommand(rawValue: "add")
        /// 移动或重命名一个文件、目录或符号链接
        public static let mv = GitCommand(rawValue: "mv")
        /// 重置当前 HEAD 到指定状态
        public static let reset = GitCommand(rawValue: "reset")
        /// 从工作区和索引中删除文件
        public static let rm = GitCommand(rawValue: "rm")
        
        /// 通过二分查找定位引入 bug 的提交
        public static let bisect = GitCommand(rawValue: "bisect")
        /// 输出和模式匹配的行
        public static let grep = GitCommand(rawValue: "grep")
        /// 显示提交日志
        public static let log = GitCommand(rawValue: "log")
        /// 显示各种类型的对象
        public static let show = GitCommand(rawValue: "show")
        /// 显示工作区状态
        public static let status = GitCommand(rawValue: "status")
        
        /// 列出、创建或删除分支
        public static let branch = GitCommand(rawValue: "branch")
        /// 切换分支或恢复工作区文件
        public static func checkout(_ branch: String?) -> Self { GitCommand(rawValue: "checkout \(branch ?? "")") }
        /// 记录变更到仓库
        public static let commit = GitCommand(rawValue: "commit")
        /// 显示提交之间、提交和工作区之间等的差异
        public static let diff = GitCommand(rawValue: "diff")
        /// 合并两个或更多开发历史
        public static let merge = GitCommand(rawValue: "merge")
        /// 在另一个分支上重新应用提交
        public static let rebase = GitCommand(rawValue: "rebase")
        /// 创建、列出、删除或校验一个 GPG 签名的标签对象
        public static let tag = GitCommand(rawValue: "tag")
        
        /// 从另外一个仓库下载对象和引用
        public static let fetch = GitCommand(rawValue: "fetch")
        /// 获取并整合另外的仓库或一个本地分支
        public static let pull = GitCommand(rawValue: "pull")
        /// 更新远程引用和相关的对象
        public static let push = GitCommand(rawValue: "push")
        
        /// 将更改保存
        public static let stash = GitCommand(rawValue: "stash")
        /// 切换（与checkout功能一致）
        public static let `switch` = GitCommand(rawValue: "switch")
        /// 从工作目录中清除未跟踪的文件
        public static let clean = GitCommand(rawValue: "clean")
        
        
    }
    
    /// git选项
    public struct GitOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 指定git在目标文档路径下运行git命令。 当给出多个 -C 选项时，每个后续的非绝对 -C <path> 都相对于前面的 -C <path> 进行解释。
        /// 此选项会影响期望路径名的选项，例如 --git-dir 和 --work-tree，因为它们对路径名的解释将相对于由 -C 选项引起的工作目录进行。 例如，以下调用是等效的：
        /// git --git-dir=a.git --work-tree=b -C c status
        /// git --git-dir=c/a.git --work-tree=c/b status
        public static func gitDirectory(_ directory: String) -> Self { GitOption(rawValue: "-C \(directory)") }
        /// git版本
        public static let version = GitOption(rawValue: "--version")
        /// 将配置参数传递给命令。 给定的值将覆盖配置文件中的值。 <name> 应该与 git config 列出的格式相同（子键用点分隔）。 请注意，允许在 git -c foo.bar ... 中省略 = 并将 foo.bar 设置为布尔真值（就像 [foo]bar 在配置文件中所做的那样）。 包括等于但具有空值（如 git -c foo.bar= ...）将 foo.bar 设置为 git config --type=bool 将转换为 false 的空字符串。
        public static func configuration(_ name: String, _ value: String) -> Self { GitOption(rawValue: "-c \(name)=\(value)") }
        
        public static func exec_path(_ path: String?) -> Self { GitOption(rawValue: "--exec-path\(path == nil ? "" : ("=" + path!))") }
        public static func htmp_path(_ path: String) -> Self { GitOption(rawValue: "--html-path \(path)") }
        public static func man_path(_ path: String) -> Self { GitOption(rawValue: "--man-path \(path)") }
        public static func info_path(_ path: String) -> Self { GitOption(rawValue: "--info-path \(path)") }
        public static let paginate = GitOption(rawValue: "--paginate")
        public static let no_pager = GitOption(rawValue: "--no-pager")
        public static func git_dir(_ path: String) -> Self { GitOption(rawValue: "--git-dir=\(path)") }
        public static func work_tree(_ path: String) -> Self { GitOption(rawValue: "--work-tree=\(path)") }
        public static func namespace(_ path: String) -> Self { GitOption(rawValue: "--namespace=\(path)") }
        public static func super_prefix(_ path: String) -> Self { GitOption(rawValue: "--super-prefix=\(path)") }
        public static let bare = GitOption(rawValue: "--bare")
        public static let no_replace_objects = GitOption(rawValue: "--no-replace-objects")
        public static let literal_pathspecs = GitOption(rawValue: "--literal-pathspecs")
        public static let glob_pathspecs = GitOption(rawValue: "--glob-pathspecs")
        public static let noglob_pathspecs = GitOption(rawValue: "--noglob-pathspecs")
        public static let icase_pathspecs = GitOption(rawValue: "--icase-pathspecs")
        public static let no_optional_locks = GitOption(rawValue: "--no-optional-locks")
        public static func list_cmds(_ groups: [String]) -> Self { GitOption(rawValue:"--list-cmds=\(groups.joined(separator: ","))") }
        
    }
    
    /// gitj基础脚本命令对象
    /// - Returns: Script
    public class func git(_ type: ScriptType = .apple(isAsAdministrator: false)) -> Script {
        Script(command: .git, type: type)
    }
    
    /// git构建通用命令
    /// - Parameters:
    ///   - options: GitOptions
    ///   - commands: GitCommand
    ///   - commandOptions: GitOptions命令子选项
    ///   - reserve: 保留额外参数
    /// - Returns: Self
    public func git_command(options: [GitOption]? = nil,
                            commands: [GitCommand]? = nil,
                            commandOptions: [GitOption]? = nil,
                            reserve: [String]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        if let options = options { arguments?.append(contentsOf: options.map { $0.rawValue }) }
        if let commands = commands { arguments?.append(contentsOf: commands.map { $0.rawValue }) }
        if let commandOptions = commandOptions { arguments?.append(contentsOf: commandOptions.map{ $0.rawValue }) }
        if let reserve = reserve { arguments?.append(contentsOf: reserve) }
            
        return self
    }
    
    /// 格式化输出
    public func git_formatCurrentBranch() -> Self {
        if arguments == nil { arguments = [] }
        
        arguments?.append("|")
        arguments?.append("sed -n '/\\\\* /s///p'")
        
        return self
    }
}

extension Script.GitOption {
    /// branch命令子可选项
    public static func branch_option(_ option: BranchOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// 分支子可选项
    public struct BranchOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let delete = BranchOption(rawValue: "--delete")
        public static let force = BranchOption(rawValue: "--force")
        public static let delete_force = BranchOption(rawValue: "-D")
        public static let remotes = BranchOption(rawValue: "--remotes")
        public static let list = BranchOption(rawValue: "--list")
        public static let all = BranchOption(rawValue: "--all")
        public static let show_current = BranchOption(rawValue: "--show-current")
        ///  show hash and subject, give twice for upstream branch
        public static let verbose = BranchOption(rawValue: "--verbose")
        public static let quiet = BranchOption(rawValue: "--quiet")
        public static func set_upstream_to(_ upstream: String) -> Self { BranchOption(rawValue: "--set-upstream=\(upstream)") }
        public static let unset_upstream = BranchOption(rawValue: "--unset-upstream")
        public static func contains(_ commit_hash: String) -> Self { BranchOption(rawValue: "--contains \(commit_hash)") }
        public static func no_contains(_ commit_hash: String) -> Self { BranchOption(rawValue: "--no-contains \(commit_hash)") }
        public static func sort(_ key: String) -> Self { BranchOption(rawValue: "--sort=\(key)") }
        public static let ignore_case = BranchOption(rawValue: "--ignore-case")
        public static func format(_ string: String) -> Self { BranchOption(rawValue: "--format \(string)") }
    }
}

extension Script.GitOption {
    /// branch命令子可选项
    public static func tag_option(_ option: TagOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// 分支子可选项
    public struct TagOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let list = TagOption(rawValue: "--list")
    }
}

extension Script.GitOption {
    /// log命令子选项
    public static func log_option(_ option: LogOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// log子选项
    public struct LogOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 格式化
        public static func pretty(_ value: Pretty) -> Self { LogOption(rawValue: "--pretty=\(value.rawValue)") }
        /// 限制输出提交日志的个数
        public static func max_count(_ count: UInt) -> Self { LogOption(rawValue: "--max-count=\(count)") }
        /// 筛选作者
        public static func author(_ pattern: String) -> Self { LogOption(rawValue: "--author=\(pattern)") }
        /// 筛选提交者
        public static func committer(_ pattern: String) -> Self { LogOption(rawValue: "--committer=\(pattern)") }
        /// 跳过编号之前的提交
        public static func skip(_ number: String) -> Self { LogOption(rawValue: "--skip=\(number)") }
        /// 筛选分支
        public static func branches(_ pattern: String) -> Self { LogOption(rawValue: "--branches=\(pattern)") }
        /// 筛选标签
        public static func tags(_ pattern: String) -> Self { LogOption(rawValue: "--tags=\(pattern)") }
        /// 筛选远程
        public static func remotes(_ pattern: String) -> Self { LogOption(rawValue: "--remotes=\(pattern)") }
        /// 筛选提交信息
        public static func grep(_ pattern: String) -> Self { LogOption(rawValue: "--grep=\(pattern)") }
        /// 输出所有匹配项
        public static let all_match = LogOption(rawValue: "--all-match")
        /// 正则忽略大小写
        public static let regexp_ignore_case = LogOption(rawValue: "--regexp-ignore-case")
        /// 筛选自从某时间开始的日志
        public static func since(_ date: String) -> Self { LogOption(rawValue: "--since=\(date)") }
        /// 筛选某时间之前的日志
        public static func until(_ date: String) -> Self { LogOption(rawValue: "--until=\(date)") }
        
    }
}

extension Script.GitOption.LogOption {
    public struct Pretty: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// <sha1> <title line>
        public static let oneline = Pretty(rawValue: "oneline")
        /// commit <sha1>
        /// Author: <author>
        /// <title line>
        public static let short = Pretty(rawValue: "short")
        /// commit <sha1>
        /// Author: <author>
        /// Date:   <author date>
        ///
        /// <title line>
        /// <full commit message>
        public static let medium = Pretty(rawValue: "medium")
        /// commit <sha1>
        /// Author: <author>
        /// Commit: <committer>
        ///
        /// <title line>
        /// <full commit message>
        public static let full = Pretty(rawValue: "full")
        /// commit <sha1>
        /// Author:     <author>
        /// AuthorDate: <author date>
        /// Commit:     <committer>
        /// CommitDate: <committer date>
        ///
        /// <title line>
        /// <full commit message>
        public static let fuller = Pretty(rawValue: "fuller")
        /// From <sha1> <date>
        /// From: <author>
        /// Date: <author date>
        /// Subject: [PATCH] <title line>

        /// <full commit message>
        public static let email = Pretty(rawValue: "email")
        /// 源数据
        public static let raw = Pretty(rawValue: "raw")
        /// 参考使用Script.Format拼凑
        public static func format(_ string: String) -> Self { Pretty(rawValue: "format:\(string)") }
        /// 与format(_)功能一致，只是每条目之间使用终止符（换行）而不是分隔符
        public static func tformat(_ string: String) -> Self { Pretty(rawValue: "tformat:\(string)") }
        
        /// 参考使用Script.Format拼凑
        public static func format(_ fmts: [Format], separateBy separator: String = " ") -> Self {
            format(fmts.compactMap({ $0.rawValue }).joined(separator: separator))
        }
        
    }
}

extension Script.GitOption.LogOption.Pretty {
    /// 格式化值
    public struct Format: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        // - 扩展为单个文字字符的占位符
        /// 换行
        public static let newline = Format(rawValue: "%%n")
        /// %
        public static let raw_precent_sign = Format(rawValue: "%%%%")
        /// 从十六进制代码打印一个字节
        public static let hex = Format(rawValue: "%%x00")
        
        // - 扩展为从提交中提取的信息的占位符
        /// 提交哈希值
        public static let commit_hash = Format(rawValue: "%%H")
        /// 缩写提交哈希值
        public static let abbreviated_commit_hash = Format(rawValue: "%%h")
        /// 树哈希值
        public static let tree_hash = Format(rawValue: "%%T")
        /// 缩写树哈希值
        public static let abbreviated_tree_hash = Format(rawValue: "%%t")
        /// 父哈希值
        public static let parent_hashes = Format(rawValue: "%%P")
        /// 缩写父哈希值
        public static let abbreviated_parent_hashes = Format(rawValue: "%%p")
        /// 作者名称
        public static let author_name = Format(rawValue: "%%an")
        /// 作者名称（邮件映射）
        public static let author_name_mailmap = Format(rawValue: "%%aN")
        /// 作者邮箱
        public static let author_email = Format(rawValue: "%%ae")
        /// 作者邮箱（邮件映射）
        public static let author_email_mailmap = Format(rawValue: "%%aE")
        /// 用户日期（格式化期望--date=option）
        public static let author_date = Format(rawValue: "%%ad")
        /// 提交者名称
        public static let committer_name = Format(rawValue: "%%cn")
        /// 提交者名称（邮件映射）
        public static let committer_name_mailmap = Format(rawValue: "%%cN")
        /// 提交者邮箱
        public static let committer_email = Format(rawValue: "%%ce")
        /// 提交者邮箱（邮件映射）
        public static let committer_email_mailmap = Format(rawValue: "%%cE")
        /// 提交者日期
        public static let committer_date = Format(rawValue: "%%cd")
        /// 参考名称
        public static let reference_name = Format(rawValue: "%%d")
        /// 编码
        public static let encoding = Format(rawValue: "%%e")
        /// 提交标题
        public static let commit_title = Format(rawValue: "%%s")
        /// 提交内容
        public static let commit_body = Format(rawValue: "%%b")
        /// 提交笔记
        public static let commit_notes = Format(rawValue: "%%N")
    }
}

extension Script.GitOption {
    /// status命令子选项
    public static func status_option(_ option: StatusOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// status子选项
    public struct StatusOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let short = StatusOption(rawValue: "--short")
        public static let branch = StatusOption(rawValue: "--branch")
        public static let show_stash = StatusOption(rawValue: "--show-stash")
        public static let long = StatusOption(rawValue: "--long")
        public static let verbose = StatusOption(rawValue: "--verbose")
        public static func untracked_files(_ mode: UntrackedMode = .normal) -> Self { StatusOption(rawValue: "--untracked-files=\(mode.rawValue)") }
        public static func ignored_files(_ mode: IgnoredMode = .traditional) -> Self { StatusOption(rawValue: "--ignored=\(mode.rawValue)")}
    }
}

extension Script.GitOption.StatusOption {
    public struct UntrackedMode: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let no = UntrackedMode(rawValue: "no")
        public static let normal = UntrackedMode(rawValue: "normal")
        public static let all = UntrackedMode(rawValue: "all")
    }
    
    public struct IgnoredMode: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let traditional = IgnoredMode(rawValue: "traditional")
        public static let no = IgnoredMode(rawValue: "no")
        public static let matching = IgnoredMode(rawValue: "matching")
    }
}


extension Script.GitOption {
    /// checkout 命令子选项
    public static func checkout_option(_ option: CheckoutOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// checkout子选项
    public struct CheckoutOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 静默输出
        public static let quiet = CheckoutOption(rawValue: "--quiet")
        /// 强制操作
        public static let force = CheckoutOption(rawValue: "--force")
        /// 创建并切换至新分支，如果分支已存在则失败
        public static func new_branch(_ branch: String) -> Self { CheckoutOption(rawValue: "-b \(branch)") }
        /// 强制创建并切换至新分支，如果分支已存在则只切换至该分支
        public static func new_branch_force(_ branch: String) -> Self { CheckoutOption(rawValue: "-B \(branch)") }
        /// 关联远程分支与 git branch --set-upstream-to=<branch> 功能一致
        public static func track(_ remote_branch: String) -> Self { CheckoutOption(rawValue: "--track \(remote_branch)") }
        /// 切换至分支
        public static func branch(_ name: String) -> Self { CheckoutOption(rawValue: name) }
        /// 重置修改
        public static func reset(_ path: String) -> Self { CheckoutOption(rawValue: "-- \(path)") }
    }
}

extension Script.GitOption {
    /// reset命令子选项
    public static func reset_option(_ option: ResetOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// reset子选项
    public struct ResetOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        /// 这种形式将当前分支头重置为 <commit> 并可能更新索引（将其重置为 <commit> 的树）和取决于 <mode> 的工作树。 如果省略 <mode>，则默认为 --mixed。
        public static func reset_commit(_ mode: Mode, commit: Commit) -> Self { ResetOption(rawValue: "\(mode.rawValue) \(commit.rawValue)") }
        /// 只输出错误
        public static let quiet = ResetOption(rawValue: "--quiet")
        /// 此表单将所有 <paths> 的索引条目重置为它们在 <tree-ish> 处的状态。 （它不会影响工作树或当前分支。）
        /// 这意味着 git reset <paths> 与 git add <paths> 相反。 运行 git reset <paths> 更新索引条目后，您可以使用 git-checkout(1) 将索引中的内容检查到工作树中。 或者，使用 git-checkout(1) 并指定提交，您可以一次性将提交中路径的内容复制到索引和工作树。
        public static func reset_paths(_ paths: [String]) -> Self { ResetOption(rawValue: "-- \(paths.joined(separator: " "))") }
        /// 以交互方式选择索引和 <tree-ish> 之间的差异（默认为 HEAD）。 所选的块被反向应用到索引。
        /// 这意味着 git reset -p 与 git add -p 相反，即您可以使用它来有选择地重置大块头。 请参阅 git-add(1) 的“交互模式”部分以了解如何操作 --patch 模式。
        public static func reset_patch_paths(_ paths: [String]) -> Self { ResetOption(rawValue: "--patch \(paths.joined(separator: " "))") }
    }
}

extension Script.GitOption.ResetOption {
    public struct Mode: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 根本不接触索引文件或工作树（但将头部重置为 <commit>，就像所有模式一样）。
        /// 这会留下所有更改的文件“要提交的更改”，正如 git status 所说的那样。
        public static let soft = Mode(rawValue: "--soft")
        /// 重置索引但不重置工作树（即，保留更改的文件但未标记为提交）并报告尚未更新的内容。 这是默认操作。
        /// 如果指定了 -N，则删除的路径将标记为意图添加（请参阅 git-add(1)）。
        public static let mixed = Mode(rawValue: "--mixed")
        /// 重置索引和工作树。 自 <commit> 以来对工作树中跟踪文件的任何更改都将被丢弃。
        public static let hard = Mode(rawValue: "--hard")
        /// 重置索引并更新工作树中 <commit> 和 HEAD 之间不同的文件，但保留索引和工作树之间不同的文件（即具有尚未添加的更改）。
        /// 如果 <commit> 和索引之间不同的文件具有未暂存的更改，则重置将中止。
        /// 换句话说，--merge 执行类似于 git read-tree -u -m <commit> 的操作，但会转发未合并的索引条目。
        public static let merge = Mode(rawValue: "--merge")
        /// 重置索引条目并更新工作树中 <commit> 和 HEAD 之间不同的文件。
        /// 如果 <commit> 和 HEAD 之间的文件有本地更改，则重置将中止。
        public static let keep = Mode(rawValue: "--keep")
    }
    
    public struct Commit: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let HEAD = Commit(rawValue: "HEAD")
        public static let ORIG_HEAD = Commit(rawValue: "ORIG_HEAD")
        
        public static let before_1_HEAD = Commit(rawValue: "HEAD^")
        public static func before_n_HEAD(_ n: String) -> Self { Commit(rawValue: "HEAD~\(n)") }
        
        public static func commit_hash(_ hash: String) -> Self { Commit(rawValue: hash) }
    }
}

extension Script.GitOption {
    /// add命令子选项
    public static func add_option(_ option: AddOption) -> Self {
        Script.GitOption(rawValue: option.rawValue)
    }
    /// add子选项
    public struct AddOption: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        /// 文件路径
        public static func pathspec(_ path: Pathspec) -> Self { AddOption(rawValue: path.rawValue) }
        /// 允许添加除忽略文件之外的文件
        public static let forece = AddOption(rawValue: "--force")
    }
}

extension Script.GitOption.AddOption {
    public struct Pathspec: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let all = Pathspec(rawValue: ".")
        public static func files(_ paths: [String]) -> Self { Pathspec(rawValue: paths.joined(separator: " ")) }
    }
}
