-- GUI

function Wireless_MainGUI( player )
	local A01 = Wireless_Add_Frame( mod_gui.get_frame_flow( player ), "WirelessNetworksGUI", "outer_frame" )
	local A02 = Wireless_Add_Table( A01, "WirelessNetworksGUITable01", 2 )
	local A03 = { Wireless_Add_Frame( A02, "WirelessNetworksGUIHiddenFrame01", "outer_frame" ),
				  Wireless_Add_Frame( A02, "WirelessNetworksGUIHiddenFrame02", "outer_frame" ) }
	local A04 = Wireless_Add_Frame( A03[1], "WirelessNetworksGUIFrame01" )
	local A05 = { Wireless_Add_Label( A04, "WirelessNetworksGUILabel01", "Wireless Networks Interface" ),
				  Wireless_Add_Table( A04, "WirelessNetworksGUITable02", 3 ) }
	A05[1].style = "description_title_label"
	local A06 = { Wireless_Add_Drop_Down( A05[2], "WirelessNetworksGUIDropDown01", global.WirelessNetworks ),
				  Wireless_Add_Sprite_Button( A05[2], "WirelessNetworksGUISpriteButton01", "Senpais-plus" ),
				  Wireless_Add_Sprite_Button( A05[2], "WirelessNetworksGUISpriteButton02", "utility/trash_bin" ) }
end

function Wireless_AddGUI( parent )
	local B01 = Wireless_Add_Frame( parent, "WirelessNetworksGUIFrame02" )
	local B02 = { Wireless_Add_Textfield( B01, "WirelessNetworksGUITextfield" ),
				  Wireless_Add_Button( B01, "WirelessNetworksGUIButton", "Add Network" ) }
end

function Wireless_DisplayGUI( parent, index )
	local C01 = Wireless_Add_Frame( parent, "WirelessNetworksGUIHiddenFrame03", "outer_frame" )
	local C02 = { Wireless_Add_Label( C01, "WirelessNetworksGUILabel02", "Stats of this Network" ),
				  Wireless_Add_Flow( C01, "WirelessNetworksGUIFlow01", "vertical" ),
				  Wireless_Add_Flow( C01, "WirelessNetworksGUIFlow02", "vertical" ) }
	C02[1].style = "description_title_label"
	local C03 = { Wireless_Add_Table( C02[2], "WirelessNetworksGUITable03", 2 ),
				  Wireless_Add_Table( C02[3], "WirelessNetworksGUITable04", 2 ) }
	local C04 = { Wireless_Add_Label( C03[1], "WirelessNetworksGUILabel03", "Total Count of Sender:" ),
				  Wireless_Add_Label( C03[1], "WirelessNetworksGUILabel04", #global.WirelessNetworksSender[index] or 0 ),
				  Wireless_Add_Label( C03[2], "WirelessNetworksGUILabel05", "Total Count of Reciever:" ),
				  Wireless_Add_Label( C03[2], "WirelessNetworksGUILabel06", #global.WirelessNetworksReciever[index] or 0 ) }
	C04[1].style = "description_label"
	C04[2].style = "description_value_label"
	C04[3].style = "description_label"
	C04[4].style = "description_value_label"
end

function Wireless_ChooseNetworkGUI( player, index )
	local D01 = Wireless_Add_Frame( player.gui.center, "WirelessNetworksGUIFrame03" )
	local D02 = { Wireless_Add_Label(D01, "WirelessNetworksGUILabel07", "Current Network or" ),
				  Wireless_Add_Label(D01, "WirelessNetworksGUILabel08", "Change Network" ),
				  Wireless_Add_Drop_Down( D01, "WirelessNetworksGUIDropDown02", global.WirelessNetworks ) }
	D02[1].style = "description_title_label"
	D02[2].style = "description_title_label"
	D02[3].selected_index = index
	return D01
end

-- GUI Elements

function Wireless_Add_Sprite_Button( flow, name, sprite, style )
	return flow.add{ type = "sprite-button", name = name, style = style or nil, sprite = sprite }
end

function Wireless_Add_Frame( flow, name, style )
	return flow.add{ type = "frame", name = name, direction = "vertical", style = style or nil }
end

function Wireless_Add_Table( flow, name, column_count )
	return flow.add{ type = "table", name = name, column_count = column_count }
end

function Wireless_Add_Drop_Down( flow, name, items )
	return flow.add{ type = "drop-down", name = name, items = items or nil }
end

function Wireless_Add_Textfield( flow, name, text )
	return flow.add{ type = "textfield", name = name, text = text or nil }
end

function Wireless_Add_Button( flow, name, caption )
	return flow.add{ type = "button", name = name, caption = caption or nil }
end

function Wireless_Add_Scroll_Pane( flow, name )
	return flow.add{ type = "scroll-pane", name = name }
end

function Wireless_Add_Label( flow, name, caption )
	return flow.add{ type = "label", name = name, caption = caption or nil }
end

function Wireless_Add_Flow( flow, name, direction, style )
	return flow.add{ type = "flow", name = name, direction = direction, style = style or nil }
end

-- Script

function Wireless_globals()
	global.WirelessNetworks = global.WirelessNetworks or {}
	global.WirelessNetworksSender = global.WirelessNetworksSender or {}
	global.WirelessNetworksReciever = global.WirelessNetworksReciever or {}
	global.PlayerDATA = global.PlayerDATA or {}
end

function Wireless_Players()
	for _, p in pairs( game.players ) do
		if not mod_gui.get_button_flow( p ).WirelessGUIButton then
			local button = Wireless_Add_Sprite_Button( mod_gui.get_button_flow( p ), "WirelessGUIButton", "Wireless" )
			button.style.visible = true
		end
	end
end

function Wireless_OnRemove( event )
	local entity = event.entity
	if entity.name == "Wireless-Sender" then
		for j = 1, #global.WirelessNetworks do
			if #global.WirelessNetworksSender[global.WirelessNetworks[j]] > 0 then
				for m, mm in pairs( global.WirelessNetworksSender[global.WirelessNetworks[j]] ) do
					if mm == entity then
						global.WirelessNetworksSender[global.WirelessNetworks[j]][m] = nil
						return
					end
				end
			end
		end
	end
	if entity.name == "Wireless-Reciever" then
		for j = 1, #global.WirelessNetworks do
			if #global.WirelessNetworksReciever[global.WirelessNetworks[j]] > 0 then
				for m, mm in pairs( global.WirelessNetworksReciever[global.WirelessNetworks[j]] ) do
					if mm == entity then
						global.WirelessNetworksReciever[global.WirelessNetworks[j]][m] = nil
						return
					end
				end
			end
		end
	end
end