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

/// Xcodebuild编译打包、导包等关于xcode的操作
extension Script {
    /// xcodebuild选项
    public struct XcodebuildOption: Hashable {
        public let rawValue: [String]
        public init(rawValue: String...) { self.rawValue = rawValue }
        
        /// 编译.xcodeproj文件路径（当所在文档目录下存在多项目工程则需要设置此值）
        public static func project(_ xcodeproj: String) -> Self { XcodebuildOption(rawValue: "-project", xcodeproj) }
        /// 编译特定的目标
        public static func target(_ targetName: String) -> Self { XcodebuildOption(rawValue: "-target", targetName) }
        /// 编译指定项目中所有目标
        public static let alltargets = XcodebuildOption(rawValue: "-alltargets")
        /// 编译.xcworkspace文件路径
        public static func workspace(_ xcworkspace: String) -> Self { XcodebuildOption(rawValue: "-workspace", xcworkspace) }
        /// 编译特定的scheme（当编译xcworkspace时则需要设置此值）
        public static func scheme(_ schemeName: String) -> Self { XcodebuildOption(rawValue: "-scheme", schemeName) }
        /// 编译特定的设备
        public static func destination(_ destinationspecifier: String) -> Self {  XcodebuildOption(rawValue: "-destination", "'\(destinationspecifier)'") }
        /// 编译特定的设备
        public static func destination(_ destinationspecifier: [DestinationSpecifier]) -> Self { XcodebuildOption(rawValue: "-destination", "'\(destinationspecifier.map{ $0.rawValue }.joined(separator: ","))'") }
        /// 指定特定设备时搜索目标设备超时时间（默认30s）
        public static func destinationTimeout(_ timeout: String) -> Self { XcodebuildOption(rawValue: "-destination-timeout \(timeout)") }
        /// 编译每个目标时指定的配置
        public static func configuration(_ config: Configuration) -> Self { XcodebuildOption(rawValue: "-configuration", config.rawValue) }
        /// 编译每个项目指定的系统架构
        public static func arch(_ architectures: [Architecture]) -> Self { XcodebuildOption(rawValue: "-arch", "'\(architectures.map{ $0.rawValue }.joined(separator: ","))'") }
        /// 编译指定特定的sdk
        /// - Parameters:
        ///  - sdkNameOrFullPath: sdk名称或完整路径
        public static func sdk(_ sdkNameOrFullPath: String) -> Self { XcodebuildOption(rawValue: "-sdk", sdkNameOrFullPath) }
        /// 展示所有Xcode知晓且可用的SDK的名字
        public static let showSDKs = XcodebuildOption(rawValue: "-showsdks")
        /// 显示工程的编译设置列表（不包含启动生成的设置）
        public static let showBuildSettings = XcodebuildOption(rawValue: "-showBuildSettings")
        /// 显示工程的有效的目标(destinations)
        public static let showdestinations = XcodebuildOption(rawValue: "-showdestinations")
        /// 显示反馈编译所有调用的命令的时间
        public static let showBuildTimingSummary = XcodebuildOption(rawValue: "-showBuildTimingSummary")
        /// 显示特定scheme的测试计划列表
        public static let showTestPlans = XcodebuildOption(rawValue: "-showTestPlans")
        /// 显示工程的目标(targets)与配置(configuration)
        public static let list = XcodebuildOption(rawValue: "-list")
        /// 打开或关闭地址清理程序。 这会覆盖工作区中方案的启动操作的设置。
        public static func enableAddressSanitizer(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-enableAddressSanitizer \(enable.onObjectiveCString)") }
        /// 打开或关闭线程消毒剂。 这会覆盖工作区中方案的启动操作的设置。
        public static func enableThreadSanitizer(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-enableThreadSanitizer \(enable.onObjectiveCString)") }
        /// 打开或关闭未定义的行为消毒剂。 这会覆盖工作区中方案的启动操作的设置。
        public static func enableUndefinedBehaviorSanitizer(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-enableUndefinedBehaviorSanitizer \(enable.onObjectiveCString)") }
        /// 在测试期间打开或关闭代码覆盖率。 这将覆盖工作区中方案的测试操作的设置。
        public static func enableCodeCoverage(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-enableCodeCoverage \(enable.onObjectiveCString)") }
        /// 在测试期间指定 ISO 639-1 语言。 这将覆盖工作区中方案的测试操作的设置。
        public static func testLanguage(_ language: String) -> Self { XcodebuildOption(rawValue: "-testLanguage \(language)") }
        /// 在测试期间指定 ISO 3166-1地区。 这将覆盖工作区中方案的测试操作的设置。
        public static func testRegion(_ region: String) -> Self { XcodebuildOption(rawValue: "-testRegion \(region)") }
        /// 在对工作区中的方案执行操作时，覆盖应用于派生数据的文件夹。
        public static func derivedDataPath(_ path: String) -> Self { XcodebuildOption(rawValue: "-derivedDataPath \(path)") }
        /// 将包写入指定路径，其中包含对工作区中的方案执行操作的结果。 如果路径已经存在，xcodebuild 将退出并显示错误。 将自动创建中间目录。 该包包含构建日志、代码覆盖率报告、带有测试结果的 XML 属性列表、屏幕截图和测试期间收集的其他附件，以及各种诊断日志。
        public static func resultBundlePath(_ path: String) -> Self { XcodebuildOption(rawValue: "-resultBundlePath \(path)") }
        /// 允许xcodebuild与苹果开发者网站沟通更新创建配置文件(provision)
        public static let allowProvisioningUpdates = XcodebuildOption(rawValue: "-allowProvisioningUpdates")
        /// 允许xcodebuild如有必要的情况下与苹果开发者网站沟通注册目标设备
        public static let allowProvisioningDeviceRegistration = XcodebuildOption(rawValue: "-allowProvisioningDeviceRegistration")
        /// 指定 App Store Connect 发布的身份验证密钥的路径。 如果指定，xcodebuild 将使用此凭据向 Apple Developer 网站进行身份验证。 需要 -authenticationKeyID 和 -authenticationKeyIssuerID。
        public static func authenticationKeyPath(_ path: String) -> Self { XcodebuildOption(rawValue: "-authenticationKeyPath \(path)") }
        /// 指定与 -authenticationKeyPath 处的 App Store Conect 身份验证密钥关联的密钥标识符。 此字符串可以位于 <https://appstoreconnect.apple.com> 上的用户和访问提供商的详细信息中
        public static func authenticationKeyID(_ id: String) -> Self { XcodebuildOption(rawValue: "-authenticationKeyID \(id)") }
        /// 指定与 -authenticationKeyPath 处的身份验证密钥关联的 App Store Connect 颁发者标识符。 此字符串可以位于 <https://appstoreconnect.apple.com> 上的用户和访问提供商的详细信息中
        public static func authenticationKeyIssuerID(_ issuerID: String) -> Self { XcodebuildOption(rawValue: "-authenticationKeyIssuerID \(issuerID)") }
        /// 指定应分发存档。 需要 -archivePath 和 -exportOptionsPlist。 对于导出，还需要 -exportPath。 不能与动作一起传递。
        public static let exportArchive = XcodebuildOption(rawValue: "-exportArchive")
        /// 导出已由 Apple 公证的档案。 需要 -archivePath 和 -exportPath
        public static let exportNotarizedApp = XcodebuildOption(rawValue: "-exportNotarizedApp")
        /// 指定存档操作生成的存档的路径，或指定在传递 -exportArchive 或 -exportNotarizedApp 时应导出的存档。
        public static func archivePath(_ xcarchivePath: String) -> Self { XcodebuildOption(rawValue: "-archivePath", xcarchivePath) }
        /// 指定导出产品的目的地，包括导出文件的名称。
        public static func exportPath(_ destinationPath: String) -> Self { XcodebuildOption(rawValue: "-exportPath", destinationPath) }
        /// 特定的-exportArchive的选项关于导出配置
        public static func exportOptionsPlist(_ path: String) -> Self { XcodebuildOption(rawValue: "-exportOptionsPlist", path) }
        /// 将本地化导出到 XLIFF 文件。 需要 -project 和 -localizationPath。 不能与Action一起传递。
        public static let exportLocalizations = XcodebuildOption(rawValue: "-exportLocalizations")
        /// 将本地化导入到 XLIFF 文件。 需要 -project 和 -localizationPath。 不能与Action一起传递。
        public static let importLocalizations = XcodebuildOption(rawValue: "-importLocalizations")
        /// 指定目录或单个 XLIFF 本地化文件的路径。
        public static func localizationPath(_ path: String) -> Self { XcodebuildOption(rawValue: "-localizationPath \(path)") }
        /// 指定包含在本地化导出中的可选 ISO 639-1 语言。 可以重复指定多种语言。 可以排除以指定导出仅包括开发语言字符串。
        public static func exportLanguage(_ language: String) -> Self { XcodebuildOption(rawValue: "-exportLanguage \(language)") }
        /// 操作
        public static func action(_ actions: [Action]) -> Self { XcodebuildOption(rawValue: actions.map{ $0.rawValue }.joined(separator: " ")) }
        /// 当文件所有target会使用此文件中的编译设置并覆盖其他相关设置
        public static func xcconfig(_ xcconfigFilePath: String) -> Self { XcodebuildOption(rawValue: "-xcconfig", xcconfigFilePath) }
        /// 指定测试运行参数。 只能与 test-without-building 动作一起使用。 不能与 -workspace 或 -project 一起使用。 有关文件格式的详细信息，请参阅 <x-man-page://5/xcodebuild.xctestrun>。
        public static func xctestrun(_ xctestrunPath: String) -> Self { XcodebuildOption(rawValue: "-xctestrun \(xctestrunPath)") }
        /// 指定应使用与方案关联的哪个测试计划进行测试。 传递不带扩展名的 .xctestplan 文件的名称。
        public static func testPlan(_ test_plan_name: String) -> Self { XcodebuildOption(rawValue: "-testPlan \(test_plan_name)")}
        /// 在测试操作中约束测试目标、类或方法。 -only-testing 将测试操作限制为仅测试指定的标识符，并排除所有其他标识符。 -skip-testing 限制测试操作跳过测试指定的标识符，但包括所有其他标识符。 测试标识符的格式为 TestTarget[/TestClass[/TestMethod]]。 标识符的 TestTarget 组件是单元或 UI 测试包的名称，如测试导航器中所示。 xcodebuild 命令可以组合多个约束选项，但 -only-testing 优先于 -skip-testing。
        public static func skip_testing(_ test_identifier: String) -> Self { XcodebuildOption(rawValue: "-skip-testing \(test_identifier)") }
        /// 在测试操作中约束测试目标、类或方法。 -only-testing 将测试操作限制为仅测试指定的标识符，并排除所有其他标识符。 -skip-testing 限制测试操作跳过测试指定的标识符，但包括所有其他标识符。 测试标识符的格式为 TestTarget[/TestClass[/TestMethod]]。 标识符的 TestTarget 组件是单元或 UI 测试包的名称，如测试导航器中所示。 xcodebuild 命令可以组合多个约束选项，但 -only-testing 优先于 -skip-testing。
        public static func only_testing(_ test_identifier: String) -> Self { XcodebuildOption(rawValue: "-only-testing \(test_identifier)") }
        /// 在测试操作中约束测试配置。 -only-test-configuration 将测试操作限制为仅测试测试计划中的指定测试配置，并排除所有其他测试配置。 -skip-test-configuration 限制测试操作跳过指定的测试配置，但包括所有其他测试配置。 每个测试配置名称必须与测试计划中指定的配置名称匹配，并且区分大小写。 xcodebuild 命令可以组合多个约束选项，但 -only-test-configuration 优先于 -skip-test-configuration。
        public static func skip_test_configuration(_ test_configuration_name: Configuration) -> Self { XcodebuildOption(rawValue: "-skip-test-configuration \(test_configuration_name.rawValue)") }
        /// 在测试操作中约束测试配置。 -only-test-configuration 将测试操作限制为仅测试测试计划中的指定测试配置，并排除所有其他测试配置。 -skip-test-configuration 限制测试操作跳过指定的测试配置，但包括所有其他测试配置。 每个测试配置名称必须与测试计划中指定的配置名称匹配，并且区分大小写。 xcodebuild 命令可以组合多个约束选项，但 -only-test-configuration 优先于 -skip-test-configuration。
        public static func only_test_configuration(_ test_configuration_name: Configuration) -> Self { XcodebuildOption(rawValue: "-only-test-configuration \(test_configuration_name)") }
        /// 不要同时在指定的目标上运行测试。 完整的测试套件将在给定目标上运行完成，然后再开始下一个目标。
        public static let disable_concurrent_destination_testing = XcodebuildOption(rawValue: "-disable-concurrent-destination-testing")
        /// 如果指定了多个设备目标（并且 -disable-concurrent-destination-testing 未通过），则一次仅测试多个设备。 例如，如果指定了四台 iOS 设备，但数量为 2，则完整的测试套件将在每台设备上运行，但在给定时间仅测试两台设备。
        public static func maximum_concurrent_test_device_destinations(_ number: String) -> Self { XcodebuildOption(rawValue: "-maximum-concurrent-test-device-destinations \(number)") }
        /// 如果指定了多个模拟器目标（并且 -disable-concurrent-destination-testing 未通过），则一次仅在多个模拟器上进行测试。 例如，如果指定了四个 iOS 模拟器，但数量为 2，则完整的测试套件将在每个模拟器上运行，但在给定时间只会测试两个模拟器。
        public static func maximum_concurrent_test_simulator_destinations(_ number: String) -> Self { XcodebuildOption(rawValue: "-maximum-concurrent-test-simulator-destinations \(number)") }
        
        /// 覆盖方案中的每个目标设置以并行运行测试。
        public static func parallel_testing_enabled(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-parallel-testing-enabled \(enable.onObjectiveCString)") }
        /// 并行执行测试时，生成准确数量的测试运行程序。 如果已指定，则覆盖 -maximum-parallel-testing-workers。
        public static func parallel_testing_worker_count(_ number: String) -> Self { XcodebuildOption(rawValue: "-parallel-testing-worker-count \(number)") }
        /// 限制同时进行测试的程序的数量
        public static func maximum_parallel_testing_workers(_ number: String) -> Self { XcodebuildOption(rawValue: "-maximum-parallel-testing-workers \(number)") }
        /// 如果启用了并行测试（通过 -parallel-testing-enabled 选项，或基于单个测试目标）并且通过了多个目标说明符，则在目标之间分配测试类，而不是在每个目标上运行整个测试套件 （这是传递多个目标说明符时的默认行为）。
        public static let parallelize_tests_among_destinations = XcodebuildOption(rawValue: "-parallelize-tests-among-destinations")
        /// 启用或禁用测试超时行为。 此值优先于测试计划中指定的值。
        public static func test_timeouts_enabled(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-test-timeouts-enabled \(enable.onObjectiveCString)") }
        /// 如果启用了测试超时，则将执行单个测试的默认执行时间。
        public static func default_test_execution_time_allowance(_ seconds: String) -> Self { XcodebuildOption(rawValue: "-default-test-execution-time-allowance \(seconds)") }
        /// 给予单个测试执行的最长执行时间，与测试的首选允许时间无关。
        public static func maximum_test_execution_time_allowance(_ seconds: String) -> Self { XcodebuildOption(rawValue: "-maximum-test-execution-time-allowance \(seconds)") }
        /// 如果指定，测试将运行多次。 可以与 -retry-tests-on-failure 或 -run-tests-until-failure 结合使用，在这种情况下，这将成为最大迭代次数。
        public static func test_iterations(_ number: String) -> Self { XcodebuildOption(rawValue: "-test-iterations \(number)") }
        /// 如果指定，测试将在失败时重试。 可以与 -test-iterations number 结合使用，在这种情况下，number 将是最大迭代次数。 否则，假设最多为 3。 不能与 -run-tests-until-failure 一起使用。
        public static let retry_tests_on_failure = XcodebuildOption(rawValue: "-retry-tests-on-failure")
        /// 如果指定，测试将一直运行直到失败。 可以与 -test-iterations number 结合使用，在这种情况下，number 将是最大迭代次数。 否则，假定最多为 100。 不能与 -retry-tests-on-failure 一起使用。
        public static let run_tests_until_failure = XcodebuildOption(rawValue: "-run-tests-until-failure")
        /// 每次重复的测试是否应该使用新的流程来执行。 必须与 -test-iterations、-retry-tests-on-failure 或 -run-tests-until-failure 结合使用。 如果未指定，测试将在同一过程中重复。
        public static func test_repetition_relaunch_enabled(_ enable: Bool) -> Self { XcodebuildOption(rawValue: "-test-repetition-relaunch-enabled \(enable.onObjectiveCString)") }
        /// 打印将要执行的命令，但不执行它们。
        public static let dry_run = XcodebuildOption(rawValue: "-dry-run")
        /// 跳过不能执行的操作而不是失败。 此选项仅在通过 -scheme 时才有效。
        public static let skipUnavailableActions = XcodebuildOption(rawValue: "-skipUnavailableActions")
        /// 将构建设置 buildsetting 设置为 value。 可以在以下位置找到 Xcode 构建设置的详细参考：<https://help.apple.com/xcode/mac/current/#/itcaec37c2a6>
        public static func buildsetting(_ value: BuildSetting) -> Self { XcodebuildOption(rawValue: "buildsetting=\(value.rawValue)") }
        /// 将用户默认 userdefault 设置为 value。
        public static func userdefault(_ value: String) -> Self { XcodebuildOption(rawValue: "-userdefault=\(value)") }
        /// 使用给定的工具链，用标识符或名称指定。
        public static func toolchain(_ identifierOrName: String) -> Self { XcodebuildOption(rawValue: "-toolchain \(identifierOrName)") }
        /// 除了警告和错误之外，不要打印任何输出。
        public static let quiet = XcodebuildOption(rawValue: "-quiet")
        /// 提供额外的状态输出。
        public static let verbose = XcodebuildOption(rawValue: "-verbose")
        /// 显示此 Xcode 安装的版本信息。 不启动构建。 与 -sdk 结合使用时，显示指定 SDK 的版本，如果 -sdk 不带参数，则显示所有 SDK。此外，如果指定了 infoitem，可能会返回单行报告的版本信息
        public static let version = XcodebuildOption(rawValue: "-version")
        /// 显示 Xcode 和 SDK 许可协议。 允许在不启动 Xcode 本身的情况下接受许可协议，这对无头系统很有用。 必须以特权用户身份运行。
        public static let license = XcodebuildOption(rawValue: "-license")
        /// 检查是否需要执行任何首次启动任务。
        public static let checkFirstLaunchStatus = XcodebuildOption(rawValue: "-checkFirstLaunchStatus")
        /// 安装软件包并同意许可。
        public static let runFirstLaunch = XcodebuildOption(rawValue: "-runFirstLaunch")
        /// 显示 xcodebuild 的使用信息。
        public static let usage = XcodebuildOption(rawValue: "-usage")
    }
    
    /// xcodebuild命令
    public struct XcodebuildCommand: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let archive = XcodebuildCommand(rawValue: "archive")
        public static let clean = XcodebuildCommand(rawValue: "clean")
        
    }
    
    /// xcodebuild基础命令
    /// - Returns: Script
    public class func xcodebuild() -> Script {
        Script(command: .xcodebuild,
               type: .process(isIgnoreOutput: true, environment: nil, input: nil))
    }
    
    /// xcodebuild命令
    /// - Parameters:
    ///   - command: 命令
    ///   - options: 选项属性集合
    /// - Returns: Self
    public func xcodebuild_command(command: XcodebuildCommand? = nil, options: [XcodebuildOption]? = nil) -> Self {
        if arguments == nil { arguments = [] }
        
        if let command = command { arguments?.append(command.rawValue) }
        if let options = options { arguments?.append(contentsOf: options.flatMap { $0.rawValue }) }
        
        return self
    }
    
}

extension Script.XcodebuildOption {
    /// 操作
    /// 可指定一个或多个动作执行
    public struct Action: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 编译target(默认操作）
        public static let build = Action(rawValue: "build")
        /// 编译指定target下scheme关联的测试
        public static let build_for_testing = Action(rawValue: "build-for-testing")
        /// 分析
        public static let analyze = Action(rawValue: "analyze")
        /// 打包scheme
        public static let archive = Action(rawValue: "archive")
        /// 测试scheme
        public static let test = Action(rawValue: "test")
        /// 测试编译的包
        /// 如果使用 -scheme 提供方案，则该命令会在构建根 (SRCROOT) 中查找包。 如果 xctestrun 文件与 -xctestrun 一起提供，则该命令会在 xctestrun 文件中指定的路径中查找包。
        public static let test_without_building = Action(rawValue: "test-without-building")
        /// 拷贝工程资源
        public static let installsrc = Action(rawValue: "installsrc")
        /// 构建目标并将其安装到分发根目录中目标的安装目录中
        public static let install = Action(rawValue: "install")
        /// 从构建根目录中删除构建产品和中间文件
        public static let clean = Action(rawValue: "clean")
    }
    
    /// 特定设备信息
    public struct DestinationSpecifier: Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        /// 系统平台
        public static func platform(_ value: String) -> Self {
            DestinationSpecifier(rawValue: "platform=\(value)")
        }
        /// 设备名称
        public static func name(_ value: String) -> Self {
            DestinationSpecifier(rawValue: "name=\(value)")
        }
        /// 设备uuid
        public static func id(_ value: String) -> Self {
            DestinationSpecifier(rawValue: "id=\(value)")
        }
        /// 系统版本号（模拟器才需要）
        public static func OS(_ value: String) -> Self {
            DestinationSpecifier(rawValue: "OS=\(value)")
        }
    }
    /// 导出可选值，用于构建exportOptions.plist
    /// 参考: xcodebuild -help
    public struct ExportOptions: Hashable {
        public let rawValue: Script.KeyValueType
        public init(rawValue: Script.KeyValueType) { self.rawValue = rawValue }
        
        public struct Method: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static func channel(_ value: Script.Channel) -> Self { Method(rawValue: value.rawValue) }
            
            public static let validation = Method(rawValue: "validation")
            public static let package = Method(rawValue: "package")
            public static let developer_id = Method(rawValue: "developer-id")
            public static let mac_application = Method(rawValue: "mac-application")
        }
        
        public struct Destination: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let export = Destination(rawValue: "export")
            public static let upload = Destination(rawValue: "upload")
        }
        
        public struct SigningStyle: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let manual = SigningStyle(rawValue: "manual")
            public static let automatic = SigningStyle(rawValue: "automatic")
        }
        
        /// 对应在buildSettings中CODE_SIGN_IDENTITY的值
        public struct SigningCertificate: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let Mac_App_Distribution = SigningCertificate(rawValue: "Mac App Distribution")
            public static let iOS_Developer = SigningCertificate(rawValue: "iOS Developer")
            public static let iOS_Distribution = SigningCertificate(rawValue: "iOS Distribution")
            public static let Developer_ID_Application = SigningCertificate(rawValue: "Developer ID Application")
            public static let Apple_Distribution = SigningCertificate(rawValue: "Apple Distribution")
            public static let Mac_Developer = SigningCertificate(rawValue: "Mac Developer")
            public static let Apple_Development = SigningCertificate(rawValue: "Apple Development")
            
            /// 理论上被淘汰了
            /// 从.pbxproj中CODE_SIGN_IDENTITY是此值，在xcode中看是 iOS Developer
            public static let iPhone_Developer = SigningCertificate(rawValue: "iPhone Developer")
            /// 理论上被淘汰了
            /// /// 从.pbxproj中CODE_SIGN_IDENTITY是此值，在xcode中看是 iOS Distribution
            public static let iPhone_Distribution = SigningCertificate(rawValue: "iPhone Distribution")
        }
        
