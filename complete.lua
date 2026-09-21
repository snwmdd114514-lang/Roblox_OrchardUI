
local CONFIG_FOLDER = "AppleGUI"
local CONFIG_FILE_NAME = "config.json"

--local URL = "https://raw.githubusercontent.com/snwmdd114514-lang/Script/bbcb624f25e1a7bf9a3632a3c60c03b6f25c910d/AppleGUI"


local lib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local AssetService = game:GetService("AssetService")
local CaptureService = game:GetService("CaptureService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer


local ASSET = {


    ShadowSoft = "rbxassetid://6015897843",
    ShadowTight = "rbxassetid://1316045217",

    Search = "rbxassetid://7734052925",
    ChevronRight = "rbxassetid://7733717755",
    ChevronDown = "rbxassetid://7733717447",
    ChevronLeft = "rbxassetid://7733717651",
    ArrowLeft = "rbxassetid://7733673136",
    ArrowRight = "rbxassetid://7733673345",
    Settings = "rbxassetid://8997386997",
    Maximize = "rbxassetid://7733992901",
    Minimize = "rbxassetid://7733997870",
    X = "rbxassetid://7743878857",
    Wifi = "rbxassetid://7743878148",
    Bluetooth = "rbxassetid://7733687147",
    Network = "rbxassetid://7733954611",
    Battery = "rbxassetid://7733674503",
    Accessibility = "rbxassetid://7743871002",
    Appearance = "rbxassetid://7733764005",
    Display = "rbxassetid://7734002839",
    Lock = "rbxassetid://7733992528",
    Sliders = "rbxassetid://7734058803",
    Layout = "rbxassetid://7733970543",
    Cloud = "rbxassetid://7733746980",
}


local C = {
    Window = Color3.fromRGB(247, 247, 248),
    Sidebar = Color3.fromRGB(246, 246, 247),
    Content = Color3.fromRGB(251, 251, 252),
    Card = Color3.fromRGB(244, 244, 246),
    CardPressed = Color3.fromRGB(232, 232, 235),
    Search = Color3.fromRGB(229, 229, 231),
    Text = Color3.fromRGB(31, 31, 33),
    Secondary = Color3.fromRGB(114, 114, 119),
    Tertiary = Color3.fromRGB(156, 156, 161),
    Divider = Color3.fromRGB(216, 216, 219),
    Blue = Color3.fromRGB(10, 122, 255),
    SwitchOff = Color3.fromRGB(206, 206, 211),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
}

local function tw(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function round(obj, px)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, px)
    c.Parent = obj
    return c
end

local function circle(obj)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color
    s.Transparency = transparency
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

local function addShadow(parent, z, extraX, extraY, transparency, tight)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "ShadowImage"
    shadow.Parent = parent
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, extraX or 38, 1, extraY or 38)
    shadow.BackgroundTransparency = 1
    shadow.Image = tight and ASSET.ShadowTight or ASSET.ShadowSoft
    shadow.ImageColor3 = C.Black
    shadow.ImageTransparency = transparency or 0.82
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = tight and Rect.new(10, 10, 118, 118) or Rect.new(47, 47, 450, 450)
    shadow.ZIndex = z or 0
    return shadow
end

local function addTopHighlight(parent, inset, z, transparency)
    local h = Instance.new("Frame")
    h.Name = "TopHighlight"
    h.Parent = parent
    h.AnchorPoint = Vector2.new(0.5, 0)
    h.Position = UDim2.new(0.5, 0, 0, 1)
    h.Size = UDim2.new(1, -(inset or 24), 0, 1)
    h.BackgroundColor3 = C.White
    h.BackgroundTransparency = transparency or 0.25
    h.BorderSizePixel = 0
    h.ZIndex = z or (parent.ZIndex + 1)
    return h
end

local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    return CoreGui
end

local function protect(gui)
    if syn and typeof(syn.protect_gui) == "function" then
        pcall(function() syn.protect_gui(gui) end)
    end
end

local function iconLabel(parent, image, size, color, z)
    local i = Instance.new("ImageLabel")
    i.Parent = parent
    i.BackgroundTransparency = 1
    i.Size = UDim2.fromOffset(size, size)
    i.Image = image
    i.ImageColor3 = color or C.Text
    i.ScaleType = Enum.ScaleType.Fit
    i.ZIndex = z or parent.ZIndex + 1
    return i
end

local function pressScale(button, amount)
    amount = amount or 0.97
    local s = Instance.new("UIScale")
    s.Scale = 1
    s.Parent = button

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tw(s, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = amount})
        end
    end)
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tw(s, TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        end
    end)
end

local function trafficLight(parent, x, color, kind)

    local hit = Instance.new("TextButton")
    hit.Name = kind
    hit.Parent = parent
    hit.Position = UDim2.fromOffset(x - 20, 6)
    hit.Size = UDim2.fromOffset(40, 40)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 30

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Parent = hit
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(13, 13)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.ZIndex = 31
    circle(dot)
    stroke(dot, C.Black, 0.82, 0.7)

    local glyph = iconLabel(dot,
        kind == "close" and ASSET.X or (kind == "minimize" and ASSET.Minimize or ASSET.Maximize),
        8,
        kind == "close" and Color3.fromRGB(118, 31, 26)
            or (kind == "minimize" and Color3.fromRGB(121, 79, 15) or Color3.fromRGB(25, 96, 40)),
        32
    )
    glyph.AnchorPoint = Vector2.new(0.5, 0.5)
    glyph.Position = UDim2.fromScale(0.5, 0.5)
    glyph.ImageTransparency = 1

    local function showGlyph(show)
        tw(glyph, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = show and 0.02 or 1
        })
    end

    hit.MouseEnter:Connect(function() showGlyph(true) end)
    hit.MouseLeave:Connect(function() showGlyph(false) end)
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then showGlyph(true) end
    end)
    hit.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            task.delay(0.12, function() showGlyph(false) end)
        end
    end)

    return hit
end

