local ToolbarClass = {}
ToolbarClass.__index = ToolbarClass
ToolbarClass.__type = "Toolbar"

function ToolbarClass:__tostring()
	return ToolbarClass.__type
end

function ToolbarClass.new(parameters: table)
	local self = setmetatable({}, ToolbarClass)
    -- Set all parameters to <Class> Toolbar
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

function ToolbarClass:Create() -- creates a new toolbar
    if not self.Name then
        return warn("Toolbar [Name] not passed")
    end
    return self._plugin:CreateToolbar(self.Name)
end

----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- PRIVATE METHODS -------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

function ToolbarClass:_Init()
	self.Object = self:Create()
end

return ToolbarClass