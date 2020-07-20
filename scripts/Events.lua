require "mod-gui"
require "util"

local player_lib = require "scripts/Player"
local network_lib = require "scripts/Network"
local definesevents = defines.events
local wirelessnames =
{
	["wireless-transmitter"] = true,
	["wireless-reciever"] = true
}
local script_data =
{
	players = {},
	pertickupdates = {},
	currenttick = 1,
	maximumupdates = 0,
	networks = {},
	index = 1,
	networknames = {},
	names = {},
	transmitter = {},
	reciever = {}
}

local update_players = function(network)
	for _, player in pairs(script_data.players) do
		if player.dropdown and script_data.networknames(player.dropdown.selected_index) == network.name then
			player.transmitterlabel.caption = table_size(network.transmitter)
			player.recieverlabel.caption = table_size(network.reciever)
		end
	end
end

local playerstart = function(player_index)
    if 	not script_data.players[tostring(player_index)] then
        local player = player_lib.new(game.players[player_index])

        script_data.players[player.index] = player
    end
end

local playerload = function()
    for _, player in pairs(game.players) do
        playerstart(player.index)
    end
end

local updatepertickupdates = function()
	script_data.pertickupdates = {}

	local pertickupdates = script_data.pertickupdates
	local maxvalue = settings.global["Network-Update-Sec"].value

	for i = 1, maxvalue do
		pertickupdates[i] = {}
	end

	local currentnumber = 1

	for index, _ in pairs(script_data.networks) do
		table.insert(pertickupdates[currentnumber], index)
		
		if currentnumber == maxvalue then
			currentnumber = 1
		else
			currentnumber = currentnumber + 1
		end
	end

	script_data.currenttick = 1
	script_data.maximumupdates = maxvalue
end

--Events
local on_tick = function()
	local networks = script_data.networks
	local currenttick = script_data.currenttick
	local updatenetworks = script_data.pertickupdates[currenttick]
	
	for _, index in pairs( updatenetworks ) do
		networks[index]:update()
	end

	if currenttick == script_data.maximumupdates then
		script_data.currenttick = 1
	else
		script_data.currenttick = currenttick + 1
	end
end

local on_entity_cloned = function(event)
	local source = event.source
	local destination = event.destination
	local sourcename = source.name
	local destinationname = destination.name

	if wirelessnames[sourcename] and wirelessnames[destinationname] then
		local network = script_data[sourcename:sub(10)][tostring(source.unit_number)]

		if network then
			local index = tostring(destination.unit_number)
			local destinationtype = destinationname:sub(10)
			local destinationnetwork = script_data[destinationtype][index]

			if destinationnetwork then
				script_data.networks[destinationnetwork]:remove(destination)
			end

			script_data[destinationtype][index] = network
			script_data.networks[network]:add(destination)

			update_players(script_data.networks[network])
		end
	end
end