function lib:init(ti, dosplash, visiblekey, deleteprevious)
    local guiParent = getGuiParent()

    if deleteprevious then
        local old = guiParent:FindFirstChild("AppleSettingsUI")
        if old then old:Destroy() end
        local legacy = guiParent:FindFirstChild("AppleDesktopUILibrary")
        if legacy then legacy:Destroy() end
    end

    local scrgui = Instance.new("ScreenGui")
    scrgui.Name = "AppleSettingsUI"
    scrgui.IgnoreGuiInset = true
    scrgui.ResetOnSpawn = false
    scrgui.DisplayOrder = 999999
    scrgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protect(scrgui)
    scrgui.Parent = guiParent


    local glassOwnedImages = {}
    local glassGeometryCache = {}
    local captureQueue = {}
    local captureBusy = false

    local function gClamp(x, a, b)
        if x < a then return a end
        if x > b then return b end
        return x
    end

    local function gLerp(a, b, t)
        return a + (b - a) * t
    end

    local function gRound(x)
        return math.floor(x + 0.5)
    end

    local function styleConfig(style)
        if style == "knob" then
            return {
                maxAxis = 52,


                shift = 0.225,
                frost = 0.10,
                blur = 0.90,
                alpha = 238,
                spec = 0.34,
                chroma = 0.02,
            }
        elseif style == "toast" then
            return {
                maxAxis = 128,
                shift = 0.060,
                frost = 0.12,
                blur = 1.65,
                alpha = 176,
                spec = 0.20,
                chroma = 0.07,
            }
        elseif style == "modal" then
            return {
                maxAxis = 128,
                shift = 0.052,
                frost = 0.15,
                blur = 1.85,
                alpha = 194,
                spec = 0.20,
                chroma = 0.06,
            }
        else
            return {
                maxAxis = 128,
                shift = 0.070,
                frost = 0.13,
                blur = 1.55,
                alpha = 184,
                spec = 0.23,
                chroma = 0.07,
            }
        end
    end

    local function chooseOutputSize(style, absSize)
        local cfg = styleConfig(style)
        local biggest = math.max(absSize.X, absSize.Y, 1)
        local scale = math.min(1, cfg.maxAxis / biggest)
        local w = math.max(16, math.floor(absSize.X * scale + 0.5))
        local h = math.max(16, math.floor(absSize.Y * scale + 0.5))
        if style == "knob" then
            w, h = 48, 48
        end
        return w, h
    end

    local function getGeometry(style, w, h)
        local key = style .. ":" .. tostring(w) .. "x" .. tostring(h)
        local cached = glassGeometryCache[key]
        if cached then return cached end

        local cfg = styleConfig(style)
        local count = w * h
        local dirX = buffer.create(count * 4)
        local dirY = buffer.create(count * 4)
        local ringMap = buffer.create(count)
        local frostMap = buffer.create(count)
        local specMap = buffer.create(count)
        local lowerMap = buffer.create(count)

        for y = 0, h - 1 do
            for x = 0, w - 1 do
                local p = y * w + x
                local f = p * 4
                local nx = ((x + 0.5) / w) * 2 - 1
                local ny = ((y + 0.5) / h) * 2 - 1

                local aspect = w / math.max(1, h)
                local ay = ny * math.min(2.30, aspect) * 0.70
                local dist = math.sqrt(nx * nx + ay * ay)
                local ring = 1 - gClamp(math.abs(dist - 0.80) / 0.25, 0, 1)
                ring = ring * ring

                local len = math.max(0.001, math.sqrt(nx * nx + ny * ny))
                buffer.writef32(dirX, f, nx / len)
                buffer.writef32(dirY, f, ny / len)
                buffer.writeu8(ringMap, p, gRound(ring * 255))

                local frost = cfg.frost + ring * 0.055
                buffer.writeu8(frostMap, p, gRound(gClamp(frost, 0, 1) * 255))

                local top = gClamp(1 - math.abs((y / h) - 0.10) / 0.13, 0, 1) * cfg.spec
                local left = gClamp(1 - math.abs((x / w) - 0.06) / 0.07, 0, 1) * (cfg.spec * 0.28)
                buffer.writeu8(specMap, p, gRound(math.max(top, left) * 255))

                local lower = gClamp(((y / h) - 0.80) / 0.20, 0, 1) * 0.055
                buffer.writeu8(lowerMap, p, gRound(lower * 255))
            end
        end

        cached = {
            dirX = dirX,
            dirY = dirY,
            ring = ringMap,
            frost = frostMap,
            spec = specMap,
            lower = lowerMap,
        }
        glassGeometryCache[key] = cached
        return cached
    end

    local function queueScreenCapture(hiddenObjects, callback)
        table.insert(captureQueue, {
            hidden = hiddenObjects or {},
            callback = callback,
        })

        local function pump()
            if captureBusy or #captureQueue == 0 then return end
            captureBusy = true
            local request = table.remove(captureQueue, 1)

            task.spawn(function()
                local oldVisible = {}
                for _, object in ipairs(request.hidden) do
                    if object and object.Parent and object:IsA("GuiObject") then
                        oldVisible[object] = object.Visible
                        object.Visible = false
                    end
                end


                local screenshotHud = GuiService:FindFirstChild("ScreenshotHud")
                local oldHideCore, oldHidePlayer
                if screenshotHud then
                    pcall(function()
                        oldHideCore = screenshotHud.HideCoreGuiForCaptures
                        oldHidePlayer = screenshotHud.HidePlayerGuiForCaptures
                        screenshotHud.HideCoreGuiForCaptures = false
                        screenshotHud.HidePlayerGuiForCaptures = false
                    end)
                end


                RunService.RenderStepped:Wait()

                local finished = false

                local function restore()
                    for object, wasVisible in pairs(oldVisible) do
                        if object and object.Parent then
                            object.Visible = wasVisible
                        end
                    end
                    if screenshotHud then
                        pcall(function()
                            if oldHideCore ~= nil then screenshotHud.HideCoreGuiForCaptures = oldHideCore end
                            if oldHidePlayer ~= nil then screenshotHud.HidePlayerGuiForCaptures = oldHidePlayer end
                        end)
                    end
                end

                local function finish(sourceEditable, err)
                    if finished then
                        if sourceEditable then
                            pcall(function() sourceEditable:Destroy() end)
                        end
                        return
                    end
                    finished = true
                    restore()
                    pcall(request.callback, sourceEditable, err)
                    if sourceEditable then
                        pcall(function() sourceEditable:Destroy() end)
                    end
                    captureBusy = false
                    pump()
                end

                local okStart, startErr = pcall(function()
                    CaptureService:CaptureScreenshot(function(contentId)
                        restore()
                        task.spawn(function()
                            local okLoad, loaded = pcall(function()
                                return AssetService:CreateEditableImageAsync(Content.fromUri(contentId))
                            end)
                            if okLoad and loaded then
                                finish(loaded, nil)
                            else
                                finish(nil, loaded)
                            end
                        end)
                    end)
                end)

                if not okStart then
                    finish(nil, startErr)
                    return
                end

                task.delay(4, function()
                    if not finished then
                        finish(nil, "CaptureService timeout")
                    end
                end)
            end)
        end

        pump()
    end

    local function renderCapturedRegion(sourceEditable, rectPos, rectSize, style, destination)
        if not sourceEditable or not destination then return false end

        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1, 1)
        local sourceSize = sourceEditable.Size
        if sourceSize.X < 1 or sourceSize.Y < 1 then return false end

        local sxScale = sourceSize.X / math.max(1, viewport.X)
        local syScale = sourceSize.Y / math.max(1, viewport.Y)

        local x0 = math.floor(rectPos.X * sxScale)
        local y0 = math.floor(rectPos.Y * syScale)
        local cw = math.max(2, math.floor(rectSize.X * sxScale + 0.5))
        local ch = math.max(2, math.floor(rectSize.Y * syScale + 0.5))

        x0 = gClamp(x0, 0, math.max(0, sourceSize.X - 2))
        y0 = gClamp(y0, 0, math.max(0, sourceSize.Y - 2))
        cw = gClamp(cw, 2, math.max(2, sourceSize.X - x0))
        ch = gClamp(ch, 2, math.max(2, sourceSize.Y - y0))

        local okRead, crop = pcall(function()
            return sourceEditable:ReadPixelsBuffer(Vector2.new(x0, y0), Vector2.new(cw, ch))
        end)
        if not okRead or not crop then return false end

        local w, h = destination.Size.X, destination.Size.Y
        local geometry = getGeometry(style, w, h)
        local cfg = styleConfig(style)
        local out = buffer.create(w * h * 4)

        local function readCrop(x, y, c)
            x = gClamp(gRound(x), 0, cw - 1)
            y = gClamp(gRound(y), 0, ch - 1)
            return buffer.readu8(crop, (y * cw + x) * 4 + c)
        end

        for y = 0, h - 1 do
            local baseV = (y + 0.5) / h
            for x = 0, w - 1 do
                local p = y * w + x
                local f = p * 4
                local baseU = (x + 0.5) / w

                local ring = buffer.readu8(geometry.ring, p) / 255
                local dx = buffer.readf32(geometry.dirX, f)
                local dy = buffer.readf32(geometry.dirY, f)

                local shiftPx = math.min(cw, ch) * cfg.shift * ring
                local sourceX = baseU * (cw - 1) - dx * shiftPx
                local sourceY = baseV * (ch - 1) - dy * shiftPx

                local blur = cfg.blur
                local function blurred(channel, channelShift)
                    local px = sourceX + channelShift
                    return
                        readCrop(px, sourceY, channel) * 0.40
                        + readCrop(px - blur, sourceY, channel) * 0.15
                        + readCrop(px + blur, sourceY, channel) * 0.15
                        + readCrop(px, sourceY - blur, channel) * 0.15
                        + readCrop(px, sourceY + blur, channel) * 0.15
                end


                local r = blurred(0, -cfg.chroma)
                local g = blurred(1, 0)
                local b = blurred(2, cfg.chroma)

                local frost = buffer.readu8(geometry.frost, p) / 255
                local spec = buffer.readu8(geometry.spec, p) / 255
                local lower = buffer.readu8(geometry.lower, p) / 255

                r = gLerp(r, 255, frost)
                g = gLerp(g, 255, frost)
                b = gLerp(b, 255, frost)

                r = gLerp(r, 255, spec)
                g = gLerp(g, 255, spec)
                b = gLerp(b, 255, spec)

                local dark = 1 - lower
                r, g, b = r * dark, g * dark, b * dark

                buffer.writeu8(out, f, gClamp(gRound(r), 0, 255))
                buffer.writeu8(out, f + 1, gClamp(gRound(g), 0, 255))
                buffer.writeu8(out, f + 2, gClamp(gRound(b), 0, 255))
                buffer.writeu8(out, f + 3, gClamp(cfg.alpha + gRound(ring * 20), 0, 255))
            end
        end

        destination:WritePixelsBuffer(Vector2.zero, Vector2.new(w, h), out)
        return true
    end

    local function attachLiquidGlass(parentObject, style, z, cornerRadius, imageTransparency, frostTransparency)
        parentObject.ClipsDescendants = true

        local glassImage = Instance.new("ImageLabel")
        glassImage.Name = "LiquidGlassLayer"
        glassImage.Parent = parentObject
        glassImage.Size = UDim2.fromScale(1, 1)
        glassImage.BackgroundTransparency = 1
        glassImage.BorderSizePixel = 0
        glassImage.ImageTransparency = imageTransparency == nil and 1 or imageTransparency
        glassImage.ScaleType = Enum.ScaleType.Stretch
        glassImage.ResampleMode = Enum.ResamplerMode.Default
        glassImage.ZIndex = z or (parentObject.ZIndex + 1)
        round(glassImage, cornerRadius or 16)


        local frost = Instance.new("Frame")
        frost.Name = "FrostLayer"
        frost.Parent = parentObject
        frost.Size = UDim2.fromScale(1, 1)
        frost.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
        frost.BackgroundTransparency = frostTransparency or 0.90
        frost.BorderSizePixel = 0
        frost.ZIndex = (z or parentObject.ZIndex + 1) + 1
        round(frost, cornerRadius or 16)

        local fg = Instance.new("UIGradient")
        fg.Parent = frost
        fg.Rotation = 92
        fg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.22),
            NumberSequenceKeypoint.new(0.38, 0.62),
            NumberSequenceKeypoint.new(1, 0.82),
        })

        local controller = {
            Dirty = true,
            Busy = false,
            HasImage = false,
            Destination = nil,
            LastPosition = nil,
            LastSize = nil,
            Waiters = {},
        }

        function controller:MarkDirty()
            self.Dirty = true
        end

        function controller:SetShown(shown, glassAlpha, frostAlpha)
            if not glassImage.Parent then return end
            glassImage.ImageTransparency = shown and (glassAlpha or 0.02) or 1
            frost.BackgroundTransparency = shown and (frostAlpha or 0.90) or 1
        end

        function controller:Refresh(onReady, force)
            if not parentObject.Parent then return end

            if self.Busy then
                if onReady then
                    table.insert(self.Waiters, onReady)
                end
                return
            end

            local rectPos = parentObject.AbsolutePosition
            local rectSize = parentObject.AbsoluteSize
            if rectSize.X < 2 or rectSize.Y < 2 then return end

            if self.LastPosition and self.LastSize then
                if (rectPos - self.LastPosition).Magnitude > 0.75 or (rectSize - self.LastSize).Magnitude > 0.75 then
                    self.Dirty = true
                end
            end

            if self.HasImage and not self.Dirty and not force then
                if onReady then onReady(true, true) end
                return
            end

            self.Busy = true
            local w, h = chooseOutputSize(style, rectSize)

            if not self.Destination or self.Destination.Size.X ~= w or self.Destination.Size.Y ~= h then
                if self.Destination then
                    pcall(function() self.Destination:Destroy() end)
                end
                local okCreate, destination = pcall(function()
                    return AssetService:CreateEditableImage({Size = Vector2.new(w, h)})
                end)
                if not okCreate or not destination then
                    self.Busy = false
                    if onReady then onReady(false, false) end
                    return
                end
                self.Destination = destination
                table.insert(glassOwnedImages, destination)
                local okContent, content = pcall(function()
                    return Content.fromObject(destination)
                end)
                if okContent then
                    glassImage.ImageContent = content
                end
            end


            queueScreenCapture({self.HideObject or parentObject}, function(sourceEditable, err)
                if not parentObject.Parent then
                    self.Busy = false
                    return
                end

                local okRender = false
                if sourceEditable and self.Destination then
                    okRender = renderCapturedRegion(sourceEditable, rectPos, rectSize, style, self.Destination)
                end

                self.Busy = false
                if okRender then
                    self.HasImage = true
                    self.Dirty = false
                    self.LastPosition = rectPos
                    self.LastSize = rectSize
                else
                    warn("[AppleSettingsUI] Snapshot liquid glass refresh failed:", err)
                end

                if onReady then onReady(okRender, false) end

                if #self.Waiters > 0 then
                    local waiters = self.Waiters
                    self.Waiters = {}
                    for _, waiter in ipairs(waiters) do
                        pcall(waiter, okRender, false)
                    end
                end
            end)
        end

        return glassImage, frost, controller
    end

    scrgui.Destroying:Connect(function()
        for _, editable in ipairs(glassOwnedImages) do
            pcall(function() editable:Destroy() end)
        end
    end)


    local island = Instance.new("Frame")
    island.Name = "DynamicIsland"
    island.Parent = scrgui
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.Position = UDim2.new(0.5, 0, 0, 8)
    island.Size = UDim2.fromOffset(126, 36)
    island.BackgroundColor3 = C.Black
    island.BorderSizePixel = 0
    island.ZIndex = 900
    island.ClipsDescendants = true
    circle(island)

    local islandText = Instance.new("TextLabel")
    islandText.Parent = island
    islandText.Size = UDim2.fromScale(1, 1)
    islandText.BackgroundTransparency = 1
    islandText.RichText = true
    islandText.Text = '<font color="#FFFFFF">60</font> <font color="#8E8E93">FPS</font>'
    islandText.TextColor3 = C.White
    islandText.Font = Enum.Font.GothamMedium
    islandText.TextSize = 12
    islandText.ZIndex = 901

    local islandButton = Instance.new("TextButton")
    islandButton.Parent = island
    islandButton.Size = UDim2.fromScale(1, 1)
    islandButton.BackgroundTransparency = 1
    islandButton.Text = ""
    islandButton.AutoButtonColor = false
    islandButton.ZIndex = 902

    local fpsFrames, fpsElapsed = 0, 0
    local fpsConnection = RunService.RenderStepped:Connect(function(dt)
        fpsFrames += 1
        fpsElapsed += dt
        if fpsElapsed >= 0.25 then
            local fps = math.max(1, math.floor((fpsFrames / fpsElapsed) + 0.5))
            islandText.Text = string.format('<font color="#FFFFFF">%d</font> <font color="#8E8E93">FPS</font>', fps)
            fpsFrames, fpsElapsed = 0, 0
        end
    end)

    local islandBusy = false
    local function islandJelly()
        if islandBusy then return end
        islandBusy = true
        local t1 = tw(island, TweenInfo.new(0.075, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(134, 39)})
        t1.Completed:Wait()
        local t2 = tw(island, TweenInfo.new(0.085, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.fromOffset(123, 35)})
        t2.Completed:Wait()
        local t3 = tw(island, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(126, 36)})
        t3.Completed:Wait()
        islandBusy = false
    end


    local shell = Instance.new("Frame")
    shell.Name = "Shell"
    shell.Parent = scrgui
    shell.AnchorPoint = Vector2.new(0.5, 0.5)
    shell.Position = UDim2.fromScale(0.5, 0.5)
    shell.Size = UDim2.fromOffset(820, 650)
    shell.BackgroundTransparency = 1
    shell.Visible = false
    shell.ZIndex = 5

    local mainShadow = addShadow(shell, 5, 54, 58, 0.78, false)
    mainShadow.Position = UDim2.new(0.5, 0, 0.5, 6)

    local main = Instance.new("CanvasGroup")
    main.Name = "main"
    main.Parent = shell
    main.Size = UDim2.fromScale(1, 1)
    main.BackgroundColor3 = C.Window
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.GroupTransparency = 1
    main.ZIndex = 10
    main.ClipsDescendants = true
    round(main, 24)


    stroke(main, Color3.fromRGB(42, 42, 44), 0.72, 0.75)

    addTopHighlight(main, 42, 35, 0.18)

    local windowScale = Instance.new("UIScale")
    windowScale.Name = "WindowScale"
    windowScale.Scale = 0.97
    windowScale.Parent = shell

    local SIDEBAR_W = 258
    local TOP_H = 58

    local leftPane = Instance.new("Frame")
    leftPane.Name = "LeftPane"
    leftPane.Parent = main
    leftPane.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
    leftPane.BackgroundColor3 = C.Sidebar
    leftPane.BorderSizePixel = 0
    leftPane.ZIndex = 12

    local leftDivider = Instance.new("Frame")
    leftDivider.Parent = main
    leftDivider.Position = UDim2.new(0, SIDEBAR_W, 0, 0)
    leftDivider.Size = UDim2.new(0, 1, 1, 0)
    leftDivider.BackgroundColor3 = C.Divider
    leftDivider.BackgroundTransparency = 0.38
    leftDivider.BorderSizePixel = 0
    leftDivider.ZIndex = 15

    local contentPane = Instance.new("Frame")
    contentPane.Name = "ContentPane"
    contentPane.Parent = main
    contentPane.Position = UDim2.new(0, SIDEBAR_W + 1, 0, 0)
    contentPane.Size = UDim2.new(1, -(SIDEBAR_W + 1), 1, 0)
    contentPane.BackgroundColor3 = C.Content
    contentPane.BorderSizePixel = 0
    contentPane.ZIndex = 11


    local trafficHost = Instance.new("Frame")
    trafficHost.Parent = leftPane
    trafficHost.Position = UDim2.fromOffset(12, 5)
    trafficHost.Size = UDim2.fromOffset(118, 48)
    trafficHost.BackgroundTransparency = 1
    trafficHost.ZIndex = 20

    local close = trafficLight(trafficHost, 17, Color3.fromRGB(255, 95, 87), "close")
    local minimize = trafficLight(trafficHost, 47, Color3.fromRGB(255, 189, 46), "minimize")
    local resize = trafficLight(trafficHost, 77, Color3.fromRGB(40, 200, 64), "resize")


    local search = Instance.new("Frame")
    search.Name = "search"
    search.Parent = leftPane
    search.Position = UDim2.fromOffset(16, 64)
    search.Size = UDim2.new(1, -32, 0, 36)
    search.BackgroundColor3 = C.Search
    search.BorderSizePixel = 0
    search.ZIndex = 20
    round(search, 18)

    local searchIcon = iconLabel(search, ASSET.Search, 18, Color3.fromRGB(107, 107, 112), 22)
    searchIcon.AnchorPoint = Vector2.new(0, 0.5)
    searchIcon.Position = UDim2.new(0, 12, 0.5, 0)

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "searchtextbox"
    searchBox.Parent = search
    searchBox.Position = UDim2.fromOffset(39, 0)
    searchBox.Size = UDim2.new(1, -48, 1, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.ClearTextOnFocus = false
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search"
    searchBox.PlaceholderColor3 = Color3.fromRGB(118, 118, 123)
    searchBox.TextColor3 = C.Text
    searchBox.TextSize = 15
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ZIndex = 22


    local account = Instance.new("Frame")
    account.Name = "AccountRow"
    account.Parent = leftPane
    account.Position = UDim2.fromOffset(16, 108)
    account.Size = UDim2.new(1, -32, 0, 58)
    account.BackgroundTransparency = 1
    account.ZIndex = 20

    local avatar = Instance.new("ImageLabel")
    avatar.Parent = account
    avatar.AnchorPoint = Vector2.new(0, 0.5)
    avatar.Position = UDim2.new(0, 5, 0.5, 0)
    avatar.Size = UDim2.fromOffset(44, 44)
    avatar.BackgroundColor3 = Color3.fromRGB(208, 208, 212)
    avatar.BorderSizePixel = 0
    avatar.ZIndex = 21
    circle(avatar)
    task.spawn(function()
        pcall(function()
            avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
    end)

    local accountName = Instance.new("TextLabel")
    accountName.Parent = account
    accountName.Position = UDim2.fromOffset(59, 8)
    accountName.Size = UDim2.new(1, -64, 0, 22)
    accountName.BackgroundTransparency = 1
    accountName.Text = LocalPlayer.DisplayName
    accountName.TextColor3 = C.Text
    accountName.TextSize = 16
    accountName.Font = Enum.Font.GothamMedium
    accountName.TextXAlignment = Enum.TextXAlignment.Left
    accountName.ZIndex = 21

    local accountSub = Instance.new("TextLabel")
    accountSub.Parent = account
    accountSub.Position = UDim2.fromOffset(59, 29)
    accountSub.Size = UDim2.new(1, -64, 0, 18)
    accountSub.BackgroundTransparency = 1
    accountSub.Text = "Account"
    accountSub.TextColor3 = C.Secondary
    accountSub.TextSize = 13
    accountSub.Font = Enum.Font.Gotham
    accountSub.TextXAlignment = Enum.TextXAlignment.Left
    accountSub.ZIndex = 21


    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "sidebar"
    sidebar.Parent = leftPane
    sidebar.Position = UDim2.fromOffset(12, 176)
    sidebar.Size = UDim2.new(1, -24, 1, -188)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.Active = true
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.CanvasSize = UDim2.new()
    sidebar.ScrollBarThickness = 2
    sidebar.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 184)
    sidebar.ZIndex = 20

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 3)


    local nav = Instance.new("Frame")
    nav.Name = "Navigation"
    nav.Parent = contentPane
    nav.Position = UDim2.fromOffset(18, 10)
    nav.Size = UDim2.fromOffset(92, 40)
    nav.BackgroundTransparency = 1
    nav.ZIndex = 20

    local function navButton(x, image)
        local b = Instance.new("ImageButton")
        b.Parent = nav
        b.Position = UDim2.fromOffset(x, 0)
        b.Size = UDim2.fromOffset(40, 40)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Image = image
        b.ImageColor3 = Color3.fromRGB(175, 175, 179)
        b.ImageTransparency = 0.02
        b.ScaleType = Enum.ScaleType.Fit
        b.ZIndex = 21
        round(b, 20)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 11)
        pad.PaddingRight = UDim.new(0, 11)
        pad.PaddingTop = UDim.new(0, 11)
        pad.PaddingBottom = UDim.new(0, 11)
        pad.Parent = b
        pressScale(b, 0.92)
        return b
    end

    local backButton = navButton(0, ASSET.ChevronLeft)
    local forwardButton = navButton(44, ASSET.ChevronRight)
    forwardButton.ImageTransparency = 0.45

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = contentPane
    title.Position = UDim2.fromOffset(126, 15)
    title.Size = UDim2.new(1, -144, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = ti or ""
    title.TextColor3 = C.Text
    title.TextSize = 17
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.ZIndex = 20

    local dragRegion = Instance.new("Frame")
    dragRegion.Name = "DragRegion"
    dragRegion.Parent = contentPane
    dragRegion.Position = UDim2.fromOffset(118, 0)
    dragRegion.Size = UDim2.new(1, -118, 0, TOP_H)
    dragRegion.BackgroundTransparency = 1
    dragRegion.Active = true
    dragRegion.ZIndex = 19

    local workarea = Instance.new("Frame")
    workarea.Name = "workarea"
    workarea.Parent = contentPane
    workarea.Position = UDim2.fromOffset(0, TOP_H)
    workarea.Size = UDim2.new(1, 0, 1, -TOP_H)
    workarea.BackgroundColor3 = C.Content
    workarea.BorderSizePixel = 0
    workarea.ClipsDescendants = true
    workarea.ZIndex = 14


    local dragging, dragStart, startPos
    dragRegion.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = shell.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            shell.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)


    local currentMobile = false
    local function applyResponsive()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local v = cam.ViewportSize
        currentMobile = math.min(v.X, v.Y) < 600

        local width = math.min(820, math.max(340, v.X - (currentMobile and 10 or 54)))
        local height = math.min(650, math.max(470, v.Y - (currentMobile and 48 or 92)))
        shell.Size = UDim2.fromOffset(width, height)

        local side = math.clamp(math.floor(width * 0.315), currentMobile and 126 or 210, 258)
        SIDEBAR_W = side
        leftPane.Size = UDim2.new(0, side, 1, 0)
        leftDivider.Position = UDim2.new(0, side, 0, 0)
        contentPane.Position = UDim2.new(0, side + 1, 0, 0)
        contentPane.Size = UDim2.new(1, -(side + 1), 1, 0)

        if currentMobile then
            search.Position = UDim2.fromOffset(10, 58)
            search.Size = UDim2.new(1, -20, 0, 36)
            account.Position = UDim2.fromOffset(10, 101)
            account.Size = UDim2.new(1, -20, 0, 54)
            avatar.Size = UDim2.fromOffset(38, 38)
            accountName.Position = UDim2.fromOffset(50, 6)
            accountSub.Position = UDim2.fromOffset(50, 27)
            sidebar.Position = UDim2.fromOffset(8, 162)
            sidebar.Size = UDim2.new(1, -16, 1, -170)
            title.Visible = false
            nav.Position = UDim2.fromOffset(10, 8)
        else
            search.Position = UDim2.fromOffset(16, 64)
            search.Size = UDim2.new(1, -32, 0, 36)
            account.Position = UDim2.fromOffset(16, 108)
            account.Size = UDim2.new(1, -32, 0, 58)
            avatar.Size = UDim2.fromOffset(44, 44)
            accountName.Position = UDim2.fromOffset(59, 8)
            accountSub.Position = UDim2.fromOffset(59, 29)
            sidebar.Position = UDim2.fromOffset(12, 176)
            sidebar.Size = UDim2.new(1, -24, 1, -188)
            title.Visible = true
            nav.Position = UDim2.fromOffset(18, 10)
        end
    end


    local visible = not (workspace.CurrentCamera and math.min(workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y) < 600)
    local animating = false

    local function showWindow()
        if animating or shell.Visible then return end
        animating = true
        shell.Visible = true
        main.GroupTransparency = 0.18
        windowScale.Scale = 0.955
        shell.Position = UDim2.new(0.5, 0, 0.5, 14)
        mainShadow.ImageTransparency = 0.94

        tw(shell, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.5)})
        tw(main, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
        tw(mainShadow, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.78})
        local t = tw(windowScale, TweenInfo.new(0.44, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        t.Completed:Wait()
        animating = false
    end

    local function hideWindow()
        if animating or not shell.Visible then return end
        animating = true
        tw(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 0.15})
        tw(mainShadow, TweenInfo.new(0.18), {ImageTransparency = 0.96})
        tw(shell, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 12)})
        local t = tw(windowScale, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.97})
        t.Completed:Wait()
        shell.Visible = false
        shell.Position = UDim2.fromScale(0.5, 0.5)
        main.GroupTransparency = 0
        windowScale.Scale = 1
        animating = false
    end

    local window = {}

    function window:ToggleVisible()
        visible = not shell.Visible
        if visible then showWindow() else hideWindow() end
    end

    islandButton.Activated:Connect(function()
        task.spawn(islandJelly)
        if not shell.Visible then
            visible = true
            showWindow()
        else

            visible = false
            hideWindow()
        end
    end)

    minimize.Activated:Connect(function()
        visible = false
        hideWindow()
    end)

    close.Activated:Connect(function()
        if fpsConnection then fpsConnection:Disconnect() end
        scrgui:Destroy()
    end)

    local greenCallback
    function window:GreenButton(callback)
        greenCallback = callback
    end

    local zoomed = false
    local savedSize, savedPosition
    resize.Activated:Connect(function()
        if greenCallback then
            task.spawn(greenCallback)
            return
        end
        if animating then return end
        if not zoomed then
            savedSize, savedPosition = shell.Size, shell.Position
            local cam = workspace.CurrentCamera
            if cam then
                local v = cam.ViewportSize
                tw(shell, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(math.max(340, v.X - 24), math.max(470, v.Y - 54)),
                    Position = UDim2.fromScale(0.5, 0.5),
                })
            end
        else
            tw(shell, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = savedSize,
                Position = savedPosition,
            })
        end
        zoomed = not zoomed
    end)

    if visiblekey then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == visiblekey then
                window:ToggleVisible()
            end
        end)
    end


    if dosplash then
        task.spawn(function()
            local holder = Instance.new("Frame")
            holder.Parent = scrgui
            holder.AnchorPoint = Vector2.new(0.5, 0.5)
            holder.Position = UDim2.fromScale(0.5, 0.5)
            holder.Size = UDim2.fromOffset(148, 148)
            holder.BackgroundTransparency = 1
            holder.ZIndex = 800

            addShadow(holder, 800, 40, 40, 0.83, false)

            local splash = Instance.new("CanvasGroup")
            splash.Parent = holder
            splash.Size = UDim2.fromScale(1, 1)
            splash.BackgroundColor3 = C.White
            splash.GroupTransparency = 1
            splash.ZIndex = 801
            round(splash, 30)
            stroke(splash, C.Black, 0.88, 0.8)
            addTopHighlight(splash, 30, 803, 0.25)

            local ic = iconLabel(splash, ASSET.Settings, 58, Color3.fromRGB(122, 122, 127), 804)
            ic.AnchorPoint = Vector2.new(0.5, 0.5)
            ic.Position = UDim2.fromScale(0.5, 0.5)

            local sc = Instance.new("UIScale")
            sc.Scale = 0.86
            sc.Parent = splash
            tw(splash, TweenInfo.new(0.18), {GroupTransparency = 0})
            tw(sc, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
            task.wait(0.85)
            tw(splash, TweenInfo.new(0.18), {GroupTransparency = 1})
            task.wait(0.2)
            holder:Destroy()
        end)
    end


    local sectionRecords = {}
    local selectedIndex = 0
    local history = {}
    local historyPos = 0

    local function nameMatches(rec, q)
        return q == "" or string.find(string.lower(rec.name or ""), q, 1, true) ~= nil
    end

    local function ancestorsExpanded(rec)
        local p = rec.parent
        while p do
            if p.expanded == false then return false end
            p = p.parent
        end
        return true
    end

    local function applyFilter()
        local q = string.lower(searchBox.Text)

        for _, rec in ipairs(sectionRecords) do
            local visible = rec.sidebarVisible ~= false

            if visible then
                if q == "" then
                    if rec.isSubpage then
                        visible = ancestorsExpanded(rec)
                    end
                else
                    local own = nameMatches(rec, q)
                    local childMatch = false
                    for _, child in ipairs(rec.children or {}) do
                        if child.sidebarVisible ~= false and nameMatches(child, q) then
                            childMatch = true
                            break
                        end
                    end
                    visible = own or childMatch
                end
            end

            rec.button.Visible = visible
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)


    local activeModal
    local function showModal(titleText, bodyText, specs, icon)
        if activeModal then return "Already visible" end

        local overlay = Instance.new("Frame")
        overlay.Name = "ModalOverlay"
        overlay.Parent = scrgui
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(92, 92, 98)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 950

        local holder = Instance.new("Frame")
        holder.Parent = overlay
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.Position = UDim2.fromScale(0.5, 0.5)
        holder.Size = UDim2.fromOffset(390, 270 + math.max(0, #specs - 1) * 46)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 951

        addShadow(holder, 951, 54, 58, 0.80, false)

        local card = Instance.new("CanvasGroup")
        card.Parent = holder
        card.Size = UDim2.fromScale(1, 1)
        card.BackgroundColor3 = Color3.fromRGB(246, 248, 252)
        card.BackgroundTransparency = 0.86
        card.BorderSizePixel = 0
        card.GroupTransparency = 1
        card.ZIndex = 952
        card.ClipsDescendants = true
        round(card, 26)
        local modalGlass, modalFrost, modalGlassCtl = attachLiquidGlass(card, "modal", 953, 26, 1, 1)
        modalGlassCtl:SetShown(false)
        modalGlassCtl.HideObject = overlay
        stroke(card, C.Black, 0.82, 0.8)
        addTopHighlight(card, 36, 954, 0.12)

        local cardScale = Instance.new("UIScale")
        cardScale.Scale = 0.90
        cardScale.Parent = card

        local iconHolder = Instance.new("Frame")
        iconHolder.Parent = card
        iconHolder.AnchorPoint = Vector2.new(0.5, 0)
        iconHolder.Position = UDim2.new(0.5, 0, 0, 22)
        iconHolder.Size = UDim2.fromOffset(62, 62)
        iconHolder.BackgroundColor3 = Color3.fromRGB(235, 235, 237)
        iconHolder.BorderSizePixel = 0
        iconHolder.ZIndex = 955
        round(iconHolder, 17)
        addShadow(iconHolder, 954, 18, 18, 0.91, true)

        local modalIcon = iconLabel(iconHolder, icon and icon ~= "" and icon or ASSET.Settings, 38, Color3.fromRGB(132, 132, 137), 956)
        modalIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        modalIcon.Position = UDim2.fromScale(0.5, 0.5)

        local mt = Instance.new("TextLabel")
        mt.Parent = card
        mt.Position = UDim2.fromOffset(28, 98)
        mt.Size = UDim2.new(1, -56, 0, 30)
        mt.BackgroundTransparency = 1
        mt.Text = titleText or "Notice"
        mt.TextColor3 = C.Text
        mt.TextSize = 21
        mt.Font = Enum.Font.GothamSemibold
        mt.TextXAlignment = Enum.TextXAlignment.Left
        mt.ZIndex = 955

        local mb = Instance.new("TextLabel")
        mb.Parent = card
        mb.Position = UDim2.fromOffset(28, 138)
        mb.Size = UDim2.new(1, -56, 0, 58)
        mb.BackgroundTransparency = 1
        mb.Text = bodyText or ""
        mb.TextColor3 = C.Text
        mb.TextSize = 15
        mb.Font = Enum.Font.Gotham
        mb.TextWrapped = true
        mb.TextXAlignment = Enum.TextXAlignment.Left
        mb.TextYAlignment = Enum.TextYAlignment.Top
        mb.ZIndex = 955

        local actions = Instance.new("Frame")
        actions.Parent = card
        actions.AnchorPoint = Vector2.new(0.5, 1)
        actions.Position = UDim2.new(0.5, 0, 1, -20)
        actions.Size = UDim2.new(1, -40, 0, math.max(46, #specs * 46))
        actions.BackgroundTransparency = 1
        actions.ZIndex = 955

        local al = Instance.new("UIListLayout")
        al.Parent = actions
        al.FillDirection = Enum.FillDirection.Vertical
        al.HorizontalAlignment = Enum.HorizontalAlignment.Center
        al.VerticalAlignment = Enum.VerticalAlignment.Bottom
        al.Padding = UDim.new(0, 8)

        local function dismiss(cb)
            tw(overlay, TweenInfo.new(0.16), {BackgroundTransparency = 1})
            tw(card, TweenInfo.new(0.14), {GroupTransparency = 1})
            local t = tw(cardScale, TweenInfo.new(0.14), {Scale = 0.96})
            t.Completed:Wait()
            activeModal = nil
            overlay:Destroy()
            if cb then task.spawn(cb) end
        end

        for idx, spec in ipairs(specs) do
            local b = Instance.new("TextButton")
            b.Parent = actions
            b.Size = UDim2.new(1, 0, 0, 46)
            b.BackgroundColor3 = idx == 1 and C.Blue or Color3.fromRGB(222, 222, 225)
            b.BorderSizePixel = 0
            b.Text = spec.text or "OK"
            b.TextColor3 = idx == 1 and C.White or C.Text
            b.TextSize = 16
            b.Font = idx == 1 and Enum.Font.GothamSemibold or Enum.Font.GothamMedium
            b.AutoButtonColor = false
            b.ZIndex = 956
            round(b, 23)
            pressScale(b, 0.975)
            b.Activated:Connect(function() task.spawn(dismiss, spec.callback) end)
        end

        activeModal = overlay
        overlay.Visible = false


        modalGlassCtl:Refresh(function(ok)
            if not overlay.Parent then return end
            if ok then
                modalGlassCtl:SetShown(true, 0.04, 0.91)
            end

            overlay.Visible = true
            overlay.BackgroundTransparency = 1
            card.GroupTransparency = 1
            cardScale.Scale = 0.90

            tw(overlay, TweenInfo.new(0.18), {BackgroundTransparency = 0.56})
            tw(card, TweenInfo.new(0.18), {GroupTransparency = 0})
            tw(cardScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        end)
    end

    function window:Notify(txt1, txt2, b1, icon, callback)
        return showModal(txt1, txt2, {{text = b1 or "OK", callback = callback}}, icon)
    end

    function window:Notify2(txt1, txt2, b1, b2, icon, callback, callback2)
        return showModal(txt1, txt2, {
            {text = b1 or "OK", callback = callback},
            {text = b2 or "Cancel", callback = callback2},
        }, icon)
    end

    function window:TempNotify(t1, t2, icon)
        local holder = Instance.new("Frame")
        holder.Name = "tempnotif"
        holder.Parent = scrgui
        holder.AnchorPoint = Vector2.new(1, 0)
        holder.Position = UDim2.new(1, 28, 0, 62)
        holder.Size = UDim2.fromOffset(currentMobile and 300 or 380, 82)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 700

        addShadow(holder, 700, 40, 40, 0.84, false)

        local toast = Instance.new("CanvasGroup")
        toast.Parent = holder
        toast.Size = UDim2.fromScale(1, 1)
        toast.BackgroundColor3 = Color3.fromRGB(246, 249, 255)
        toast.BackgroundTransparency = 0.96
        toast.GroupTransparency = 0
        toast.BorderSizePixel = 0
        toast.ZIndex = 701
        toast.ClipsDescendants = true
        round(toast, 17)
        local toastGlass, toastFrost, toastGlassCtl = attachLiquidGlass(toast, "toast", 702, 17, 1, 1)
        toastGlassCtl:SetShown(false)
        toastGlassCtl.HideObject = holder
        stroke(toast, C.Black, 0.86, 0.8)
        addTopHighlight(toast, 26, 705, 0.15)

        local x = 16
        if icon and icon ~= "" then
            local ih = Instance.new("Frame")
            ih.Parent = toast
            ih.AnchorPoint = Vector2.new(0, 0.5)
            ih.Position = UDim2.new(0, 14, 0.5, 0)
            ih.Size = UDim2.fromOffset(46, 46)
            ih.BackgroundColor3 = Color3.fromRGB(232, 232, 235)
            ih.BorderSizePixel = 0
            ih.ZIndex = 703
            round(ih, 12)
            local ii = iconLabel(ih, icon, 28, Color3.fromRGB(90, 90, 94), 704)
            ii.AnchorPoint = Vector2.new(0.5, 0.5)
            ii.Position = UDim2.fromScale(0.5, 0.5)
            x = 72
        end

        local a = Instance.new("TextLabel")
        a.Parent = toast
        a.Position = UDim2.fromOffset(x, 13)
        a.Size = UDim2.new(1, -(x + 12), 0, 22)
        a.BackgroundTransparency = 1
        a.Text = t1 or ""
        a.TextColor3 = C.Text
        a.TextSize = 16
        a.Font = Enum.Font.GothamSemibold
        a.TextXAlignment = Enum.TextXAlignment.Left
        a.ZIndex = 703

        local b = Instance.new("TextLabel")
        b.Parent = toast
        b.Position = UDim2.fromOffset(x, 38)
        b.Size = UDim2.new(1, -(x + 12), 0, 30)
        b.BackgroundTransparency = 1
        b.Text = t2 or ""
        b.TextColor3 = C.Secondary
        b.TextSize = 13
        b.Font = Enum.Font.Gotham
        b.TextWrapped = true
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.TextYAlignment = Enum.TextYAlignment.Top
        b.ZIndex = 703

        local finalToastPosition = UDim2.new(1, -12, 0, 62)
        holder.Position = finalToastPosition
        holder.Visible = false


        toastGlassCtl:Refresh(function(ok)
            if not holder.Parent then return end
            if ok then
                toastGlassCtl:SetShown(true, 0.03, 0.93)
            end

            holder.Position = UDim2.new(1, 28, 0, 62)
            holder.Visible = true
            tw(holder, TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = finalToastPosition
            })
        end)

        task.delay(4, function()
            if holder.Parent then
                tw(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 30, 0, 62)})
                task.wait(0.24)
                if holder.Parent then holder:Destroy() end
            end
        end)
    end


    local defaultIcons = {
        ASSET.Settings, ASSET.Wifi, ASSET.Bluetooth, ASSET.Network, ASSET.Battery,
        ASSET.Accessibility, ASSET.Appearance, ASSET.Display, ASSET.Lock, ASSET.Sliders,
        ASSET.Layout, ASSET.Cloud,
    }

    function window:Divider(name)
        local d = Instance.new("TextLabel")
        d.Name = "sidebardivider"
        d.Parent = sidebar
        d.Size = UDim2.new(1, -10, 0, 24)
        d.BackgroundTransparency = 1
        d.Text = name
        d.TextColor3 = C.Secondary
        d.TextSize = 12
        d.Font = Enum.Font.GothamMedium
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextYAlignment = Enum.TextYAlignment.Bottom
        d.ZIndex = 21
        return d
    end

    local function updateSelection()
        for idx, rec in ipairs(sectionRecords) do
            local selected = idx == selectedIndex
            tw(rec.button, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = selected and C.Blue or C.Sidebar,
                BackgroundTransparency = selected and 0 or 1,
            })
            tw(rec.label, TweenInfo.new(0.16), {TextColor3 = selected and C.White or C.Text})
            tw(rec.icon, TweenInfo.new(0.16), {ImageColor3 = selected and C.White or Color3.fromRGB(88, 88, 93)})
            if rec.iconBg then
                tw(rec.iconBg, TweenInfo.new(0.16), {
                    BackgroundColor3 = selected and Color3.fromRGB(255,255,255) or Color3.fromRGB(226,226,229),
                    BackgroundTransparency = selected and 0.82 or 0,
                })
            end
            rec.page.Visible = selected
            if selected then
                rec.page.GroupTransparency = 1
                rec.page.Position = UDim2.fromOffset(7, 0)
                tw(rec.page, TweenInfo.new(0.20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    GroupTransparency = 0,
                    Position = UDim2.fromOffset(0, 0),
                })
            end
        end
    end

    local function updateHistoryButtons()
        local canBack = historyPos > 1
        local canForward = historyPos > 0 and historyPos < #history
        tw(backButton, TweenInfo.new(0.12), {
            ImageTransparency = canBack and 0.02 or 0.58,
            ImageColor3 = canBack and Color3.fromRGB(92,92,97) or Color3.fromRGB(175,175,179),
        })
        tw(forwardButton, TweenInfo.new(0.12), {
            ImageTransparency = canForward and 0.02 or 0.58,
            ImageColor3 = canForward and Color3.fromRGB(92,92,97) or Color3.fromRGB(175,175,179),
        })
    end

    local function navigateTo(index, pushHistory)
        local rec = sectionRecords[index]
        if not rec then return false end

        if pushHistory ~= false then
            if history[historyPos] ~= index then
                while #history > historyPos do
                    table.remove(history)
                end
                table.insert(history, index)
                historyPos = #history
            end
        end

        selectedIndex = index
        title.Text = rec.name or ""
        updateSelection()
        updateHistoryButtons()
        return true
    end

    local function resolvePage(target)
        if type(target) == "table" and type(target.Select) == "function" then
            return target
        end
        if type(target) == "string" then
            for _, rec in ipairs(sectionRecords) do
                if rec.name == target and rec.section then
                    return rec.section
                end
            end
        end
        return nil
    end

    function window:GoTo(target)
        local page = resolvePage(target)
        if page then
            page:Select()
            return true
        end
        return false
    end

    function window:Section(name, customIcon, subtitle)
        local index = #sectionRecords + 1
        local image = customIcon or defaultIcons[((index - 1) % #defaultIcons) + 1]

        local sb = Instance.new("TextButton")
        sb.Name = "sidebar2"
        sb.Parent = sidebar
        sb.Size = UDim2.new(1, -4, 0, currentMobile and 42 or 38)
        sb.LayoutOrder = index * 100
        sb.BackgroundColor3 = C.Sidebar
        sb.BackgroundTransparency = 1
        sb.BorderSizePixel = 0
        sb.Text = ""
        sb.AutoButtonColor = false
        sb.ZIndex = 21
        round(sb, 9)

        local iconBg = Instance.new("Frame")
        iconBg.Parent = sb
        iconBg.AnchorPoint = Vector2.new(0, 0.5)
        iconBg.Position = UDim2.new(0, 7, 0.5, 0)
        iconBg.Size = UDim2.fromOffset(26, 26)
        iconBg.BackgroundColor3 = Color3.fromRGB(226, 226, 229)
        iconBg.BorderSizePixel = 0
        iconBg.ZIndex = 22
        round(iconBg, 7)

        local si = iconLabel(iconBg, image, 18, Color3.fromRGB(88, 88, 93), 23)
        si.AnchorPoint = Vector2.new(0.5, 0.5)
        si.Position = UDim2.fromScale(0.5, 0.5)

        local sl = Instance.new("TextLabel")
        sl.Parent = sb
        sl.Position = UDim2.fromOffset(42, 0)
        sl.Size = UDim2.new(1, -48, 1, 0)
        sl.BackgroundTransparency = 1
        sl.Text = name
        sl.TextColor3 = C.Text
        sl.TextSize = currentMobile and 13 or 15
        sl.Font = Enum.Font.GothamMedium
        sl.TextXAlignment = Enum.TextXAlignment.Left
        sl.TextTruncate = Enum.TextTruncate.AtEnd
        sl.ZIndex = 23

        pressScale(sb, 0.985)

        local page = Instance.new("CanvasGroup")
        page.Name = "Page"
        page.Parent = workarea
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.GroupTransparency = 1
        page.Visible = false
        page.ZIndex = 15

        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "workareamain"
        scroll.Parent = page
        scroll.Position = UDim2.fromOffset(currentMobile and 10 or 20, 8)
        scroll.Size = UDim2.new(1, currentMobile and -20 or -40, 1, -16)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Active = true
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new()
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 184)
        scroll.ZIndex = 16

        local layout = Instance.new("UIListLayout")
        layout.Parent = scroll
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)


        local header = Instance.new("Frame")
        header.Name = "SectionHeader"
        header.Parent = scroll
        header.Size = UDim2.new(1, -4, 0, currentMobile and 106 or 130)
        header.BackgroundColor3 = Color3.fromRGB(246, 246, 247)
        header.BorderSizePixel = 0
        header.ZIndex = 17
        round(header, 16)

        local hiBg = Instance.new("Frame")
        hiBg.Parent = header
        hiBg.AnchorPoint = Vector2.new(0.5, 0)
        hiBg.Position = UDim2.new(0.5, 0, 0, 18)
        hiBg.Size = UDim2.fromOffset(currentMobile and 46 or 56, currentMobile and 46 or 56)
        hiBg.BackgroundColor3 = Color3.fromRGB(176, 176, 181)
        hiBg.BorderSizePixel = 0
        hiBg.ZIndex = 18
        round(hiBg, 13)
        addShadow(hiBg, 17, 16, 16, 0.92, true)

        local hi = iconLabel(hiBg, image, currentMobile and 28 or 34, C.White, 19)
        hi.AnchorPoint = Vector2.new(0.5, 0.5)
        hi.Position = UDim2.fromScale(0.5, 0.5)

        local ht = Instance.new("TextLabel")
        ht.Parent = header
        ht.Position = UDim2.new(0, 16, 0, currentMobile and 66 or 78)
        ht.Size = UDim2.new(1, -32, 0, 28)
        ht.BackgroundTransparency = 1
        ht.Text = name
        ht.TextColor3 = C.Text
        ht.TextSize = currentMobile and 20 or 24
        ht.Font = Enum.Font.GothamSemibold
        ht.TextXAlignment = Enum.TextXAlignment.Center
        ht.ZIndex = 18

        local hs = Instance.new("TextLabel")
        hs.Parent = header
        hs.Position = UDim2.new(0, 16, 0, currentMobile and 88 or 106)
        hs.Size = UDim2.new(1, -32, 0, 18)
        hs.BackgroundTransparency = 1
        hs.Text = subtitle or "Manage settings and preferences."
        hs.TextColor3 = C.Secondary
        hs.TextSize = currentMobile and 11 or 13
        hs.Font = Enum.Font.Gotham
        hs.TextXAlignment = Enum.TextXAlignment.Center
        hs.TextTruncate = Enum.TextTruncate.AtEnd
        hs.ZIndex = 18

        local rec = {
            name = name,
            index = index,
            button = sb,
            label = sl,
            icon = si,
            iconBg = iconBg,
            page = page,
            scroll = scroll,
            sidebarVisible = true,
            isSubpage = false,
            parent = nil,
            children = {},
            expanded = true,
            depth = 0,
        }
        table.insert(sectionRecords, rec)

        local sec = {}
        sec._rec = rec
        rec.section = sec

        function sec:Select()
            navigateTo(index, true)
        end


        function sec:Create(childName, showInSidebar, childIcon, childSubtitle)
            local show = true
            if type(showInSidebar) == "table" then
                local opts = showInSidebar
                show = opts.ShowInSidebar ~= false
                childIcon = opts.Icon or childIcon
                childSubtitle = opts.Subtitle or childSubtitle
            elseif type(showInSidebar) == "boolean" then
                show = showInSidebar
            elseif showInSidebar == nil then
                show = true
            end

            local child = window:Section(childName, childIcon or ASSET.ChevronRight, childSubtitle)
            local childRec = child._rec
            if not childRec then return child end

            childRec.isSubpage = true
            childRec.parent = rec
            childRec.depth = (rec.depth or 0) + 1
            childRec.sidebarVisible = show
            table.insert(rec.children, childRec)


            childRec.button.LayoutOrder = rec.button.LayoutOrder + #rec.children

            local indent = 18 * childRec.depth
            childRec.button.Size = UDim2.new(1, -(4 + indent), 0, currentMobile and 38 or 34)
            childRec.iconBg.Size = UDim2.fromOffset(20, 20)
            childRec.iconBg.Position = UDim2.new(0, 7 + indent, 0.5, 0)
            childRec.icon.Size = UDim2.fromOffset(14, 14)
            childRec.label.Position = UDim2.fromOffset(34 + indent, 0)
            childRec.label.Size = UDim2.new(1, -(40 + indent), 1, 0)
            childRec.label.TextSize = currentMobile and 12 or 13
            childRec.label.Font = Enum.Font.Gotham


            if show and not rec.treeChevron then
                local chevron = Instance.new("ImageButton")
                chevron.Name = "TreeChevron"
                chevron.Parent = rec.button
                chevron.AnchorPoint = Vector2.new(0, 0.5)
                chevron.Position = UDim2.new(0, 1, 0.5, 0)
                chevron.Size = UDim2.fromOffset(22, 22)
                chevron.BackgroundTransparency = 1
                chevron.Image = ASSET.ChevronRight
                chevron.ImageColor3 = Color3.fromRGB(126, 126, 131)
                chevron.ImageTransparency = 0.05
                chevron.ScaleType = Enum.ScaleType.Fit
                chevron.Rotation = rec.expanded and 90 or 0
                chevron.ZIndex = 30
                local cp = Instance.new("UIPadding")
                cp.PaddingLeft = UDim.new(0, 6)
                cp.PaddingRight = UDim.new(0, 6)
                cp.PaddingTop = UDim.new(0, 6)
                cp.PaddingBottom = UDim.new(0, 6)
                cp.Parent = chevron
                rec.treeChevron = chevron


                rec.iconBg.Position = UDim2.new(0, 25, 0.5, 0)
                rec.label.Position = UDim2.fromOffset(60, 0)
                rec.label.Size = UDim2.new(1, -66, 1, 0)

                chevron.Activated:Connect(function()
                    rec.SuppressSelectUntil = os.clock() + 0.12
                    rec.expanded = not rec.expanded
                    tw(chevron, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Rotation = rec.expanded and 90 or 0,
                    })
                    applyFilter()
                end)
            end

            applyFilter()
            return child
        end
        sec.CreatePage = sec.Create


        function sec:GoTo(text, target, buttonIcon)
            return sec:Button(text, function()
                local targetPage = resolvePage(target)
                if targetPage then
                    targetPage:Select()
                end
            end, buttonIcon)
        end
        sec.Navigate = sec.GoTo

        function sec:Divider(text)
            local d = Instance.new("TextLabel")
            d.Parent = scroll
            d.Size = UDim2.new(1, -12, 0, 30)
            d.BackgroundTransparency = 1
            d.Text = text
            d.TextColor3 = C.Text
            d.TextSize = currentMobile and 15 or 17
            d.Font = Enum.Font.GothamSemibold
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.TextYAlignment = Enum.TextYAlignment.Bottom
            d.ZIndex = 17
            return d
        end

        local function makeRow(rowName, h)
            local row = Instance.new("Frame")
            row.Name = rowName
            row.Parent = scroll
            row.Size = UDim2.new(1, -4, 0, h or 52)
            row.BackgroundColor3 = C.Card
            row.BorderSizePixel = 0
            row.ZIndex = 17
            round(row, 14)
            return row
        end

        function sec:Button(text, callback, buttonIcon)
            local row = makeRow("button", 52)
            local hit = Instance.new("TextButton")
            hit.Parent = row
            hit.Size = UDim2.fromScale(1, 1)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.AutoButtonColor = false
            hit.ZIndex = 20

            local x = 16
            if buttonIcon then
                local bi = iconLabel(row, buttonIcon, 22, Color3.fromRGB(120, 120, 125), 19)
                bi.AnchorPoint = Vector2.new(0, 0.5)
                bi.Position = UDim2.new(0, 14, 0.5, 0)
                x = 48
            end

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(x, 0)
            l.Size = UDim2.new(1, -(x + 42), 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            local ch = iconLabel(row, ASSET.ChevronRight, 18, Color3.fromRGB(174, 174, 178), 18)
            ch.AnchorPoint = Vector2.new(1, 0.5)
            ch.Position = UDim2.new(1, -14, 0.5, 0)

            hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    tw(row, TweenInfo.new(0.07), {BackgroundColor3 = C.CardPressed})
                end
            end)
            hit.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    tw(row, TweenInfo.new(0.16), {BackgroundColor3 = C.Card})
                end
            end)
            if callback then hit.Activated:Connect(callback) end
            return row
        end

        function sec:Label(text)
            local row = makeRow("label", 48)
            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(16, 0)
            l.Size = UDim2.new(1, -32, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Secondary
            l.TextSize = currentMobile and 13 or 15
            l.Font = Enum.Font.Gotham
            l.TextWrapped = true
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18
            return l
        end

        function sec:Switch(text, defaultmode, callback)
            local mode = defaultmode == true
            local row = makeRow("toggleswitch", 54)

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(16, 0)
            l.Size = UDim2.new(1, -102, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18


            local hit = Instance.new("TextButton")
            hit.Parent = row
            hit.AnchorPoint = Vector2.new(1, 0.5)
            hit.Position = UDim2.new(1, -8, 0.5, 0)
            hit.Size = UDim2.fromOffset(78, 64)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.AutoButtonColor = false
            hit.ZIndex = 21

            local track = Instance.new("Frame")
            track.Parent = hit
            track.AnchorPoint = Vector2.new(0.5, 0.5)
            track.Position = UDim2.fromScale(0.5, 0.5)
            track.Size = UDim2.fromOffset(51, 31)
            track.BackgroundColor3 = mode and C.Blue or C.SwitchOff
            track.BorderSizePixel = 0
            track.ZIndex = 22
            circle(track)


            local knobHolder = Instance.new("Frame")
            knobHolder.Parent = track
            knobHolder.AnchorPoint = Vector2.new(0.5, 0.5)
            knobHolder.Position = mode and UDim2.new(1, -15.5, 0.5, 0) or UDim2.new(0, 15.5, 0.5, 0)
            knobHolder.Size = UDim2.fromOffset(27, 27)
            knobHolder.BackgroundTransparency = 1
            knobHolder.ZIndex = 23

            local knobShadow = addShadow(knobHolder, 23, 12, 12, 0.82, true)

            local knob = Instance.new("Frame")
            knob.Parent = knobHolder
            knob.Size = UDim2.fromScale(1, 1)
            knob.BackgroundColor3 = C.White
            knob.BackgroundTransparency = 0
            knob.BorderSizePixel = 0
            knob.ZIndex = 24
            knob.ClipsDescendants = true
            circle(knob)


            local knobGlass, knobFrost, knobGlassCtl = attachLiquidGlass(knob, "knob", 25, 999, 1, 1)
            knobGlassCtl:SetShown(false)
            knobGlassCtl.HideObject = knobHolder

            local knobDark = stroke(knob, Color3.fromRGB(22, 22, 24), 0.92, 0.8)
            local knobLight = stroke(knob, C.White, 1, 1)

            local knobScale = Instance.new("UIScale")
            knobScale.Scale = 1
            knobScale.Parent = knobHolder

            local hovering = false
            local jellyToken = 0

            local function setTrack(animate)
                local info = TweenInfo.new(animate and 0.18 or 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                tw(track, info, {BackgroundColor3 = mode and C.Blue or C.SwitchOff})
                tw(knobHolder, TweenInfo.new(animate and 0.24 or 0, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = mode and UDim2.new(1, -15.5, 0.5, 0) or UDim2.new(0, 15.5, 0.5, 0)
                })
            end

            local function showNormalBall(animate)
                local info = TweenInfo.new(animate and 0.16 or 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                tw(knob, info, {BackgroundTransparency = 0})
                tw(knobDark, info, {Transparency = 0.92})
                tw(knobLight, info, {Transparency = 1})
                tw(knobShadow, info, {ImageTransparency = 0.82})
                tw(knobGlass, info, {ImageTransparency = 1})
                tw(knobFrost, info, {BackgroundTransparency = 1})
            end

            local function showLiquidBall()
                if not hovering or not knob.Parent then return end


                tw(knob, TweenInfo.new(0.13, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })
                tw(knobDark, TweenInfo.new(0.13), {Transparency = 0.72})
                tw(knobLight, TweenInfo.new(0.13), {Transparency = 0.24})
                tw(knobShadow, TweenInfo.new(0.13), {ImageTransparency = 0.86})
                tw(knobGlass, TweenInfo.new(0.14), {ImageTransparency = 0.02})
                tw(knobFrost, TweenInfo.new(0.14), {BackgroundTransparency = 0.88})
            end

            local function startHoverJelly()
                jellyToken += 1
                local token = jellyToken


                showLiquidBall()

                task.spawn(function()


                    local a = tw(knobScale, TweenInfo.new(0.070, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.32})
                    a.Completed:Wait()
                    if token ~= jellyToken or not hovering then return end

                    local b = tw(knobScale, TweenInfo.new(0.080, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Scale = 1.20})
                    b.Completed:Wait()
                    if token ~= jellyToken or not hovering then return end

                    local c = tw(knobScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.25})
                    c.Completed:Wait()
                    if token ~= jellyToken or not hovering then return end


                    knobGlassCtl:Refresh(function(ok)
                        if token ~= jellyToken or not hovering then return end
                        if ok then showLiquidBall() end
                    end)
                end)
            end

            local function endHover()
                jellyToken += 1
                showNormalBall(true)
                tw(knobScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
            end

            hit.MouseEnter:Connect(function()
                if hovering then return end
                hovering = true
                startHoverJelly()
            end)

            hit.MouseLeave:Connect(function()
                if not hovering then return end
                hovering = false
                endHover()
            end)

            hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and not hovering then
                    hovering = true
                    startHoverJelly()
                end
            end)

            hit.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    task.delay(0.12, function()
                        if hovering then
                            hovering = false
                            endHover()
                        end
                    end)
                end
            end)

            hit.Activated:Connect(function()
                mode = not mode


                knobGlassCtl:MarkDirty()
                setTrack(true)

                if hovering then
                    task.delay(0.20, function()
                        if hovering then
                            knobGlassCtl:Refresh(function(ok)
                                if ok and hovering then showLiquidBall() end
                            end)
                        end
                    end)
                end

                if callback then callback(mode) end
            end)

            setTrack(false)
            showNormalBall(false)
            return row
        end

        function sec:Dropdown(text, options, defaultValue, callback)
            options = options or {}
            local current = defaultValue or options[1] or "Select"
            local row = makeRow("dropdown", 54)

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(16, 0)
            l.Size = UDim2.new(0.42, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            local trigger = Instance.new("TextButton")
            trigger.Parent = row
            trigger.AnchorPoint = Vector2.new(1, 0.5)
            trigger.Position = UDim2.new(1, -10, 0.5, 0)
            trigger.Size = UDim2.new(0.52, 0, 0, 36)
            trigger.BackgroundColor3 = C.White
            trigger.BorderSizePixel = 0
            trigger.Text = ""
            trigger.AutoButtonColor = false
            trigger.ZIndex = 20
            round(trigger, 10)
            stroke(trigger, C.Black, 0.88, 0.8)
            addTopHighlight(trigger, 16, 22, 0.24)

            local vl = Instance.new("TextLabel")
            vl.Parent = trigger
            vl.Position = UDim2.fromOffset(12, 0)
            vl.Size = UDim2.new(1, -36, 1, 0)
            vl.BackgroundTransparency = 1
            vl.Text = tostring(current)
            vl.TextColor3 = C.Text
            vl.TextSize = 14
            vl.Font = Enum.Font.Gotham
            vl.TextXAlignment = Enum.TextXAlignment.Left
            vl.ZIndex = 21

            local chevron = iconLabel(trigger, ASSET.ChevronDown, 16, C.Secondary, 21)
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position = UDim2.new(1, -9, 0.5, 0)

            local menuHolder = Instance.new("Frame")
            menuHolder.Parent = scrgui
            menuHolder.Size = UDim2.fromOffset(220, math.max(44, #options * 38 + 10))
            menuHolder.BackgroundTransparency = 1
            menuHolder.Visible = false
            menuHolder.ZIndex = 980

            addShadow(menuHolder, 980, 44, 46, 0.78, false)

            local menu = Instance.new("CanvasGroup")
            menu.Parent = menuHolder
            menu.Size = UDim2.fromScale(1, 1)
            menu.BackgroundColor3 = Color3.fromRGB(244, 248, 255)
            menu.BackgroundTransparency = 0.90
            menu.BorderSizePixel = 0
            menu.GroupTransparency = 0
            menu.ZIndex = 981
            menu.ClipsDescendants = true
            round(menu, 15)
            local menuGlass, menuFrost, menuGlassCtl = attachLiquidGlass(menu, "menu", 982, 15, 1, 1)
            menuGlassCtl:SetShown(false)
            menuGlassCtl.HideObject = menuHolder
            stroke(menu, C.Black, 0.84, 0.8)
            addTopHighlight(menu, 24, 986, 0.12)


            local menuItems = Instance.new("Frame")
            menuItems.Name = "Items"
            menuItems.Parent = menu
            menuItems.Size = UDim2.fromScale(1, 1)
            menuItems.BackgroundTransparency = 1
            menuItems.ZIndex = 984

            local menuLayout = Instance.new("UIListLayout")
            menuLayout.Parent = menuItems
            menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
            menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            menuLayout.Padding = UDim.new(0, 0)

            local menuPad = Instance.new("UIPadding")
            menuPad.Parent = menuItems
            menuPad.PaddingTop = UDim.new(0, 5)
            menuPad.PaddingBottom = UDim.new(0, 5)
            menuPad.PaddingLeft = UDim.new(0, 5)
            menuPad.PaddingRight = UDim.new(0, 5)

            local open = false
            local function reposition()
                local p = trigger.AbsolutePosition
                local s = trigger.AbsoluteSize
                local cam = workspace.CurrentCamera
                if not cam then return end
                local menuW = math.max(180, math.floor(s.X))
                menuHolder.Size = UDim2.fromOffset(menuW, math.max(44, #options * 38 + 10))
                local x = math.clamp(p.X, 8, cam.ViewportSize.X - menuW - 8)
                local y = p.Y + s.Y + 6
                if y + menuHolder.AbsoluteSize.Y > cam.ViewportSize.Y - 8 then
                    y = p.Y - menuHolder.AbsoluteSize.Y - 6
                end
                menuHolder.Position = UDim2.fromOffset(x, y)
            end

            local function setOpen(state)
                open = state
                if state then
                    reposition()


                    menuHolder.Visible = false
                    menuGlassCtl:Refresh(function(ok)
                        if not open or not menu.Parent then return end
                        if ok then
                            menuGlassCtl:SetShown(true, 0.03, 0.92)
                        end

                        menuHolder.Visible = true
                        menu.GroupTransparency = 1
                        menu.Position = UDim2.fromOffset(0, -5)
                        tw(menu, TweenInfo.new(0.17, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            GroupTransparency = 0,
                            Position = UDim2.fromOffset(0, 0),
                        })
                    end)

                    tw(chevron, TweenInfo.new(0.18), {Rotation = 180})
                else
                    tw(chevron, TweenInfo.new(0.18), {Rotation = 0})
                    local t = tw(menu, TweenInfo.new(0.12), {GroupTransparency = 1, Position = UDim2.fromOffset(0, -4)})
                    task.spawn(function()
                        t.Completed:Wait()
                        if not open then menuHolder.Visible = false end
                    end)
                end
            end

            for _, option in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Parent = menuItems
                item.Size = UDim2.new(1, 0, 0, 38)
                item.BackgroundColor3 = C.White
                item.BackgroundTransparency = 1
                item.BorderSizePixel = 0
                item.Text = tostring(option)
                item.TextColor3 = C.Text
                item.TextSize = 14
                item.Font = Enum.Font.Gotham
                item.AutoButtonColor = false
                item.ZIndex = 984
                round(item, 10)
                item.MouseEnter:Connect(function()
                    tw(item, TweenInfo.new(0.10), {BackgroundTransparency = 0.54, BackgroundColor3 = Color3.fromRGB(232, 239, 250)})
                end)
                item.MouseLeave:Connect(function()
                    tw(item, TweenInfo.new(0.12), {BackgroundTransparency = 1})
                end)
                item.Activated:Connect(function()
                    current = option
                    vl.Text = tostring(option)
                    setOpen(false)
                    if callback then callback(option) end
                end)
            end

            trigger.Activated:Connect(function() setOpen(not open) end)
            return row
        end

        function sec:TextField(text, placeholder, callback)
            local row = makeRow("textfield", currentMobile and 88 or 54)

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            local field = Instance.new("TextBox")
            field.Parent = row
            field.BackgroundColor3 = C.White
            field.BorderSizePixel = 0
            field.ClearTextOnFocus = false
            field.Text = ""
            field.PlaceholderText = placeholder or "Type..."
            field.PlaceholderColor3 = C.Tertiary
            field.TextColor3 = C.Text
            field.TextSize = 14
            field.Font = Enum.Font.Gotham
            field.TextXAlignment = Enum.TextXAlignment.Left
            field.ZIndex = 19
            round(field, 10)
            local fs = stroke(field, C.Black, 0.90, 0.8)

            local pad = Instance.new("UIPadding")
            pad.Parent = field
            pad.PaddingLeft = UDim.new(0, 12)
            pad.PaddingRight = UDim.new(0, 12)

            local function layoutTextField()
                if currentMobile then
                    l.Position = UDim2.fromOffset(14, 4)
                    l.Size = UDim2.new(1, -28, 0, 30)
                    field.Position = UDim2.fromOffset(12, 39)
                    field.Size = UDim2.new(1, -24, 0, 38)
                else
                    l.Position = UDim2.fromOffset(16, 0)
                    l.Size = UDim2.new(0.38, 0, 1, 0)
                    field.AnchorPoint = Vector2.new(1, 0.5)
                    field.Position = UDim2.new(1, -10, 0.5, 0)
                    field.Size = UDim2.new(0.56, 0, 0, 36)
                end
            end
            layoutTextField()

            field.Focused:Connect(function()
                tw(fs, TweenInfo.new(0.14), {Color = C.Blue, Transparency = 0.25})
            end)
            field.FocusLost:Connect(function()
                tw(fs, TweenInfo.new(0.14), {Color = C.Black, Transparency = 0.90})
                if callback then callback(field.Text) end
            end)
            return row
        end

        sb.Activated:Connect(function()
            if rec.SuppressSelectUntil and os.clock() < rec.SuppressSelectUntil then
                return
            end
            sec:Select()
        end)
        if index == 1 then sec:Select() end
        return sec
    end


    backButton.Activated:Connect(function()
        if historyPos > 1 then
            historyPos -= 1
            navigateTo(history[historyPos], false)
        end
    end)

    forwardButton.Activated:Connect(function()
        if historyPos > 0 and historyPos < #history then
            historyPos += 1
            navigateTo(history[historyPos], false)
        end
    end)

    updateHistoryButtons()


    applyResponsive()
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsive)
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        camera = workspace.CurrentCamera
        if camera then
            applyResponsive()
            camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsive)
        end
    end)

    if visible then
        task.defer(showWindow)
    end

    return window
end

return lib


local function plainReplace(source, oldText, newText, label)
    local s, e = string.find(source, oldText, 1, true)
    if not s then
        error("[AppleGUI Frost Patch] patch target missing: " .. tostring(label))
    end
    return string.sub(source, 1, s - 1) .. newText .. string.sub(source, e + 1)
end

local function replaceBetween(source, startMarker, endMarker, replacement, label)
    local s = string.find(source, startMarker, 1, true)
    if not s then
        error("[AppleGUI Frost Patch] start marker missing: " .. tostring(label))
    end
    local e = string.find(source, endMarker, s + #startMarker, true)
    if not e then
        error("[AppleGUI Frost Patch] end marker missing: " .. tostring(label))
    end
    return string.sub(source, 1, s - 1) .. replacement .. string.sub(source, e)
end

local okHttp, source = pcall(function()
    return game:HttpGet(URL)
end)

if not okHttp then
    error("[AppleGUI Frost Patch] HttpGet failed: " .. tostring(source))
end

if type(source) ~= "string" or #source < 1000 then
    error("[AppleGUI Frost Patch] invalid source")
end


source = string.gsub(source, 'local AssetService = game:GetService%("AssetService"%)\n', "")
source = string.gsub(source, 'local CaptureService = game:GetService%("CaptureService"%)\n', "")
source = string.gsub(source, 'local GuiService = game:GetService%("GuiService"%)\n', "")

source = plainReplace(
    source,
    [[local TextService = game:GetService("TextService")]],
    [[local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")]],
    "HttpService"
)

source = plainReplace(
    source,
    "local LocalPlayer = Players.LocalPlayer\n",
    [[local LocalPlayer = Players.LocalPlayer
local scriptStartedAt = os.clock()
local scriptStartedText = os.date("%H:%M:%S")

local DEFAULT_GUI_CONFIG = {
    -- 内置 GUI设置 分类
    ShowGUISettings = true,

    -- 主题
    Theme = "Light",

    -- 全局透明 / 磨砂
    TransparencyEnabled = true,
    FrostEnabled = true,
    FrostStrength = 1.00,

    -- 左侧分类栏
    SidebarTranslucent = true,
    SidebarTransparency = 0.22,

    -- 主窗口
    WindowTransparent = false,
    WindowTransparency = 0.08,
    ContentTransparency = 0.10,

    -- 下拉菜单默认保持不透明
    DropdownTransparent = false,
    DropdownTransparency = 0.34,
    DropdownFrost = 0.86,

    -- 灵动岛
    ShowDynamicIsland = true,
    IslandText = "点击打开",
    IslandTextSize = 11,
    IslandFPSTextSize = 11,
    IslandIcon = "rbxassetid://8997386997",
    IslandIconSize = 16,
    IslandShowIcon = true,
    IslandWidth = 196,
    IslandHeight = 36,

    -- 窗口大小
    -- 拖动右下角时，宽和高独立变化；窗口保持中心不动，
    -- 所以横向会向左右两边同时变长，纵向会向上下两边同时变高。
    WindowWidth = 820,
    WindowHeight = 650,
    MinWindowWidth = 560,
    MinWindowHeight = 430,
    MaxWindowWidth = 1380,
    MaxWindowHeight = 980,
    ShowResizeHandle = true,

    -- 兼容旧调用：window:SetScale(x) 仍可用，但拖拽不再使用等比缩放。
    WindowScale = 1.00,

    -- 配置文件
    ConfigFolder = "__APPLEGUI_CONFIG_FOLDER__",
    ConfigFileName = "__APPLEGUI_CONFIG_FILE__",
    ConfigPath = "__APPLEGUI_CONFIG_FOLDER__/__APPLEGUI_CONFIG_FILE__",
    UseConfigFile = true,
    AutoSaveConfig = true,
}

local function cloneTable(source)
    local out = {}

    for key, value in pairs(source or {}) do
        if type(value) == "table" then
            out[key] = cloneTable(value)
        else
            out[key] = value
        end
    end

    return out
end

local function mergeConfig(target, source)
    if type(source) ~= "table" then
        return target
    end

    for key, value in pairs(source) do
        if value ~= nil then
            target[key] = value
        end
    end

    return target
end

local function normalizeTheme(value)
    value = string.lower(tostring(value or "Light"))

    if value == "dark" or value == "深色" then
        return "Dark"
    end

    return "Light"
end

local function readConfigFile(path)
    if
        type(path) ~= "string"
        or path == ""
        or typeof(isfile) ~= "function"
        or typeof(readfile) ~= "function"
    then
        return nil
    end

    local okExists, exists =
        pcall(isfile, path)

    if not okExists or not exists then
        return nil
    end

    local okRead, raw =
        pcall(readfile, path)

    if
        not okRead
        or type(raw) ~= "string"
        or raw == ""
    then
        return nil
    end

    local okDecode, decoded =
        pcall(function()
            return HttpService:JSONDecode(raw)
        end)

    if okDecode and type(decoded) == "table" then
        return decoded
    end

    return nil
end

local function saveConfigFile(config)
    if
        type(config) ~= "table"
        or typeof(writefile) ~= "function"
    then
        return false
    end

    local path =
        tostring(
            config.ConfigPath
            or DEFAULT_GUI_CONFIG.ConfigPath
        )

    if path == "" then
        return false
    end

    local folder =
        string.match(path, "^(.*)/[^/]+$")

    if
        folder
        and folder ~= ""
        and typeof(makefolder) == "function"
    then
        local shouldCreate = true

        if typeof(isfolder) == "function" then
            local okFolder, exists =
                pcall(isfolder, folder)

            shouldCreate =
                not okFolder
                or not exists
        end

        if shouldCreate then
            pcall(makefolder, folder)
        end
    end

    local copy = cloneTable(config)

    local okEncode, encoded =
        pcall(function()
            return HttpService:JSONEncode(copy)
        end)

    if not okEncode then
        return false
    end

    local okWrite =
        pcall(writefile, path, encoded)

    return okWrite
end

local function buildConfigPath(folder, fileName)
    folder =
        tostring(
            folder
            or DEFAULT_GUI_CONFIG.ConfigFolder
            or "AppleGUI"
        )

    fileName =
        tostring(
            fileName
            or DEFAULT_GUI_CONFIG.ConfigFileName
            or "config.json"
        )

    folder =
        string.gsub(
            folder,
            "/+$",
            ""
        )

    fileName =
        string.gsub(
            fileName,
            "^/+",
            ""
        )

    if folder == "" then
        return fileName
    end

    return folder .. "/" .. fileName
end

local function resolveGUIConfig(config)
    local explicit =
        type(config) == "table"
        and config
        or {}

    local result =
        cloneTable(DEFAULT_GUI_CONFIG)

    local requestedPath

    if type(config) == "string" then
        requestedPath = config
    elseif
        type(explicit.ConfigPath) == "string"
        and explicit.ConfigPath ~= ""
    then
        requestedPath = explicit.ConfigPath
    else
        requestedPath =
            buildConfigPath(
                explicit.ConfigFolder
                    or result.ConfigFolder,
                explicit.ConfigFileName
                    or result.ConfigFileName
            )
    end

    result.ConfigPath = requestedPath

    local useFile =
        explicit.UseConfigFile

    if useFile == nil then
        useFile = result.UseConfigFile
    end

    if useFile ~= false then
        local fileConfig =
            readConfigFile(requestedPath)

        if fileConfig then
            mergeConfig(result, fileConfig)
        end
    end

    mergeConfig(result, explicit)

    result.ConfigFolder =
        tostring(
            result.ConfigFolder
            or DEFAULT_GUI_CONFIG.ConfigFolder
            or "AppleGUI"
        )

    result.ConfigFileName =
        tostring(
            result.ConfigFileName
            or DEFAULT_GUI_CONFIG.ConfigFileName
            or "config.json"
        )

    if
        type(config) ~= "string"
        and not (
            type(explicit.ConfigPath) == "string"
            and explicit.ConfigPath ~= ""
        )
    then
        result.ConfigPath =
            buildConfigPath(
                result.ConfigFolder,
                result.ConfigFileName
            )
    else
        result.ConfigPath =
            tostring(
                result.ConfigPath
                or buildConfigPath(
                    result.ConfigFolder,
                    result.ConfigFileName
                )
            )
    end

    result.Theme =
        normalizeTheme(result.Theme)

    return result
end

lib.DEFAULT_CONFIG =
    cloneTable(DEFAULT_GUI_CONFIG)
]],
    "script start"
)

source = plainReplace(
    source,
    [[function lib:init(ti, dosplash, visiblekey, deleteprevious)
    local guiParent = getGuiParent()]],
    [[function lib:init(ti, dosplash, visiblekey, deleteprevious, config)
    local appConfig = resolveGUIConfig(config)
    local guiParent = getGuiParent()]],
    "init config argument"
)


source = plainReplace(
    source,
    [[    Black = Color3.fromRGB(0, 0, 0),
}]],
    [[    Black = Color3.fromRGB(0, 0, 0),

    -- Theme-aware colors used by navigation / specular highlights.
    Highlight = Color3.fromRGB(255, 255, 255),
    NavButton = Color3.fromRGB(255, 255, 255),
    NavIcon = Color3.fromRGB(175, 175, 179),
}]],
    "theme color keys"
)

source = plainReplace(
    source,
    [[    h.BackgroundColor3 = C.White]],
    [[    h.BackgroundColor3 = C.Highlight]],
    "theme-aware top highlight"
)


local frostEngine = [[    ------------------------------------------------------------------------
    -- Lightweight frosted-glass surfaces
    --
    -- No screenshot capture / EditableImage / per-pixel reconstruction.
    -- Every styled GuiObject gets two live attributes:
    --   Transparency : 0 opaque -> 1 transparent
    --   Frost        : 0 none   -> 1 strongest frosted tint
    ------------------------------------------------------------------------
    local frostRefreshers = {}
    local configRefreshers = {}

    local function styleNumber(style, key, fallback)
        if type(style) == "table" and tonumber(style[key]) ~= nil then
            return math.clamp(tonumber(style[key]), 0, 1)
        end
        return fallback
    end

    local function childStyle(style, key)
        if type(style) == "table" and type(style[key]) == "table" then
            return style[key]
        end
        return nil
    end

    local function applyFrostedSurface(obj, style, z, defaultTransparency, defaultFrost)
        defaultTransparency = defaultTransparency or 0
        defaultFrost = defaultFrost or 0

        local initialTransparency = styleNumber(style, "Transparency", defaultTransparency)
        local initialFrost = styleNumber(style, "Frost", defaultFrost)

        obj:SetAttribute("Transparency", initialTransparency)
        obj:SetAttribute("Frost", initialFrost)

        local frostLayer = Instance.new("Frame")
        frostLayer.Name = "FrostLayer"
        frostLayer.Parent = obj
        frostLayer.Size = UDim2.fromScale(1, 1)
        frostLayer.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
        frostLayer.BorderSizePixel = 0
        frostLayer.Active = false
        frostLayer.ZIndex = z or obj.ZIndex

        local objectCorner =
            obj:FindFirstChildOfClass("UICorner")

        if objectCorner then
            local frostCorner =
                Instance.new("UICorner")

            frostCorner.CornerRadius =
                objectCorner.CornerRadius

            frostCorner.Parent =
                frostLayer
        end

        local frostGradient = Instance.new("UIGradient")
        frostGradient.Parent = frostLayer
        frostGradient.Rotation = 115
        frostGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(232, 239, 249)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })

        local highlight = Instance.new("Frame")
        highlight.Name = "FrostHighlight"
        highlight.Parent = obj
        highlight.AnchorPoint = Vector2.new(0.5, 0)
        highlight.Position = UDim2.new(0.5, 0, 0, 1)
        highlight.Size = UDim2.new(1, -18, 0, 1)
        highlight.BackgroundColor3 = C.Highlight
        highlight.BorderSizePixel = 0
        highlight.Active = false
        highlight.ZIndex = (z or obj.ZIndex) + 1

        local function refresh()
            local transparency = tonumber(obj:GetAttribute("Transparency"))
            local frost = tonumber(obj:GetAttribute("Frost"))

            transparency = math.clamp(
                transparency ~= nil and transparency or defaultTransparency,
                0,
                1
            )

            frost = math.clamp(
                frost ~= nil and frost or defaultFrost,
                0,
                1
            )

            local effectiveTransparency =
                appConfig.TransparencyEnabled ~= false
                and transparency
                or 0

            local globalFrostStrength =
                math.clamp(
                    tonumber(appConfig.FrostStrength)
                    or 1,
                    0,
                    1
                )

            local effectiveFrost =
                appConfig.FrostEnabled ~= false
                and frost * globalFrostStrength
                or 0

            obj.BackgroundTransparency =
                effectiveTransparency

            if appConfig.Theme == "Dark" then
                frostLayer.BackgroundColor3 =
                    Color3.fromRGB(74, 78, 88)

                frostGradient.Color =
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(
                            0,
                            Color3.fromRGB(118, 124, 136)
                        ),
                        ColorSequenceKeypoint.new(
                            0.46,
                            Color3.fromRGB(62, 68, 78)
                        ),
                        ColorSequenceKeypoint.new(
                            1,
                            Color3.fromRGB(96, 102, 114)
                        ),
                    })
            else
                frostLayer.BackgroundColor3 =
                    Color3.fromRGB(248, 250, 255)

                frostGradient.Color =
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(
                            0,
                            Color3.fromRGB(255, 255, 255)
                        ),
                        ColorSequenceKeypoint.new(
                            0.46,
                            Color3.fromRGB(232, 239, 249)
                        ),
                        ColorSequenceKeypoint.new(
                            1,
                            Color3.fromRGB(255, 255, 255)
                        ),
                    })
            end

            frostLayer.Visible =
                effectiveFrost > 0.001

            frostLayer.BackgroundTransparency =
                1 - effectiveFrost * 0.22

            frostGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(
                    0,
                    math.clamp(0.18 + (1 - effectiveFrost) * 0.72, 0, 1)
                ),
                NumberSequenceKeypoint.new(
                    0.50,
                    math.clamp(0.42 + (1 - effectiveFrost) * 0.50, 0, 1)
                ),
                NumberSequenceKeypoint.new(
                    1,
                    math.clamp(0.22 + (1 - effectiveFrost) * 0.68, 0, 1)
                ),
            })

            highlight.Visible =
                effectiveFrost > 0.001

            highlight.BackgroundTransparency =
                math.clamp(
                    1 - effectiveFrost * 0.48,
                    0,
                    1
                )
        end

        obj:GetAttributeChangedSignal("Transparency"):Connect(refresh)
        obj:GetAttributeChangedSignal("Frost"):Connect(refresh)
        table.insert(frostRefreshers, refresh)
        refresh()

        return {
            Overlay = frostLayer,
            Highlight = highlight,

            Set = function(_, transparency, frost)
                if transparency ~= nil then
                    obj:SetAttribute(
                        "Transparency",
                        math.clamp(tonumber(transparency) or defaultTransparency, 0, 1)
                    )
                end

                if frost ~= nil then
                    obj:SetAttribute(
                        "Frost",
                        math.clamp(tonumber(frost) or defaultFrost, 0, 1)
                    )
                end
            end,
        }
    end

]]

