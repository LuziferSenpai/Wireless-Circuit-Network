require( "mod-gui" )
require( "functions" )

script.on_init( function()
	Wireless_globals()
	Wireless_Players()
end )

script.on_configuration_changed( function()
	Wireless_globals()
	Wireless_Players()
end )

script.on_event( defines.events.on_gui_click, function( event )
	local element = event.element
	local name = element.name
	local player = game.players[event.player_index]
	local parent = element.parent or nil

	if not name then return end

	if name == "WirelessGUIButton" then
		if mod_gui.get_frame_flow( player ).WirelessNetworksGUI then
			mod_gui.get_frame_flow( player ).WirelessNetworksGUI.destroy()
		else
			Wireless_MainGUI( player )
		end
		return
	end
	if name == "WirelessNetworksGUISpriteButton01" then
		if parent.parent.parent.parent.children[2].children[1] then
			parent.parent.parent.parent.children[2].clear()
		else
			Wireless_AddGUI( parent.parent.parent.parent.children[2] )
		end
		return
	end
	if name == "WirelessNetworksGUISpriteButton02" then
		if parent.children[1].selected_index > 0 then
			global.WirelessNetworksSender[global.WirelessNetworks[parent.children[1].selected_index]] = nil
			if #global.WirelessNetworksReciever[global.WirelessNetworks[parent.children[1].selected_index]] then
				for _, z in pairs( global.WirelessNetworksReciever[global.WirelessNetworks[parent.children[1].selected_index]] ) do
					local behavior = z.get_or_create_control_behavior()
					behavior.parameters = { parameters = {} }
				end
			end
			global.WirelessNetworksReciever[global.WirelessNetworks[parent.children[1].selected_index]] = nil
			table.remove( global.WirelessNetworks, parent.children[1].selected_index )
			mod_gui.get_frame_flow( player ).WirelessNetworksGUI.destroy()
			Wireless_MainGUI( player )
		end
		return
	end

	if name == "WirelessNetworksGUIButton" then
		if parent.children[1].text ~= nil and not global.WirelessNetworks[parent.children[1].text] then
			table.insert( global.WirelessNetworks, parent.children[1].text )
			global.WirelessNetworksSender[parent.children[1].text] = {}
			global.WirelessNetworksReciever[parent.children[1].text] = {}
		end
		mod_gui.get_frame_flow( player ).WirelessNetworksGUI.destroy()
		Wireless_MainGUI( player )
		return
	end
end )

script.on_event( defines.events.on_gui_selection_state_changed, function( event )
	local element = event.element
	local player = game.players[event.player_index]
	local name = element.name
	local parent = element.parent or nil
	if not name then return end
	if name == "WirelessNetworksGUIDropDown01" then
		if parent.parent.children[3] then parent.parent.children[3].destroy() end
		Wireless_DisplayGUI( parent.parent, global.WirelessNetworks[element.selected_index] )
		return
	end
	if name == "WirelessNetworksGUIDropDown02" then
		local data = global.PlayerDATA[player.index]
		if data.current_index ~= 0 then
			if data.entity.name == "Wireless-Sender" then
				for r, l in pairs( global.WirelessNetworksSender[global.WirelessNetworks[data.current_index]] ) do
					if data.entity == l then
						global.WirelessNetworksSender[global.WirelessNetworks[data.current_index]][r] = nil
						break
					end
				end
				table.insert( global.WirelessNetworksSender[global.WirelessNetworks[element.selected_index]], data.entity )
				global.PlayerDATA[player.index].current_index = element.selected_index
				return
			end
			if data.entity.name == "Wireless-Reciever" then
				for r, l in pairs( global.WirelessNetworksReciever[global.WirelessNetworks[data.current_index]] ) do
					if l == data.entity then
						global.WirelessNetworksReciever[global.WirelessNetworks[data.current_index]][r] = nil
						break
					end
				end
				table.insert( global.WirelessNetworksReciever[global.WirelessNetworks[element.selected_index]], data.entity )
				global.PlayerDATA[player.index].current_index = element.selected_index
				return
			end
		else
			if data.entity.name == "Wireless-Sender" then
				table.insert( global.WirelessNetworksSender[global.WirelessNetworks[element.selected_index]], data.entity )
				global.PlayerDATA[player.index].current_index = element.selected_index
				return
			end
			if data.entity.name == "Wireless-Reciever" then
				table.insert( global.WirelessNetworksReciever[global.WirelessNetworks[element.selected_index]], data.entity )
				global.PlayerDATA[player.index].current_index = element.selected_index
				return
			end
		end
	end
end )

