# Roblox_OrchardUI

> 🍎 一个偏向 Apple / macOS 设计语言的 Roblox Luau UI 库。  
> 提供侧边栏分类、折叠页面、透明与磨砂视觉、深浅色主题、灵动岛、搜索、通知、配置保存、窗口拖拽缩放以及常用控件。

OrchardUI 的目标不是做一套“花哨特效 UI”，而是尽量保持 **简洁、统一、轻量、可配置**。  
目前的磨砂效果采用轻量视觉层实现，不使用持续的 `EditableImage` 像素折射，因此空闲时几乎没有额外持续渲染开销。

---

## 特性

- macOS / Apple 风格布局
- 左侧分类栏 + 多级折叠页面
- 页面历史 `< >` 前进 / 后退
- 浅色 / 深色主题
- 每个控件可独立设置透明度与 Frost 强度
- 内置 `GUI设置` 页面
- 支持配置文件自动读取 / 保存
- 搜索分类名和功能名
- 自带玩家账户页面
- 灵动岛：图标 + 自定义文字 + FPS
- 右下角独立宽高拖拽调整
- 绿色交通灯按钮全屏 / 退出全屏
- 红色按钮关闭状态 API
- 黄色按钮最小化
- 桌面鼠标与移动端触摸支持
- Switch、Slider、Dropdown、TextField、通知、弹窗等常用控件
- Slider 支持步进、步进圆点、左右图标
- Dropdown 默认保持不透明，可在设置中开启透明
- 不使用持续像素级液态玻璃计算

---

## 快速开始

当前示例使用：

```lua
local OrchardUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/snwmdd114514-lang/Roblox_OrchardUI/refs/heads/main/main.lua"
))()

local window = OrchardUI:init(
    "OrchardUI Demo",
    true,
    Enum.KeyCode.RightShift,
    true
)
```


创建一个页面：

```lua
local home = window:Section("主页", {
    Subtitle = "OrchardUI 示例",
    Expanded = true
})

home:Label("欢迎使用 OrchardUI")

home:Button("测试按钮", function()
    window:TempNotify(
        "OrchardUI",
        "按钮回调正常"
    )
end)
```

---

## 一个完整的小例子

```lua
local OrchardUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/snwmdd114514-lang/Roblox_OrchardUI/refs/heads/main/main.lua"
))()

local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true,
    {
        Theme = "Light",
        SidebarTranslucent = true,
        SidebarTransparency = 0.22,

        DropdownTransparent = false,

        IslandText = "点击打开",
        IslandTextSize = 11,
        IslandFPSTextSize = 11,

        WindowWidth = 820,
        WindowHeight = 650
    }
)

window:Divider("主要")

local settings = window:Section("设置", {
    Subtitle = "主设置页面",
    Expanded = true
})

local controls = settings:Create("控制", {
    ShowInSidebar = true,
    Expanded = false,
    Subtitle = "输入设备"
})

local mouse = controls:Create("鼠标", {
    ShowInSidebar = true,
    Expanded = true
})

settings:Switch(
    "启用功能",
    true,
    function(value)
        print(value)
    end
)

mouse:Slider(
    "灵敏度",
    0,
    100,
    50,
    function(value)
        print(value)
    end,
    {
        Step = 5,
        ShowSteps = true,
        ShowValue = true,
        Suffix = "%"
    }
)

mouse:Dropdown(
    "模式",
    {"自动", "模式 A", "模式 B"},
    "自动",
    function(value)
        print(value)
    end
)

settings:GoTo("进入鼠标设置", mouse)
```

---

# API 文档

下面使用 GitHub Markdown 的 `<details>` 折叠块。点击标题即可展开。

<details>
<summary><b>1. OrchardUI:init() — 创建主窗口</b></summary>

### 语法

```lua
local window = OrchardUI:init(
    title,
    splash,
    visibleKey,
    deletePrevious,
    config
)
```

### 参数

| 参数 | 类型 | 说明 |
|---|---|---|
| `title` | `string` | 窗口标题 |
| `splash` | `boolean` | 是否显示启动动画 |
| `visibleKey` | `Enum.KeyCode` | 显示 / 隐藏 UI 的快捷键 |
| `deletePrevious` | `boolean` | 是否删除旧 OrchardUI |
| `config` | `table/string/nil` | GUI 配置表，或者直接传配置文件路径 |

