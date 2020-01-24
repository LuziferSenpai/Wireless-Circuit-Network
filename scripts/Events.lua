require "mod-gui"
require "util"

local GUI = require "GUI"
local de = defines.events
local Format = string.format
local mod_button_flow = mod_gui.get_button_flow
local wirered = defines.wire_type.red
local wiregreen = defines.wire_type.green
local mathmin = math.min
local mathmax = math.max
local mathfloor = math.floor
local WirelessNames =
{
	["Wireless-Sender"] = true,
	["Wireless-Reciever"] = true
}
local script_data =
{
	PerTickUpdates = {},
	CurrentUpdateTick = 1,
	MaximumUpdates = 0,
	Sender = {},
	Reciever = {},
	
	NetworkNames = {},
	Networks =
	{
		Number = 0,
		Names = {},
		Sender = {},
		Reciever = {}
	},

	--PlayerData
	GUIS = {},
	Position = {},
	Visible = {}
}

local CloseEntityGUIS = function()
	local gui = script_data.GUIS

	if not gui then return end
	
	for _, player in pairs( game.players ) do
		local player_id = player.index

		if next( gui[player_id] ) and gui[player_id].B then
			gui[player_id].B["01"].destroy()
			gui[player_id].B = nil
		end
	end
end

local MainGUIToggle = function( player_id )
	local player = game.players[player_id]
	local screen = player.gui.screen

	if screen.WirelessFrameAGUI01 then
		local gui = script_data.GUIS[player_id].A["01"]

		gui.visible = not gui.visible
	else
		local gui = GUI.Main( screen )

		gui["01"].location = script_data.Position[player_id]
	
		gui["03"]["06"].items = script_data.Networks.Names

		script_data.GUIS[player_id].A = gui
	end

	local Visible = script_data.Visible
	Visible[player_id] = not Visible[player_id]
end

local MainGUIAddToggle = function( player_id )
	local gui = script_data.GUIS[player_id].A["02"]

	gui["05"].visible = not gui["05"].visible
	gui["06"].visible = not gui["06"].visible
end

local MainGUIUpdate = function( player_id )
	local gui = script_data.GUIS[player_id]
	if next( gui ) then
		gui = gui.A

		local selected_index = gui["03"]["06"].selected_index
		if selected_index > 0 then
			local index = Format( "%04d", selected_index )
		
			gui["02"]["07"].visible = true
			gui["02"]["08"].visible = true	
			gui["03"]["14"].caption = table_size( script_data.Networks.Sender[index] )
			gui["03"]["16"].caption = table_size( script_data.Networks.Reciever[index] )
		else
			gui["02"]["07"].visible = false
			gui["02"]["08"].visible = false	
			gui["03"]["14"].caption = 0
			gui["03"]["16"].caption = 0
		end
	end
end

local MainGUIUpdateList = function()
	local gui = script_data.GUIS
	local player_id = 0

	for _, player in pairs( game.players ) do
		player_id = player.index

		if next( gui[player_id] ) then
			gui[player_id].A["03"]["06"].items = script_data.Networks.Names

			MainGUIUpdate( player_id )
		end
	end
end

local AddNetwork = function( addtype, player_id, name, sender, reciever )
	if addtype == "addnew" and script_data.NetworkNames[name] then
		if type( player_id ) == "number" then
			game.players[player_id].print( { "Wireless.AlreadyExist" } )
		end
		
		return false
	end

	local Networks = script_data.Networks

	if Networks.Number < 1000 then
		Networks.Number = Networks.Number + 1

		local index = Format( "%04d", Networks.Number )

		Networks.Names[index] = name
		Networks.Sender[index] = sender or {}
		Networks.Reciever[index] = reciever or {}

		script_data.NetworkNames[name] = index
		
		return true
	else
		return false
	end
end