source = replaceBetween(
    source,
    [[    ------------------------------------------------------------------------
    -- Event-driven Snapshot Liquid Glass]],
    [[    ------------------------------------------------------------------------
    -- Dynamic Island launcher]],
    frostEngine,
    "liquid engine"
)


source = replaceBetween(
    source,
    [[    ------------------------------------------------------------------------
    -- Dynamic Island launcher]],
    [[    ------------------------------------------------------------------------
    -- Window shell + real nine-slice shadow image]],
    [[    ------------------------------------------------------------------------
    -- Dynamic Island launcher
    ------------------------------------------------------------------------
    local islandShadowHolder = Instance.new("Frame")
    islandShadowHolder.Name = "DynamicIslandShadow"
    islandShadowHolder.Parent = scrgui
    islandShadowHolder.AnchorPoint = Vector2.new(0.5, 0)
    islandShadowHolder.Position = UDim2.new(0.5, 0, 0, 10)
    islandShadowHolder.Size = UDim2.fromOffset(196, 36)
    islandShadowHolder.BackgroundTransparency = 1
    islandShadowHolder.BorderSizePixel = 0
    islandShadowHolder.ZIndex = 898

    local islandShadow = addShadow(
        islandShadowHolder,
        898,
        24,
        18,
        0.80,
        true
    )

    local island = Instance.new("Frame")
    island.Name = "DynamicIsland"
    island.Parent = scrgui
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.Position = UDim2.new(0.5, 0, 0, 8)
    island.BackgroundColor3 = C.Black
    island.BorderSizePixel = 0
    island.ZIndex = 900
    island.ClipsDescendants = true
    circle(island)

    local islandIcon = Instance.new("ImageLabel")
    islandIcon.Name = "Icon"
    islandIcon.Parent = island
    islandIcon.AnchorPoint = Vector2.new(0, 0.5)
    islandIcon.BackgroundTransparency = 1
    islandIcon.ImageColor3 = C.White
    islandIcon.ScaleType = Enum.ScaleType.Fit
    islandIcon.ZIndex = 901

    local islandAction = Instance.new("TextLabel")
    islandAction.Name = "Action"
    islandAction.Parent = island
    islandAction.AnchorPoint = Vector2.new(0, 0.5)
    islandAction.BackgroundTransparency = 1
    islandAction.TextColor3 = C.White
    islandAction.Font = Enum.Font.GothamMedium
    islandAction.TextXAlignment = Enum.TextXAlignment.Left
    islandAction.TextTruncate = Enum.TextTruncate.AtEnd
    islandAction.ZIndex = 901

    local islandFPS = Instance.new("TextLabel")
    islandFPS.Name = "FPS"
    islandFPS.Parent = island
    islandFPS.AnchorPoint = Vector2.new(1, 0.5)
    islandFPS.BackgroundTransparency = 1
    islandFPS.Text = "60 FPS"
    islandFPS.TextColor3 = Color3.fromRGB(142, 142, 147)
    islandFPS.Font = Enum.Font.GothamMedium
    islandFPS.TextXAlignment = Enum.TextXAlignment.Right
    islandFPS.ZIndex = 901

    local islandButton = Instance.new("TextButton")
    islandButton.Parent = island
    islandButton.Size = UDim2.fromScale(1, 1)
    islandButton.BackgroundTransparency = 1
    islandButton.Text = ""
    islandButton.AutoButtonColor = false
    islandButton.ZIndex = 902

    local function refreshIslandAppearance()
        local width =
            math.clamp(
                tonumber(appConfig.IslandWidth)
                or 196,
                130,
                360
            )

        local height =
            math.clamp(
                tonumber(appConfig.IslandHeight)
                or 36,
                30,
                58
            )

        local iconSize =
            math.clamp(
                tonumber(appConfig.IslandIconSize)
                or 16,
                10,
                28
            )

        local textSize =
            math.clamp(
                tonumber(appConfig.IslandTextSize)
                or 11,
                8,
                20
            )

        local fpsTextSize =
            math.clamp(
                tonumber(appConfig.IslandFPSTextSize)
                or 11,
                8,
                20
            )

        island.Size =
            UDim2.fromOffset(
                width,
                height
            )

        islandShadowHolder.Size =
            UDim2.fromOffset(
                width,
                height
            )

        islandIcon.Visible =
            appConfig.IslandShowIcon ~= false

        islandIcon.Image =
            tostring(
                appConfig.IslandIcon
                or ASSET.Settings
            )

        islandIcon.Size =
            UDim2.fromOffset(
                iconSize,
                iconSize
            )

        islandIcon.Position =
            UDim2.new(
                0,
                12,
                0.5,
                0
            )

        local actionX =
            appConfig.IslandShowIcon ~= false
            and (18 + iconSize)
            or 14

        islandAction.Position =
            UDim2.new(
                0,
                actionX,
                0.5,
                0
            )

        islandAction.Size =
            UDim2.new(
                1,
                -(actionX + 66),
                1,
                0
            )

        islandAction.Text =
            tostring(
                appConfig.IslandText
                or "点击打开"
            )

        islandAction.TextSize =
            textSize

        islandFPS.Position =
            UDim2.new(
                1,
                -12,
                0.5,
                0
            )

        islandFPS.Size =
            UDim2.fromOffset(
                58,
                height
            )

        islandFPS.TextSize =
            fpsTextSize
    end

    table.insert(
        configRefreshers,
        refreshIslandAppearance
    )

    refreshIslandAppearance()

    local fpsFrames, fpsElapsed = 0, 0
    local fpsConnection =
        RunService.RenderStepped:Connect(
            function(dt)
                if not island.Visible then
                    fpsFrames = 0
                    fpsElapsed = 0
                    return
                end

                fpsFrames += 1
                fpsElapsed += dt

                if fpsElapsed >= 0.25 then
                    local fps =
                        math.max(
                            1,
                            math.floor(
                                (
                                    fpsFrames
                                    / fpsElapsed
                                )
                                + 0.5
                            )
                        )

                    islandFPS.Text =
                        tostring(fps)
                        .. " FPS"

                    fpsFrames, fpsElapsed =
                        0, 0
                end
            end
        )

    local islandBusy = false

    local function islandJelly()
        if islandBusy then
            return
        end

        islandBusy = true

        local baseW =
            island.Size.X.Offset

        local baseH =
            island.Size.Y.Offset

        local growSize =
            UDim2.fromOffset(
                math.floor(baseW * 1.055 + 0.5),
                math.floor(baseH * 1.075 + 0.5)
            )

        local t1 = tw(
            island,
            TweenInfo.new(
                0.075,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {Size = growSize}
        )

        tw(
            islandShadowHolder,
            TweenInfo.new(
                0.075,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {Size = growSize}
        )

        t1.Completed:Wait()

        local squashSize =
            UDim2.fromOffset(
                math.floor(baseW * 0.985 + 0.5),
                math.floor(baseH * 0.97 + 0.5)
            )

        local t2 = tw(
            island,
            TweenInfo.new(
                0.085,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.InOut
            ),
            {Size = squashSize}
        )

        tw(
            islandShadowHolder,
            TweenInfo.new(
                0.085,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.InOut
            ),
            {Size = squashSize}
        )

        t2.Completed:Wait()

        local baseSize =
            UDim2.fromOffset(
                baseW,
                baseH
            )

        local t3 = tw(
            island,
            TweenInfo.new(
                0.22,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Size = baseSize}
        )

        tw(
            islandShadowHolder,
            TweenInfo.new(
                0.22,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Size = baseSize}
        )

        t3.Completed:Wait()
        islandBusy = false
    end

    ------------------------------------------------------------------------
    -- Window shell + real nine-slice shadow image
]],
    "configurable Dynamic Island"
)


source = plainReplace(
    source,
    [[    local windowScale = Instance.new("UIScale")
    windowScale.Name = "WindowScale"
    windowScale.Scale = 0.97
    windowScale.Parent = shell

    local SIDEBAR_W = 258]],
    [[    local windowScale = Instance.new("UIScale")
    windowScale.Name = "WindowScale"
    windowScale.Scale = 0.97
    windowScale.Parent = shell

    local BASE_WINDOW_WIDTH = 820
    local BASE_WINDOW_HEIGHT = 650

    local userWindowWidth =
        tonumber(appConfig.WindowWidth)
        or BASE_WINDOW_WIDTH

    local userWindowHeight =
        tonumber(appConfig.WindowHeight)
        or BASE_WINDOW_HEIGHT

    local fullscreenSizeOverride = false

    local function sizeBounds()
        local minW =
            math.max(
                420,
                tonumber(appConfig.MinWindowWidth)
                or 560
            )

        local minH =
            math.max(
                340,
                tonumber(appConfig.MinWindowHeight)
                or 430
            )

        local maxW =
            math.max(
                minW,
                tonumber(appConfig.MaxWindowWidth)
                or 1380
            )

        local maxH =
            math.max(
                minH,
                tonumber(appConfig.MaxWindowHeight)
                or 980
            )

        return minW, minH, maxW, maxH
    end

    local function setUserWindowSize(width, height, save)
        local minW, minH, maxW, maxH =
            sizeBounds()

        userWindowWidth =
            math.clamp(
                math.floor(
                    (tonumber(width) or userWindowWidth)
                    + 0.5
                ),
                minW,
                maxW
            )

        userWindowHeight =
            math.clamp(
                math.floor(
                    (tonumber(height) or userWindowHeight)
                    + 0.5
                ),
                minH,
                maxH
            )

        appConfig.WindowWidth =
            userWindowWidth

        appConfig.WindowHeight =
            userWindowHeight

        if not fullscreenSizeOverride then
            shell.Size =
                UDim2.fromOffset(
                    userWindowWidth,
                    userWindowHeight
                )
        end

        if
            save
            and appConfig.AutoSaveConfig ~= false
        then
            saveConfigFile(appConfig)
        end
    end

    -- Initial stored size.
    setUserWindowSize(
        userWindowWidth,
        userWindowHeight,
        false
    )

    -- Bottom-right handle.
    -- Because Shell.AnchorPoint is 0.5,0.5 and Shell stays centered:
    --   drag right  -> both left/right edges move out
    --   drag down   -> both top/bottom edges move out
    --
    -- X and Y are calculated independently. Horizontal-only dragging never
    -- changes height, and vertical-only dragging never changes width.
    local resizeGrip = Instance.new("TextButton")
    resizeGrip.Name = "ResizeGrip"
    resizeGrip.Parent = main
    resizeGrip.AnchorPoint = Vector2.new(1, 1)
    resizeGrip.Position = UDim2.new(1, -4, 1, -4)
    resizeGrip.Size = UDim2.fromOffset(32, 32)
    resizeGrip.BackgroundTransparency = 1
    resizeGrip.Text = ""
    resizeGrip.AutoButtonColor = false
    resizeGrip.ZIndex = 90

    for i = 0, 2 do
        local line = Instance.new("Frame")
        line.Name = "GripLine"
        line.Parent = resizeGrip
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = UDim2.new(
            1,
            -(7 + i * 5),
            1,
            -(7 + i * 5)
        )
        line.Size = UDim2.fromOffset(
            12 + i * 4,
            2
        )
        line.Rotation = -45
        line.BackgroundColor3 = C.Secondary
        line.BackgroundTransparency = 0.22 + i * 0.16
        line.BorderSizePixel = 0
        line.ZIndex = 91
        round(line, 1)
    end

    local resizeDragging = false
    local resizeDragInput
    local resizeStartPointer
    local resizeStartWidth
    local resizeStartHeight

    local function refreshResizeConfig()
        resizeGrip.Visible =
            appConfig.ShowResizeHandle ~= false

        if not fullscreenSizeOverride then
            setUserWindowSize(
                tonumber(appConfig.WindowWidth)
                    or userWindowWidth,
                tonumber(appConfig.WindowHeight)
                    or userWindowHeight,
                false
            )
        end
    end

    table.insert(
        configRefreshers,
        refreshResizeConfig
    )

    resizeGrip.InputBegan:Connect(function(input)
        if
            input.UserInputType
                == Enum.UserInputType.MouseButton1
            or input.UserInputType
                == Enum.UserInputType.Touch
        then
            if fullscreenSizeOverride then
                return
            end

            resizeDragging = true
            resizeDragInput = input
            resizeStartPointer = input.Position
            resizeStartWidth = userWindowWidth
            resizeStartHeight = userWindowHeight
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if
            not resizeDragging
            or not resizeStartPointer
        then
            return
        end

        local valid =
            input.UserInputType
                == Enum.UserInputType.MouseMovement

        if
            input.UserInputType
                == Enum.UserInputType.Touch
        then
            valid =
                input == resizeDragInput
        end

        if not valid then
            return
        end

        local delta =
            input.Position
            - resizeStartPointer

        -- The handle is on the bottom-right but the window grows from center.
        -- Therefore pointer movement is doubled to keep the dragged edge
        -- visually following the pointer while the opposite edge mirrors it.
        local width =
            resizeStartWidth
            + delta.X * 2

        local height =
            resizeStartHeight
            + delta.Y * 2

        setUserWindowSize(
            width,
            height,
            false
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not resizeDragging then
            return
        end

        local finished =
            input.UserInputType
                == Enum.UserInputType.MouseButton1

        if
            input.UserInputType
                == Enum.UserInputType.Touch
        then
            finished =
                input == resizeDragInput
        end

        if finished then
            resizeDragging = false
            resizeDragInput = nil
            resizeStartPointer = nil

            if appConfig.AutoSaveConfig ~= false then
                saveConfigFile(appConfig)
            end
        end
    end)

    local SIDEBAR_W = 258]],
    "independent resize handle"
)


source = plainReplace(
    source,
    [[    contentPane.BackgroundColor3 = C.Content
    contentPane.BorderSizePixel = 0
    contentPane.ZIndex = 11

    ------------------------------------------------------------------------
    -- macOS traffic lights]],
    [[    contentPane.BackgroundColor3 = C.Content
    contentPane.BorderSizePixel = 0
    contentPane.ZIndex = 11

    local LIGHT_THEME = {
        Window = Color3.fromRGB(247, 247, 248),
        Sidebar = Color3.fromRGB(246, 246, 247),
        Content = Color3.fromRGB(251, 251, 252),
        Card = Color3.fromRGB(244, 244, 246),
        CardPressed = Color3.fromRGB(232, 232, 235),
        Search = Color3.fromRGB(229, 229, 231),
        Text = Color3.fromRGB(31, 31, 33),
        Secondary = Color3.fromRGB(114, 114, 119),
        Tertiary = Color3.fromRGB(156, 156, 161),
        Divider = Color3.fromRGB(216, 216, 219),
        Blue = Color3.fromRGB(10, 122, 255),
        SwitchOff = Color3.fromRGB(206, 206, 211),

        Highlight = Color3.fromRGB(255, 255, 255),
        NavButton = Color3.fromRGB(255, 255, 255),
        NavIcon = Color3.fromRGB(175, 175, 179),
    }

    local DARK_THEME = {
        Window = Color3.fromRGB(30, 30, 32),
        Sidebar = Color3.fromRGB(35, 35, 37),
        Content = Color3.fromRGB(27, 27, 29),
        Card = Color3.fromRGB(44, 44, 46),
        CardPressed = Color3.fromRGB(58, 58, 60),
        Search = Color3.fromRGB(52, 52, 54),
        Text = Color3.fromRGB(242, 242, 247),
        Secondary = Color3.fromRGB(174, 174, 178),
        Tertiary = Color3.fromRGB(142, 142, 147),
        Divider = Color3.fromRGB(72, 72, 74),
        Blue = Color3.fromRGB(10, 132, 255),
        SwitchOff = Color3.fromRGB(99, 99, 102),

        -- 深色模式下顶部高光不再是一条刺眼白杠。
        Highlight = Color3.fromRGB(103, 103, 108),

        -- < > 返回 / 前进按钮
        NavButton = Color3.fromRGB(54, 54, 57),
        NavIcon = Color3.fromRGB(210, 210, 215),
    }

    local function colorClose(a, b)
        return
            math.abs(a.R - b.R) < 0.002
            and math.abs(a.G - b.G) < 0.002
            and math.abs(a.B - b.B) < 0.002
    end

    local function remapObjectColor(obj, property, oldPalette, newPalette)
        local okRead, current =
            pcall(function()
                return obj[property]
            end)

        if not okRead or typeof(current) ~= "Color3" then
            return
        end

        for key, oldColor in pairs(oldPalette) do
            local newColor = newPalette[key]

            if newColor and colorClose(current, oldColor) then
                pcall(function()
                    obj[property] = newColor
                end)
                return
            end
        end

        local dark =
            newPalette == DARK_THEME

        local extras = {
            {
                Color3.fromRGB(226, 226, 229),
                Color3.fromRGB(72, 72, 74),
            },
            {
                Color3.fromRGB(88, 88, 93),
                Color3.fromRGB(218, 218, 222),
            },
            {
                Color3.fromRGB(175, 175, 179),
                Color3.fromRGB(205, 205, 210),
            },
            {
                Color3.fromRGB(180, 180, 184),
                Color3.fromRGB(120, 120, 124),
            },
        }

        for _, pair in ipairs(extras) do
            local from =
                dark and pair[1] or pair[2]

            local to =
                dark and pair[2] or pair[1]

            if colorClose(current, from) then
                pcall(function()
                    obj[property] = to
                end)
                return
            end
        end
    end

    local currentTheme = "Light"

    local function applyTheme(theme)
        theme = normalizeTheme(theme)

        if theme == currentTheme then
            return
        end

        local oldPalette =
            currentTheme == "Dark"
            and DARK_THEME
            or LIGHT_THEME

        local newPalette =
            theme == "Dark"
            and DARK_THEME
            or LIGHT_THEME

        for key, value in pairs(newPalette) do
            if C[key] ~= nil then
                C[key] = value
            end
        end

        for _, obj in ipairs(scrgui:GetDescendants()) do
            if obj:IsA("GuiObject") then
                remapObjectColor(
                    obj,
                    "BackgroundColor3",
                    oldPalette,
                    newPalette
                )
            end

            if
                obj:IsA("TextLabel")
                or obj:IsA("TextButton")
                or obj:IsA("TextBox")
            then
                remapObjectColor(
                    obj,
                    "TextColor3",
                    oldPalette,
                    newPalette
                )
            end

            if obj:IsA("TextBox") then
                remapObjectColor(
                    obj,
                    "PlaceholderColor3",
                    oldPalette,
                    newPalette
                )
            end

            if
                obj:IsA("ImageLabel")
                or obj:IsA("ImageButton")
            then
                remapObjectColor(
                    obj,
                    "ImageColor3",
                    oldPalette,
                    newPalette
                )
            end

            if obj:IsA("UIStroke") then
                remapObjectColor(
                    obj,
                    "Color",
                    oldPalette,
                    newPalette
                )
            end
        end

        main.BackgroundColor3 = C.Window
        leftPane.BackgroundColor3 = C.Sidebar
        contentPane.BackgroundColor3 = C.Content
        leftDivider.BackgroundColor3 = C.Divider

        currentTheme = theme
    end

    local function applyRuntimeConfig()
        applyTheme(appConfig.Theme)

        local transparencyEnabled =
            appConfig.TransparencyEnabled ~= false

        local sidebarTranslucent =
            transparencyEnabled
            and appConfig.SidebarTranslucent ~= false

        local sidebarAlpha =
            math.clamp(
                tonumber(appConfig.SidebarTransparency)
                or 0.22,
                0,
                0.85
            )

        leftPane.BackgroundTransparency =
            sidebarTranslucent
            and sidebarAlpha
            or 0

        local windowTransparent =
            transparencyEnabled
            and appConfig.WindowTransparent == true

        local windowAlpha =
            math.clamp(
                tonumber(appConfig.WindowTransparency)
                or 0.08,
                0,
                0.65
            )

        local contentAlpha =
            math.clamp(
                tonumber(appConfig.ContentTransparency)
                or 0.10,
                0,
                0.65
            )

        -- 分类栏单独半透明时，主背景只打开一小部分，
        -- 让左侧能真正透出游戏画面，同时右侧仍保持清晰。
        main.BackgroundTransparency =
            windowTransparent
            and windowAlpha
            or (
                sidebarTranslucent
                and math.min(
                    0.32,
                    sidebarAlpha * 0.82
                )
                or 0
            )

        contentPane.BackgroundTransparency =
            windowTransparent
            and contentAlpha
            or 0

        local islandShown =
            appConfig.ShowDynamicIsland ~= false

        island.Visible = islandShown
        islandShadowHolder.Visible = islandShown

        for _, refresh in ipairs(frostRefreshers) do
            pcall(refresh)
        end

        for _, refresh in ipairs(configRefreshers) do
            pcall(refresh)
        end
    end

    -- Make the first application repaint even when config starts in Light.
    currentTheme =
        appConfig.Theme == "Dark"
        and "Light"
        or "Dark"

    applyRuntimeConfig()

    ------------------------------------------------------------------------
    -- macOS traffic lights]],
    "runtime GUI config"
)

source = plainReplace(
    source,
    [[        iconBg.BackgroundColor3 = Color3.fromRGB(226, 226, 229)]],
    [[        iconBg.BackgroundColor3 =
            appConfig.Theme == "Dark"
            and Color3.fromRGB(72, 72, 74)
            or Color3.fromRGB(226, 226, 229)]],
    "dark sidebar icon background"
)

source = plainReplace(
    source,
    [[        local si = iconLabel(iconBg, image, 18, Color3.fromRGB(88, 88, 93), 23)]],
    [[        local si = iconLabel(
            iconBg,
            image,
            18,
            appConfig.Theme == "Dark"
                and Color3.fromRGB(218, 218, 222)
                or Color3.fromRGB(88, 88, 93),
            23
        )]],
    "dark sidebar icon"
)

source = plainReplace(
    source,
    [[        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)]],
    [[        b.BackgroundColor3 = C.NavButton]],
    "theme nav button"
)

source = plainReplace(
    source,
    [[        b.ImageColor3 = Color3.fromRGB(175, 175, 179)]],
    [[        b.ImageColor3 = C.NavIcon]],
    "theme nav icon"
)


source = plainReplace(
    source,
    [[    -- Account row, because the supplied System Settings layout includes it.
    ------------------------------------------------------------------------
    local account = Instance.new("Frame")]],
    [[    -- Account row, because the supplied System Settings layout includes it.
    ------------------------------------------------------------------------
    local accountPage
    local guiSettingsPage
    local account = Instance.new("Frame")]],
    "account declaration"
)

source = plainReplace(
    source,
    [[    accountSub.Text = "Account"]],
    [[    accountSub.Text = "@" .. LocalPlayer.Name]],
    "real username"
)

source = plainReplace(
    source,
    [[    accountSub.ZIndex = 21

    ------------------------------------------------------------------------
    -- Sidebar list]],
    [[    accountSub.ZIndex = 21

    round(account, 12)

    local accountHit = Instance.new("TextButton")
    accountHit.Name = "AccountHit"
    accountHit.Parent = account
    accountHit.Size = UDim2.fromScale(1, 1)
    accountHit.BackgroundTransparency = 1
    accountHit.Text = ""
    accountHit.AutoButtonColor = false
    accountHit.ZIndex = 24
    pressScale(accountHit, 0.985)

    accountHit.MouseEnter:Connect(function()
        tw(account, TweenInfo.new(0.12), {
            BackgroundColor3 = C.CardPressed,
            BackgroundTransparency = 0.36,
        })
    end)

    accountHit.MouseLeave:Connect(function()
        tw(account, TweenInfo.new(0.14), {
            BackgroundTransparency = 1,
        })
    end)

    accountHit.Activated:Connect(function()
        if accountPage then
            accountPage:Select()
        else
            task.delay(0.05, function()
                if accountPage then
                    accountPage:Select()
                end
            end)
        end
    end)

    ------------------------------------------------------------------------
    -- Sidebar list]],
    "account click"
)


source = replaceBetween(
    source,
    [[    ------------------------------------------------------------------------
    -- Window animation]],
    [[    local window = {}]],
    [[    ------------------------------------------------------------------------
    -- Window animation
    ------------------------------------------------------------------------
    local visible =
        not (
            workspace.CurrentCamera
            and math.min(
                workspace.CurrentCamera.ViewportSize.X,
                workspace.CurrentCamera.ViewportSize.Y
            ) < 600
        )

    local animating = false
    local minimizedState = not visible
    local closingState = false
    local closingCallbacks = {}
    local zoomed = false

    local function showWindow()
        if animating or shell.Visible then
            return
        end

        animating = true
        minimizedState = false
        shell.Visible = true
        main.GroupTransparency = 0.18
        windowScale.Scale = 0.965

        shell.Position =
            UDim2.new(
                0.5,
                0,
                0.5,
                14
            )

        mainShadow.ImageTransparency = 0.94

        tw(
            shell,
            TweenInfo.new(
                0.34,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                Position =
                    UDim2.fromScale(
                        0.5,
                        0.5
                    )
            }
        )

        tw(
            main,
            TweenInfo.new(
                0.26,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                GroupTransparency = 0
            }
        )

        tw(
            mainShadow,
            TweenInfo.new(
                0.32,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                ImageTransparency = 0.78
            }
        )

        local t = tw(
            windowScale,
            TweenInfo.new(
                0.38,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                Scale = 1
            }
        )

        t.Completed:Wait()
        animating = false
    end

    local function hideWindow()
        if animating or not shell.Visible then
            return
        end

        animating = true
        minimizedState = true

        tw(
            main,
            TweenInfo.new(
                0.18,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            ),
            {
                GroupTransparency = 0.15
            }
        )

        tw(
            mainShadow,
            TweenInfo.new(0.18),
            {
                ImageTransparency = 0.96
            }
        )

        tw(
            shell,
            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.In
            ),
            {
                Position =
                    UDim2.new(
                        0.5,
                        0,
                        0.5,
                        12
                    )
            }
        )

        local t = tw(
            windowScale,
            TweenInfo.new(
                0.20,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.In
            ),
            {
                Scale = 0.97
            }
        )

        t.Completed:Wait()

        shell.Visible = false
        shell.Position =
            UDim2.fromScale(0.5, 0.5)

        main.GroupTransparency = 0
        windowScale.Scale = 1
        animating = false
    end

    local window = {}]],
    "window animation"
)

source = plainReplace(
    source,
    [[    islandButton.Activated:Connect(function()
        task.spawn(islandJelly)
        if not shell.Visible then
            visible = true
            showWindow()
        else
            -- Desktop users can also use the island as a compact toggle.
            visible = false
            hideWindow()
        end
    end)

    minimize.Activated:Connect(function()
        visible = false
        hideWindow()
    end)

    close.Activated:Connect(function()
        if fpsConnection then fpsConnection:Disconnect() end
        scrgui:Destroy()
    end)]],
    [[    islandButton.Activated:Connect(function()
        task.spawn(islandJelly)

        if not shell.Visible then
            visible = true
            showWindow()
        else
            visible = false
            hideWindow()
        end
    end)

    minimize.Activated:Connect(function()
        visible = false
        hideWindow()
    end)

    close.Activated:Connect(function()
        if closingState then
            return
        end

        closingState = true

        for _, entry in ipairs(closingCallbacks) do
            if entry.Connected then
                task.spawn(function()
                    pcall(
                        entry.Callback,
                        window:GetUIState()
                    )
                end)
            end
        end

        task.defer(function()
            if fpsConnection then
                fpsConnection:Disconnect()
            end

            scrgui:Destroy()
        end)
    end)]],
    "window state handlers"
)


source = replaceBetween(
    source,
    [[    local greenCallback]],
    [[    if visiblekey then]],
    [[    local greenCallback

    function window:GreenButton(callback)
        greenCallback = callback
    end

    local savedSize
    local savedPosition

    resize.Activated:Connect(function()
        if greenCallback then
            task.spawn(greenCallback)
        end

        if animating then
            return
        end

        if not zoomed then
            zoomed = true
            savedSize = shell.Size
            savedPosition = shell.Position
            fullscreenSizeOverride = true

            local cam =
                workspace.CurrentCamera

            if cam then
                local v =
                    cam.ViewportSize

                tw(
                    shell,
                    TweenInfo.new(
                        0.34,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Size =
                            UDim2.fromOffset(
                                math.max(
                                    340,
                                    v.X - 16
                                ),
                                math.max(
                                    470,
                                    v.Y - 24
                                )
                            ),
                        Position =
                            UDim2.fromScale(
                                0.5,
                                0.5
                            ),
                    }
                )
            end

            resizeGrip.Visible = false
        else
            zoomed = false
            fullscreenSizeOverride = false

            tw(
                shell,
                TweenInfo.new(
                    0.34,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {
                    Size = savedSize,
                    Position = savedPosition,
                }
            )

            resizeGrip.Visible =
                appConfig.ShowResizeHandle ~= false
        end

    end)

]],
    "green fullscreen"
)


source = plainReplace(
    source,
    [[    local window = {}

    function window:ToggleVisible()]],
    [[    local window = {}
    window.Config = appConfig

    function window:IsMinimized()
        return minimizedState == true
    end

    function window:IsClosing()
        return closingState == true
    end

    function window:IsFullscreen()
        return zoomed == true
    end

    function window:GetUIState()
        return {
            Minimized = minimizedState == true,
            Closing = closingState == true,
            Fullscreen = zoomed == true,
            Visible = shell.Visible == true,
        }
    end

    function window:OnClosing(callback)
        if type(callback) ~= "function" then
            return nil
        end

        local entry = {
            Callback = callback,
            Connected = true,
        }

        table.insert(closingCallbacks, entry)

        return {
            Disconnect = function()
                entry.Connected = false
            end,
        }
    end

    function window:GetConfig()
        return cloneTable(appConfig)
    end

    function window:SaveConfig(path)
        if type(path) == "string" and path ~= "" then
            appConfig.ConfigPath = path
        end

        return saveConfigFile(appConfig)
    end

    function window:SetSize(width, height, skipSave)
        setUserWindowSize(
            width,
            height,
            false
        )

        if
            not skipSave
            and appConfig.AutoSaveConfig ~= false
        then
            saveConfigFile(appConfig)
        end

        return window
    end

    function window:GetSize()
        return
            userWindowWidth,
            userWindowHeight
    end

    -- Backward compatibility only.
    -- This still changes both dimensions from the original 820x650 baseline,
    -- but the resize handle itself is no longer proportional.
    function window:SetScale(scale, skipSave)
        scale =
            math.clamp(
                tonumber(scale) or 1,
                0.50,
                1.80
            )

        appConfig.WindowScale = scale

        setUserWindowSize(
            BASE_WINDOW_WIDTH * scale,
            BASE_WINDOW_HEIGHT * scale,
            false
        )

        if
            not skipSave
            and appConfig.AutoSaveConfig ~= false
        then
            saveConfigFile(appConfig)
        end

        return window
    end

    function window:GetScale()
        return
            math.min(
                userWindowWidth / BASE_WINDOW_WIDTH,
                userWindowHeight / BASE_WINDOW_HEIGHT
            )
    end

    function window:SetConfig(key, value, skipSave)
        if type(key) == "table" then
            for k, v in pairs(key) do
                appConfig[k] = v
            end
        elseif type(key) == "string" then
            appConfig[key] = value
        end

        appConfig.Theme =
            normalizeTheme(appConfig.Theme)

        if
            (
                key == "ConfigFolder"
                or key == "ConfigFileName"
            )
            or (
                type(key) == "table"
                and (
                    key.ConfigFolder ~= nil
                    or key.ConfigFileName ~= nil
                )
            )
        then
            appConfig.ConfigPath =
                buildConfigPath(
                    appConfig.ConfigFolder,
                    appConfig.ConfigFileName
                )
        end

        applyRuntimeConfig()

        if guiSettingsPage and guiSettingsPage._rec then
            guiSettingsPage._rec.sidebarVisible =
                appConfig.ShowGUISettings ~= false

            guiSettingsPage._rec.button.Visible =
                guiSettingsPage._rec.sidebarVisible
        end

        if
            not skipSave
            and appConfig.AutoSaveConfig ~= false
        then
            saveConfigFile(appConfig)
        end

        return window
    end

    function window:ResetConfig(skipSave)
        for key in pairs(appConfig) do
            appConfig[key] = nil
        end

        mergeConfig(
            appConfig,
            cloneTable(DEFAULT_GUI_CONFIG)
        )

        applyRuntimeConfig()

        if guiSettingsPage and guiSettingsPage._rec then
            guiSettingsPage._rec.sidebarVisible =
                appConfig.ShowGUISettings ~= false

            guiSettingsPage._rec.button.Visible =
                guiSettingsPage._rec.sidebarVisible
        end

        if
            not skipSave
            and appConfig.AutoSaveConfig ~= false
        then
            saveConfigFile(appConfig)
        end

        return window
    end

    function window:ToggleVisible()]],
    "window config API"
)


source = replaceBetween(
    source,
    [[    ------------------------------------------------------------------------
    -- Search filtering]],
    [[    ------------------------------------------------------------------------
    -- Modals: grey dimming layer over the main GUI, opaque card, real shadow]],
    [[    ------------------------------------------------------------------------
    -- Search filtering: category names + feature/control names
    ------------------------------------------------------------------------
    local sectionRecords = {}
    local selectedIndex = 0
    local history = {}
    local historyPos = 0

    local function normalizeSearch(value)
        value =
            string.lower(
                tostring(value or "")
            )

        value =
            string.gsub(
                value,
                "^%s+",
                ""
            )

        value =
            string.gsub(
                value,
                "%s+$",
                ""
            )

        return value
    end

    local function recordMatches(rec, q)
        if q == "" then
            return true
        end

        if
            string.find(
                string.lower(rec.name or ""),
                q,
                1,
                true
            )
        then
            return true
        end

        for _, term in ipairs(rec.searchTerms or {}) do
            if
                string.find(
                    term,
                    q,
                    1,
                    true
                )
            then
                return true
            end
        end

        return false
    end

    local function descendantMatches(rec, q)
        for _, child in ipairs(rec.children or {}) do
            if
                child.sidebarVisible ~= false
                and (
                    recordMatches(child, q)
                    or descendantMatches(child, q)
                )
            then
                return true
            end
        end

        return false
    end

    local function ancestorsExpanded(rec)
        local p = rec.parent

        while p do
            if p.expanded == false then
                return false
            end

            p = p.parent
        end

        return true
    end

    local function applyFilter()
        local q =
            normalizeSearch(searchBox.Text)

        for _, rec in ipairs(sectionRecords) do
            local visible =
                rec.sidebarVisible ~= false

            if visible then
                if q == "" then
                    if rec.isSubpage then
                        visible =
                            ancestorsExpanded(rec)
                    end
                else
                    visible =
                        recordMatches(rec, q)
                        or descendantMatches(rec, q)
                end
            end

            rec.button.Visible = visible
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)

    ------------------------------------------------------------------------
    -- Modals: grey dimming layer over the main GUI, opaque card, real shadow
]],
    "functional search"
)

source = plainReplace(
    source,
    [[    searchBox.PlaceholderText = "Search"]],
    [[    searchBox.PlaceholderText = "搜索分类和功能"]],
    "search placeholder"
)


source = plainReplace(
    source,
    [[    local function showModal(titleText, bodyText, specs, icon)]],
    [[    local function showModal(titleText, bodyText, specs, icon, style)]],
    "modal signature"
)

source = plainReplace(
    source,
    [[        card.BackgroundTransparency = 0.86]],
    [[        card.BackgroundTransparency = 0.34]],
    "modal alpha"
)

source = plainReplace(
    source,
    [[        round(card, 26)
        local modalGlass, modalFrost, modalGlassCtl = attachLiquidGlass(card, "modal", 953, 26, 1, 1)
        modalGlassCtl:SetShown(false)
        modalGlassCtl.HideObject = overlay
        stroke(card, C.Black, 0.82, 0.8)]],
    [[        round(card, 26)
        applyFrostedSurface(card, style, 953, 0.34, 0.82)
        stroke(card, C.Black, 0.82, 0.8)]],
    "modal frost"
)

source = replaceBetween(
    source,
    [[        activeModal = overlay
        overlay.Visible = false

        -- Snapshot only once for this modal. The entire overlay is hidden from
        -- the capture, so the glass never photographs itself or the dim layer.
        modalGlassCtl:Refresh(function(ok)]],
    [[    function window:Notify]],
    [[        activeModal = overlay
        overlay.Visible = true
        overlay.BackgroundTransparency = 1
        card.GroupTransparency = 1
        cardScale.Scale = 0.90

        tw(overlay, TweenInfo.new(0.18), {
            BackgroundTransparency = 0.56
        })

        tw(card, TweenInfo.new(0.18), {
            GroupTransparency = 0
        })

        tw(
            cardScale,
            TweenInfo.new(
                0.32,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Scale = 1}
        )
    end

]],
    "modal capture"
)

source = plainReplace(
    source,
    [[    function window:Notify(txt1, txt2, b1, icon, callback)
        return showModal(txt1, txt2, {{text = b1 or "OK", callback = callback}}, icon)
    end]],
    [[    function window:Notify(txt1, txt2, b1, icon, callback, style)
        return showModal(
            txt1,
            txt2,
            {{text = b1 or "OK", callback = callback}},
            icon,
            style
        )
    end]],
    "Notify style"
)

source = plainReplace(
    source,
    [[    function window:Notify2(txt1, txt2, b1, b2, icon, callback, callback2)
        return showModal(txt1, txt2, {
            {text = b1 or "OK", callback = callback},
            {text = b2 or "Cancel", callback = callback2},
        }, icon)
    end]],
    [[    function window:Notify2(txt1, txt2, b1, b2, icon, callback, callback2, style)
        return showModal(txt1, txt2, {
            {text = b1 or "OK", callback = callback},
            {text = b2 or "Cancel", callback = callback2},
        }, icon, style)
    end]],
    "Notify2 style"
)

source = plainReplace(
    source,
    [[    function window:TempNotify(t1, t2, icon)]],
    [[    function window:TempNotify(t1, t2, icon, style)]],
    "toast signature"
)

source = plainReplace(
    source,
    [[        toast.BackgroundTransparency = 0.96]],
    [[        toast.BackgroundTransparency = 0.30]],
    "toast alpha"
)

source = plainReplace(
    source,
    [[        round(toast, 17)
        local toastGlass, toastFrost, toastGlassCtl = attachLiquidGlass(toast, "toast", 702, 17, 1, 1)
        toastGlassCtl:SetShown(false)
        toastGlassCtl.HideObject = holder
        stroke(toast, C.Black, 0.86, 0.8)]],
    [[        round(toast, 17)
        applyFrostedSurface(toast, style, 702, 0.30, 0.86)
        stroke(toast, C.Black, 0.86, 0.8)]],
    "toast frost"
)

source = replaceBetween(
    source,
    [[        local finalToastPosition = UDim2.new(1, -12, 0, 62)
        holder.Position = finalToastPosition
        holder.Visible = false

        -- New notification = one new capture. Capture at the final resting
        -- rectangle, then slide the already-frozen glass card onto screen.
        toastGlassCtl:Refresh(function(ok)]],
    [[        task.delay(4, function()]],
    [[        local finalToastPosition = UDim2.new(1, -12, 0, 62)

        holder.Position = UDim2.new(1, 28, 0, 62)
        holder.Visible = true

        tw(
            holder,
            TweenInfo.new(
                0.30,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {Position = finalToastPosition}
        )

]],
    "toast capture"
)


source = plainReplace(
    source,
    [[    function window:Section(name, customIcon, subtitle)
        local index = #sectionRecords + 1]],
    [[    function window:Section(name, customIcon, subtitle, options)
        if type(customIcon) == "table" then
            options = customIcon
            customIcon = options.Icon
            subtitle = options.Subtitle
        end

        options = options or {}

        local index = #sectionRecords + 1]],
    "Section options"
)

source = plainReplace(
    source,
    [[        round(header, 16)

        local hiBg]],
    [[        round(header, 16)
        applyFrostedSurface(
            header,
            options.Style,
            17,
            0.04,
            0.18
        )

        local hiBg]],
    "Section style"
)

source = plainReplace(
    source,
    [[            sidebarVisible = true,]],
    [[            sidebarVisible = options.ShowInSidebar ~= false,]],
    "section visibility"
)

source = plainReplace(
    source,
    [[            expanded = true,]],
    [[            expanded = options.Expanded ~= false,]],
    "section expanded"
)

source = plainReplace(
    source,
    [[        table.insert(sectionRecords, rec)

        local sec = {}]],
    [[        rec.searchTerms = {
            string.lower(tostring(name or ""))
        }

        table.insert(sectionRecords, rec)
        sb.Visible = rec.sidebarVisible

        local sec = {}]],
    "initial sidebar visibility"
)

source = plainReplace(
    source,
    [[        local sec = {}
        sec._rec = rec
        rec.section = sec

        function sec:Select()]],
    [[        local sec = {}
        sec._rec = rec
        rec.section = sec

        local function registerSearchText(value)
            if value == nil then
                return
            end

            local term =
                string.lower(
                    tostring(value)
                )

            if term == "" then
                return
            end

            table.insert(
                rec.searchTerms,
                term
            )
        end

        if subtitle then
            registerSearchText(subtitle)
        end

        function sec:Select()]],
    "section search registration"
)

source = plainReplace(
    source,
    [[        function sec:Create(childName, showInSidebar, childIcon, childSubtitle)
            local show = true
            if type(showInSidebar) == "table" then
                local opts = showInSidebar
                show = opts.ShowInSidebar ~= false
                childIcon = opts.Icon or childIcon
                childSubtitle = opts.Subtitle or childSubtitle]],
    [[        function sec:Create(childName, showInSidebar, childIcon, childSubtitle)
            local show = true
            local createOptions = nil

            if type(showInSidebar) == "table" then
                local opts = showInSidebar
                createOptions = opts
                show = opts.ShowInSidebar ~= false
                childIcon = opts.Icon or childIcon
                childSubtitle = opts.Subtitle or childSubtitle]],
    "Create options"
)

source = plainReplace(
    source,
    [[            local child = window:Section(childName, childIcon or ASSET.ChevronRight, childSubtitle)]],
    [[            local child = window:Section(
                childName,
                childIcon or ASSET.ChevronRight,
                childSubtitle,
                {
                    ShowInSidebar = show,
                    Expanded = not (
                        createOptions
                        and createOptions.Expanded == false
                    ),
                    Style = createOptions
                        and createOptions.Style
                        or nil,
                }
            )]],
    "Create passes style"
)

source = plainReplace(
    source,
    [[        sec.CreatePage = sec.Create

        -- Same appearance]],
    [[        function sec:SetExpanded(state)
            rec.expanded = state ~= false

            if rec.treeChevron then
                tw(
                    rec.treeChevron,
                    TweenInfo.new(
                        0.16,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Rotation = rec.expanded and 90 or 0,
                    }
                )
            end

            applyFilter()
            return sec
        end

        function sec:IsExpanded()
            return rec.expanded
        end

        sec.CreatePage = sec.Create

        -- Same appearance]],
    "collapse API"
)

source = plainReplace(
    source,
    [[        function sec:GoTo(text, target, buttonIcon)
            return sec:Button(text, function()
                local targetPage = resolvePage(target)
                if targetPage then
                    targetPage:Select()
                end
            end, buttonIcon)
        end]],
    [[        function sec:GoTo(text, target, buttonIcon, style)
            return sec:Button(text, function()
                local targetPage = resolvePage(target)
                if targetPage then
                    targetPage:Select()
                end
            end, buttonIcon, style)
        end]],
    "GoTo style"
)

source = plainReplace(
    source,
    [[        if index == 1 then sec:Select() end]],
    [[        if
            selectedIndex == 0
            and rec.sidebarVisible ~= false
        then
            sec:Select()
        end]],
    "first visible section"
)


source = plainReplace(
    source,
    [[        function sec:Divider(text)
            local d = Instance.new("TextLabel")]],
    [[        function sec:Divider(text)
            registerSearchText(text)

            local d = Instance.new("TextLabel")]],
    "divider search"
)

source = plainReplace(
    source,
    [[        local function makeRow(rowName, h)
            local row = Instance.new("Frame")]],
    [[        local function makeRow(rowName, h, style)
            local row = Instance.new("Frame")]],
    "makeRow"
)

source = plainReplace(
    source,
    [[            round(row, 14)
            return row
        end

        function sec:Button(text, callback, buttonIcon)]],
    [[            round(row, 14)
            applyFrostedSurface(
                row,
                style,
                17,
                0.05,
                0.22
            )
            return row
        end

        function sec:Button(text, callback, buttonIcon, style)
            registerSearchText(text)]],
    "button style"
)

source = plainReplace(
    source,
    [[            local row = makeRow("button", 52)]],
    [[            local row = makeRow("button", 52, style)]],
    "button row"
)

source = plainReplace(
    source,
    [[        function sec:Label(text)
            local row = makeRow("label", 48)]],
    [[        function sec:Label(text, style)
            registerSearchText(text)
            local row = makeRow("label", 48, style)]],
    "label style"
)


local switchReplacement = [[        function sec:Switch(text, defaultmode, callback, style)
            registerSearchText(text)
            local mode = defaultmode == true
            local row = makeRow("toggleswitch", 54, style)

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(16, 0)
            l.Size = UDim2.new(1, -102, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            local hit = Instance.new("TextButton")
            hit.Parent = row
            hit.AnchorPoint = Vector2.new(1, 0.5)
            hit.Position = UDim2.new(1, -8, 0.5, 0)
            hit.Size = UDim2.fromOffset(78, 64)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.AutoButtonColor = false
            hit.ZIndex = 21

            local track = Instance.new("Frame")
            track.Parent = hit
            track.AnchorPoint = Vector2.new(0.5, 0.5)
            track.Position = UDim2.fromScale(0.5, 0.5)
            track.Size = UDim2.fromOffset(51, 31)
            track.BackgroundColor3 = mode and C.Blue or C.SwitchOff
            track.BorderSizePixel = 0
            track.ZIndex = 22
            circle(track)

            local knobHolder = Instance.new("Frame")
            knobHolder.Parent = track
            knobHolder.AnchorPoint = Vector2.new(0.5, 0.5)
            knobHolder.Position = mode
                and UDim2.new(1, -15.5, 0.5, 0)
                or UDim2.new(0, 15.5, 0.5, 0)
            knobHolder.Size = UDim2.fromOffset(27, 27)
            knobHolder.BackgroundTransparency = 1
            knobHolder.ZIndex = 23

            local knobShadow =
                addShadow(knobHolder, 23, 12, 12, 0.82, true)

            local knob = Instance.new("Frame")
            knob.Parent = knobHolder
            knob.Size = UDim2.fromScale(1, 1)
            knob.BackgroundColor3 = C.White
            knob.BackgroundTransparency = 0
            knob.BorderSizePixel = 0
            knob.ZIndex = 24
            knob.ClipsDescendants = true
            circle(knob)

            local knobStyle = childStyle(style, "Knob")
            local hoverTransparency =
                styleNumber(knobStyle, "Transparency", 0.72)
            local hoverFrost =
                styleNumber(knobStyle, "Frost", 0.88)

            local knobFrost = applyFrostedSurface(
                knob,
                {Transparency = 0, Frost = 0},
                25,
                0,
                0
            )

            local knobDark =
                stroke(knob, Color3.fromRGB(22, 22, 24), 0.92, 0.8)

            local knobLight =
                stroke(knob, C.White, 1, 1)

            local knobScale = Instance.new("UIScale")
            knobScale.Scale = 1
            knobScale.Parent = knobHolder

            local hovering = false
            local jellyToken = 0

            local function setTrack(animate)
                tw(
                    track,
                    TweenInfo.new(
                        animate and 0.18 or 0,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    {
                        BackgroundColor3 =
                            mode and C.Blue or C.SwitchOff
                    }
                )

                tw(
                    knobHolder,
                    TweenInfo.new(
                        animate and 0.24 or 0,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Position = mode
                            and UDim2.new(1, -15.5, 0.5, 0)
                            or UDim2.new(0, 15.5, 0.5, 0)
                    }
                )
            end

            local function showHoverFrost()
                knobFrost:Set(
                    hoverTransparency,
                    hoverFrost
                )

                tw(
                    knobDark,
                    TweenInfo.new(0.12),
                    {Transparency = 0.78}
                )

                tw(
                    knobLight,
                    TweenInfo.new(0.12),
                    {Transparency = 0.22}
                )

                tw(
                    knobShadow,
                    TweenInfo.new(0.12),
                    {ImageTransparency = 0.86}
                )
            end

            local function showNormalBall()
                knobFrost:Set(0, 0)

                tw(
                    knobDark,
                    TweenInfo.new(0.14),
                    {Transparency = 0.92}
                )

                tw(
                    knobLight,
                    TweenInfo.new(0.14),
                    {Transparency = 1}
                )

                tw(
                    knobShadow,
                    TweenInfo.new(0.14),
                    {ImageTransparency = 0.82}
                )
            end

            local function startHoverJelly()
                jellyToken += 1
                local token = jellyToken

                showHoverFrost()

                task.spawn(function()
                    local a = tw(
                        knobScale,
                        TweenInfo.new(
                            0.070,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.Out
                        ),
                        {Scale = 1.32}
                    )

                    a.Completed:Wait()

                    if token ~= jellyToken or not hovering then
                        return
                    end

                    local b = tw(
                        knobScale,
                        TweenInfo.new(
                            0.080,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.InOut
                        ),
                        {Scale = 1.20}
                    )

                    b.Completed:Wait()

                    if token ~= jellyToken or not hovering then
                        return
                    end

                    tw(
                        knobScale,
                        TweenInfo.new(
                            0.18,
                            Enum.EasingStyle.Back,
                            Enum.EasingDirection.Out
                        ),
                        {Scale = 1.25}
                    )
                end)
            end

            local function endHover()
                jellyToken += 1
                showNormalBall()

                tw(
                    knobScale,
                    TweenInfo.new(
                        0.24,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),
                    {Scale = 1}
                )
            end

            hit.MouseEnter:Connect(function()
                if hovering then return end
                hovering = true
                startHoverJelly()
            end)

            hit.MouseLeave:Connect(function()
                if not hovering then return end
                hovering = false
                endHover()
            end)

            hit.InputBegan:Connect(function(input)
                if
                    input.UserInputType
                        == Enum.UserInputType.Touch
                    and not hovering
                then
                    hovering = true
                    startHoverJelly()
                end
            end)

            hit.InputEnded:Connect(function(input)
                if
                    input.UserInputType
                        == Enum.UserInputType.Touch
                then
                    task.delay(0.12, function()
                        if hovering then
                            hovering = false
                            endHover()
                        end
                    end)
                end
            end)

            hit.Activated:Connect(function()
                mode = not mode
                setTrack(true)

                if callback then
                    callback(mode)
                end
            end)

            setTrack(false)
            showNormalBall()

            return row
        end

]]

source = replaceBetween(
    source,
    [[        function sec:Switch(text, defaultmode, callback)]],
    [[        function sec:Dropdown(]],
    switchReplacement,
    "Switch"
)


local dropdownReplacement = [[        function sec:Slider(text, minValue, maxValue, defaultValue, callback, options)
            registerSearchText(text)
            options = options or {}

            minValue = tonumber(minValue) or 0
            maxValue = tonumber(maxValue) or 100

            if maxValue < minValue then
                minValue, maxValue = maxValue, minValue
            end

            if maxValue == minValue then
                maxValue = minValue + 1
            end

            local initialStep = tonumber(options.Step) or 0
            if initialStep < 0 then
                initialStep = math.abs(initialStep)
            end

            -- Step = nil / "" / 0 means fully continuous.
            if initialStep <= 0 then
                initialStep = 0
            end

            local initialShowSteps =
                initialStep > 0
                and options.ShowSteps ~= false

            local value =
                math.clamp(
                    tonumber(defaultValue) or minValue,
                    minValue,
                    maxValue
                )

            local row = makeRow(
                "slider",
                currentMobile and 94 or 70,
                options
            )

            row:SetAttribute("Minimum", minValue)
            row:SetAttribute("Maximum", maxValue)
            row:SetAttribute("Step", initialStep)
            row:SetAttribute("ShowSteps", initialShowSteps)
            row:SetAttribute("Value", value)

            ----------------------------------------------------------------
            -- Label
            ----------------------------------------------------------------

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            ----------------------------------------------------------------
            -- Slider control host
            ----------------------------------------------------------------

            local control = Instance.new("Frame")
            control.Parent = row
            control.BackgroundTransparency = 1
            control.ZIndex = 19

            if currentMobile then
                l.Position = UDim2.fromOffset(14, 3)
                l.Size = UDim2.new(1, -28, 0, 25)

                control.Position = UDim2.fromOffset(12, 31)
                control.Size = UDim2.new(1, -24, 0, 52)
            else
                l.Position = UDim2.fromOffset(16, 0)
                l.Size = UDim2.new(0.31, 0, 1, 0)

                control.AnchorPoint = Vector2.new(1, 0.5)
                control.Position = UDim2.new(1, -12, 0.5, 0)
                control.Size = UDim2.new(0.64, 0, 0, 52)
            end

            local leftIconAsset = options.LeftIcon
            local rightIconAsset = options.RightIcon

            local leftPad =
                leftIconAsset and 31 or 4

            local rightPad =
                rightIconAsset and 31 or 4

            local iconColor =
                typeof(options.IconColor) == "Color3"
                and options.IconColor
                or Color3.fromRGB(112, 112, 117)

            if leftIconAsset and leftIconAsset ~= "" then
                local leftIcon = iconLabel(
                    control,
                    leftIconAsset,
                    tonumber(options.LeftIconSize) or 18,
                    typeof(options.LeftIconColor) == "Color3"
                        and options.LeftIconColor
                        or iconColor,
                    23
                )

                leftIcon.AnchorPoint = Vector2.new(0, 0.5)
                leftIcon.Position = UDim2.new(0, 0, 0, 20)
            end

            if rightIconAsset and rightIconAsset ~= "" then
                local rightIcon = iconLabel(
                    control,
                    rightIconAsset,
                    tonumber(options.RightIconSize) or 20,
                    typeof(options.RightIconColor) == "Color3"
                        and options.RightIconColor
                        or iconColor,
                    23
                )

                rightIcon.AnchorPoint = Vector2.new(1, 0.5)
                rightIcon.Position = UDim2.new(1, 0, 0, 20)
            end

            ----------------------------------------------------------------
            -- Track
            ----------------------------------------------------------------

            local track = Instance.new("Frame")
            track.Parent = control
            track.Position = UDim2.new(
                0,
                leftPad,
                0,
                16
            )
            track.Size = UDim2.new(
                1,
                -(leftPad + rightPad),
                0,
                8
            )
            track.BackgroundColor3 =
                typeof(options.TrackColor) == "Color3"
                and options.TrackColor
                or Color3.fromRGB(218, 218, 222)
            track.BorderSizePixel = 0
            track.ZIndex = 21
            circle(track)

            local fill = Instance.new("Frame")
            fill.Parent = track
            fill.Size = UDim2.fromScale(0, 1)
            fill.BackgroundColor3 =
                typeof(options.FillColor) == "Color3"
                and options.FillColor
                or C.Blue
            fill.BorderSizePixel = 0
            fill.ZIndex = 22
            circle(fill)

            ----------------------------------------------------------------
            -- Step dots
            ----------------------------------------------------------------

            local dotsHost = Instance.new("Frame")
            dotsHost.Name = "StepDots"
            dotsHost.Parent = control
            dotsHost.Position = UDim2.new(
                0,
                leftPad,
                0,
                32
            )
            dotsHost.Size = UDim2.new(
                1,
                -(leftPad + rightPad),
                0,
                8
            )
            dotsHost.BackgroundTransparency = 1
            dotsHost.ZIndex = 20

            local function getStep()
                local step =
                    tonumber(
                        row:GetAttribute("Step")
                    ) or 0

                if step < 0 then
                    step = math.abs(step)
                end

                if step <= 0 then
                    return 0
                end

                return step
            end

            local function showStepsEnabled()
                return
                    getStep() > 0
                    and row:GetAttribute("ShowSteps") == true
            end

            local function rebuildStepDots()
                for _, child in ipairs(
                    dotsHost:GetChildren()
                ) do
                    child:Destroy()
                end

                dotsHost.Visible =
                    showStepsEnabled()

                if not dotsHost.Visible then
                    return
                end

                local step = getStep()
                local range = maxValue - minValue

                if step <= 0 or range <= 0 then
                    dotsHost.Visible = false
                    return
                end

                local intervalCount =
                    math.max(
                        1,
                        math.floor(
                            range / step + 0.000001
                        )
                    )

                -- Avoid building hundreds of GUI dots.
                -- Snapping still uses the exact Step value; only the
                -- visual markers are thinned when there are too many.
                local maxDots =
                    math.max(
                        2,
                        tonumber(options.MaxStepDots)
                            or 32
                    )

                local stride =
                    math.max(
                        1,
                        math.ceil(
                            intervalCount
                            / (maxDots - 1)
                        )
                    )

                local dotColor =
                    typeof(options.StepColor) == "Color3"
                    and options.StepColor
                    or Color3.fromRGB(177, 177, 182)

                local dotSize =
                    math.clamp(
                        tonumber(options.StepDotSize)
                            or 3,
                        2,
                        6
                    )

                local function makeDot(alpha)
                    local dot = Instance.new("Frame")
                    dot.Parent = dotsHost
                    dot.AnchorPoint =
                        Vector2.new(0.5, 0.5)
                    dot.Position =
                        UDim2.new(
                            math.clamp(alpha, 0, 1),
                            0,
                            0.5,
                            0
                        )
                    dot.Size =
                        UDim2.fromOffset(
                            dotSize,
                            dotSize
                        )
                    dot.BackgroundColor3 =
                        dotColor
                    dot.BackgroundTransparency =
                        0.16
                    dot.BorderSizePixel = 0
                    dot.ZIndex = 21
                    circle(dot)
                end

                local lastAlpha = -1

                for i = 0, intervalCount, stride do
                    local steppedValue =
                        math.min(
                            minValue + i * step,
                            maxValue
                        )

                    local alpha =
                        (steppedValue - minValue)
                        / range

                    makeDot(alpha)
                    lastAlpha = alpha
                end

                if lastAlpha < 0.999 then
                    makeDot(1)
                end
            end

            ----------------------------------------------------------------
            -- Knob: same visual language as Switch
            ----------------------------------------------------------------

            local knobHolder = Instance.new("Frame")
            knobHolder.Parent = track
            knobHolder.AnchorPoint =
                Vector2.new(0.5, 0.5)
            knobHolder.Position =
                UDim2.new(0, 0, 0.5, 0)
            knobHolder.Size =
                UDim2.fromOffset(25, 25)
            knobHolder.BackgroundTransparency = 1
            knobHolder.ZIndex = 26

            local knobShadow =
                addShadow(
                    knobHolder,
                    26,
                    10,
                    10,
                    0.82,
                    true
                )

            local knob = Instance.new("Frame")
            knob.Parent = knobHolder
            knob.Size = UDim2.fromScale(1, 1)
            knob.BackgroundColor3 = C.White
            knob.BackgroundTransparency = 0
            knob.BorderSizePixel = 0
            knob.ZIndex = 27
            knob.ClipsDescendants = true
            circle(knob)

            local knobStyle =
                childStyle(options, "Knob")

            local hoverTransparency =
                styleNumber(
                    knobStyle,
                    "Transparency",
                    0.72
                )

            local hoverFrost =
                styleNumber(
                    knobStyle,
                    "Frost",
                    0.88
                )

            local knobFrost =
                applyFrostedSurface(
                    knob,
                    {
                        Transparency = 0,
                        Frost = 0,
                    },
                    28,
                    0,
                    0
                )

            local knobDark =
                stroke(
                    knob,
                    Color3.fromRGB(22, 22, 24),
                    0.92,
                    0.8
                )

            local knobLight =
                stroke(
                    knob,
                    C.White,
                    1,
                    1
                )

            local knobScale =
                Instance.new("UIScale")
            knobScale.Scale = 1
            knobScale.Parent = knobHolder

            ----------------------------------------------------------------
            -- Optional value label
            ----------------------------------------------------------------

            local valueLabel

            if options.ShowValue == true then
                valueLabel =
                    Instance.new("TextLabel")

                valueLabel.Parent = control
                valueLabel.AnchorPoint =
                    Vector2.new(0.5, 1)
                valueLabel.Position =
                    UDim2.new(0.5, 0, 0, 10)
                valueLabel.Size =
                    UDim2.fromOffset(86, 18)
                valueLabel.BackgroundTransparency = 1
                valueLabel.TextColor3 =
                    C.Secondary
                valueLabel.TextSize = 11
                valueLabel.Font =
                    Enum.Font.GothamMedium
                valueLabel.TextXAlignment =
                    Enum.TextXAlignment.Center
                valueLabel.ZIndex = 24
            end

            local function decimalsForStep(step)
                if step <= 0 then
                    return
                        tonumber(options.Decimals)
                        or 2
                end

                local s = tostring(step)
                local dot =
                    string.find(s, ".", 1, true)

                if not dot then
                    return 0
                end

                return math.min(
                    6,
                    #s - dot
                )
            end

            local function formatValue(v)
                if
                    type(options.ValueFormatter)
                        == "function"
                then
                    local ok, result =
                        pcall(
                            options.ValueFormatter,
                            v
                        )

                    if ok and result ~= nil then
                        return tostring(result)
                    end
                end

                local decimals =
                    decimalsForStep(getStep())

                local suffix =
                    tostring(options.Suffix or "")

                return
                    string.format(
                        "%."
                        .. tostring(decimals)
                        .. "f",
                        v
                    )
                    .. suffix
            end

            ----------------------------------------------------------------
            -- Value logic
            ----------------------------------------------------------------

            local settingValueAttribute = false

            local function snapValue(raw)
                raw =
                    math.clamp(
                        tonumber(raw) or minValue,
                        minValue,
                        maxValue
                    )

                local step = getStep()

                if step > 0 then
                    raw =
                        minValue
                        + math.floor(
                            (raw - minValue)
                            / step
                            + 0.5
                        )
                        * step
                end

                return
                    math.clamp(
                        raw,
                        minValue,
                        maxValue
                    )
            end

            local function alphaForValue(v)
                return
                    math.clamp(
                        (v - minValue)
                        / (maxValue - minValue),
                        0,
                        1
                    )
            end

            local function updateVisual()
                local alpha =
                    alphaForValue(value)

                fill.Size =
                    UDim2.new(
                        alpha,
                        0,
                        1,
                        0
                    )

                knobHolder.Position =
                    UDim2.new(
                        alpha,
                        0,
                        0.5,
                        0
                    )

                if valueLabel then
                    valueLabel.Text =
                        formatValue(value)
                end
            end

            local function setValue(newValue, fireCallback)
                local snapped =
                    snapValue(newValue)

                if math.abs(snapped - value) < 1e-9 then
                    updateVisual()
                    return
                end

                value = snapped

                settingValueAttribute = true
                row:SetAttribute("Value", value)
                settingValueAttribute = false

                updateVisual()

                if fireCallback and callback then
                    callback(value)
                end
            end

            ----------------------------------------------------------------
            -- Hover / drag jelly animation
            ----------------------------------------------------------------

            local hovering = false
            local dragging = false
            local dragInput
            local jellyToken = 0

            local function showHoverFrost()
                knobFrost:Set(
                    hoverTransparency,
                    hoverFrost
                )

                tw(
                    knobDark,
                    TweenInfo.new(0.12),
                    {Transparency = 0.78}
                )

                tw(
                    knobLight,
                    TweenInfo.new(0.12),
                    {Transparency = 0.22}
                )

                tw(
                    knobShadow,
                    TweenInfo.new(0.12),
                    {ImageTransparency = 0.86}
                )
            end

            local function showNormalBall()
                knobFrost:Set(0, 0)

                tw(
                    knobDark,
                    TweenInfo.new(0.14),
                    {Transparency = 0.92}
                )

                tw(
                    knobLight,
                    TweenInfo.new(0.14),
                    {Transparency = 1}
                )

                tw(
                    knobShadow,
                    TweenInfo.new(0.14),
                    {ImageTransparency = 0.82}
                )
            end

            local function startJelly()
                jellyToken += 1
                local token = jellyToken

                showHoverFrost()

                task.spawn(function()
                    local a = tw(
                        knobScale,
                        TweenInfo.new(
                            0.070,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.Out
                        ),
                        {Scale = 1.32}
                    )

                    a.Completed:Wait()

                    if
                        token ~= jellyToken
                        or (not hovering and not dragging)
                    then
                        return
                    end

                    local b = tw(
                        knobScale,
                        TweenInfo.new(
                            0.080,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.InOut
                        ),
                        {Scale = 1.20}
                    )

                    b.Completed:Wait()

                    if
                        token ~= jellyToken
                        or (not hovering and not dragging)
                    then
                        return
                    end

                    tw(
                        knobScale,
                        TweenInfo.new(
                            0.18,
                            Enum.EasingStyle.Back,
                            Enum.EasingDirection.Out
                        ),
                        {Scale = 1.25}
                    )
                end)
            end

            local function endJelly()
                jellyToken += 1
                showNormalBall()

                tw(
                    knobScale,
                    TweenInfo.new(
                        0.24,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),
                    {Scale = 1}
                )
            end

            ----------------------------------------------------------------
            -- Hit areas
            ----------------------------------------------------------------

            local trackHit =
                Instance.new("TextButton")

            trackHit.Parent = control
            trackHit.Position =
                UDim2.new(
                    0,
                    leftPad,
                    0,
                    2
                )
            trackHit.Size =
                UDim2.new(
                    1,
                    -(leftPad + rightPad),
                    0,
                    36
                )
            trackHit.BackgroundTransparency = 1
            trackHit.Text = ""
            trackHit.AutoButtonColor = false
            trackHit.ZIndex = 25

            local knobHit =
                Instance.new("TextButton")

            knobHit.Parent = knobHolder
            knobHit.AnchorPoint =
                Vector2.new(0.5, 0.5)
            knobHit.Position =
                UDim2.fromScale(0.5, 0.5)
            knobHit.Size =
                UDim2.fromOffset(40, 40)
            knobHit.BackgroundTransparency = 1
            knobHit.Text = ""
            knobHit.AutoButtonColor = false
            knobHit.ZIndex = 30

            local function valueFromScreenX(screenX)
                local width =
                    math.max(
                        1,
                        track.AbsoluteSize.X
                    )

                local alpha =
                    math.clamp(
                        (
                            screenX
                            - track.AbsolutePosition.X
                        )
                        / width,
                        0,
                        1
                    )

                return
                    minValue
                    + (maxValue - minValue)
                    * alpha
            end

            local function beginDrag(input)
                dragging = true
                dragInput = input

                if not hovering then
                    startJelly()
                end

                setValue(
                    valueFromScreenX(
                        input.Position.X
                    ),
                    true
                )
            end

            trackHit.InputBegan:Connect(function(input)
                if
                    input.UserInputType
                        == Enum.UserInputType.MouseButton1
                    or input.UserInputType
                        == Enum.UserInputType.Touch
                then
                    beginDrag(input)
                end
            end)

            knobHit.InputBegan:Connect(function(input)
                if
                    input.UserInputType
                        == Enum.UserInputType.MouseButton1
                    or input.UserInputType
                        == Enum.UserInputType.Touch
                then
                    beginDrag(input)
                end
            end)

            knobHit.MouseEnter:Connect(function()
                if hovering then return end
                hovering = true

                if not dragging then
                    startJelly()
                end
            end)

            knobHit.MouseLeave:Connect(function()
                hovering = false

                if not dragging then
                    endJelly()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not dragging then
                    return
                end

                local allowed =
                    input.UserInputType
                        == Enum.UserInputType.MouseMovement

                if
                    input.UserInputType
                        == Enum.UserInputType.Touch
                then
                    allowed =
                        input == dragInput
                end

                if allowed then
                    setValue(
                        valueFromScreenX(
                            input.Position.X
                        ),
                        true
                    )
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if not dragging then
                    return
                end

                local endsDrag =
                    input.UserInputType
                        == Enum.UserInputType.MouseButton1

                if
                    input.UserInputType
                        == Enum.UserInputType.Touch
                then
                    endsDrag =
                        input == dragInput
                end

                if endsDrag then
                    dragging = false
                    dragInput = nil

                    if not hovering then
                        endJelly()
                    end
                end
            end)

            ----------------------------------------------------------------
            -- Runtime attributes
            ----------------------------------------------------------------

            row:GetAttributeChangedSignal("Value"):Connect(function()
                if settingValueAttribute then
                    return
                end

                setValue(
                    row:GetAttribute("Value"),
                    false
                )
            end)

            row:GetAttributeChangedSignal("Step"):Connect(function()
                local step = getStep()

                if step <= 0 then
                    dotsHost.Visible = false
                end

                rebuildStepDots()
                setValue(value, false)
            end)

            row:GetAttributeChangedSignal("ShowSteps"):Connect(function()
                rebuildStepDots()
            end)

            rebuildStepDots()
            value = snapValue(value)

            settingValueAttribute = true
            row:SetAttribute("Value", value)
            settingValueAttribute = false

            updateVisual()
            showNormalBall()

            return row
        end

        function sec:Dropdown(text, options, defaultValue, callback, style)
            registerSearchText(text)
            options = options or {}

            local current =
                defaultValue or options[1] or "Select"

            local row =
                makeRow("dropdown", 54, style)

            local l = Instance.new("TextLabel")
            l.Parent = row
            l.Position = UDim2.fromOffset(16, 0)
            l.Size = UDim2.new(0.42, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = C.Text
            l.TextSize = currentMobile and 14 or 16
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 18

            local trigger = Instance.new("TextButton")
            trigger.Parent = row
            trigger.AnchorPoint = Vector2.new(1, 0.5)
            trigger.Position = UDim2.new(1, -10, 0.5, 0)
            trigger.Size = UDim2.new(0.52, 0, 0, 36)
            trigger.BackgroundColor3 = C.Card
            trigger.BorderSizePixel = 0
            trigger.Text = ""
            trigger.AutoButtonColor = false
            trigger.ZIndex = 20
            round(trigger, 10)

            local triggerStyle =
                childStyle(style, "Trigger")

            local triggerFrostCtl =
                applyFrostedSurface(
                    trigger,
                    triggerStyle,
                    20,
                    0,
                    0
                )

            stroke(trigger, C.Black, 0.88, 0.8)
            addTopHighlight(trigger, 16, 22, 0.24)

            local vl = Instance.new("TextLabel")
            vl.Parent = trigger
            vl.Position = UDim2.fromOffset(12, 0)
            vl.Size = UDim2.new(1, -36, 1, 0)
            vl.BackgroundTransparency = 1
            vl.Text = tostring(current)
            vl.TextColor3 = C.Text
            vl.TextSize = 14
            vl.Font = Enum.Font.Gotham
            vl.TextXAlignment = Enum.TextXAlignment.Left
            vl.ZIndex = 23

            local chevron =
                iconLabel(
                    trigger,
                    ASSET.ChevronDown,
                    16,
                    C.Secondary,
                    23
                )

            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position =
                UDim2.new(1, -9, 0.5, 0)

            local menuHolder = Instance.new("Frame")
            menuHolder.Parent = scrgui
            menuHolder.Size =
                UDim2.fromOffset(
                    220,
                    math.max(44, #options * 38 + 10)
                )
            menuHolder.BackgroundTransparency = 1
            menuHolder.Visible = false
            menuHolder.ZIndex = 980

            addShadow(
                menuHolder,
                980,
                44,
                46,
                0.78,
                false
            )

            local menu = Instance.new("CanvasGroup")
            menu.Parent = menuHolder
            menu.Size = UDim2.fromScale(1, 1)
            menu.BackgroundColor3 =
                C.Card
            menu.BorderSizePixel = 0
            menu.GroupTransparency = 0
            menu.ZIndex = 981
            menu.ClipsDescendants = true
            round(menu, 15)

            local popupStyle =
                childStyle(style, "Popup")

            local menuFrostCtl =
                applyFrostedSurface(
                    menu,
                    popupStyle,
                    982,
                    0,
                    0
                )

            stroke(menu, C.Black, 0.84, 0.8)
            addTopHighlight(menu, 24, 986, 0.12)

            local function refreshDropdownConfig()
                if appConfig.DropdownTransparent == true then
                    local dropdownAlpha =
                        math.clamp(
                            tonumber(
                                appConfig.DropdownTransparency
                            )
                            or 0.34,
                            0,
                            0.85
                        )

                    local dropdownFrost =
                        math.clamp(
                            tonumber(
                                appConfig.DropdownFrost
                            )
                            or 0.86,
                            0,
                            1
                        )

                    triggerFrostCtl:Set(
                        styleNumber(
                            triggerStyle,
                            "Transparency",
                            dropdownAlpha * 0.35
                        ),
                        styleNumber(
                            triggerStyle,
                            "Frost",
                            dropdownFrost * 0.42
                        )
                    )

                    menuFrostCtl:Set(
                        styleNumber(
                            popupStyle,
                            "Transparency",
                            dropdownAlpha
                        ),
                        styleNumber(
                            popupStyle,
                            "Frost",
                            dropdownFrost
                        )
                    )
                else
                    triggerFrostCtl:Set(0, 0)
                    menuFrostCtl:Set(0, 0)
                end
            end

            table.insert(
                configRefreshers,
                refreshDropdownConfig
            )

            refreshDropdownConfig()

            local menuItems = Instance.new("Frame")
            menuItems.Name = "Items"
            menuItems.Parent = menu
            menuItems.Size = UDim2.fromScale(1, 1)
            menuItems.BackgroundTransparency = 1
            menuItems.ZIndex = 984

            local menuLayout =
                Instance.new("UIListLayout")
            menuLayout.Parent = menuItems
            menuLayout.SortOrder =
                Enum.SortOrder.LayoutOrder
            menuLayout.HorizontalAlignment =
                Enum.HorizontalAlignment.Center
            menuLayout.Padding = UDim.new(0, 0)

            local menuPad =
                Instance.new("UIPadding")
            menuPad.Parent = menuItems
            menuPad.PaddingTop = UDim.new(0, 5)
            menuPad.PaddingBottom = UDim.new(0, 5)
            menuPad.PaddingLeft = UDim.new(0, 5)
            menuPad.PaddingRight = UDim.new(0, 5)

            local open = false

            local function reposition()
                local p = trigger.AbsolutePosition
                local s = trigger.AbsoluteSize
                local cam = workspace.CurrentCamera

                if not cam then return end

                local menuW =
                    math.max(180, math.floor(s.X))

                menuHolder.Size =
                    UDim2.fromOffset(
                        menuW,
                        math.max(44, #options * 38 + 10)
                    )

                local x = math.clamp(
                    p.X,
                    8,
                    cam.ViewportSize.X - menuW - 8
                )

                local y = p.Y + s.Y + 6

                if
                    y + menuHolder.AbsoluteSize.Y
                        > cam.ViewportSize.Y - 8
                then
                    y =
                        p.Y
                        - menuHolder.AbsoluteSize.Y
                        - 6
                end

                menuHolder.Position =
                    UDim2.fromOffset(x, y)
            end

            local function setOpen(state)
                open = state

                if state then
                    reposition()
                    menuHolder.Visible = true
                    menu.GroupTransparency = 1
                    menu.Position =
                        UDim2.fromOffset(0, -5)

                    tw(
                        menu,
                        TweenInfo.new(
                            0.17,
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ),
                        {
                            GroupTransparency = 0,
                            Position =
                                UDim2.fromOffset(0, 0),
                        }
                    )

                    tw(
                        chevron,
                        TweenInfo.new(0.18),
                        {Rotation = 180}
                    )
                else
                    tw(
                        chevron,
                        TweenInfo.new(0.18),
                        {Rotation = 0}
                    )

                    local t = tw(
                        menu,
                        TweenInfo.new(0.12),
                        {
                            GroupTransparency = 1,
                            Position =
                                UDim2.fromOffset(0, -4),
                        }
                    )

                    task.spawn(function()
                        t.Completed:Wait()

                        if not open then
                            menuHolder.Visible = false
                        end
                    end)
                end
            end

            for _, option in ipairs(options) do
                local item =
                    Instance.new("TextButton")

                item.Parent = menuItems
                item.Size =
                    UDim2.new(1, 0, 0, 38)
                item.BackgroundColor3 = C.White
                item.BackgroundTransparency = 1
                item.BorderSizePixel = 0
                item.Text = tostring(option)
                item.TextColor3 = C.Text
                item.TextSize = 14
                item.Font = Enum.Font.Gotham
                item.AutoButtonColor = false
                item.ZIndex = 984
                round(item, 10)

                item.MouseEnter:Connect(function()
                    tw(
                        item,
                        TweenInfo.new(0.10),
                        {
                            BackgroundTransparency = 0.54,
                            BackgroundColor3 =
                                Color3.fromRGB(
                                    232,
                                    239,
                                    250
                                ),
                        }
                    )
                end)

                item.MouseLeave:Connect(function()
                    tw(
                        item,
                        TweenInfo.new(0.12),
                        {BackgroundTransparency = 1}
                    )
                end)

                item.Activated:Connect(function()
                    current = option
                    vl.Text = tostring(option)
                    setOpen(false)

                    if callback then
                        callback(option)
                    end
                end)
            end

            trigger.Activated:Connect(function()
                setOpen(not open)
            end)

            return row
        end

]]

source = replaceBetween(
    source,
    [[        function sec:Dropdown(]],
    [[        function sec:TextField(]],
    dropdownReplacement,
    "Dropdown"
)


source = plainReplace(
    source,
    [[        function sec:TextField(text, placeholder, callback)
            local row = makeRow("textfield", currentMobile and 88 or 54)]],
    [[        function sec:TextField(text, placeholder, callback, style)
            registerSearchText(text)
            local row = makeRow(
                "textfield",
                currentMobile and 88 or 54,
                style
            )]],
    "TextField style"
)

source = plainReplace(
    source,
    [[            round(field, 10)
            local fs = stroke(field, C.Black, 0.90, 0.8)]],
    [[            round(field, 10)

            applyFrostedSurface(
                field,
                childStyle(style, "Input"),
                19,
                0.10,
                0.24
            )

            local fs =
                stroke(field, C.Black, 0.90, 0.8)]],
    "TextField frost"
)


local guiSettingsPageCode = [[    ------------------------------------------------------------------------
    -- Built-in GUI settings page
    ------------------------------------------------------------------------
    task.defer(function()
        if not scrgui.Parent then return end

        guiSettingsPage = window:Section("GUI设置", {
            Icon = ASSET.Settings,
            Subtitle = "主题、透明度、磨砂与配置",
            ShowInSidebar = appConfig.ShowGUISettings ~= false,
            Expanded = true,
            Style = {
                Transparency = 0.03,
                Frost = 0.14,
            },
        })

        local rec =
            guiSettingsPage
            and guiSettingsPage._rec

        if not rec then
            return
        end

        rec.sidebarVisible =
            appConfig.ShowGUISettings ~= false

        rec.button.Visible =
            rec.sidebarVisible

        guiSettingsPage:Label(
            "AppleGUI 内置设置。执行器支持 readfile/writefile 时可读取和保存配置；"
            .. "未检测到配置文件时自动使用默认值。",
            {
                Transparency = 0.10,
                Frost = 0.26,
            }
        )

        guiSettingsPage:Label(
            "配置目录　"
            .. tostring(
                appConfig.ConfigFolder
                or DEFAULT_GUI_CONFIG.ConfigFolder
            )
            .. "　文件　"
            .. tostring(
                appConfig.ConfigFileName
                or DEFAULT_GUI_CONFIG.ConfigFileName
            ),
            {
                Transparency = 0.10,
                Frost = 0.24,
            }
        )

        guiSettingsPage:Label(
            "完整路径　"
            .. tostring(
                appConfig.ConfigPath
                or DEFAULT_GUI_CONFIG.ConfigPath
            ),
            {
                Transparency = 0.10,
                Frost = 0.24,
            }
        )

        ------------------------------------------------------------
        -- 主题
        ------------------------------------------------------------

        guiSettingsPage:Divider("主题")

        guiSettingsPage:Dropdown(
            "界面主题",
            {
                "浅色",
                "深色",
            },
            appConfig.Theme == "Dark"
                and "深色"
                or "浅色",
            function(value)
                window:SetConfig(
                    "Theme",
                    value == "深色"
                        and "Dark"
                        or "Light"
                )
            end
        )

        ------------------------------------------------------------
        -- 分类栏
        ------------------------------------------------------------

        guiSettingsPage:Divider("分类栏")

        guiSettingsPage:Switch(
            "分类栏半透明",
            appConfig.SidebarTranslucent ~= false,
            function(value)
                window:SetConfig(
                    "SidebarTranslucent",
                    value
                )
            end
        )

        guiSettingsPage:Slider(
            "分类栏透明度",
            0,
            70,
            math.floor(
                (
                    tonumber(
                        appConfig.SidebarTransparency
                    )
                    or 0.22
                )
                * 100
                + 0.5
            ),
            function(value)
                -- 拖动 Slider 时不连续写配置文件。
                window:SetConfig(
                    "SidebarTransparency",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        ------------------------------------------------------------
        -- 全局透明度
        ------------------------------------------------------------

        guiSettingsPage:Divider("透明")

        guiSettingsPage:Switch(
            "开启透明效果",
            appConfig.TransparencyEnabled ~= false,
            function(value)
                window:SetConfig(
                    "TransparencyEnabled",
                    value
                )
            end
        )

        guiSettingsPage:Switch(
            "窗口半透明",
            appConfig.WindowTransparent == true,
            function(value)
                window:SetConfig(
                    "WindowTransparent",
                    value
                )
            end
        )

        guiSettingsPage:Slider(
            "窗口透明度",
            0,
            55,
            math.floor(
                (
                    tonumber(
                        appConfig.WindowTransparency
                    )
                    or 0.08
                )
                * 100
                + 0.5
            ),
            function(value)
                window:SetConfig(
                    "WindowTransparency",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        guiSettingsPage:Slider(
            "内容区域透明度",
            0,
            55,
            math.floor(
                (
                    tonumber(
                        appConfig.ContentTransparency
                    )
                    or 0.10
                )
                * 100
                + 0.5
            ),
            function(value)
                window:SetConfig(
                    "ContentTransparency",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        ------------------------------------------------------------
        -- 磨砂
        ------------------------------------------------------------

        guiSettingsPage:Divider("磨砂")

        guiSettingsPage:Switch(
            "开启磨砂效果",
            appConfig.FrostEnabled ~= false,
            function(value)
                window:SetConfig(
                    "FrostEnabled",
                    value
                )
            end
        )

        guiSettingsPage:Slider(
            "全局磨砂强度",
            0,
            100,
            math.floor(
                (
                    tonumber(
                        appConfig.FrostStrength
                    )
                    or 1
                )
                * 100
                + 0.5
            ),
            function(value)
                window:SetConfig(
                    "FrostStrength",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        ------------------------------------------------------------
        -- 下拉菜单
        ------------------------------------------------------------

        guiSettingsPage:Divider("下拉菜单")

        guiSettingsPage:Switch(
            "下拉菜单透明",
            appConfig.DropdownTransparent == true,
            function(value)
                window:SetConfig(
                    "DropdownTransparent",
                    value
                )
            end
        )

        guiSettingsPage:Slider(
            "下拉菜单透明度",
            0,
            75,
            math.floor(
                (
                    tonumber(
                        appConfig.DropdownTransparency
                    )
                    or 0.34
                )
                * 100
                + 0.5
            ),
            function(value)
                window:SetConfig(
                    "DropdownTransparency",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        guiSettingsPage:Slider(
            "下拉菜单磨砂强度",
            0,
            100,
            math.floor(
                (
                    tonumber(
                        appConfig.DropdownFrost
                    )
                    or 0.86
                )
                * 100
                + 0.5
            ),
            function(value)
                window:SetConfig(
                    "DropdownFrost",
                    value / 100,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
                Suffix = "%",
            }
        )

        ------------------------------------------------------------
        -- 窗口大小
        ------------------------------------------------------------

        guiSettingsPage:Divider("窗口大小")

        guiSettingsPage:Slider(
            "窗口宽度",
            tonumber(appConfig.MinWindowWidth) or 560,
            tonumber(appConfig.MaxWindowWidth) or 1380,
            tonumber(appConfig.WindowWidth) or 820,
            function(value)
                window:SetSize(
                    value,
                    userWindowHeight,
                    true
                )
            end,
            {
                Step = 10,
                ShowSteps = false,
                ShowValue = true,
                Suffix = " px",
            }
        )

        guiSettingsPage:Slider(
            "窗口高度",
            tonumber(appConfig.MinWindowHeight) or 430,
            tonumber(appConfig.MaxWindowHeight) or 980,
            tonumber(appConfig.WindowHeight) or 650,
            function(value)
                window:SetSize(
                    userWindowWidth,
                    value,
                    true
                )
            end,
            {
                Step = 10,
                ShowSteps = false,
                ShowValue = true,
                Suffix = " px",
            }
        )

        guiSettingsPage:Switch(
            "显示右下角大小手柄",
            appConfig.ShowResizeHandle ~= false,
            function(value)
                window:SetConfig(
                    "ShowResizeHandle",
                    value
                )
            end
        )

        guiSettingsPage:Button(
            "恢复默认窗口大小",
            function()
                window:SetSize(
                    820,
                    650
                )
            end
        )

        guiSettingsPage:Label(
            "拖动右下角时宽和高分别计算：只横着拖只改变宽度，"
            .. "只竖着拖只改变高度。窗口中心保持不动，所以宽度会向左右"
            .. "两边同时增长，高度会向上下两边同时增长。"
        )

        ------------------------------------------------------------
        -- 灵动岛
        ------------------------------------------------------------
        ------------------------------------------------------------
        -- 灵动岛
        ------------------------------------------------------------

        guiSettingsPage:Divider("灵动岛")

        guiSettingsPage:Switch(
            "显示灵动岛",
            appConfig.ShowDynamicIsland ~= false,
            function(value)
                window:SetConfig(
                    "ShowDynamicIsland",
                    value
                )
            end
        )

        guiSettingsPage:Switch(
            "显示灵动岛图标",
            appConfig.IslandShowIcon ~= false,
            function(value)
                window:SetConfig(
                    "IslandShowIcon",
                    value
                )
            end
        )

        guiSettingsPage:TextField(
            "灵动岛文字",
            tostring(
                appConfig.IslandText
                or "点击打开"
            ),
            function(value)
                if value == "" then
                    value = "点击打开"
                end

                window:SetConfig(
                    "IslandText",
                    value
                )
            end
        )

        guiSettingsPage:TextField(
            "灵动岛图标",
            tostring(
                appConfig.IslandIcon
                or "rbxassetid://8997386997"
            ),
            function(value)
                if value == "" then
                    value =
                        "rbxassetid://8997386997"
                end

                window:SetConfig(
                    "IslandIcon",
                    value
                )
            end
        )

        guiSettingsPage:Slider(
            "主文字大小",
            8,
            20,
            tonumber(
                appConfig.IslandTextSize
            ) or 11,
            function(value)
                window:SetConfig(
                    "IslandTextSize",
                    value,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
            }
        )

        guiSettingsPage:Slider(
            "FPS 文字大小",
            8,
            20,
            tonumber(
                appConfig.IslandFPSTextSize
            ) or 11,
            function(value)
                window:SetConfig(
                    "IslandFPSTextSize",
                    value,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
            }
        )

        guiSettingsPage:Slider(
            "图标大小",
            10,
            28,
            tonumber(
                appConfig.IslandIconSize
            ) or 16,
            function(value)
                window:SetConfig(
                    "IslandIconSize",
                    value,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
            }
        )

        guiSettingsPage:Slider(
            "灵动岛宽度",
            130,
            320,
            tonumber(
                appConfig.IslandWidth
            ) or 196,
            function(value)
                window:SetConfig(
                    "IslandWidth",
                    value,
                    true
                )
            end,
            {
                Step = 2,
                ShowSteps = false,
                ShowValue = true,
            }
        )

        guiSettingsPage:Slider(
            "灵动岛高度",
            30,
            52,
            tonumber(
                appConfig.IslandHeight
            ) or 36,
            function(value)
                window:SetConfig(
                    "IslandHeight",
                    value,
                    true
                )
            end,
            {
                Step = 1,
                ShowSteps = false,
                ShowValue = true,
            }
        )

        ------------------------------------------------------------
        -- 其他
        ------------------------------------------------------------

        guiSettingsPage:Divider("其他")

        guiSettingsPage:Switch(
            "自动保存配置",
            appConfig.AutoSaveConfig ~= false,
            function(value)
                window:SetConfig(
                    "AutoSaveConfig",
                    value
                )
            end
        )

        guiSettingsPage:Button(
            "保存当前 GUI 配置",
            function()
                local ok =
                    window:SaveConfig()

                window:TempNotify(
                    "GUI设置",
                    ok
                        and "配置已经保存。"
                        or "当前执行环境不支持写入配置文件。"
                )
            end
        )

        guiSettingsPage:Label(
            "Slider 调整透明度/磨砂时只实时应用，不会在拖动过程中连续写磁盘；"
            .. "调整完成后可以点击「保存当前 GUI 配置」。",
            {
                Transparency = 0.12,
                Frost = 0.28,
            }
        )

        guiSettingsPage:Label(
            "脚本作者也可以在 init() 的第 5 个参数传入配置表，"
            .. "例如 ConfigFolder、Theme、SidebarTransparency、WindowWidth、WindowHeight、"
            .. "IslandText、DropdownTransparent 等；"
            .. "显式参数优先级高于配置文件。",
            {
                Transparency = 0.12,
                Frost = 0.28,
            }
        )
    end)

]]


local accountPageCode = [[    ------------------------------------------------------------------------
    -- Built-in player account page
    ------------------------------------------------------------------------
    task.defer(function()
        if not scrgui.Parent then return end

        accountPage = window:Section("Apple账户", {
            Icon = ASSET.Cloud,
            Subtitle = "玩家账户与脚本会话",
            ShowInSidebar = false,
            Style = {
                Transparency = 0.02,
                Frost = 0.12,
            },
        })

        local rec =
            accountPage and accountPage._rec

        if not rec then return end

        rec.sidebarVisible = false
        rec.button.Visible = false

        local scroll = rec.scroll
        local oldHeader =
            scroll:FindFirstChild("SectionHeader")

        if oldHeader then
            oldHeader:Destroy()
        end

        local hero = Instance.new("Frame")
        hero.Name = "AccountHero"
        hero.Parent = scroll
        hero.LayoutOrder = -100
        hero.Size =
            UDim2.new(
                1,
                -4,
                0,
                currentMobile and 214 or 248
            )
        hero.BackgroundColor3 =
            C.Card
        hero.BorderSizePixel = 0
        hero.ZIndex = 17
        round(hero, 18)

        applyFrostedSurface(
            hero,
            {
                Transparency = 0.03,
                Frost = 0.12,
            },
            17,
            0.03,
            0.12
        )

        local profileAvatar =
            Instance.new("ImageLabel")

        profileAvatar.Parent = hero
        profileAvatar.AnchorPoint =
            Vector2.new(0.5, 0)
        profileAvatar.Position =
            UDim2.new(0.5, 0, 0, 18)
        profileAvatar.Size =
            UDim2.fromOffset(
                currentMobile and 92 or 112,
                currentMobile and 92 or 112
            )
        profileAvatar.BackgroundColor3 =
            C.SwitchOff
        profileAvatar.BorderSizePixel = 0
        profileAvatar.ZIndex = 19
        circle(profileAvatar)

        addShadow(
            profileAvatar,
            18,
            20,
            20,
            0.91,
            true
        )

        task.spawn(function()
            pcall(function()
                profileAvatar.Image =
                    Players:GetUserThumbnailAsync(
                        LocalPlayer.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size420x420
                    )
            end)
        end)

        local display =
            Instance.new("TextLabel")

        display.Parent = hero
        display.AnchorPoint =
            Vector2.new(0.5, 0)
        display.Position =
            UDim2.new(
                0.5,
                0,
                0,
                currentMobile and 118 or 140
            )
        display.Size =
            UDim2.new(1, -32, 0, 34)
        display.BackgroundTransparency = 1
        display.Text = LocalPlayer.DisplayName
        display.TextColor3 = C.Text
        display.TextSize =
            currentMobile and 22 or 27
        display.Font = Enum.Font.GothamSemibold
        display.TextXAlignment =
            Enum.TextXAlignment.Center
        display.ZIndex = 20

        local username =
            Instance.new("TextLabel")

        username.Parent = hero
        username.AnchorPoint =
            Vector2.new(0.5, 0)
        username.Position =
            UDim2.new(
                0.5,
                0,
                0,
                currentMobile and 153 or 179
            )
        username.Size =
            UDim2.new(1, -32, 0, 28)
        username.BackgroundTransparency = 1
        username.Text = "@" .. LocalPlayer.Name
        username.TextColor3 = C.Text
        username.TextSize =
            currentMobile and 15 or 18
        username.Font = Enum.Font.Gotham
        username.TextXAlignment =
            Enum.TextXAlignment.Center
        username.ZIndex = 20

        accountPage:Divider("玩家")

        accountPage:Label(
            "用户名　@" .. LocalPlayer.Name,
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        accountPage:Label(
            "显示名称　" .. LocalPlayer.DisplayName,
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        accountPage:Label(
            "User ID　" .. tostring(LocalPlayer.UserId),
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        accountPage:Label(
            "账号年龄　"
                .. tostring(LocalPlayer.AccountAge)
                .. " 天",
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        accountPage:Divider("脚本会话")

        accountPage:Label(
            "脚本开启时间　"
                .. scriptStartedText,
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        local uptime = accountPage:Label(
            "已运行　00:00:00",
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        accountPage:Label(
            "Place ID　"
                .. tostring(game.PlaceId),
            {
                Transparency = 0.08,
                Frost = 0.24,
            }
        )

        task.spawn(function()
            while
                scrgui.Parent
                and uptime.Parent
            do
                local total =
                    math.max(
                        0,
                        math.floor(
                            os.clock()
                            - scriptStartedAt
                        )
                    )

                local hours =
                    math.floor(total / 3600)

                local minutes =
                    math.floor(
                        (total % 3600) / 60
                    )

                local seconds =
                    total % 60

                uptime.Text =
                    string.format(
                        "已运行　%02d:%02d:%02d",
                        hours,
                        minutes,
                        seconds
                    )

                task.wait(1)
            end
        end)
    end)

]]

source = plainReplace(
    source,
    [[    ------------------------------------------------------------------------
    -- Real navigation history. < returns to the previously opened page;]],
    guiSettingsPageCode
    .. accountPageCode
    .. [[    ------------------------------------------------------------------------
    -- Real navigation history. < returns to the previously opened page;]],
    "account page"
)


if not string.find(source, "function sec:Slider", 1, true) then
    error("[AppleGUI Frost Patch] Slider API patch missing")
end

for _, expected in ipairs({
    "function window:SetConfig",
    "function window:GetConfig",
    "function window:IsMinimized",
    "function window:IsClosing",
    "function window:IsFullscreen",
    "function window:GetUIState",
    "GUI设置",
    "搜索分类和功能",
    "registerSearchText",
}) do
    if not string.find(source, expected, 1, true) then
        error(
            "[AppleGUI Frost Patch] expected feature missing: "
            .. expected
        )
    end
end

for _, token in ipairs({
    "attachLiquidGlass",
    "CaptureService",
    "CreateEditableImage",
    "modalGlassCtl",
    "toastGlassCtl",
    "knobGlassCtl",
    "menuGlassCtl",
}) do
    if string.find(source, token, 1, true) then
        error(
            "[AppleGUI Frost Patch] old liquid token remains: "
            .. token
        )
    end
end


source =
    string.gsub(
        source,
        "__APPLEGUI_CONFIG_FOLDER__",
        function()
            return tostring(CONFIG_FOLDER)
        end
    )

source =
    string.gsub(
        source,
        "__APPLEGUI_CONFIG_FILE__",
        function()
            return tostring(CONFIG_FILE_NAME)
        end
    )

local function stripGeneratedComments(text)
    text = string.gsub(
        text,
        "%-%-%[%[.-%]%]",
        ""
    )

    text = string.gsub(
        text,
        "^%s*%-%-[^\n]*\n",
        ""
    )

    text = string.gsub(
        text,
        "\n%s*%-%-[^\n]*",
        "\n"
    )

    return text
end

source = stripGeneratedComments(source)

local chunk, compileErr = loadstring(source)

if not chunk then
    error(
        "[AppleGUI Frost Patch] compile failed: "
        .. tostring(compileErr)
    )
end

local okLib, AppleGUI = pcall(chunk)

if not okLib then
    error(
        "[AppleGUI Frost Patch] runtime failed: "
        .. tostring(AppleGUI)
    )
end

return AppleGUI
