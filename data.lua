local MODNAME = "__Wireless_Circuit_Network__"

local entity = util.table.deepcopy( data.raw["constant-combinator"]["constant-combinator"] )

local item = util.table.deepcopy( data.raw["item"]["constant-combinator"] )

local recipe = util.table.deepcopy( data.raw["recipe"]["constant-combinator"] )
recipe.ingredients = { { "constant-combinator", 1 } }

local sender_entity = util.table.deepcopy( entity )
sender_entity.name = "Wireless-Sender"
sender_entity.minable.result = "Wireless-Sender"
sender_entity.item_slot_count = 0

local sender_item = util.table.deepcopy( item )
sender_item.name = "Wireless-Sender"
sender_item.order = "c[combinators]-za[wireless-sender]"
sender_item.place_result = "Wireless-Sender"

local sender_recipe = util.table.deepcopy( recipe )
sender_recipe.name = "Wireless-Sender"
sender_recipe.result = "Wireless-Sender"

local reciever_entity = util.table.deepcopy( entity )
reciever_entity.name = "Wireless-Reciever"
reciever_entity.minable.result = "Wireless-Reciever"
reciever_entity.item_slot_count = 500

local reciever_item = util.table.deepcopy( item )
reciever_item.name = "Wireless-Reciever"
reciever_item.order = "c[combinators]-zb[wireless-reciever]"
reciever_item.place_result = "Wireless-Reciever"

local reciever_recipe = util.table.deepcopy( recipe )
reciever_recipe.name = "Wireless-Reciever"
reciever_recipe.result = "Wireless-Reciever"

table.insert( data.raw["technology"]["circuit-network"].effects, { type = "unlock-recipe", recipe = "Wireless-Sender" } )
table.insert( data.raw["technology"]["circuit-network"].effects, { type = "unlock-recipe", recipe = "Wireless-Reciever" } )

data:extend{ sender_entity, sender_item, sender_recipe, reciever_entity, reciever_item, reciever_recipe,
			 { type = "sprite", name = "Wireless", filename = MODNAME .. "/graphics/Wireless.png", priority = "extra-high-no-scale", width = 32, height = 32, scale = 1 } }

data.raw["sprite"] = data.raw["sprite"] or {}

if not data.raw["sprite"]["Senpais-plus"] then
	data:extend{ { type = "sprite", name = "Senpais-plus", filename = MODNAME .. "/graphics/plus.png", priority = "extra-high-no-scale", width = 32, height = 32, scale = 1 } }
end