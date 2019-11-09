for index, force in pairs( game.forces ) do
  	local technologies = force.technologies
  	local recipes = force.recipes

  	recipes["Wireless-Sender"].enabled = technologies["circuit-network"].researched
  	recipes["Wireless-Reciever"].enabled = technologies["circuit-network"].researched
end