### 示例

```lua
local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true,
    {
        Theme = "Dark",
        SidebarTranslucent = true,
        SidebarTransparency = 0.30,
        DropdownTransparent = false
    }
)
```

如果第 5 个参数直接传字符串：

```lua
local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true,
    "MyScript/gui.json"
)
```

会把该字符串作为配置文件路径。

</details>

<details>
<summary><b>2. Section() — 创建顶级分类页面</b></summary>

### 推荐写法

```lua
local page = window:Section("设置", {
    Icon = "rbxassetid://...",
    Subtitle = "设置脚本功能",
    ShowInSidebar = true,
    Expanded = true,

    Style = {
        Transparency = 0.05,
        Frost = 0.20
    }
})
```

### 兼容旧写法

```lua
local page = window:Section(
    "设置",
    "rbxassetid://...",
    "设置脚本功能"
)
```

### Options

| 字段 | 默认 | 说明 |
|---|---:|---|
| `Icon` | 自动 | 页面图标 |
| `Subtitle` | `nil` | 页面副标题 |
| `ShowInSidebar` | `true` | 是否显示在左侧栏 |
| `Expanded` | `true` | 有子页面时默认是否展开 |
| `Style` | `nil` | 页面头部透明 / Frost 样式 |

</details>

<details>
<summary><b>3. Create() / CreatePage() — 创建子页面</b></summary>

`Create()` 用于创建树状子分类。

```lua
local controls = settings:Create("控制", {
    ShowInSidebar = true,
    Expanded = false,
    Subtitle = "鼠标与键盘"
})
```

继续创建更深层：

```lua
local mouse = controls:Create("鼠标", {
    ShowInSidebar = true,
    Expanded = true
})

local pointer = mouse:Create("指针", {
    ShowInSidebar = true,
    Expanded = false
})
```

结构类似：

```text
设置
└─ 控制
   └─ 鼠标
      └─ 指针
```

### 隐藏页面

```lua
local advanced = controls:Create("高级设置", {
    ShowInSidebar = false
})
```

该页面真实存在，但不会出现在侧边栏。

### 别名

```lua
section:CreatePage(...)
```

等价于：

```lua
section:Create(...)
```

</details>

<details>
<summary><b>4. Select() / GoTo() — 页面跳转</b></summary>

直接打开页面：

```lua
mouse:Select()
```

创建一个外观和普通 Button 一样的跳转按钮：

```lua
settings:GoTo(
    "打开鼠标设置",
    mouse
)
```

支持跳转到隐藏页面：

```lua
settings:GoTo(
    "高级设置",
    advanced
)
```

`GoTo()` 也支持 Style：

```lua
settings:GoTo(
    "进入控制",
    controls,
    nil,
    {
        Transparency = 0.25,
        Frost = 0.60
    }
)
```

顶部 `< >` 会保存实际访问历史，可以返回上一个页面或重新前进。

</details>

<details>
<summary><b>5. SetExpanded() / IsExpanded() — 折叠页面</b></summary>

展开：

```lua
controls:SetExpanded(true)
```

折叠：

```lua
controls:SetExpanded(false)
```

读取：

```lua
local expanded =
    controls:IsExpanded()
```

创建时设置默认状态：

```lua
local controls = settings:Create("控制", {
    Expanded = false
})
```

</details>

<details>
<summary><b>6. Button() — 按钮</b></summary>

```lua
local button = page:Button(
    "执行",
    function()
        print("clicked")
    end
)
```

带图标：

```lua
page:Button(
    "执行",
    function()
    end,
    "rbxassetid://..."
)
```

独立透明 / Frost：

```lua
local button = page:Button(
    "半透明按钮",
    function()
    end,
    nil,
    {
        Transparency = 0.35,
        Frost = 0.75
    }
)
```

创建后仍可实时修改：

```lua
button:SetAttribute(
    "Transparency",
    0.50
)

button:SetAttribute(
    "Frost",
    0.90
)
```

</details>

<details>
<summary><b>7. Label() — 文本行</b></summary>

```lua
page:Label(
    "这是一段说明文字"
)
```

样式：

```lua
page:Label(
    "透明说明",
    {
        Transparency = 0.20,
        Frost = 0.45
    }
)
```

