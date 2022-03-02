local ButtonClass = {}
ButtonClass.__index = ButtonClass
ButtonClass.__type = "Button"

function ButtonClass:__tostring()
	return ButtonClass.__type
end

function ButtonClass.new(parameters: table)
	local self = setmetatable({}, ButtonClass)
    -- Set all parameters to <Class> Button
	for name, value in next, parameters do
        self[name] = value
    end
	-- Initialize!
	self:_Init()
	
	return self
end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------- PUBLIC METHODS -------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

function ButtonClass:Create() -- creates a new toolbar
    if not self.Name then
        return warn("Name is not found!")
    end
    -- Set empties
    self.Description = self.Description or "n/a"
    self.Icon = self.Icon or "rbxassetid://963300406"
    -- Return our button back!
    return self.Toolbar:CreateButton(self.Name, self.Description, self.Icon)
end

----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- PRIVATE METHODS -------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

function ButtonClass:_Init()
	if not self.Toolbar then
        return warn("[Toolbar] not passed. \n Initialization Stopped!")
    end
    self.Object = self:Create()
end

return ButtonClass