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
        local function Get(): table
            local Get = {}
            local function Create(parameters: table): Instance
                local Class = {}
                Class.__type = parameters._type
                Class._msg, Class.Object = pcall(parameters.Create)
                if not Class._msg then -- <boolean> message is a handshake in a protected call.
                    return warn("<Class> Object: "..tostring(parameters._type).." could not be created")
                end
                Class.__index = Object -- order of creation.
                function Class:__tostring()
                    return Class.__type
                end
                return Class -- return a metatable for better flexibility
            end
            -- Scope Declarations
            local Screen, Background, Radial
            -- Vanilla Instances
            Screen = Create {
                _type = "Screen";
                Create = function(self, ...)
                    local ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    ScreenGui.Parent = game:GetService("CoreGui")
                    return ScreenGui
                end
            }
            Background = Create {
                _type = "Background";
                Create = function(self, ...)
                    -- Create a Background Frame
                    local bgFrame = Instance.new("Frame")
                    bgFrame.BackgroundColor3 = Color3.fromRGB(39,39,39)
                    bgFrame.BackgroundTransparency = .8
                    bgFrame.BorderSizePixel = 0;
                    bgFrame.ZIndex = -1
                    bgFrame.Active = false
                    bgFrame.Size = UDim2.fromScale(1,1)
                    bgFrame.Parent = DefaultRadial and Screen.Object or nil
                    return bgFrame
                end
            }
            -- -- EgoMoose UI Instances
            local EgoMoose = require(script.GuiLib.LazyLoader)
            Radial = Create {
                _type = "Radial";
                Create = function(self, ...)
                    local RadialMenu = EgoMoose.Classes.RadialMenu.new(2, .75, math.pi*.5) -- create our radial menu
                    RadialMenu.Frame.AnchorPoint = Vector2.new(.5,.5)
                    RadialMenu.Frame.Position = UDim2.fromScale(.5,.5)
                    RadialMenu.Frame.Size = UDim2.fromScale(.3,.3)
                    RadialMenu.Frame.Parent = Background.Object
                
                    for i = 1, 2 do
                        local label = Instance.new("ImageLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        -- label.Image = images[i].Texture
                        label.Parent = RadialMenu:GetAttachment(i)
                    end
                    return RadialMenu
                end
            }
            Get = {Screen, Background, Radial}
            return Get
            -- End of Create Scope
        end
        local function Initialize(self): table
            local empty = {} -- storage table,
            local created = self:Get()
            local self = setmetatable({__index = self}, created) -- override self
            -- enumerate through self,
            for index,meta in next, getmetatable(self) do
                if meta then
                    empty[meta.__type] = meta.Object
                end
            end
            return empty
        end
        return {Get = Get, Initialize = Initialize}
    end

    local UI = UI():Initialize()
    -- ToggleRadial <Button> Connections
    ToggleRadial.Object.Click:Connect(function()
        DefaultRadial = not DefaultRadial and true
        UI.Background.Parent = DefaultRadial and UI.Screen or nil
    end)


    UI.Radial.Clicked:Connect(function(index)
        print(index)
    end)

    UI.Radial.Hover:Connect(function(oldIndex, newIndex)
        if (oldIndex) then
            UI.Radial:GetRadial(oldIndex).ImageColor3 = Color3.new(0, 0, 0)
        end
        UI.Radial:GetRadial(newIndex).ImageColor3 = Color3.new(1, 1, 1)
    end)

    plugin.Unloading:Connect(function()
        UI.Radial:Destroy()
        UI.Background:Destroy()
    end)

    local GUI = game:GetService("GuiService")
    game["Run Service"].Stepped:Connect(function(dt)
        UI.Radial.Enabled = not GUI.SelectedObject
    end)
end
Radial()
print("Loaded: Object Oriented Tool")
-- End of our scope!