</details>

<details>
<summary><b>8. Divider() — 分组标题 / 分隔</b></summary>

页面内部：

```lua
page:Divider("输入设备")
```

顶级侧栏：

```lua
window:Divider("系统")
```

Divider 的文字也会加入搜索索引。

</details>

<details>
<summary><b>9. Switch() — Apple 风格开关</b></summary>

```lua
page:Switch(
    "自然滚动",
    true,
    function(value)
        print(value)
    end
)
```

### 独立设置圆球

```lua
page:Switch(
    "自然滚动",
    true,
    function(value)
    end,
    {
        Transparency = 0.12,
        Frost = 0.30,

        Knob = {
            Transparency = 0.74,
            Frost = 0.92
        }
    }
)
```

鼠标移到圆球后会进行轻微果冻式放大，最终保持约 `1.25x`。

</details>

<details>
<summary><b>10. Slider() — 滑动条</b></summary>

### 基础用法

```lua
local slider = page:Slider(
    "音量",
    0,
    100,
    50,
    function(value)
        print(value)
    end
)
```

### 步进

```lua
page:Slider(
    "速度",
    0,
    100,
    50,
    function(value)
    end,
    {
        Step = 10,
        ShowSteps = true
    }
)
```

`Step` 为：

```lua
nil
0
""
```

时自动视为 **连续滑动，不使用步进**。

### 隐藏步进点，但继续吸附

```lua
{
    Step = 10,
    ShowSteps = false
}
```

### 显示值

```lua
{
    ShowValue = true,
    Suffix = "%"
}
```

### 左右图标

```lua
{
    LeftIcon = "rbxassetid://...",
    RightIcon = "rbxassetid://...",

    LeftIconSize = 16,
    RightIconSize = 20
}
```

### 更多 Slider Options

```lua
{
    Step = 5,
    ShowSteps = true,
    ShowValue = true,

    Suffix = "%",
    Decimals = 0,

    LeftIcon = "rbxassetid://...",
    RightIcon = "rbxassetid://...",

    LeftIconSize = 16,
    RightIconSize = 20,

    LeftIconColor = Color3.fromRGB(...),
    RightIconColor = Color3.fromRGB(...),
    IconColor = Color3.fromRGB(...),

    TrackColor = Color3.fromRGB(...),
    FillColor = Color3.fromRGB(...),

    StepColor = Color3.fromRGB(...),
    StepDotSize = 3,

    MaxStepDots = 32,

    ValueFormatter = function(value)
        return tostring(value) .. "%"
    end,

    Knob = {
        Transparency = 0.75,
        Frost = 0.90
    }
}
```

### 运行时控制

改变值：

```lua
slider:SetAttribute(
    "Value",
    75
)
```

改变步进：

```lua
slider:SetAttribute(
    "Step",
    5
)
```

关闭步进：

```lua
slider:SetAttribute(
    "Step",
    0
)
```

显示 / 隐藏步进圆点：

```lua
slider:SetAttribute(
    "ShowSteps",
    false
)
```

</details>

<details>
<summary><b>11. Dropdown() — 下拉菜单</b></summary>

```lua
page:Dropdown(
    "主题",
    {
        "自动",
        "浅色",
        "深色"
    },
    "自动",
    function(value)
        print(value)
    end
)
```

默认情况下 Dropdown **不透明**。

要允许下拉菜单使用透明 / Frost：

```lua
window:SetConfig(
    "DropdownTransparent",
    true
)
```

单个 Dropdown 可以分别设置行、按钮和 Popup：

```lua
page:Dropdown(
    "主题",
    {"自动", "浅色", "深色"},
    "自动",
    function(value)
    end,
    {
        Transparency = 0.10,
        Frost = 0.25,

        Trigger = {
            Transparency = 0.20,
            Frost = 0.50
        },

        Popup = {
            Transparency = 0.40,
            Frost = 0.90
        }
    }
)
```

</details>

<details>
<summary><b>12. TextField() — 文本输入</b></summary>

```lua
page:TextField(
    "名称",
    "请输入...",
    function(value)
        print(value)
    end
)
```

独立设置输入框：

```lua
page:TextField(
    "名称",
    "请输入...",
    function(value)
    end,
    {
        Transparency = 0.15,
        Frost = 0.35,

        Input = {
            Transparency = 0.30,
            Frost = 0.65
        }
    }
)
```

