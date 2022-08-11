# ScriptSDK
macOS swift Process/NSAppleScript class encapsulation

macOS swift封装NSAppleScript、Process脚本 

- NSAppleScript适合即时反馈的脚本
- Process比较适合延时脚本，比如`xcodebuild archive`。**一旦一个脚本内的`echo`打印多了，异步情况下可能无法输出所有打印内容**

### 使用方法

```swift
// 执行脚本
let ret = Script.git()
								.git_command(options: [.version])
                .execute()
guard let value = ret.success as? String else { 
  	print("executed failed: \(ret.failure)")
		return 
}
print("executed succeed: \(value)")


// 中断脚本（只能中断Process脚本）
Executor.shared.interrupt()

// 监听Process的打印
Executor.shared
				.streamResultSubject?
				.sink { ret in
            // success is from stanardOutput
            // failure is from stanardError
            print("[Stream] \(ret)")
        }
        .store(in: &cancellable)
```



### 扩展新的脚本

```swift
// 新增新的脚本路径
extension ScriptPathCacher {
		static let mdfind = Command(rawValue: "mdfind")
}

let cacher = ScriptPathCacher.shared
// 缓存mdfind的查找脚本及其路径
cacher[.mdfind] = cacher.which(.mdfind)

// 新增新的脚本
extension Script {
  	class func mdfind() -> Script {
				Script(command: .mdfind, type: .apple(isAsAdministrator: false))
	  }
  
  	func mdfind_command(_ query: String) -> Self {
      	if arguments == nil { arguments = [] }
      	
      	arugments.append("'\(query)'")
      
    		return self
	  }
}

// 执行
let ret = Script.mdfind()
								.mdfind_command("com_apple_xcode_dsym_uuids == ABDEADFAFASD234ALKSJDFZ")
								.execute()
guard let value = ret.success as? String else { 
  	print("executed failed: \(ret.failure)")
		return 
}
print("executed succeed: \(value.components(separatedBy: "/r"))")
```

