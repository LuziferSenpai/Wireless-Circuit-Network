local MODNAME = "__Wireless_Circuit_Network__"

local entity = util.table.deepcopy( data.raw["constant-combinator"]["constant-combinator"] )
entity.icon_size = 32
entity.icon_mipmap = nil

local item = util.table.deepcopy( data.raw["item"]["constant-combinator"] )
item.icon_size = 32
item.icon_mipmap = nil

local recipe = util.table.deepcopy( data.raw["recipe"]["constant-combinator"] )
recipe.ingredients = { { "constant-combinator", 1 } }

local sender_entity = util.table.deepcopy( entity )
sender_entity.name = "Wireless-Sender"
sender_entity.icon = MODNAME .. "/graphics/sender-i.png"
sender_entity.minable.result = "Wireless-Sender"
sender_entity.item_slot_count = 0
sender_entity.sprites = make_4way_animation_from_spritesheet
(
	{
		layers = 
		{
			{
				filename = MODNAME .. "/graphics/sender.png",
				width = 58,
				height = 52,
				frame_count = 1,
				shift = util.by_pixel( 0, 5 ),
				hr_version =
				{
					scale = 0.5,
					filename = MODNAME .. "/graphics/hr-sender.png",
					width = 114,
					height = 102,
					frame_count = 1,
					shift = util.by_pixel( 0, 5 )
				}
			},
			{
        		filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
        		width = 50,
        		height = 34,
        		frame_count = 1,
        		shift = util.by_pixel( 9, 6 ),
        		draw_as_shadow = true,
        		hr_version =
        		{
        		  scale = 0.5,
        		  filename = "__base__/graphics/entity/combinator/hr-constant-combinator-shadow.png",
        		  width = 98,
        		  height = 66,
        		  frame_count = 1,
        		  shift = util.by_pixel( 8.5, 5.5 ),
        		  draw_as_shadow = true
        		}
      		}
		}
	}
)

local sender_item = util.table.deepcopy( item )
sender_item.name = "Wireless-Sender"
sender_item.icon = MODNAME .. "/graphics/sender-i.png"
sender_item.order = "c[combinators]-za[wireless-sender]"
sender_item.place_result = "Wireless-Sender"

local sender_recipe = util.table.deepcopy( recipe )
sender_recipe.name = "Wireless-Sender"
sender_recipe.result = "Wireless-Sender"

local reciever_entity = util.table.deepcopy( entity )
reciever_entity.name = "Wireless-Reciever"
reciever_entity.icon = MODNAME .. "/graphics/reciever-i.png"
reciever_entity.minable.result = "Wireless-Reciever"
reciever_entity.item_slot_count = 1000
reciever_entity.sprites = make_4way_animation_from_spritesheet
(
	{
		layers = 
		{
			{
				filename = MODNAME .. "/graphics/reciever.png",
				width = 58,
				height = 52,
				frame_count = 1,
				shift = util.by_pixel( 0, 5 ),
				hr_version =
				{
					scale = 0.5,
					filename = MODNAME .. "/graphics/hr-reciever.png",
					width = 114,
					height = 102,
					frame_count = 1,
					shift = util.by_pixel( 0, 5 )
				}
			},
			{
        		filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
        		width = 50,
        		height = 34,
        		frame_count = 1,
        		shift = util.by_pixel( 9, 6 ),
        		draw_as_shadow = true,
        		hr_version =
        		{
        		  scale = 0.5,
        		  filename = "__base__/graphics/entity/combinator/hr-constant-combinator-shadow.png",
        		  width = 98,
        		  height = 66,
        		  frame_count = 1,
        		  shift = util.by_pixel( 8.5, 5.5 ),
        		  draw_as_shadow = true
        		}
      		}
		}
	}
)

local reciever_item = util.table.deepcopy( item )
reciever_item.name = "Wireless-Reciever"
reciever_item.icon = MODNAME .. "/graphics/reciever-i.png"
reciever_item.order = "c[combinators]-zb[wireless-reciever]"
reciever_item.place_result = "Wireless-Reciever"

local reciever_recipe = util.table.deepcopy( recipe )
reciever_recipe.name = "Wireless-Reciever"
reciever_recipe.result = "Wireless-Reciever"

table.insert( data.raw["technology"]["circuit-network"].effects, { type = "unlock-recipe", recipe = "Wireless-Sender" } )
table.insert( data.raw["technology"]["circuit-network"].effects, { type = "unlock-recipe", recipe = "Wireless-Reciever" } )

data:extend
{
	sender_entity, sender_item, sender_recipe, reciever_entity, reciever_item, reciever_recipe,
	{
		type = "sprite",
		name = "Wireless",
		filename = MODNAME .. "/graphics/Wireless.png",
		priority = "extra-high-no-scale",
		width = 32,
		height = 32,
		scale = 1
	},
	{
		type = "sprite",
		name = "Senpais-plus",
		filename = MODNAME .. "/graphics/plus.png",
		priority = "extra-high-no-scale",
		width = 32,
		height = 32,
		scale = 1
	}
}

local style = data.raw["gui-style"].default

style["SenpaisFlowCenter/Left8"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center",
    horizontal_align = "left",
    horizontal_spacing = 8
}

style["SenpaisFlowCenter/Left4"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center",
    horizontal_align = "left",
    horizontal_spacing = 4
}

style["SenpaisLine4"] =
{
    type = "line_style",
    top_margin = 4,
    bottom_margin = 4
}

style["SenpaisToolButton28"] =
{
    type = "button_style",
    parent = "tool_button",
    size = 28,
    padding = 0
}