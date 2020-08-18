local mod_storage = minetest.get_mod_storage()
local modname = minetest.get_current_modname()
local path = minetest.get_modpath(modname)
local tmp = {}
dofile(path.."/table.lua")

local cube_def = {
	hp_max = 1,
	physical = true,
	weight = 5,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "cube",
	visual_size = {x=1, y=1},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = true,
	on_activate = function(self, staticdata)
		if tmp.texture ~= nil then
			self.texture = tmp.texture
			tmp.texture = nil
		else
			if staticdata ~= nil
			and staticdata ~= "" then

				local data = staticdata:split(";")

				if data and data[1]then
					self.texture = data[1]
				end
			end
		end
		if self.texture ~= nil then
			self.object:set_properties({textures = {self.texture,self.texture,self.texture,self.texture,self.texture,self.texture}})
		end
	end,
	get_staticdata = function(self)

		if self.texture ~= nil then
			return self.texture
		end

		return ""
	end,
}
minetest.register_entity("infinity_color:color_cube", cube_def)

minetest.register_craftitem("infinity_color:spawn", {
	description = "Color Cube Spawner",
	inventory_image = "^[colorize:#fff",
	on_place = function(itemstack, placer, pointed_thing)
	if pointed_thing.ref then
		local pos1 = pointed_thing.ref:get_pos()
	end
	if pos1 then
		pos1.y = pos1.y + 1
	end
	local pos = pointed_thing.above or pos1
	if pos then
		local meta = itemstack:get_meta()
		local color = meta:get_string("inf_color") or "#fff"
		local color_str = "^[colorize:"..tostring(color)
		tmp.texture = color_str
		local Object = minetest.add_entity(pos, "infinity_color:color_cube")
		if placer:get_player_name() then
			if not (creative and creative.is_enabled_for and creative.is_enabled_for(placer:get_player_name())) then
				itemstack:take_item()
			end
		end
	end
	return itemstack
end,})
