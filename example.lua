local MY_GUI_CONFIG_FOLDER = "AppleGUI_Test"
local MY_GUI_CONFIG_FILE = "config.json"

local URL =
    "https://raw.githubusercontent.com/snwmdd114514-lang/Roblox_OrchardUI/refs/heads/main/main"

local okHttp, source = pcall(function()
    return game:HttpGet(URL)
end)

if not okHttp then
    error(
        "[AppleGUI 中文测试] 无法读取仓库："
        .. tostring(source)
    )
end

local chunk, compileError = loadstring(source)

if not chunk then
    error(
        "[AppleGUI 中文测试] AppleGUI 编译失败："
        .. tostring(compileError)
    )
end

local okLibrary, AppleGUI = pcall(chunk)

if not okLibrary then
    error(
        "[AppleGUI 中文测试] AppleGUI 运行失败："
        .. tostring(AppleGUI)
    )
end

if
    type(AppleGUI) ~= "table"
    or type(AppleGUI.init) ~= "function"
then
    error(
        "[AppleGUI 中文测试] 仓库没有返回有效的 AppleGUI 库"
    )
end

local window = AppleGUI:init(
    "AppleGUI 中文完整测试",
    true,
    Enum.KeyCode.RightShift,
    true,

    {
        ConfigFolder = MY_GUI_CONFIG_FOLDER,
        ConfigFileName = MY_GUI_CONFIG_FILE,
        ShowGUISettings = true,
        ShowResizeHandle = true,

        IslandText = "点击打开",
        IslandTextSize = 11,
        IslandFPSTextSize = 11,
        IslandIcon = "rbxassetid://8997386997",
        IslandIconSize = 16,
    }
)

window:Divider("系统")

local home = window:Section(
    "主页",
    {
        Subtitle = "AppleGUI 中文功能总览",
        Expanded = true,

        Style = {
            Transparency = 0.03,
            Frost = 0.18,
        },
    }
)

home:Label(
    "这是 AppleGUI 的中文完整测试页。"
    .. "左侧可以切换分类；顶部 < 和 > 用于返回上一个页面和重新前进。",
    {
        Transparency = 0.10,
        Frost = 0.32,
    }
)

home:Divider("快速入口")

local settings = window:Section(
    "设置",
    {
        Subtitle = "折叠页面、控件和跳转测试",
        Expanded = true,
    }
)

local controls = settings:Create(
    "控制",
    {
        ShowInSidebar = true,
        Expanded = false,

        Subtitle = "鼠标、键盘和输入设备",

        Style = {
            Transparency = 0.08,
            Frost = 0.28,
        },
    }
)

local mouse = controls:Create(
    "鼠标",
    {
        ShowInSidebar = true,
        Expanded = true,

        Subtitle = "指针与滚动设置",

        Style = {
            Transparency = 0.12,
            Frost = 0.38,
        },
    }
)

local keyboard = controls:Create(
    "键盘",
    {
        ShowInSidebar = true,
        Expanded = false,
        Subtitle = "按键和快捷键",
    }
)

local trackpad = controls:Create(
    "触控板",
    {
        ShowInSidebar = true,
        Expanded = false,
        Subtitle = "手势和点击设置",
    }
)

local pointer = mouse:Create(
    "指针",
    {
        ShowInSidebar = true,
        Expanded = false,
        Subtitle = "光标速度和精度",
    }
)

local scrolling = mouse:Create(
    "滚动",
    {
        ShowInSidebar = true,
        Expanded = false,
        Subtitle = "滚轮和自然滚动",
    }
)

local hiddenAdvanced = controls:Create(
    "隐藏高级设置",
    {
        ShowInSidebar = false,
        Expanded = false,
        Subtitle = "不会显示在左侧栏",
    }
)

local hiddenDiagnostics = mouse:Create(
    "鼠标诊断",
    {
        ShowInSidebar = false,
        Expanded = false,
        Subtitle = "隐藏诊断页面",
    }
)

local appearance = window:Section(
    "外观",
    {
        Subtitle = "透明度和磨砂效果测试",

        Style = {
            Transparency = 0.05,
            Frost = 0.20,
        },
    }
)

local notifications = window:Section(
    "通知",
    {
        Subtitle = "Toast 和弹窗测试",
    }
)

local textInput = window:Section(
    "输入",
    {
        Subtitle = "文本框和回调测试",
    }
)