        public struct Manifest: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let appURL = Manifest(rawValue: "appURL")
            public static let displayImageURL = Manifest(rawValue: "displayImageURL")
            public static let fullSizeImageURL = Manifest(rawValue: "fullSizeImageURL")
            public static let assetPackManifestURL = Manifest(rawValue: "assetPackManifestURL")
        }
        
        public struct Thinning: Hashable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let none = Thinning(rawValue: "<none>")
            public static let thin_for_all_variants = Thinning(rawValue: "<thin-for-all-variants>")
            public static func model(_ name: String) -> Self { Thinning(rawValue: name) }
        }
        
        public typealias BundleID = String
        public typealias ProvisionIdOrFileName = String
        
        /// xcode是否需要通过bitcode重新编译，需要与app中的Enable Bitcode一致，默认为为true
        public static func compileBitcode(_ enable: Bool = true) -> Self { ExportOptions(rawValue: ["compileBitcode": enable]) }
        /// 当前app是本地导出还是上传到Apple的服务器。可以填写的值为export、upload，默认值为export。
        public static func destination(_ value: Destination = .export) -> Self { ExportOptions(rawValue: ["destination": value.rawValue]) }
        /// 格式化包内可用目标的bundle identifier
        public static func distributionBundleIdentifier(_ bundleIdentifier: String) -> Self { ExportOptions(rawValue: ["distributionBundleIdentifier": bundleIdentifier]) }
        /// 对于非 App Store 导出，如果app使用了On Demand Resources功能，并设置为 YES，则app将会加载所有的资源以便在无服务器支持下测试该app。
        /// 如果没有配置onDemandResourcesAssetPacksBaseURL选项，则默认值为YES
        public static func embedOnDemandResourcesAssetPacksInBundle(_ on: Bool = true) -> Self { ExportOptions(rawValue: ["embedOnDemandResourcesAssetPacksInBundle": on]) }
        /// 对于app store的导出，在iTMSTransporter上传时判断是否生成App Store的相关信息。默认值为NO。
        public static func generateAppStoreInformation(_ generate: Bool = false) -> Self { ExportOptions(rawValue: ["generateAppStoreInformation": generate]) }
        /// 如果应用程序使用 CloudKit，这将配置“com.apple.developer.icloud-container-environment”权利。 可用选项因所使用的配置文件类型而异，但可能包括：Development 与 Production。
        public static func iCloudContainerEnvironment(_ environment: String) -> Self { ExportOptions(rawValue: ["iCloudContainerEnvironment": environment])}
        /// 仅用于手动签名。 提供用于签名的证书名称、SHA-1 哈希或自动选择器。
        /// 自动选择器允许 Xcode 选择最新安装的特定类型的证书。 可用的自动选择器是“Developer ID Installer”和“Mac Installer Distribution”。 默认为匹配当前分发方法的自动证书选择器。
        public static func installerSigningCertificate(_ value: String) -> Self { ExportOptions(rawValue: ["installerSigningCertificate": value]) }
        /// 上传到 App Store Connect 时，Xcode 是否应该管理应用程序的内部版本号？ 默认为YES。
        public static func manageAppVersionAndBuildNumber(_ shouldManage: Bool = true) -> Self { ExportOptions(rawValue: ["manageAppVersionAndBuildNumber": shouldManage]) }
        /// 对于非 App Store 导出，参数用于web上安装测试应用包使用。 为了生成分发清单，该键的值应该是包含三个子键的字典：appURL、displayImageURL、fullSizeImageURL。
        /// 如使用了on-demand resources，还需要额外的子键 assetPackManifestURL。
        public static func manifest(_ urls: [Manifest: String]) -> Self { ExportOptions(rawValue: ["manifest": urls.map { [$0.key.rawValue: $0.value]}]) }
        /// 描述 Xcode 应该如何导出存档。因存档类型而异，默认为development
        public static func method(_ value: Method = .channel(.development)) -> Self { ExportOptions(rawValue: ["method": value.rawValue]) }
        /// 该参数在非app store的导出类型下有效。
        /// 如果app使用了On Demand Resources，并且embedOnDemandResourcesAssetPacksInBundle配置不是YES，则需要配置该字段。
        /// 该配置确定app如何下载On Demand Resources资源。
        public static func onDemandResourcesAssetPacksBaseURL(_ url: String) -> Self { ExportOptions(rawValue: ["onDemandResourcesAssetPacksBaseURL": url]) }
        /// 仅用于手动签名。 指定要用于应用程序中每个可执行文件的配置文件。 该字典中的键是可执行文件的包标识符； 值是要使用的配置文件名称或 UUID。
        public static func provisioningProfiles(_ bundleIdMatchProvisionIdOrName: [BundleID: ProvisionIdOrFileName]) -> Self { ExportOptions(rawValue: ["provisioningProfiles": bundleIdMatchProvisionIdOrName]) }
        /// 仅用于手动签名。 签名可以配置为证书名称、SHA-1 Hash或者自动选择。其中自动选择允许Xcode自动选择最新可以使用的证书
        /// 证书签名类型。证书一般表示为 Apple Development: TeamName (Team ID) 其中Apple Development表示的就是证书签名类型用于此处
        public static func signingCertificate(_ certificate: SigningCertificate) -> Self { ExportOptions(rawValue: ["signingCertificate": certificate.rawValue]) }
        /// 重新签名app以进行分发时的签名方式，可选项为manual, automatic
        /// 归档时自动签名的应用程序可以在分发过程中手动或自动签名，默认为自动。
        /// 归档时手动签名的应用程序必须在分发期间手动签名，因此signingStyle 的值将被忽略。
        public static func signingStyle(_ style: SigningStyle = .manual) -> Self { ExportOptions(rawValue: ["signingStyle": style.rawValue]) }
        /// 是否需要从ipa文件中裁剪swift库。默认值为YES。
        public static func stripSwiftSymbols(_ enable: Bool = true) -> Self { ExportOptions(rawValue: ["stripSwiftSymbols": enable]) }
        /// 开发团队标识
        public static func teamID(_ id: String) -> Self { ExportOptions(rawValue: ["teamID": id]) }
        
        /// 对于非 App Store 导出，Xcode是否打出指定一个或多个设备的精简包。
        /// 可用选项：<none>（Xcode 生成非精简的通用应用程序）、<thin-for-all-variants>（Xcode 生成通用应用程序和所有可用的精简版本）或特定设备的模型标识符（例如“ iPhone7,1")。 默认为 <none>。
        public static func thinning(_ value: Thinning = .none) -> Self { ExportOptions(rawValue: ["thinning": value]) }
        /// 对于AppStore导出的包是否应该包含bitcode。默认为YES
        public static func uploadBitcode(_ enable: Bool = true) -> Self { ExportOptions(rawValue: ["uploadBitcode": enable]) }
        /// 对于AppStore导出的包是否应该包含符号表。默认为YES
        public static func uploadSymbols(_ enable: Bool = false) -> Self { ExportOptions(rawValue: ["uploadSymbols": enable]) }
    }
    
}

extension Array where Element == Script.XcodebuildOption.ExportOptions {
    /// [Script.XcodebuildOption.ExportOptions] => [String: AnyHashable]
    public var keyValues: Script.KeyValueType {
        map { $0.rawValue }.reduce([:], { $0.merging($1, uniquingKeysWith: { (current, _) in current }) })
    }
}

extension Set where Element == Script.XcodebuildOption.ExportOptions {
    /// Set<Script.XcodebuildOption.ExportOptions> => [String: AnyHashable]
    public var keyValues: Script.KeyValueType {
        map { $0.rawValue }.reduce([:], { $0.merging($1, uniquingKeysWith: { (current, _) in current }) })
    }
}
