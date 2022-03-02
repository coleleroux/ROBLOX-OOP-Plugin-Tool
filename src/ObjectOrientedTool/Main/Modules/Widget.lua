local WidgetClass = {}
WidgetClass.__index = WidgetClass
WidgetClass.__type = "Widget"

function WidgetClass:__tostring()
	return WidgetClass.__type
end

function WidgetClass.new(parameters: table)
	local self = setmetatable({}, WidgetClass)
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

-- Creates a new <Widget> Object
function WidgetClass:Create(widget_info: table)
    -- Declare parameters, for <Method> DockWidgetPluginGuiInfo.new
    if not widget_info then
        return warn("<Widget> secondary parameters are not found")
    end
    return self._plugin:CreateDockWidgetPluginGui(
        self.Title,
        DockWidgetPluginGuiInfo.new(unpack(widget_info))
    );
end

----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- PRIVATE METHODS -------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

function WidgetClass:_Init()
	if not self._plugin then
        return warn("<Widget> is not Loaded. \n\t\t\t\t\t* Initialization Stopped!")
    end
    self.Loaded = true
end

return WidgetClass