local about = window:Section(
    "关于测试",
    {
        Subtitle = "API 与操作说明",
    }
)

home:GoTo(
    "进入「设置」",
    settings,
    nil,
    {
        Transparency = 0.18,
        Frost = 0.42,
    }
)

home:GoTo(
    "进入「控制」",
    controls,
    nil,
    {
        Transparency = 0.22,
        Frost = 0.50,
    }
)

home:GoTo(
    "直接进入「鼠标」",
    mouse,
    nil,
    {
        Transparency = 0.26,
        Frost = 0.58,
    }
)

home:GoTo(
    "进入「外观」",
    appearance
)

home:GoTo(
    "进入「通知」",
    notifications
)

home:GoTo(
    "打开内置「GUI设置」",
    "GUI设置",
    nil,
    {
        Transparency = 0.12,
        Frost = 0.30,
    }
)

home:Divider("搜索功能测试")

home:Label(
    "搜索框现在不仅搜索分类名，也会搜索页面里的功能。"
    .. "可以尝试输入：自然滚动、跟踪速度、玩家备注、透明菜单、"
    .. "指针加速、保存当前 GUI 配置。",
    {
        Transparency = 0.12,
        Frost = 0.30,
    }
)

home:Divider("账号页面")

home:Label(
    "点击左侧头像区域可以进入内置「Apple账户」页面。"
    .. "其中会显示真实 Roblox 用户名、显示名称、UserId、账号年龄、"
    .. "脚本开启时间、已运行时间和 PlaceId。",
    {
        Transparency = 0.14,
        Frost = 0.36,
    }
)

home:Divider("导航测试")

home:Label(
    "推荐测试顺序：主页 → 设置 → 控制 → 鼠标 → 指针。"
    .. "然后连续点击顶部 < 返回，再点击 > 前进。",
    {
        Transparency = 0.12,
        Frost = 0.30,
    }
)

settings:Label(
    "「控制」是一个可折叠子分类。当前测试配置为默认折叠。",
    {
        Transparency = 0.12,
        Frost = 0.30,
    }
)

settings:Divider("折叠 API")

settings:Button(
    "展开「控制」",
    function()
        controls:SetExpanded(true)

        window:TempNotify(
            "折叠测试",
            "「控制」已经展开。",
            nil,
            {
                Transparency = 0.30,
                Frost = 0.80,
            }
        )
    end,
    nil,
    {
        Transparency = 0.20,
        Frost = 0.46,
    }
)

settings:Button(
    "折叠「控制」",
    function()
        controls:SetExpanded(false)

        window:TempNotify(
            "折叠测试",
            "「控制」已经折叠。",
            nil,
            {
                Transparency = 0.30,
                Frost = 0.80,
            }
        )
    end
)

settings:Button(
    "读取「控制」当前展开状态",
    function()
        local state = controls:IsExpanded()

        window:TempNotify(
            "当前状态",
            state
                and "「控制」目前：已展开"
                or "「控制」目前：已折叠",
            nil,
            {
                Transparency = 0.28,
                Frost = 0.82,
            }
        )

    end
)

settings:Divider("页面跳转")

settings:GoTo("打开「控制」", controls)
settings:GoTo("打开「鼠标」", mouse)
settings:GoTo("打开隐藏的高级设置", hiddenAdvanced)

controls:Label(
    "这个页面下面有三个可见子页面：鼠标、键盘、触控板。"
    .. "另外还有一个隐藏高级页面。",
    {
        Transparency = 0.15,
        Frost = 0.38,
    }
)

controls:Divider("设备")

controls:GoTo(
    "鼠标",
    mouse,
    nil,
    {
        Transparency = 0.16,
        Frost = 0.42,
    }
)

controls:GoTo("键盘", keyboard)
controls:GoTo("触控板", trackpad)

controls:Divider("隐藏页面")

controls:GoTo(
    "高级设置（侧边栏隐藏）",
    hiddenAdvanced,
    nil,
    {
        Transparency = 0.24,
        Frost = 0.62,
    }
)

mouse:Label(
    "这里重点测试 Switch、Dropdown、透明度、磨砂度和嵌套页面。",
    {
        Transparency = 0.12,
        Frost = 0.36,
    }
)

mouse:Divider("开关")

