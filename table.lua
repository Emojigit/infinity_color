-- Minetest Mod: infinity_color - init.lua
-- origin code: (c) 2017 orwell96
-- edited code: (c) 2020 Emoji

minetest.register_node("infinity_color:table", {
	description = "Color Changing table Table",
	tiles = {"engrave_top.png", "engrave_side.png"},
	groups = {choppy=2,flammable=3, oddly_breakable_by_hand=2},
	sounds = default and default.node_sound_wood_defaults(),
	on_punch = function(pos, node, player)
		local pname=player:get_player_name()
		local stack=player:get_wielded_item()
		if not(stack:get_name()=="infinity_color:spawn") then
			minetest.chat_send_player(pname, "Please wield the color spawner you want to color, and then click the engraving table again.")
			return
		end
		local idef=minetest.registered_items[stack:get_name()]
		if not idef then
			minetest.chat_send_player(pname, "You can't name an unknown item!")
			return
		end
		local name="#fff"
		local what="Color Block Spawner"
		if stack:get_count()>1 then
			what="stack of "..what
		end
		
		local meta=stack:get_meta()
		if meta then
			local metaname=meta:get_string("inf_color")
			if metaname~="" then
				name=metaname
			end
		end
		local fieldtype = "field"
		minetest.show_formspec(pname, "inf_color_table", "size[5.5,2.5]"..fieldtype.."[0.5,0.5;5,1;name;Enter a new name for this "..what..";"..name.."]button_exit[1,1.5;3,1;ok;OK]")
	end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname=="inf_color_table" and fields.name and fields.ok then
		local pname=player:get_player_name()
		
		local stack=player:get_wielded_item()
		if not(stack:get_name()=="infinity_color:spawn") then
			minetest.chat_send_player(pname, "Please wield the color spawner you want to color, and then click the engraving table again.")
			return
		end
		local idef=minetest.registered_items[stack:get_name()]
		if not idef then
			minetest.chat_send_player(pname, "You can't name an unknown item!")
			return
		end
		local meta=stack:get_meta()
		if not meta then
			minetest.chat_send_player(pname, "For some reason, the stack metadata couldn't be acquired. Try again!")
			return
		end
		
		if not(fields.name) then
			meta:set_string("inf_color", "#fff")
		else
			meta:set_string("inf_color", fields.name)
		end
		--write back
		player:set_wielded_item(stack)
	end
end)

minetest.register_craft({
	output = "infinity_color:table",
	recipe = {
		{"group:dye", "group:dye", "group:dye"},
		{"group:wood", "default:diamond", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})