local on_gui_click = function(event)
	local name = event.element.name

	if name:sub(1, 14) == "WIRELESS_CLICK" then
		local player_id = event.player_index
		local player = game.players[player_id]
		local playermeta = script_data.players[tostring(player_id)]
		local number = name:sub(16, 17)

		if number == "01" then
			if playermeta.frame then
				playermeta:clear()
			else
				playermeta:gui(script_data.networknames)
			end
		elseif number == "02" then
			playermeta:clear()
		elseif number == "03" then
			local selected_index = playermeta.dropdown.selected_index

			if selected_index > 0 then
				local networkname = script_data.networknames[selected_index]
				local index = script_data.names[networkname]
				local network = script_data.networks[index]

				for index_number, _ in pairs(network.transmitter) do
					script_data.transmitter[index_number] = nil
				end

				for index_number, _ in pairs(network.reciever) do
					script_data.reciever[index_number] = nil
				end

				script_data.networknames[selected_index] = nil
				script_data.names[network.name] = nil
				script_data.networks[index] = nil

				if next(script_data.networks) then
					for _, scriptplayer in pairs(script_data.players) do
						local dropdown = scriptplayer.dropdown

						if dropdown then
							dropdown.items = script_data.networknames
							selected_index = dropdown.selected_index

							if selected_index == 0 then
								scriptplayer.transmitterflow.visible = false
								scriptplayer.transmitterlabel.caption = ""
								scriptplayer.recieverflow.visible = false
								scriptplayer.recieverlabel.caption = ""
								scriptplayer.line.visible = false
							else
								local network2 = script_data.networks[script_data.names[script_data.networknames[selected_index]]]
								scriptplayer.transmitterlabel.caption = table_size(network2.transmitter)
								scriptplayer.recieverlabel.caption = table_size(network2.reciever)
							end
						end
					end
				else
					for _, scriptplayer in pairs(script_data.players) do
						if scriptplayer.dropdown then
							scriptplayer.dropdown.items = {}
							scriptplayer.transmitterflow.visible = false
							scriptplayer.transmitterlabel.caption = ""
							scriptplayer.recieverflow.visible = false
							scriptplayer.recieverlabel.caption = ""
							scriptplayer.line.visible = false
						end
					end
				end
			else
				player.print({"Wireless.NothingSelected"})
			end
		elseif number == "04" then
			local text = playermeta.textfield.text

			if #text > 0 then
				if script_data.names[text] then
					player.print({"Wireless.AlreadyExist"})
				else
					local index = tostring(script_data.index)

					script_data.networks[index] = network_lib.new(index, text)
					table.insert(script_data.networknames, text)
					script_data.names[text] = index

					script_data.index = script_data.index + 1

					updatepertickupdates()

					for _, scriptplayer in pairs(script_data.players) do
						if scriptplayer.dropdown then
							scriptplayer.dropdown.items = script_data.networknames
						end
					end
				end
			else
				player.print({"Wireless.NoName"})
			end
		elseif number == "05" then
			playermeta:clearentity()
		end
	end
end

local on_gui_closed = function(event)
	local element = event.element

	if element and element.name == "WIRELESS_ENTITY_GUI" then
		script_data.players[tostring(event.player_index)]:clearentity()
	end
end

local on_gui_location_changed = function(event)
    local playermeta = script_data.players[tostring(event.player_index)]
    local element = event.element
    if playermeta.frame and element.index == playermeta.frame.index then
        playermeta.location = element.location
    end
end

local on_gui_opened = function(event)
	if event.gui_type == defines.gui_type.entity then
		local entity = event.entity
		local name = entity.name

		if wirelessnames[name] then
			local number = 0
			local index = script_data[name:sub(10)][tostring(entity.unit_number)]
			
			if index then
				local networkname = script_data.networks[index].name
				local networknames = script_data.networknames

				for i = 1, #networknames do
					if networknames[i] == networkname then
						number = i
						
						break
					end
				end
			end

			script_data.players[tostring(event.player_index)]:entitygui(script_data.networknames, number, entity)
		end
	end
end

local on_gui_selection_state_changed = function(event)
	local element = event.element
	local name = element.name

	if name:sub(1, 13) == "WIRELESS_DROP" then
		local playermeta = script_data.players[tostring(event.player_index)]
		local selected_index = element.selected_index
		local network = script_data.networks[script_data.names[script_data.networknames[selected_index]]]
		local number = name:sub(15, 16)

		if number == "01" then
			playermeta.transmitterflow.visible = true
			playermeta.transmitterlabel.caption = table_size(network.transmitter)
			playermeta.recieverflow.visible = true
			playermeta.recieverlabel.caption = table_size(network.transmitter)
			playermeta.line.visible = true
		elseif number == "02" then
			local entity = playermeta.entity
			local index = tostring(entity.unit_number)
			local entitytype = entity.name:sub(10)
			local entitynetwork = script_data[entitytype][index]

			if entitynetwork then
				script_data.networks[entitynetwork]:remove(entity)
			end

			script_data[entitytype][index] = network.index
			network:add(entity)

			update_players(network)
		end
	end