mouse:Switch(
    "自然滚动",
    true,
    function(value)
    end,
    {
        Transparency = 0.10,
        Frost = 0.28,

        Knob = {
            Transparency = 0.74,
            Frost = 0.92,
        },
    }
)

mouse:Switch(
    "辅助点击",
    false,
    function(value)
        window:TempNotify(
            "辅助点击",
            "当前状态：" .. tostring(value),
            nil,
            {
                Transparency = 0.34,
                Frost = 0.86,
            }
        )
    end,
    {
        Transparency = 0.16,
        Frost = 0.40,

        Knob = {
            Transparency = 0.68,
            Frost = 0.80,
        },
    }
)

mouse:Switch(
    "提高指针精度",
    true,
    function(value)
    end
)

mouse:Divider("滑动条")
mouse:Slider(
    "连续灵敏度",
    0,
    100,
    52,
    function(value)
    end,
    {
        Step = 0,
        ShowSteps = true,
        ShowValue = true,
        Suffix = "%",

        Transparency = 0.12,
        Frost = 0.30,

        Knob = {
            Transparency = 0.72,
            Frost = 0.90,
        },
    }
)
local steppedSlider = mouse:Slider(
    "指针速度",
    0,
    10,
    5,
    function(value)
    end,
    {
        Step = 1,
        ShowSteps = true,
        ShowValue = true,

        Transparency = 0.14,
        Frost = 0.36,

        Knob = {
            Transparency = 0.76,
            Frost = 0.94,
        },
    }
)
mouse:Slider(
    "隐藏步进点",
    0,
    100,
    40,
    function(value)
    end,
    {
        Step = 10,
        ShowSteps = false,
        ShowValue = true,
        Suffix = "%",
    }
)

mouse:Button(
    "切换「指针速度」步进点显示",
    function()
        steppedSlider:SetAttribute(
            "ShowSteps",
            not steppedSlider:GetAttribute(
                "ShowSteps"
            )
        )
    end
)

mouse:Button(
    "把「指针速度」改成连续滑动",
    function()
        steppedSlider:SetAttribute(
            "Step",
            0
        )
    end
)

mouse:Button(
    "恢复「指针速度」Step = 1",
    function()
        steppedSlider:SetAttribute(
            "Step",
            1
        )

        steppedSlider:SetAttribute(
            "ShowSteps",
            true
        )
    end
)

mouse:Divider("下拉菜单")

mouse:Dropdown(
    "跟踪速度",
    {
        "很慢",
        "慢",
        "普通",
        "快",
        "很快",
    },
    "普通",
    function(value)
        window:TempNotify(
            "跟踪速度",
            "已经选择：" .. tostring(value)
        )
    end,
    {
        Transparency = 0.14,
        Frost = 0.36,

        Trigger = {
            Transparency = 0.24,
            Frost = 0.58,
        },

        Popup = {
            Transparency = 0.48,
            Frost = 0.96,
        },
    }
)

mouse:Dropdown(
    "主按钮",
    {
        "左键",
        "右键",
    },
    "左键",
    function(value)
    end,
    {
        Popup = {
            Transparency = 0.38,
            Frost = 0.84,
        },
    }
)

mouse:Divider("子页面")

mouse:GoTo("指针设置", pointer)
mouse:GoTo("滚动设置", scrolling)
mouse:GoTo("鼠标诊断（隐藏）", hiddenDiagnostics)

pointer:Label(
    "这是「鼠标」下面的三级页面，用来测试多级树状侧边栏。",
    {
        Transparency = 0.18,
        Frost = 0.45,
    }
)

pointer:Dropdown(
    "指针速度",
    {
        "1",
        "2",
        "3",
        "4",
        "5",
    },
    "3",
    function(value)
    end
)

pointer:Switch(
    "指针加速",
    true,
    function(value)
    end,
    {
        Knob = {
            Transparency = 0.78,
            Frost = 0.96,
        },
    }
)

pointer:GoTo("返回鼠标", mouse)

scrolling:Label(
    "滚动页面用于测试同级子分类切换。"
)

scrolling:Switch(
    "自然滚动方向",
    true,
    function(value)
    end
)

scrolling:Dropdown(
    "滚轮速度",
    {
        "慢",
        "普通",
        "快",
    },
    "普通",
    function(value)
    end
)

scrolling:GoTo("返回鼠标", mouse)

