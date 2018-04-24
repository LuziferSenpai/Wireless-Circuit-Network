game.reload_script()

for index, force in pairs( game.forces ) do
	force.reset_recipes()
	force.reset_technologies()
end

for index, force in pairs( game.forces ) do
	local tech = force.technologies
	local recipe = force.recipes
	if tech["circuit-network"].researched then
		if recipe["Wireless-Sender"] then recipe["Wireless-Sender"].enabled = true end
		if recipe["Wireless-Reciever"] then recipe["Wireless-Reciever"].enabled = true end
	end
end