</details>

<details>
<summary><b>13. TempNotify() — 临时通知</b></summary>

```lua
window:TempNotify(
    "标题",
    "通知内容"
)
```

完整参数：

```lua
window:TempNotify(
    title,
    body,
    icon,
    style
)
```

例：

```lua
window:TempNotify(
    "设置完成",
    "配置已保存",
    nil,
    {
        Transparency = 0.35,
        Frost = 0.85
    }
)
```

</details>

<details>
<summary><b>14. Notify() / Notify2() — 模态弹窗</b></summary>

### 单按钮

```lua
window:Notify(
    "确认",
    "操作已完成",
    "确定",
    nil,
    function()
        print("OK")
    end
)
```

### 双按钮

```lua
window:Notify2(
    "确认删除",
    "确定继续吗？",
    "继续",
    "取消",
    nil,

    function()
        print("继续")
    end,

    function()
        print("取消")
    end
)
```

可在最后传入 Style：

```lua
{
    Transparency = 0.35,
    Frost = 0.85
}
```

</details>

<details>
<summary><b>15. 窗口显示 / 隐藏 / 状态 API</b></summary>

切换显示：

```lua
window:ToggleVisible()
```

是否缩小：

```lua
local minimized =
    window:IsMinimized()
```

是否正在关闭：

```lua
local closing =
    window:IsClosing()
```

是否全屏：

```lua
local fullscreen =
    window:IsFullscreen()
```

一次获取所有状态：

```lua
local state =
    window:GetUIState()

print(state.Minimized)
print(state.Closing)
print(state.Fullscreen)
print(state.Visible)
```

返回：

```lua
{
    Minimized = false,
    Closing = false,
    Fullscreen = false,
    Visible = true
}
```

### 关闭事件

点击红色按钮后，会先设置：

```lua
Closing = true
```

然后触发：

```lua
window:OnClosing(function(state)
    window:SaveConfig()
end)
```

可以用于停止任务或保存配置。

返回的连接支持：

```lua
local connection =
    window:OnClosing(function()
    end)

connection:Disconnect()
```

</details>

<details>
<summary><b>16. GreenButton() / 全屏</b></summary>

绿色交通灯按钮默认用于：

```text
普通窗口
→ 全屏
→ 恢复原大小
```

可以附加自己的回调：

```lua
window:GreenButton(function()
    -- 自定义逻辑
end)
```

自定义 callback **不会覆盖全屏功能**，两者会同时执行。

全屏状态：

```lua
window:IsFullscreen()
```

</details>

<details>
<summary><b>17. SetSize() / GetSize() — 修改窗口大小</b></summary>

设置宽高：

```lua
window:SetSize(
    1000,
    720
)
```

读取：

```lua
local width, height =
    window:GetSize()
```

右下角拖动手柄采用 **宽高独立调整**：

```text
横着拖 → 只改变宽度
竖着拖 → 只改变高度
斜着拖 → 宽高分别变化
```

窗口中心保持固定，因此：

```text
宽度增加 → 左右两边同时扩展
高度增加 → 上下两边同时扩展
```

旧版兼容 API：

```lua
window:SetScale(1.2)
window:GetScale()
```

仍然存在，但推荐新代码使用：

```lua
SetSize()
GetSize()
```

</details>

<details>
<summary><b>18. 配置系统</b></summary>

OrchardUI 内置默认配置。

### 仓库作者直接修改

库文件顶部：

```lua
local CONFIG_FOLDER = "AppleGUI"
local CONFIG_FILE_NAME = "config.json"
```

例如改成：

```lua
local CONFIG_FOLDER = "OrchardUI"
local CONFIG_FILE_NAME = "settings.json"
```

最终路径：

```text
OrchardUI/settings.json
```

### 调用库的脚本单独指定

```lua
local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true,
    {
        ConfigFolder = "MyScript",
        ConfigFileName = "gui.json"
    }
)
```

### 配置优先级

```text
内置默认值
    ↓
配置文件
    ↓
init() 显式传入的配置
```

后面的优先级更高。

### 读取配置

```lua
local config =
    window:GetConfig()
```

### 修改配置

```lua
window:SetConfig(
    "Theme",
    "Dark"
)
```

