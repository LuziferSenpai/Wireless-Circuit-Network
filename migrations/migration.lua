for index, force in pairs( game.forces ) do
	local technologies = force.technologies
	local recipes = force.recipes
	
	recipes["wireless-transmitter"].enabled = technologies["circuit-network"].researched
	recipes["wireless-reciever"].enabled = technologies["circuit-network"].researched
end