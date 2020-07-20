local player_data = {}

player_data.metatable = {__index = player_data}

function player_data.new(player)
    local module = {
        player = player,
        index = tostring(player.index),
        location = {x = 5, y = 85 * player.display_scale},
        button = mod_gui.get_button_flow(player).add{type = "sprite-button", name = "WIRELESS_CLICK_01", sprite = "Wireless", style = mod_gui.button_style},
    }

    setmetatable(module, player_data.metatable)

    return module
end

function player_data:gui(networks)
    local frame = self.player.gui.screen.add{type = "frame", name = "WIRELESS_LOCATION", direction = "vertical", style = "inner_frame_in_outer_frame"}
    local titleflow = frame.add{type = "flow", direction = "horizontal", style = "wirelesstitlebarflow"}
    titleflow.add{type = "label", caption = {"Wireless.Title"}, style = "frame_title"}
    titleflow.add{type = "empty-widget", style = "wirelessdragwidget"}.drag_target = frame
    titleflow.add{type = "sprite-button", name = "WIRELESS_CLICK_02", sprite = "utility/close_white", style = "frame_action_button"}
    local networkflow = frame.add{type = "flow", direction = "horizontal", style = "wirelessflowcenterleft88"}
    networkflow.add{type = "label", caption = {"Wireless.NetworkTitle"}, style = "caption_label"}
    networkflow.add{type = "empty-widget", style = "wirelesswidget"}
    self.dropdown = networkflow.add{type = "drop-down", name = "WIRELESS_DROP_01", items = networks}
    networkflow.add{type = "sprite-button", name = "WIRELESS_CLICK_03", sprite = "Senpais-remove", style = "wirelesstoolbutton"}
    frame.add{type = "line", direction = "horizontal"}
    local transmitterflow = frame.add{type = "flow", direction = "horizontal"}
    transmitterflow.add{type = "label", caption = {"Wireless.Transmitter"}, style = "description_label"}
    self.transmitterlabel = transmitterflow.add{type = "label", style = "description_value_label"}
    transmitterflow.visible = false
    self.transmitterflow = transmitterflow
    local recieverflow = frame.add{type = "flow", direction = "horizontal"}
    recieverflow.add{type = "label", caption = {"Wireless.Reciever"}, style = "description_label"}
    self.recieverlabel = recieverflow.add{type = "label", style = "description_value_label"}
    recieverflow.visible = false
    self.recieverflow = recieverflow
    self.line = frame.add{type = "line", direction = "horizontal"}
    self.line.visible = false
    local addflow = frame.add{type = "flow", direction = "horizontal", style = "wirelessflowcenterleft8"}
    addflow.add{type = "label", caption = {"Wireless.Name"}}
    self.textfield = addflow.add{type = "textfield"}
    addflow.add{type = "button", name = "WIRELESS_CLICK_04", caption = {"Wireless.AddNetwork"}}
    frame.location = self.location
    self.frame = frame
end

function player_data:clear()
    self.frame.destroy()
    self.frame = nil
    self.dropdown = nil
    self.transmitterflow = nil
    self.transmitterlabel = nil
    self.recieverflow = nil
    self.recieverlabel = nil
    self.line = nil
    self.textfield = nil
end

function player_data:entitygui(networks, index, entity)
    local frame = self.player.gui.center.add{type = "frame", name = "WIRELESS_ENTITY_GUI", direction = "vertical", style = "inner_frame_in_outer_frame"}
    local titleflow = frame.add{type = "flow", direction = "horizontal", style = "wirelesstitlebarflow"}
    titleflow.add{type = "label", caption = {"Wireless.Network"}, style = "frame_title"}
    titleflow.add{type = "empty-widget", style = "wirelessdragwidget"}
    titleflow.add{type = "sprite-button", name = "WIRELESS_CLICK_05", sprite = "utility/close_white", style = "frame_action_button"}
    frame.add{type = "line", direction = "horizontal"}
    self.entitydropdown = frame.add{type = "drop-down", name = "WIRELESS_DROP_02", items = networks, selected_index = index}
    self.entityframe = frame
    self.entity = entity

    self.player.opened = frame
end

function player_data:clearentity()
    self.entityframe.destroy()
    self.entityframe = nil
    self.entitydropdown = nil
    self.entity = nil
end

return player_data