keyboard:Label(
    "这个页面用来测试折叠分类里的另一个同级页面。",
    {
        Transparency = 0.12,
        Frost = 0.28,
    }
)

keyboard:Switch(
    "按键重复",
    true,
    function(value)
    end
)

keyboard:Dropdown(
    "重复速度",
    {
        "慢",
        "普通",
        "快",
        "非常快",
    },
    "普通",
    function(value)
    end
)

keyboard:TextField(
    "快捷键名称",
    "例如：打开菜单",
    function(text)

        window:TempNotify(
            "文本输入",
            "输入内容：" .. tostring(text)
        )
    end,
    {
        Input = {
            Transparency = 0.28,
            Frost = 0.62,
        },
    }
)

trackpad:Label(
    "触控板页面主要用于测试多个 Switch 连续排列。",
    {
        Transparency = 0.14,
        Frost = 0.34,
    }
)

trackpad:Switch(
    "轻点来点按",
    true,
    function(value)
    end
)

trackpad:Switch(
    "三指拖移",
    false,
    function(value)
    end
)

trackpad:Switch(
    "双指辅助点击",
    true,
    function(value)
    end
)

hiddenAdvanced:Label(
    "这个页面使用 ShowInSidebar = false 创建。"
    .. "因此它不会出现在左侧栏，但仍然可以通过 GoTo() 打开。",
    {
        Transparency = 0.18,
        Frost = 0.50,
    }
)

hiddenAdvanced:Divider("高级参数")

hiddenAdvanced:Switch(
    "原始输入",
    false,
    function(value)
    end
)

hiddenAdvanced:Dropdown(
    "轮询率",
    {
        "125 Hz",
        "250 Hz",
        "500 Hz",
        "1000 Hz",
    },
    "1000 Hz",
    function(value)
    end,
    {
        Popup = {
            Transparency = 0.52,
            Frost = 1.00,
        },
    }
)

hiddenAdvanced:GoTo("返回控制", controls)

hiddenDiagnostics:Label(
    "这是另一个隐藏页面，用于确认多层级隐藏页面也能正常跳转。"
)

hiddenDiagnostics:Button(
    "发送诊断通知",
    function()
        window:TempNotify(
            "鼠标诊断",
            "隐藏页面跳转工作正常。",
            nil,
            {
                Transparency = 0.38,
                Frost = 0.94,
            }
        )
    end
)

hiddenDiagnostics:GoTo("返回鼠标", mouse)

appearance:Label(
    "这里专门测试每个控件独立的透明度和磨砂度。",
    {
        Transparency = 0.12,
        Frost = 0.34,
    }
)

appearance:Divider("静态透明度对比")

appearance:Button(
    "低透明 / 低磨砂",
    function()
    end,
    nil,
    {
        Transparency = 0.10,
        Frost = 0.20,
    }
)

appearance:Button(
    "中透明 / 中磨砂",
    function()
    end,
    nil,
    {
        Transparency = 0.38,
        Frost = 0.62,
    }
)

appearance:Button(
    "高透明 / 高磨砂",
    function()
    end,
    nil,
    {
        Transparency = 0.68,
        Frost = 0.96,
    }
)

appearance:Divider("运行时动态调整")

local dynamicDemo = appearance:Button(
    "动态磨砂测试对象",
    function()
        window:TempNotify(
            "动态对象",
            "这个按钮的透明度和 Frost 可以在运行时改变。"
        )
    end,
    nil,
    {
        Transparency = 0.20,
        Frost = 0.30,
    }
)

appearance:Button(
    "设为：几乎不透明",
    function()
        dynamicDemo:SetAttribute(
            "Transparency",
            0.08
        )

        dynamicDemo:SetAttribute(
            "Frost",
            0.18
        )
    end
)

appearance:Button(
    "设为：中等磨砂",
    function()
        dynamicDemo:SetAttribute(
            "Transparency",
            0.38
        )

        dynamicDemo:SetAttribute(
            "Frost",
            0.68
        )
    end
)

appearance:Button(
    "设为：高度透明磨砂",
    function()
        dynamicDemo:SetAttribute(
            "Transparency",
            0.72
        )

        dynamicDemo:SetAttribute(
            "Frost",
            1.00
        )
    end
)

appearance:Divider("滑动条图标")

appearance:Label(
    "Slider 支持 LeftIcon / RightIcon。下面使用公开 Roblox 图标 ID 测试两侧图标。",
    {
        Transparency = 0.14,
        Frost = 0.34,
    }
)