end

local on_player_created = function(event)
    playerstart(event.player_index)
end

local on_player_removed = function( event )
    script_data.players[tostring(event.player_index)] = nil
end

local on_runtime_mod_setting_changed = function(event)
	if event.setting == "Network-Update-Sec" then
		updatepertickupdates()
	end
end

local on_entity_removed = function(event)
	local entity = event.entity

	if not (entity and entity.valid) then return end

	local name = entity.name

	if wirelessnames[name] then
		local entitytype = name:sub(10)
		local index = tostring(entity.unit_number)
		local index_number = script_data[entitytype][index]
		
		if index_number then
			script_data.networks[index_number]:remove(entity)
			script_data[entitytype][index] = nil
		end
	end
end

local lib = {}

lib.events =
{
	[definesevents.on_tick] = on_tick,
	[definesevents.on_entity_cloned] = on_entity_cloned,
	[definesevents.on_entity_settings_pasted] = on_entity_cloned,
	[definesevents.on_gui_click] = on_gui_click,
	[definesevents.on_gui_closed] = on_gui_closed,
	[definesevents.on_gui_location_changed] = on_gui_location_changed,
	[definesevents.on_gui_opened] = on_gui_opened,
	[definesevents.on_gui_selection_state_changed] = on_gui_selection_state_changed,
	[definesevents.on_player_created] = on_player_created,
	[definesevents.on_player_removed] = on_player_removed,
	[definesevents.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed,
	[definesevents.on_entity_died] = on_entity_removed,
    [definesevents.on_robot_mined_entity] = on_entity_removed,
    [definesevents.script_raised_destroy] = on_entity_removed,
    [definesevents.on_player_mined_entity] = on_entity_removed,
}

lib.add_remote_interface = function()
	remote.add_interface
	(
		"WirelessName",
		{
			Change = function(player_id, text)
                local playermeta = script_data.players[tostring(player_id)]

                if playermeta.textfield then
                    playermeta.textfield.text = text

                    return false
                else
                    return true
                end
			end
		}
	)
end

lib.on_init = function()
	global.wireless = global.wireless or script_data

	updatepertickupdates()

	playerload()
end

lib.on_load = function()
	script_data = global.wireless or script_data

	for _, player in pairs(script_data.players) do
		setmetatable(player, player_lib.metatable)
	end
end

lib.on_configuration_changed = function(event)
	local changes = event.mod_changes or {}

	if next(changes) then
		global.wireless = global.wireless or script_data

		playerload()

		local wirelesschanges = changes["Wireless_Circuit_Network"] or {}

		if next(wirelesschanges) then
			local oldversion = wirelesschanges.old_version

			if oldversion and wirelesschanges.new_version then
				if oldversion == "0.3.4" then
					local Networks = global.script_data.Networks
					for index, name in pairs(Networks.Names) do
						local index_number = tostring(script_data.index)

						local network = network_lib.new(index_number, name)
						script_data.networks[index_number] = network
						table.insert(script_data.networknames, name)
						script_data.names[name] = index_number

						script_data.index = script_data.index + 1

						for _, entity in pairs(Networks.Sender[index]) do
							if entity.valid then
								network:add(entity)
								script_data.transmitter[tostring(entity.unit_number)] = index_number
							end
						end

						for _, entity in pairs(Networks.Reciever[index]) do
							if entity.valid then
								network:add(entity)
								script_data.reciever[tostring(entity.unit_number)] = index_number
							end
						end
					end

					for _, player in pairs(game.players) do
						if mod_gui.get_button_flow(player).WirelessButton then
							mod_gui.get_button_flow(player).WirelessButton.destroy()
						end
					end

					global.script_data = nil
				elseif oldversion == "0.4.0" then
					for _, player in pairs(game.players) do
						if mod_gui.get_button_flow(player).WirelessButton then
							mod_gui.get_button_flow(player).WirelessButton.destroy()
						end
					end
				end
			end
		end

		updatepertickupdates()
	end
end

return lib