批量：

```lua
window:SetConfig({
    Theme = "Dark",
    SidebarTransparency = 0.35,
    DropdownTransparent = false
})
```

### 保存配置

```lua
window:SaveConfig()
```

指定路径：

```lua
window:SaveConfig(
    "MyScript/custom.json"
)
```

### 重置

```lua
window:ResetConfig()
```

配置文件功能依赖执行环境是否提供类似：

```text
isfile
readfile
writefile
makefolder
isfolder
```

如果没有检测到配置文件或者相关文件 API，OrchardUI 会继续使用内置默认配置。

</details>

<details>
<summary><b>19. 全部默认配置</b></summary>

```lua
{
    ShowGUISettings = true,

    Theme = "Light",

    TransparencyEnabled = true,
    FrostEnabled = true,
    FrostStrength = 1.00,

    SidebarTranslucent = true,
    SidebarTransparency = 0.22,

    WindowTransparent = false,
    WindowTransparency = 0.08,
    ContentTransparency = 0.10,

    DropdownTransparent = false,
    DropdownTransparency = 0.34,
    DropdownFrost = 0.86,

    ShowDynamicIsland = true,
    IslandText = "点击打开",
    IslandTextSize = 11,
    IslandFPSTextSize = 11,
    IslandIcon = "rbxassetid://8997386997",
    IslandIconSize = 16,
    IslandShowIcon = true,
    IslandWidth = 196,
    IslandHeight = 36,

    WindowWidth = 820,
    WindowHeight = 650,

    MinWindowWidth = 560,
    MinWindowHeight = 430,

    MaxWindowWidth = 1380,
    MaxWindowHeight = 980,

    ShowResizeHandle = true,

    ConfigFolder = "AppleGUI",
    ConfigFileName = "config.json",
    ConfigPath = "AppleGUI/config.json",

    UseConfigFile = true,
    AutoSaveConfig = true
}
```

</details>

<details>
<summary><b>20. 内置 GUI设置 页面</b></summary>

OrchardUI 可以自动创建一个官方分类：

```text
GUI设置
```

默认：

```lua
ShowGUISettings = true
```

如果脚本作者不希望显示：

```lua
{
    ShowGUISettings = false
}
```

当前 GUI设置 可以调整：

- 浅色 / 深色主题
- 分类栏半透明
- 分类栏透明度
- 全局透明效果
- 窗口半透明
- 窗口透明度
- 内容区域透明度
- Frost 开关
- 全局 Frost 强度
- Dropdown 透明开关
- Dropdown 透明度
- Dropdown Frost 强度
- 窗口宽度
- 窗口高度
- 右下角大小手柄
- 灵动岛显示
- 灵动岛图标显示
- 灵动岛文字
- 灵动岛图标
- 灵动岛主文字大小
- FPS 文字大小
- 图标大小
- 灵动岛宽度
- 灵动岛高度
- 自动保存配置
- 手动保存配置

</details>

<details>
<summary><b>21. 灵动岛</b></summary>

默认：

```text
[图标] 点击打开                 60 FPS
```

配置：

```lua
{
    ShowDynamicIsland = true,

    IslandText = "点击打开",
    IslandTextSize = 11,

    IslandFPSTextSize = 11,

    IslandIcon = "rbxassetid://8997386997",
    IslandIconSize = 16,
    IslandShowIcon = true,

    IslandWidth = 196,
    IslandHeight = 36
}
```

运行时修改：

```lua
window:SetConfig({
    IslandText = "打开菜单",
    IslandTextSize = 13,
    IslandFPSTextSize = 10,
    IslandIconSize = 18,
    IslandWidth = 230
})
```

灵动岛：

- 显示实时 FPS
- 点击可以打开 / 收起主 UI
- 带轻微果冻动画
- 带独立软阴影
- 隐藏时停止不必要的 FPS UI 更新

</details>

<details>
<summary><b>22. 搜索</b></summary>

搜索框不仅搜索分类名，也会索引页面里的功能名称。

例如页面：

```text
鼠标
├─ 自然滚动
├─ 指针速度
├─ 跟踪速度
└─ 鼠标诊断
```

搜索：

```text
自然滚动
```

会找到对应的“鼠标”页面。

当前会参与搜索的内容包括：