local UpdatePerTickUpdates = function()
	script_data.PerTickUpdates = {}

	local PerTickUpdates = script_data.PerTickUpdates
	local maxvalue = settings.global["Network-Update-Sec"].value
	
	for i = 1, maxvalue do
		PerTickUpdates[i] = {}
	end

	local currentnumber = 1

	for _, index in pairs( script_data.NetworkNames ) do
		table.insert( PerTickUpdates[currentnumber], index )

		currentnumber = currentnumber + 1

		if currentnumber > maxvalue then
			currentnumber = 1
		end
	end

	script_data.CurrentUpdateTick = 1
	script_data.MaximumUpdates = maxvalue
end

local Events =
{
	["WirelessDropDownAGUI01"] = function( event )
		MainGUIUpdate( event.player_index )
	end,
	["WirelessDropDownBGUI01"] = function( event )
		local player_id = event.player_index
		local gui = script_data.GUIS[player_id].B["02"]
		local index_number = Format( "%04d", event.element.selected_index )
		local index = gui["04"].caption
		local entitytype = gui["05"].caption
		local index_number2 = script_data[entitytype][index]

		if index_number2 then
			script_data.Networks[entitytype][index_number2][index] = nil
			script_data[entitytype][index] = nil
		end

		script_data.Networks[entitytype][index_number][index] = gui["06"].entity
		script_data[entitytype][index] = index_number

		MainGUIUpdateList()
	end
}

local Click =
{
	["WirelessButton"] = function( event )
		MainGUIToggle( event.player_index )
	end,
	["WirelessButtonAGUI01"] = function( event )
		local player_id = event.player_index
		local gui = script_data.GUIS[player_id].A["03"]
		local text = gui["10"].text

		if text:len() > 0 then
			if AddNetwork( "addnew", player_id, text ) then
				MainGUIAddToggle( player_id )

				gui["10"].text = ""

				MainGUIUpdateList()
				UpdatePerTickUpdates()
			end
		else
			game.players[player_id].print( { "Wireless.NoName" } )
		end
	end,
	["WirelessSpriteButtonAGUI01"] = function( event )
		local player_id = event.player_index

		script_data.GUIS[player_id].A["01"].visible = false
		script_data.Visible[player_id] = false
	end,
	["WirelessSpriteButtonAGUI02"] = function( event )
		MainGUIAddToggle( event.player_index )
	end,
	["WirelessSpriteButtonAGUI03"] = function( event )
		local player_id = event.player_index
		local gui = script_data.GUIS[player_id]
		local selected_index = gui.A["03"]["06"].selected_index

		if selected_index > 0 then
			CloseEntityGUIS()
			
			local index_number = Format( "%04d", selected_index )
			local Networks = script_data.Networks
			local Sender = Networks.Sender[index_number]
			local Reciever = Networks.Reciever[index_number]

			for index, entity in pairs( Sender ) do
				script_data.Sender[index] = nil
			end

			for index, entity in pairs( Reciever ) do
				entity.get_or_create_control_behavior().parameters = { parameters = {} }

				script_data.Reciever[index] = nil
			end

			script_data.NetworkNames[Networks.Names[index_number]] = nil

			Networks.Names[index_number] = nil
			Networks.Sender[index_number] = nil
			Networks.Reciever[index_number] = nil

			script_data.Networks =
			{
				Number = 0,
				Names = {},
				Sender = {},
				Reciever = {}
			}

			local Names = Networks.Names
			
			for entry, name in pairs( Names ) do
				AddNetwork( "", player_id, name, Networks.Sender[entry], Networks.Reciever[entry] )
			end

			MainGUIUpdateList()
			UpdatePerTickUpdates()
		else
			game.players[player_id].print( { "Wireless.NothingSelected" } )
		end
	end,
	["WirelessSpriteButtonBGUI01"] = function( event )
		local player_id = event.player_index

		script_data.GUIS[player_id].B["01"].destroy()
		script_data.GUIS[player_id].B = nil
	end
}

local PlayerStart = function( player_id )
	local player = game.players[player_id]
	local button_flow = mod_button_flow( player )

	if not button_flow.WirelessButton then
		local b = GUI.AddSpriteButton( button_flow, "WirelessButton", "Wireless" )
	end

	script_data.Position[player_id] = script_data.Position[player_id] or { x = 5, y = 85 * player.display_scale }
	script_data.GUIS[player_id] = script_data.GUIS[player_id] or {}
	script_data.Visible[player_id] = script_data.Visible[player_id] or false