script.on_event( defines.events.on_gui_opened, function( event )
	local player = game.players[event.player_index]
	if event.entity then
		local entity = event.entity
		local found = false
		if player.gui.center.WirelessNetworksGUIFrame03 then player.gui.center.WirelessNetworksGUIFrame03.destroy() end
		if entity.name == "Wireless-Sender" then
			if #global.WirelessNetworks > 0 then
				for z = 1, #global.WirelessNetworks do
					if #global.WirelessNetworksSender[global.WirelessNetworks[z]] > 0 then
						for network, senderentity in pairs( global.WirelessNetworksSender[global.WirelessNetworks[z]] ) do
							if entity == senderentity then
								found = true
								if global.WirelessNetworks[z] then
									global.PlayerDATA[player.index] = { current_index = z, entity = entity }
									player.opened = Wireless_ChooseNetworkGUI( player, z )
								else
									global.PlayerDATA[player.index] = { current_index = 0, entity = entity }
									player.opened = Wireless_ChooseNetworkGUI( player, 0 )
								end
								return
							end
						end
					end
				end
			end
		end
		if entity.name == "Wireless-Reciever" then
			if #global.WirelessNetworks > 0 then
				for z = 1, #global.WirelessNetworks do
					if #global.WirelessNetworksReciever[global.WirelessNetworks[z]] > 0 then
						for network, recieverentity in pairs( global.WirelessNetworksReciever[global.WirelessNetworks[z]] ) do
							if entity == recieverentity then
								found = true
								if global.WirelessNetworks[z] then
									global.PlayerDATA[player.index] = { current_index = z, entity = entity }
									player.opened = Wireless_ChooseNetworkGUI( player, z )
								else
									global.PlayerDATA[player.index] = { current_index = 0, entity = entity }
									player.opened = Wireless_ChooseNetworkGUI( player, 0 )
								end
								return
							end
						end
					end
				end
			end
		end
		if ( entity.name == "Wireless-Sender" or entity.name == "Wireless-Reciever" ) and not found then
			global.PlayerDATA[player.index] = { current_index = 0, entity = entity }
			player.opened = Wireless_ChooseNetworkGUI( player, 0 )
			return
		end
	end
end )

script.on_event( defines.events.on_gui_closed, function( event )
	if event.element and event.element.name == "WirelessNetworksGUIFrame03" then
		event.element.destroy()
		global.PlayerDATA[game.players[event.player_index].index] = nil
	end
end )

script.on_event( defines.events.on_tick, function( event )
	if event.tick % ( game.speed * settings.global["Network-Update-Sec"].value ) == 0 then
		if #global.WirelessNetworks > 0 then
			for _, t in pairs( global.WirelessNetworks ) do
				local signals = {}
				if #global.WirelessNetworksSender[t] > 0 then
					for _, p in pairs( global.WirelessNetworksSender[t] ) do
						local red = p.get_circuit_network( defines.wire_type.red )
						local green = p.get_circuit_network( defines.wire_type.green )
						if red then
							if red.signals ~= nil and #red.signals > 0 then
								for _, r in pairs( red.signals ) do
									local signal_found = false
									for _, p in pairs( signals ) do
										if p.signal.name == r.signal.name then
											p.count = p.count + r.count
											signal_found = true
											break
										end
									end
									if not signal_found then table.insert( signals, r ) end
								end
							end
						end
						if green then
							if green.signals ~= nil and #green.signals > 0 then
								for _, e in pairs( green.signals ) do
									local signal_found = false
									for _, p in pairs( signals ) do
										if p.signal.name == e.signal.name then
											p.count = p.count + e.count
											signal_found = true
											break
										end
									end
									if not signal_found then table.insert( signals, e ) end
								end
							end
						end
					end
				end
				if #global.WirelessNetworksReciever[t] > 0 then
					for _, c in pairs( global.WirelessNetworksReciever[t] ) do
						local behavior = c.get_or_create_control_behavior()
						local parameter = {}
						if #signals > 0 then
							for g = 1, #signals do
								local h = { count = signals[g].count, index = g, signal = signals[g].signal }
								table.insert( parameter, h )
							end
						end
						behavior.parameters = { parameters = parameter }
					end
				end
			end
		end
	end
end )

script.on_event( defines.events.on_player_created, function( event )
	local player = game.players[event.player_index]
	local button = Wireless_Add_Sprite_Button( mod_gui.get_button_flow( player ), "WirelessGUIButton", "Wireless" )
	button.style.visible = true
end )

script.on_event( defines.events.on_pre_player_mined_item, Wireless_OnRemove )
script.on_event( defines.events.on_robot_pre_mined, Wireless_OnRemove )
script.on_event( defines.events.on_entity_died, Wireless_OnRemove )