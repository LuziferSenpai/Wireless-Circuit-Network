local MODNAME = "__Wireless_Circuit_Network__"

local entity = util.table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.icon_size = 32
entity.icon_mipmap = nil

local item = util.table.deepcopy(data.raw["item"]["constant-combinator"])
item.icon_size = 32
item.icon_mipmap = nil

local recipe = util.table.deepcopy(data.raw["recipe"]["constant-combinator"])
recipe.ingredients = {{"constant-combinator", 1}}

local transmitter_entity = util.table.deepcopy(entity)
transmitter_entity.name = "wireless-transmitter"
transmitter_entity.icon = MODNAME .. "/graphics/transmitter-i.png"
transmitter_entity.minable.result = "wireless-transmitter"
transmitter_entity.item_slot_count = 0
transmitter_entity.sprites = make_4way_animation_from_spritesheet({
	layers = {
		{
			filename = MODNAME .. "/graphics/transmitter.png",
			width = 58,
			height = 52,
			frame_count = 1,
			shift = util.by_pixel(0, 5),
			hr_version = {
				scale = 0.5,
				filename = MODNAME .. "/graphics/hr-transmitter.png",
				width = 114,
				height = 102,
				frame_count = 1,
				shift = util.by_pixel(0, 5)
			}
		},
		{
			filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
			width = 50,
			height = 34,
			frame_count = 1,
			shift = util.by_pixel( 9, 6 ),
			draw_as_shadow = true,
			hr_version = {
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
})

local transmitter_item = util.table.deepcopy(item)
transmitter_item.name = "wireless-transmitter"
transmitter_item.icon = MODNAME .. "/graphics/transmitter-i.png"
transmitter_item.order = "c[combinators]-za[wireless-transmitter]"
transmitter_item.place_result = "wireless-transmitter"

local transmitter_recipe = util.table.deepcopy(recipe)
transmitter_recipe.name = "wireless-transmitter"
transmitter_recipe.result = "wireless-transmitter"

local reciever_entity = util.table.deepcopy(entity)
reciever_entity.name = "wireless-reciever"
reciever_entity.icon = MODNAME .. "/graphics/reciever-i.png"
reciever_entity.minable.result = "wireless-reciever"
reciever_entity.item_slot_count = 1000
reciever_entity.sprites = make_4way_animation_from_spritesheet({
	layers = {
		{
			filename = MODNAME .. "/graphics/reciever.png",
			width = 58,
			height = 52,
			frame_count = 1,
			shift = util.by_pixel(0, 5),
			hr_version = {
				scale = 0.5,
				filename = MODNAME .. "/graphics/hr-reciever.png",
				width = 114,
				height = 102,
				frame_count = 1,
				shift = util.by_pixel(0, 5)
			}
		},
		{
			filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
			width = 50,
			height = 34,
			frame_count = 1,
			shift = util.by_pixel(9, 6),
			draw_as_shadow = true,
			hr_version = {
				scale = 0.5,
				filename = "__base__/graphics/entity/combinator/hr-constant-combinator-shadow.png",
				width = 98,
				height = 66,
				frame_count = 1,
				shift = util.by_pixel(8.5, 5.5),
				draw_as_shadow = true
			}
		}
	}
})

local reciever_item = util.table.deepcopy(item)
reciever_item.name = "wireless-reciever"
reciever_item.icon = MODNAME .. "/graphics/reciever-i.png"
reciever_item.order = "c[combinators]-zb[wireless-reciever]"
reciever_item.place_result = "wireless-reciever"

local reciever_recipe = util.table.deepcopy(recipe)
reciever_recipe.name = "wireless-reciever"
reciever_recipe.result = "wireless-reciever"

table.insert(data.raw["technology"]["circuit-network"].effects, {type = "unlock-recipe", recipe = "wireless-transmitter"})
table.insert(data.raw["technology"]["circuit-network"].effects, {type = "unlock-recipe", recipe = "wireless-reciever"})

data:extend{
	transmitter_entity, transmitter_item, transmitter_recipe, reciever_entity, reciever_item, reciever_recipe,
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
	},
	{
        type = "sprite",
        name = "Senpais-remove",
        filename = MODNAME .. "/graphics/remove-icon.png",
        priority = "extra-high-no-scale",
        width = 64,
        height = 64,
        scale = 1
    }
}

local s = data.raw["gui-style"].default

--Flows
s["wirelesstitlebarflow"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center"
}

s["wirelessflowcenterleft8"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    horizontal_align = "left",
    vertical_align = "center",
    horizontal_spacing = 8,
    top_margin = 8
}

s["wirelessflowcenterleft88"] =
{
    type = "horizontal_flow_style",
    parent = "wirelessflowcenterleft8",
    bottom_margin = 8
}

--Widgets
s["wirelessdragwidget"] =
{
    type = "empty_widget_style",
    parent = "draggable_space_header",
    horizontally_stretchable = "on",
    natural_height = 24,
    minimal_width = 24,
}

s["wirelesswidget"] =
{
	type = "empty_widget_style",
	horizontally_stretchable = "on",
	minimal_width = 30
}

--Buttons
s["wirelesstoolbutton"] =
{
    type = "button_style",
    parent = "tool_button",
    size = 28
}