end

local PlayerLoad = function()
	for _, player in pairs( game.players ) do
		PlayerStart( player.index )
	end
end

--Events
local on_tick = function()
	local Networks = script_data.Networks
	
	for _, network in pairs( script_data.PerTickUpdates[script_data.CurrentUpdateTick] ) do
		local signaltable = {}
		local signals = {}
		local index_number = 1
		local parameters = {}

		for index, entity in pairs( Networks.Sender[network] ) do
			if entity.valid then
				signals = entity.get_circuit_network( wirered )

				if signals and signals.signals then
					for _, signal in pairs( signals.signals ) do
						if signal then
							local signal2 = signal.signal
							local signaltype = signal2.type
							local signalname = signal2.name
							local signalcount = signal.count
		
							if not signaltable[signaltype] then
								signaltable[signaltype] = {}
							end
	
							local signaltabletype = signaltable[signaltype]
	
							if signaltabletype[signalname] then
								signaltabletype[signalname].count = signaltabletype[signalname].count + signalcount
							else
								signaltabletype[signalname] = { signal = signal2, count = signalcount }
							end
						end
					end
				end

				signals = entity.get_circuit_network( wiregreen )

				if signals and signals.signals then
					for _, signal in pairs( signals.signals ) do
						if signal then
							local signal2 = signal.signal
							local signaltype = signal2.type
							local signalname = signal2.name
							local signalcount = signal.count
		
							if not signaltable[signaltype] then
								signaltable[signaltype] = {}
							end
	
							local signaltabletype = signaltable[signaltype]
	
							if signaltabletype[signalname] then
								signaltabletype[signalname].count = signaltabletype[signalname].count + signalcount
							else
								signaltabletype[signalname] = { signal = signal2, count = signalcount }
							end
						end
					end
				end
			else
				script_data.Sender[index] = nil
				script_data.Networks.Sender[network][index] = nil

				MainGUIUpdateList()
			end
		end

		for index, entity in pairs( Networks.Reciever[network] ) do
			if entity.valid then
				index_number = 1
				parameters = {}

				for _, signals2 in pairs( signaltable ) do
					for _, signals3 in pairs( signals2 ) do
						if index_number < 1000 then
							parameters[index_number] = { index = index_number, signal = signals3.signal, count = mathmin( 2147483647, mathmax( -2147483647, mathfloor( signals3.count or 1 ) ) ) }
							index_number = index_number + 1
						else
							break
						end
					end
				end

				entity.get_or_create_control_behavior().parameters = { parameters = parameters }
			else
				script_data.Reciever[index] = nil
				script_data.Networks.Reciever[network][index] = nil

				MainGUIUpdateList()
			end
		end
	end

	script_data.CurrentUpdateTick = script_data.CurrentUpdateTick + 1

	if script_data.CurrentUpdateTick > script_data.MaximumUpdates then
		script_data.CurrentUpdateTick = 1
	end
end

local on_entity_cloned = function( event )
	local entity = event.destination
	local name = entity.name

	if WirelessNames[name] then
		local entitytype = name:sub( 10 )
		local source = event.source
		local network = script_data[source.name:sub( 10 )]["E" .. source.unit_number]

		if network then
			local index = "E" .. entity.unit_number
			script_data.Networks[entitytype][network][index] = entity
			script_data[entitytype][index] = network

			MainGUIUpdateList()
		end
	end
end

local on_gui_click = function( event )
	local click = Click[event.element.name]

	if click then
		click( event )
	end
end

local on_gui_closed = function( event )
	local element = event.element

	if element and element.name == "WirelessFrameBGUI01" then
		element.destroy()

		script_data.GUIS[event.player_index].B = nil
	end
end

local on_gui_location_changed = function( event )
	local element = event.element

	if element.name == "WirelessFrameAGUI01" then
		script_data.Position[event.player_index] = element.location
	end
end

