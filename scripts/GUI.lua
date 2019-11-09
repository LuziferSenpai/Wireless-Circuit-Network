local GUI = {}

local AddButton = function( parent, name, caption, style )
	return parent.add{ type = "button", name = name, caption = caption, style = style }
end

local AddCheckbox = function( parent, name, caption, style )
	return parent.add{ type = "checkbox", name = name, caption = caption, state = false, style = style }
end

local AddDropDown = function( parent, name, items, style )
	return parent.add{ type = "drop-down", name = name, items = items, style = style }
end

local AddEntityPreview = function( parent, name )
	return parent.add{ type = "entity-preview", name = name }
end

local AddFlow = function( parent, name, direction, style )
	return parent.add{ type = "flow", name = name, direction = direction, style = style }
end

local AddFrame = function( parent, name, style )
	return parent.add{ type = "frame", name = name, direction = "vertical", style = style }
end

local AddLabel = function( parent, name, caption, style )
	return parent.add{ type = "label", name = name, caption = caption, style = style }
end

local AddLine = function( parent, name, direction, style )
	return parent.add{ type = "line", name = name, direction = direction, style = style }
end

local AddSpriteButton = function( parent, name, sprite, style )
	return parent.add{ type = "sprite-button", name = name, sprite = sprite, style = style }
end

local AddTextField = function( parent, name, text, style )
	return parent.add{ type = "textfield", name = name, text = text, style = style }
end

local AddWidget = function( parent, name, style )
	return parent.add{ type = "empty-widget", name = name, style = style }
end

GUI.Main = function( parent )
	local A = {}

	A["01"] = AddFrame( parent, "WirelessFrameAGUI01", "dialog_frame" )
	A["02"] =
	{
		["01"] = AddFlow( A["01"], "WirelessFlowAGUI01", "horizontal", "SenpaisFlowCenter/Left8" ),
		["02"] = AddLine( A["01"], "WirelessLineAGUI01", "horizontal", "SenpaisLine4" ),
		["03"] = AddFlow( A["01"], "WirelessFlowAGUI02", "horizontal", "SenpaisFlowCenter/Left4" ),
		["04"] = AddLine( A["01"], "WirelessLineAGUI02", "horizontal", "SenpaisLine4" ),
		["05"] = AddFlow( A["01"], "WirelessFlowAGUI03", "horizontal", "SenpaisFlowCenter/Left4" ),
		["06"] = AddLine( A["01"], "WirelessLineAGUI03", "horizontal", "SenpaisLine4" ),
		["07"] = AddFlow( A["01"], "WirelessFlowAGUI04", "horizontal", "SenpaisFlowCenter/Left4" ),
		["08"] = AddFlow( A["01"], "WirelessFlowAGUI05", "horizontal", "SenpaisFlowCenter/Left4" ),
	}
	A["03"] =
	{
		["01"] = AddLabel( A["02"]["01"], "WirelessLabelAGUI01", { "Wireless.Title" }, "frame_title" ),
		["02"] = AddWidget( A["02"]["01"], "WirelessWidgetAGUI01", "draggable_space_header" ),
		["03"] = AddSpriteButton( A["02"]["01"], "WirelessSpriteButtonAGUI01", "utility/close_white", "close_button" ),

		["04"] = AddLabel( A["02"]["03"], "WirelessLabelAGUI02", { "Wireless.NetworkTitle" }, "caption_label" ),
		["05"] = AddWidget( A["02"]["03"], "WirelessWidgetAGUI02" ),
		["06"] = AddDropDown( A["02"]["03"], "WirelessDropDownAGUI01", {} ),
		["07"] = AddSpriteButton( A["02"]["03"], "WirelessSpriteButtonAGUI02", "Senpais-plus", "SenpaisToolButton28" ),
		["08"] = AddSpriteButton( A["02"]["03"], "WirelessSpriteButtonAGUI03", "utility/remove", "SenpaisToolButton28" ),

		["09"] = AddLabel( A["02"]["05"], "WirelessLabelAGUI03", { "Wireless.Name" } ),
		["10"] = AddTextField( A["02"]["05"], "WirelessTextFieldAGUI01", "" ),
		["11"] = AddWidget( A["02"]["05"], "WirelessWidgetAGUI03" ),
		["12"] = AddButton( A["02"]["05"], "WirelessButtonAGUI01", { "Wireless.AddNetwork" } ),
		["13"] = AddLabel( A["02"]["07"], "WirelessLabelAGUI04", { "Wireless.Sender" }, "description_label" ),
		["14"] = AddLabel( A["02"]["07"], "WirelessLabelAGUI05", "0", "description_value_label" ),
		["15"] = AddLabel( A["02"]["08"], "WirelessLabelAGUI06", { "Wireless.Reciever" }, "description_label" ),
		["16"] = AddLabel(A["02"]["08"], "WirelessLabelAGUI07", "0", "description_value_label" )
	}

	A["02"]["05"].visible = false
	A["02"]["06"].visible = false
	A["02"]["07"].visible = false
	A["02"]["08"].visible = false

	A["03"]["02"].style.horizontally_stretchable = true
	A["03"]["02"].style.natural_height = 24
	A["03"]["02"].style.minimal_width = 50
	A["03"]["02"].drag_target = A["01"]
	A["03"]["05"].style.horizontally_stretchable = true
	A["03"]["05"].style.minimal_width = 24
	A["03"]["10"].style.width = 110
	A["03"]["11"].style.horizontally_stretchable = true

	return A
end

GUI.EntityGUI = function( parent )
	local B = {}

	B["01"] = AddFrame( parent, "WirelessFrameBGUI01", "dialog_frame" )
	B["02"] =
	{
		["01"] = AddFlow( B["01"], "WirelessFlowBGUI01", "horizontal", "SenpaisFlowCenter/Left8" ),
		["02"] = AddLine( B["01"], "WirleessLineBGUI01", "horizontal", "SenpaisLine4" ),
		["03"] = AddDropDown( B["01"], "WirelessDropDownBGUI01", {} ),
		["04"] = AddLabel( B["01"], "WirelessLabelBGUI01", "" ),
		["05"] = AddLabel( B["01"], "WirelessLabelBGUI02", "" ),
		["06"] = AddEntityPreview( B["01"], "WirelessEntityPreviewBGUI01" )
	}
	B["03"] =
	{
		["01"] = AddLabel( B["02"]["01"], "WirelessLabelBGUI03", { "Wireless.Network" }, "frame_title" ),
		["02"] = AddWidget( B["02"]["01"], "WirelessWidgetBGUI01" ),
		["03"] = AddSpriteButton( B["02"]["01"], "WirelessSpriteButtonBGUI01", "utility/close_white", "close_button" )
	}

	B["02"]["03"].style.horizontally_stretchable = true
	B["02"]["04"].visible = false
	B["02"]["05"].visible = false
	B["02"]["06"].visible = false

	B["03"]["02"].style.horizontally_stretchable = true
	B["03"]["02"].style.minimal_width = 50

	return B
end

GUI.AddSpriteButton = AddSpriteButton

return GUI