require( "mod-gui" )

local F = require "functions"
local de = defines.events
local mf = mod_gui.get_frame_flow

script.on_init( function()
	F.Globals()
	F.Players()
end )

script.on_configuration_changed( function()
	F.Globals()
	F.Players()
end )

script.on_event( de.on_gui_click, function( ee )
	local id = ee.player_index
	local p = game.players[id]
	local e = ee.element
	local n = e.name
	local pa = e.parent

	if ( n == nil or pa == nil ) then return end

	if n == "WirelessGUIButton" then
		if mf( p ).WirelessNetworksGUI then
			mf( p ).WirelessNetworksGUI.destroy()
		else
			F.MainGUI( mf( p ) )
		end
		return
	end
	if n == "WirelessNetworksSpriteButton01" then
		local g = pa.parent.parent.parent.children[2]
		if g.children[1] then
			g.clear()
		else
			F.AddGUI( g )
		end
		return
	end
	if n == "WirelessNetworksSpriteButton02" then
		local i = pa.children[1].selected_index
		if i > 0 then
			local nn = global.WirelessNetworks.N[i]
			for _, en in pairs( global.WirelessNetworks.E ) do
				if en.n == nn then
					en.n = ""
					if en.t == "Reciever" then
						local b = en.e.get_or_create_control_behavior()
						b.parameters = { parameters = {} }
					end
				end
			end
			global.WirelessNetworks["Sender"][nn] = nil
			global.WirelessNetworks["Reciever"][nn] = nil
			table.remove(global.WirelessNetworks.N, i )
			mf( p ).WirelessNetworksGUI.destroy()
			F.MainGUI( mf( p ) ) 
		end
		return
	end
	if n == "WirelessNetworksButton" then
		local nn = pa.children[2].text
		if nn ~= nil and not global.WirelessNetworks.N[nn] then
			table.insert( global.WirelessNetworks.N, nn )
			global.WirelessNetworks["Sender"][nn] = {}
			global.WirelessNetworks["Reciever"][nn] = {}
		end
		mf( p ).WirelessNetworksGUI.destroy()
		F.MainGUI( mf( p ) )
		return
	end
end )

script.on_event( de.on_gui_selection_state_changed, function( ee )
	local id = ee.player_index
	local p = game.players[id]
	local e = ee.element
	local n = e.name
	local pa = e.parent
	local i = e.selected_index

	if ( n == nil or pa == nil ) then return end

	if n == "WirelessNetworksDropDown01" then
		local paa = pa.parent
		if paa.children[3] then paa.children[3].destroy() end
		F.DisplayGUI( paa, global.WirelessNetworks.N[i] )
		return
	end
	if n == "WirelessNetworksDropDown02" then
		local d = global.PlayerDATA[id]
		local ci = d.ci
		local nn = global.WirelessNetworks.N[i]
		local eee = d.e
		local ii = eee.unit_number
		local dd = global.WirelessNetworks.E["E" .. ii]
		local t = dd.t
		if ci > 0 then
			global.WirelessNetworks[t][global.WirelessNetworks.N[ci]]["E" .. ii] = nil
		end
		global.WirelessNetworks.E["E" .. ii].n = nn
		global.PlayerDATA[id].ci = i
		global.WirelessNetworks[t][nn]["E" .. ii] = true
		return
	end
end )

script.on_event( de.on_gui_opened, function( ee )
	if ee.gui_type == defines.gui_type.entity then
		local e = ee.entity
		if e.unit_number then
			local id = ee.player_index
			local p = game.players[id]
			local i = e.unit_number
			local n = e.name
			local g = p.gui.center
			if g.WirelessNetworksFrame03 then g.WirelessNetworksFrame03.destroy() end
			if global.WirelessNetworks.E["E" .. i] then
				local d = global.WirelessNetworks.E["E" .. i]
				if d.n == "" then
					global.PlayerDATA[id] = { ci = 0, e = e }
					p.opened = F.ChooseNetworkGUI( g, 0 )
				else
					for z = 1, #global.WirelessNetworks.N do
						if d.n == global.WirelessNetworks.N[z] then
							global.PlayerDATA[id] = { ci = z, e = e }
							p.opened = F.ChooseNetworkGUI( g, z )
							break
						end
					end
				end
			elseif ( n == "Wireless-Sender" or n == "Wireless-Reciever" ) then
				global.WirelessNetworks.E["E" .. i] = { t = n:sub(10), n = "", e = e }
				global.PlayerDATA[id] = { ci = 0, e = e }
				p.opened = F.ChooseNetworkGUI( g, 0 )
			end
		end
	end
end )