local on_gui_opened = function( event )
	if event.gui_type == defines.gui_type.entity then
		local entity = event.entity
		local name = entity.name

		if WirelessNames[name] then
			local player_id = event.player_index
			local player = game.players[player_id]
			local index = "E" .. entity.unit_number
			local center = player.gui.center
			local entitytype = name:sub( 10 )
			local gui = GUI.EntityGUI( center )

			gui["02"]["03"].items = script_data.Networks.Names
			gui["02"]["04"].caption = index
			gui["02"]["05"].caption = entitytype
			gui["02"]["06"].entity = entity

			if script_data[entitytype][index] then
				gui["02"]["03"].selected_index = tonumber( script_data[entitytype][index] )
			end

			script_data.GUIS[player_id].B = gui

			player.opened = gui["01"]
		end
	end
end

local on_gui_event = function( event )
	local events = Events[event.element.name]
		
	if events then
		events( event )
	end
end

local on_player_created = function( event )
	PlayerStart( event.player_index )
end

local on_player_removed = function( event )
	local player_id = event.player_index

	script_data.Position[player_id] = nil
	script_data.GUI[player_id] = nil
	script_data.Visible[player_id] = nil
end

local on_runtime_mod_setting_changed = function( event )
	if event.setting == "Network-Update-Sec" then
		UpdatePerTickUpdates()
	end
end

local lib = {}

lib.events =
{
	[de.on_tick] = on_tick,
	[de.on_entity_cloned] = on_entity_cloned,
	[de.on_entity_settings_pasted] = on_entity_cloned,
	[de.on_gui_click] = on_gui_click,
	[de.on_gui_closed] = on_gui_closed,
	[de.on_gui_location_changed] = on_gui_location_changed,
	[de.on_gui_opened] = on_gui_opened,
	[de.on_gui_selection_state_changed] = on_gui_event,
	[de.on_player_created] = on_player_created,
	[de.on_player_removed] = on_player_removed,
	[de.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
}

lib.add_remote_interface = function()
	remote.add_interface
	(
		"WirelessName",
		{
			Change = function( player_id, text )
				local gui = script_data.GUIS[player_id]

				if script_data.Visible[player_id] and gui.A["02"]["05"].visible then
					gui["03"]["10"].text = text

					return false
				else
					return true
				end
			end
		}
	)
end

lib.on_load = function()
	script_data = global.script_data or script_data
end

lib.on_configuration_changed = function( event )
	local changes = event.mod_changes or {}

	if next( changes ) then
		global.script_data = global.script_data or script_data

		PlayerLoad()

		local wirelesschanges = changes["Wireless_Circuit_Network"] or {}

		if next( wirelesschanges ) then
			local oldversion = wirelesschanges.old_version

			if oldversion and wirelesschanges.new_version then
				if oldversion <= "0.2.0" then
					for _, player in pairs( game.players ) do
						local button_flow = mod_button_flow( player )
						local frame_flow = mod_gui.get_frame_flow( player )

						if button_flow.WirelessGUIButton then button_flow.WirelessGUIButton.destroy() end
						if frame_flow.WirelessNetworksGUI then frame_flow.WirelessNetworksGUI.destroy() end
					end

					local Networks = script_data.Networks
					local Sender = script_data.Sender
					local Reciever = script_data.Reciever
					local WirelessNetworks = global.WirelessNetworks

					for _, name in pairs( WirelessNetworks.N ) do
						if AddNetwork( "addnew", nil, name ) then
							local index_number =Format( "%04d", Networks.Number )
							
							for index, _ in pairs( WirelessNetworks.Sender[name] ) do
								Sender[index] = index_number
								Networks.Sender[index_number][index] = WirelessNetworks.E[index].e
							end

							for index, _ in pairs( WirelessNetworks.Reciever[name] ) do
								Reciever[index] = index_number
								Networks.Reciever[index_number][index] = WirelessNetworks.E[index].e
							end
						end
					end

					global.PlayerData = nil
					global.WirelessNetworks = nil
				end
			end
		end

		UpdatePerTickUpdates()
	end
end

lib.on_init = function()
	global.script_data = global.script_data or script_data

	UpdatePerTickUpdates()
	PlayerLoad()
end

return lib