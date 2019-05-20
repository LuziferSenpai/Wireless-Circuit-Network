F =
{
	Globals = function()
		global.WirelessNetworks = global.WirelessNetworks or { N = {}, E = {}, Sender = {}, Reciever = {} }
		global.PlayerDATA = global.PlayerDATA or {}
	end,
	Players = function()
		for _, p in pairs( game.players ) do
			if not mod_gui.get_button_flow( p ).WirelessGUIButton then
				local b = F.AddSpriteButton( mod_gui.get_button_flow( p ), "WirelessGUIButton", "Wireless" )
			end
		end
	end,
	MainGUI = function( p )
		local A01 = F.AddFrame( p, "WirelessNetworksGUI", "outer_frame_without_shadow" )
		local A02 = F.AddTable( A01, "WirelessNetworksTable01", 2 )
		local A03 =
		{
			F.AddFrame( A02, "WirelessNetworksHiddenFrame01", "outer_frame_without_shadow" ),
			F.AddFrame( A02, "WirelessNetworksHiddenFrame02", "outer_frame_without_shadow" )
		}
		local A04 = F.AddFrame( A03[1], "WirelessNetworksFrame01" )
		local A05 =
		{
			F.AddLabel( A04, "WirelessNetworksLabel01", { "Wireless-Networks.Interface" } ),
			F.AddTable( A04, "WirelessNetworksTable02", 3 )
		}
		A05[1].style = "description_title_label"
		local A06 =
		{
			F.AddDropDown( A05[2], "WirelessNetworksDropDown01", global.WirelessNetworks.N ),
			F.AddSpriteButton( A05[2], "WirelessNetworksSpriteButton01", "Senpais-plus" ),
			F.AddSpriteButton( A05[2], "WirelessNetworksSpriteButton02", "utility/trash_bin" )
		}
	end,
	AddGUI = function( p )
		local B01 = F.AddFrame( p, "WirelessNetworksFrame02" )
		local B02 =
		{
			F.AddLabel( B01, "WirelessNetworksLabel02", { "Wireless-Networks.NewNetwork" } ),
			F.AddTextfield( B01, "WirelessNetworksTextField" ),
			F.AddButton( B01, "WirelessNetworksButton", { "Wireless-Networks.AddNetwork" } )
		}
		B02[1].style = "description_title_label"
	end,
	DisplayGUI = function( p, i )
		local C01 = F.AddFrame( p, "WirelessNetworksHiddenFrame03", "outer_frame_without_shadow" )
		local C02 =
		{
			F.AddLabel( C01, "WirelessNetworksLabel03", { "Wireless-Networks.Stats" } ),
			F.AddTable( C01, "WirelessNetworksTable03", 2 ),
			F.AddTable( C01, "WirelessNetworksTable04", 2 )
		}
		C02[1].style = "description_title_label"
		local C03 =
		{
			F.AddLabel( C02[2], "WirelessNetworksLabel04", { "Wireless-Networks.TotalSender" } ),
			F.AddLabel( C02[2], "WirelessNetworksLabel05", table_size( global.WirelessNetworks["Sender"][i] ) or 0 ),
			F.AddLabel( C02[3], "WirelessNetworksLabel06", { "Wireless-Networks.TotalReciever" } ),
			F.AddLabel( C02[3], "WirelessNetworksLabel07", table_size( global.WirelessNetworks["Reciever"][i] ) or 0 )
		}
		C03[1].style = "description_label"
		C03[2].style = "description_value_label"
		C03[3].style = "description_label"
		C03[4].style = "description_value_label"
	end,
	ChooseNetworkGUI = function( p, i )
		local D01 = F.AddFrame( p, "WirelessNetworksFrame03" )
		local D02 =
		{
			F.AddLabel(D01, "WirelessNetworksLabel08", { "Wireless-Networks.Network" } ),
			F.AddDropDown( D01, "WirelessNetworksDropDown02", global.WirelessNetworks.N )
		}
		D02[1].style = "description_title_label"
		D02[2].selected_index = i
		return D01
	end,
	AddSpriteButton = function(f, n, s, st )
		return f.add{ type = "sprite-button", name = n, style = st or nil, sprite = s }
	end,
	AddFrame = function( f, n, s )
		return f.add{ type = "frame", name = n, direction = "vertical", style = s or nil }
	end,
	AddTable = function( f, n, c )
		return f.add{ type = "table", name = n, column_count = c }
	end,
	AddDropDown = function( f, n, i )
		return f.add{ type = "drop-down", name = n, items = i or nil }
	end,
	AddTextfield = function( f, n, t )
		return f.add{ type = "textfield", name = n, text = t or nil }
	end,
	AddButton = function( f, n, c )
		return f.add{ type = "button", name = n, caption = c or nil }
	end,
	AddLabel = function( f, n, c )
		return f.add{ type = "label", name = n, caption = c or nil }
	end
}

function Wireless_OnRemove( e )
	local ee = e.entity
	local i = ee.unit_number
	local d = global.WirelessNetworks.E["E" .. i]
	global.WirelessNetworks[d.t:sub( 1, 1 ):upper() .. d.t:sub( 2 ):lower()][d.n]["E" .. i] = nil
	global.WirelessNetworks.E["E" .. i] = nil
	--if entity.name == "Wireless-Reciever" then
	--	for j = 1, #global.WirelessNetworks do
	--		if #global.WirelessNetworksReciever[global.WirelessNetworks[j]] > 0 then
	--			for m, mm in pairs( global.WirelessNetworksReciever[global.WirelessNetworks[j]] ) do
	--				if mm == entity then
	--					global.WirelessNetworksReciever[global.WirelessNetworks[j]][m] = nil
	--					return
	--				end
	--			end
	--		end
	--	end
	--end
end

return F