appearance:Slider(
    "带两侧图标",
    0,
    100,
    58,
    function(value)
    end,
    {
        Step = 10,
        ShowSteps = true,
        ShowValue = false,
        LeftIcon = "rbxassetid://7733715400",
        RightIcon = "rbxassetid://7733715400",

        LeftIconSize = 16,
        RightIconSize = 21,

        Transparency = 0.18,
        Frost = 0.44,

        Knob = {
            Transparency = 0.78,
            Frost = 0.96,
        },
    }
)

appearance:Divider("深色模式检查")

appearance:Label(
    "进入左侧「GUI设置」切换到深色后，重点检查：顶部 < > 返回按钮、"
    .. "Dropdown 顶部细高光、弹出菜单、搜索框、分类卡片和文字颜色。"
)

appearance:Button(
    "立即切换深色",
    function()
        window:SetConfig(
            "Theme",
            "Dark"
        )
    end
)

appearance:Button(
    "立即切换浅色",
    function()
        window:SetConfig(
            "Theme",
            "Light"
        )
    end
)

appearance:Button(
    "分类栏透明度 40%",
    function()
        window:SetConfig({
            SidebarTranslucent = true,
            SidebarTransparency = 0.40,
        })
    end
)

appearance:Button(
    "恢复分类栏默认透明度",
    function()
        window:SetConfig({
            SidebarTranslucent = true,
            SidebarTransparency = 0.22,
        })
    end
)

appearance:Divider("窗口大小 / 灵动岛")

appearance:Label(
    "右下角手柄现在不是等比缩放：横着拖只改变宽度，竖着拖只改变高度；"
    .. "窗口以中心为基准，所以会向两边对称增长。"
)

appearance:Button(
    "宽窗口：1100 × 650",
    function()
        window:SetSize(
            1100,
            650
        )
    end
)

appearance:Button(
    "高窗口：820 × 850",
    function()
        window:SetSize(
            820,
            850
        )
    end
)

appearance:Button(
    "宽高都变：1100 × 800",
    function()
        window:SetSize(
            1100,
            800
        )
    end
)

appearance:Button(
    "恢复默认：820 × 650",
    function()
        window:SetSize(
            820,
            650
        )
    end
)

appearance:Button(
    "打印当前窗口大小",
    function()
        local width, height =
            window:GetSize()

    end
)

appearance:Button(
    "灵动岛改成「打开测试菜单」",
    function()
        window:SetConfig({
            IslandText = "打开测试菜单",
            IslandTextSize = 12,
            IslandFPSTextSize = 10,
            IslandIconSize = 18,
            IslandWidth = 230,
        })
    end
)

appearance:Button(
    "恢复默认灵动岛",
    function()
        window:SetConfig({
            IslandText = "点击打开",
            IslandTextSize = 11,
            IslandFPSTextSize = 11,
            IslandIcon = "rbxassetid://8997386997",
            IslandIconSize = 16,
            IslandWidth = 196,
            IslandHeight = 36,
        })
    end
)

appearance:Divider("下拉菜单默认外观")

appearance:Label(
    "下拉菜单现在默认不透明。"
    .. "进入「GUI设置」打开「下拉菜单透明」后，"
    .. "下面各 Dropdown 的 Transparency / Frost 配置才会启用。",
    {
        Transparency = 0.12,
        Frost = 0.30,
    }
)

appearance:Divider("下拉菜单磨砂")

appearance:Dropdown(
    "界面外观",
    {
        "自动",
        "浅色",
        "深色",
        "高对比度",
    },
    "自动",
    function(value)
        window:TempNotify(
            "外观",
            "选择了：" .. tostring(value)
        )
    end,
    {
        Transparency = 0.18,
        Frost = 0.42,

        Trigger = {
            Transparency = 0.34,
            Frost = 0.72,
        },

        Popup = {
            Transparency = 0.56,
            Frost = 1.00,
        },
    }
)

notifications:Label(
    "通知现在使用轻量透明 + 磨砂视觉层，不再进行 EditableImage 像素计算。",
    {
        Transparency = 0.14,
        Frost = 0.36,
    }
)

notifications:Divider("临时通知")

notifications:Button(
    "显示默认 TempNotify",
    function()
        window:TempNotify(
            "普通通知",
            "这是默认透明度和默认磨砂度。"
        )
    end
)