script.on_event( de.on_gui_closed, function( ee )
	local e = ee.element
	if e and e.name == "WirelessNetworksFrame03" then
		e.destroy()
		global.PlayerDATA[ee.player_index] = nil
	end
end )

script.on_event( de.on_entity_settings_pasted, function( ee )
	local s = ee.source
	local d = ee.destination
	local dd = "E" .. d.unit_number
	local sn = global.WirelessNetworks.E["E" .. s.unit_number] or nil
	local dn = global.WirelessNetworks.E[dd] or nil
	if sn ~= nil and next( sn ) and sn.n ~= "" then
		local n = sn.n
		local na = d.name
		if dn ~= nil and next( dn ) then
			local t = dn.t
			global.WirelessNetworks[t][dn.n][dd] = ""
			global.WirelessNetworks.E[dd].n = n
			global.WirelessNetworks[t][n][dd] = true
		elseif ( na == "Wireless-Sender" or na == "Wireless-Reciever" ) then
			local t = na:sub(10)
			global.WirelessNetworks.E[dd] = { t = t, n = n, e = d }
			global.WirelessNetworks[t][n][dd] = true
		end
	end
end )

script.on_event( de.on_tick, function( ee )
	if ee.tick % ( game.speed * settings.global["Network-Update-Sec"].value ) == 0 then
		local gl = global.WirelessNetworks
		if next( gl.N ) then
			for _, nn in pairs( gl.N ) do
				local s = {}
				local n = gl["Sender"][nn]
				if next( n ) then
					for i, _ in pairs( n ) do
						local p = gl.E[i].e
						if p.valid then
							local r = p.get_circuit_network( defines.wire_type.red )
							local g = p.get_circuit_network( defines.wire_type.green )
							if r then
								if r.signals ~= nil and #r.signals > 0 then
									for _, z in pairs( r.signals ) do
										local f = false
										for _, si in pairs( s ) do
											if si.signal.name == z.signal.name then
												si.count = si.count + z.count
												f = true
												break
											end
										end
										if not f then table.insert( s, z ) end
									end
								end
							end
							if g then
								if g.signals ~= nil and #g.signals > 0 then
									for _, z in pairs( g.signals ) do
										local f = false
										for _, si in pairs( s ) do
											if si.signal.name == z.signal.name then
												si.count = si.count + z.count
												f = true
												break
											end
										end
										if not f then table.insert( s, z ) end
									end
								end
							end
						else
							global.WirelessNetworks["Sender"][nn][i] = nil
							global.WirelessNetworks.E[i] = nil
						end
					end
				end
				n = gl["Reciever"][nn]
				if next( n ) then
					for i, _ in pairs( n ) do
						local p = gl.E[i].e
						if p.valid then
							local b = p.get_or_create_control_behavior()
							local pa = {}
							if #s >0 then
								for z = 1, #s do
									local h = { count = s[z].count, index = z, signal = s[z].signal }
									table.insert( pa, h )
								end
							end
							b.parameters = { parameters = pa }
						else
							global.WirelessNetworks["Reciever"][nn][i] = nil
							global.WirelessNetworks.E[i] = nil
						end
					end
				end
			end
		end
	end
end )

script.on_event( defines.events.on_player_created, function( e )
	local p = game.players[e.player_index]
	local b = F.AddSpriteButton( mod_gui.get_button_flow( p ), "WirelessGUIButton", "Wireless" )
end )