- Section 名称
- Subtitle
- Divider
- Button
- Label
- Switch
- Slider
- Dropdown
- TextField
- GoTo 按钮文字

搜索状态不会永久改变原来的折叠配置；清空搜索后恢复正常树状结构。

</details>

<details>
<summary><b>23. 玩家账户页面</b></summary>

左侧顶部包含当前 Roblox 玩家信息。

点击头像区域后会进入内置账户页面。

页面会显示：

- Roblox 头像
- DisplayName
- `@Username`
- User ID
- 账号年龄
- 脚本启动时间
- 脚本已运行时间
- Place ID

账户页面本身不会作为普通分类固定显示在侧边栏。

</details>

<details>
<summary><b>24. 通用 Style 格式</b></summary>

多数控件支持：

```lua
{
    Transparency = 0.30,
    Frost = 0.75
}
```

取值范围：

```text
Transparency
0 = 不透明
1 = 完全透明

Frost
0 = 无磨砂视觉
1 = 最强磨砂视觉
```

运行时也可以直接修改返回的 GuiObject：

```lua
control:SetAttribute(
    "Transparency",
    0.45
)

control:SetAttribute(
    "Frost",
    0.90
)
```

> `Frost` 是 OrchardUI 的轻量磨砂视觉层，并非对 Roblox 3D framebuffer 做实时高斯模糊或像素折射。

</details>

---

# 推荐项目结构

```text
Roblox_OrchardUI
├─ OrchardUI
├─ README.md
├─ LICENSE
└─ examples
   ├─ Basic.lua
   ├─ Controls.lua
   └─ FullDemo.lua
```

如果继续沿用当前文件名，也可以：

```text
Roblox_OrchardUI
├─ AppleGUI
└─ README.md
```

但正式发布时更建议把主库文件也改名为：

```text
OrchardUI
```

---

# 配置示例

```lua
local config = {
    Theme = "Dark",

    SidebarTranslucent = true,
    SidebarTransparency = 0.30,

    TransparencyEnabled = true,

    FrostEnabled = true,
    FrostStrength = 0.85,

    DropdownTransparent = false,

    WindowWidth = 900,
    WindowHeight = 680,

    ShowDynamicIsland = true,
    IslandText = "打开设置",

    ConfigFolder = "MyScript",
    ConfigFileName = "orchard.json"
}

local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true,
    config
)
```

---

# 关于性能

OrchardUI 当前的透明 / Frost 方案主要由 Roblox 原生 GUI 组成。

它不会持续运行：

- `EditableImage` 像素重建
- 屏幕截图采样
- 实时液态玻璃折射
- 大量逐帧 blur 运算

多数功能采用事件驱动：

```text
搜索输入变化 → 更新搜索
拖动 Slider → 更新 Slider
拖动窗口大小 → 更新窗口
修改配置 → 更新主题 / 透明度
灵动岛可见 → 更新 FPS
```

空闲时不会为了磨砂效果持续重新计算整个 UI。

---

# 注意事项

1. OrchardUI 主要面向 Luau / Roblox GUI 环境。
2. 配置文件读取和写入取决于运行环境是否提供文件 API。
3. 部分外部图标使用 `rbxassetid://...`，可自行替换。
4. `DropdownTransparent` 默认关闭，以保证菜单可读性。
5. 深色主题会同步调整导航按钮、高光、文字、卡片等主要颜色。
6. `SetScale()` 为旧版兼容 API，新项目优先使用 `SetSize()`。
7. 如果使用自定义 Raw 地址，请确保返回的是 OrchardUI 主库源码。

---

# 最简模板

```lua
local OrchardUI = loadstring(game:HttpGet(
    "YOUR_RAW_URL"
))()

local window = OrchardUI:init(
    "My Script",
    true,
    Enum.KeyCode.RightShift,
    true
)

window:Divider("主要")

local home = window:Section("主页")

home:Label("Hello OrchardUI")

home:Button("按钮", function()
    window:TempNotify(
        "OrchardUI",
        "Hello!"
    )
end)
```

---

## License

请根据项目实际使用的许可证补充此处。不要在没有添加许可证文件的情况下默认声明 MIT 等许可证。

---

<p align="center">
  <b>Roblox_OrchardUI</b><br>
  Apple-inspired Roblox UI Library
</p>