notifications:Button(
    "显示高透明磨砂 TempNotify",
    function()
        window:TempNotify(
            "透明通知",
            "Transparency = 0.55，Frost = 1.00",
            nil,
            {
                Transparency = 0.55,
                Frost = 1.00,
            }
        )
    end,
    nil,
    {
        Transparency = 0.22,
        Frost = 0.46,
    }
)

notifications:Divider("单按钮弹窗")

notifications:Button(
    "显示 Notify",
    function()
        window:Notify(
            "确认操作",
            "这是一个单按钮磨砂弹窗。",
            "确定",
            nil,
            function()
            end,
            {
                Transparency = 0.36,
                Frost = 0.88,
            }
        )
    end
)

notifications:Divider("双按钮弹窗")

notifications:Button(
    "显示 Notify2",
    function()
        window:Notify2(
            "选择操作",
            "这是双按钮弹窗，用来测试确认和取消回调。",
            "继续",
            "取消",
            nil,

            function()
                window:TempNotify(
                    "结果",
                    "你点击了「继续」。"
                )
            end,

            function()
                window:TempNotify(
                    "结果",
                    "你点击了「取消」。"
                )
            end,

            {
                Transparency = 0.42,
                Frost = 0.92,
            }
        )
    end
)

textInput:Label(
    "输入页用于测试 TextField 的焦点、回调和独立磨砂设置。"
)

textInput:Divider("文本输入")

textInput:TextField(
    "玩家备注",
    "请输入内容...",
    function(value)

        window:TempNotify(
            "输入完成",
            "内容：" .. tostring(value),
            nil,
            {
                Transparency = 0.32,
                Frost = 0.84,
            }
        )
    end,
    {
        Transparency = 0.16,
        Frost = 0.38,

        Input = {
            Transparency = 0.30,
            Frost = 0.66,
        },
    }
)

textInput:TextField(
    "搜索关键词",
    "例如：Mouse",
    function(value)
    end,
    {
        Input = {
            Transparency = 0.44,
            Frost = 0.88,
        },
    }
)

about:Label(
    "AppleGUI 当前仓库地址（v3 深色/GUI设置测试）：\n"
    .. URL,
    {
        Transparency = 0.14,
        Frost = 0.34,
    }
)

about:Divider("已覆盖的 API")

about:Label(
    "init / Divider / Section / Create / CreatePage / "
    .. "SetExpanded / IsExpanded / GoTo / Navigate / "
    .. "Button / Label / Switch / Slider / Dropdown / TextField / "
    .. "TempNotify / Notify / Notify2 / GreenButton / GetConfig / SetConfig / SaveConfig",
    {
        Transparency = 0.18,
        Frost = 0.44,
    }
)

about:Divider("GUI 配置 API")

about:Label(
    "默认配置文件：AppleGUI/config.json。"
    .. "如果文件不存在就使用库内默认值。"
    .. "也可以在 init() 第 5 个参数传配置表覆盖文件。",
    {
        Transparency = 0.14,
        Frost = 0.34,
    }
)

about:Button(
    "打印当前 GUI 配置",
    function()
        local config = window:GetConfig()

        for key, value in pairs(config) do
        end
    end
)

about:Button(
    "保存当前 GUI 配置",
    function()
        local ok = window:SaveConfig()

        window:TempNotify(
            "配置文件",
            ok
                and "配置保存成功。"
                or "当前执行环境没有 writefile 支持。"
        )
    end
)

about:Divider("UI 状态 API")

about:Button(
    "显示当前 UI 状态",
    function()
        local state = window:GetUIState()

        window:TempNotify(
            "UI 状态",
            "缩小=" .. tostring(state.Minimized)
            .. "　关闭中=" .. tostring(state.Closing)
            .. "　全屏=" .. tostring(state.Fullscreen)
        )
    end
)

window:OnClosing(function(state)
    local _ = state.Closing
end)

about:Divider("快捷操作")

about:Button(
    "打印测试成功信息",
    function()
    end
)

about:GoTo("返回主页", home)

home:Select()

task.delay(1.0, function()
    window:TempNotify(
        "AppleGUI 中文测试已启动",
        "先测试左侧折叠分类，再点击头像查看 Apple账户。",
        nil,
        {
            Transparency = 0.34,
            Frost = 0.90,
        }
    )
end)

