local Modules = script.Modules
local Buttons = require(Modules.Button)
-- Make our Toolbar!
local Toolbar = require(Modules.Toolbar).new({
    _plugin = plugin;
    Name = "Object Oriented Tools";
})
local function Radial()
    -- Radial
    local DefaultRadial = false -- default toggle option
    -- Toggle <Button> for opening/closing Radial Menu!!
    local ToggleRadial = Buttons.new {
        Toolbar = Toolbar.Object,
        Name = "Toggle Radial", -- defaults on open.
        Description = "Toggle the radial menu"
    }
    local function UI()
        local function Create(): table
            -- Scope Declarations
            local screen, background, radial
            -- Vanilla Instances
            local Screen = function(): Instance
                local ScreenGui = Instance.new("ScreenGui")
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                ScreenGui.Parent = game:GetService("CoreGui")
                return ScreenGui
            end
            local Background = function(screen_gui: Instance): Instance
                -- Create a Background Frame
                local bgFrame = Instance.new("Frame")
                bgFrame.BackgroundColor3 = Color3.fromRGB(39,39,39)
                bgFrame.BackgroundTransparency = .8
                bgFrame.BorderSizePixel = 0;
                bgFrame.ZIndex = -1
                bgFrame.Active = false
                bgFrame.Size = UDim2.fromScale(1,1)
                bgFrame.Parent = DefaultRadial and screen_gui or nil
                return bgFrame
            end
            -- EgoMoose UI Instances
            local EgoMoose = require(script.GuiLib.LazyLoader)
            local Radial = function(): Instance
                local RadialClass = {}
                RadialClass.__type = "Radial"
                local RadialMenu = EgoMoose.Classes.RadialMenu.new(2, .75, math.pi*.5) -- create our radial menu
                RadialMenu.Frame.AnchorPoint = Vector2.new(.5,.5)
                RadialMenu.Frame.Position = UDim2.fromScale(.5,.5)
                RadialMenu.Frame.Size = UDim2.fromScale(.3,.3)
                RadialMenu.Frame.Parent = frame
            
                for i = 1, 2 do
                    local label = Instance.new("ImageLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    -- label.Image = images[i].Texture
                    label.Parent = RadialMenu:GetAttachment(i)
                end
                RadialClass.__index = RadialMenu
                function RadialClass:__tostring()
                    return RadialClass.__type
                end
                return setmetatable({},RadialClass)
            end
            return {Screen,Background,Radial} -- order of creation.
            -- End of Create Scope
        end
        local function Initialize(self): table
            local created = self:Create()
            local new = setmetatable({__index = self}, created)
            -- enumerate through self,
            for name,func in next, getmetatable(new) do
                local message, child = pcall(func)
                if message then -- <boolean> message is a handshake in a protected call.
                    new[tostring(child)] = child
                end
            end

            warn(new.Radial)

            return new
        end
        return {Create = Create, Initialize = Initialize}
    end

    local UI = UI():Initialize()
    -- table.foreach(UI, print)


    -- ToggleRadial <Button> Connections
    ToggleRadial.Object.Click:Connect(function()
        DefaultRadial = not DefaultRadial and true
        frame.Parent = DefaultRadial and ScreenGui or nil
    end)


    RadialMenu.Clicked:Connect(function(index)
        print(index)
    end)

    RadialMenu.Hover:Connect(function(oldIndex, newIndex)
        if (oldIndex) then
            RadialMenu:GetRadial(oldIndex).ImageColor3 = Color3.new(0, 0, 0)
        end
        RadialMenu:GetRadial(newIndex).ImageColor3 = Color3.new(1, 1, 1)
    end)

    plugin.Unloading:Connect(function()
        RadialMenu:Destroy()
        frame:Destroy()
    end)

    local GUI = game:GetService("GuiService")
    game["Run Service"].Stepped:Connect(function(dt)
        RadialMenu.Enabled = not GUI.SelectedObject
    end)
end
Radial()
print("Loaded: Object Oriented Tool")
-- End of our scope!