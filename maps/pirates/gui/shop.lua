
local Memory = require 'maps.pirates.memory'
local Common = require 'maps.pirates.common'
local CoreData = require 'maps.pirates.coredata'
local Utils = require 'maps.pirates.utils_local'
local Math = require 'maps.pirates.math'
local Balance = require 'maps.pirates.balance'
local Surfaces = require 'maps.pirates.surfaces.surfaces'
local Roles = require 'maps.pirates.roles.roles'
local Crew = require 'maps.pirates.crew'
local Shop = require 'maps.pirates.shop.shop'
local Progression = require 'maps.pirates.progression'
local Structures = require 'maps.pirates.structures.structures'
local inspect = require 'utils.inspect'.inspect
local Boats = require 'maps.pirates.structures.boats.boats'
local GuiCommon = require 'maps.pirates.gui.common'
local Public = {}

local window_name = 'shop'

function Public.toggle_window(player)
	local flow, flow2, flow3, flow4, flow5, flow6

	local shop_data_1 = Shop.main_shop_data_1
	local shop_data_2 = Shop.main_shop_data_2

	if player.gui.screen[window_name .. '_piratewindow'] then player.gui.screen[window_name .. '_piratewindow'].destroy() return end
	
	flow = GuiCommon.new_window(player, window_name)
	flow.caption = 'Shop'

	
	flow2 = flow.add({
		name = 'trades',
		type = 'flow',
		direction = 'vertical',
	})
    flow2.style.top_margin = 3
    flow2.style.bottom_margin = 3
    flow2.style.horizontal_align = 'center'
    flow2.style.vertical_align = 'center'

	for k, _ in pairs(shop_data_1) do
		flow3 = GuiCommon.flow_add_shop_item(flow2, k)
	end

	flow3 = flow2.add({
		name = 'line_1',
		type = 'line',
	})
    flow3.style.width = 100

	for k, _ in pairs(shop_data_2) do
		flow3 = GuiCommon.flow_add_shop_item(flow2, k)
	end


	flow2 = GuiCommon.flow_add_close_button(flow, window_name .. '_piratebutton')

	flow3 = flow2.add({
		name = 'tospend',
		type = 'sprite-button',
		sprite = 'item/sulfur',
		index = 1,
		enabled = false,
	})
end





function Public.update(player)
	local flow, flow2, flow3, flow4, flow5, flow6

	local memory = Memory.get_crew_memory()
	local shop_data = Utils.nonrepeating_join_dict(Shop.main_shop_data_1, Shop.main_shop_data_2)
	local shop_data_1 = Shop.main_shop_data_1
	local shop_data_2 = Shop.main_shop_data_2
	
	local availability_data = memory.mainshop_availability_bools

	if not player.gui.screen[window_name .. '_piratewindow'] then return end
	flow = player.gui.screen[window_name .. '_piratewindow']


	--*** WHAT TO SHOW ***--

	if memory.gold then
		flow.close_button_flow.hflow.tospend.number = memory.gold
		flow.close_button_flow.hflow.tospend.tooltip = string.format('The crew has %01d gold.', memory.gold)
	else
		flow.close_button_flow.hflow.tospend.number = 0
		flow.close_button_flow.hflow.tospend.tooltip = string.format('The crew has %01d gold.', 0)
	end

	if memory.crewstatus == Crew.enum.ADVENTURING then
		flow.trades.visible = true
	else
		flow.trades.visible = false
	end

	local anything_in_shop_1 = false
	for k, _ in pairs(shop_data_1) do
		if availability_data and availability_data[k] == true then
			flow.trades[k].visible = true
			anything_in_shop_1 = true
			if player.index == memory.playerindex_captain then
				flow.trades[k].buy_button.visible = true
			else
				flow.trades[k].buy_button.visible = false
			end
		else
			flow.trades[k].visible = false
		end
	end
	flow.trades.line_1.visible = anything_in_shop_1
	for k, _ in pairs(shop_data_2) do
		if availability_data and availability_data[k] == true then
			flow.trades[k].visible = true
			if player.index == memory.playerindex_captain then
				flow.trades[k].buy_button.visible = true
			else
				flow.trades[k].buy_button.visible = false
			end
		else
			flow.trades[k].visible = false
		end
	end


	--*** UPDATE CONTENT ***--

	local multiplier = Balance.main_shop_cost_multiplier()

	for k, v in pairs(shop_data) do
		for k2, v2 in pairs(v.base_cost) do
			if v2 == false then
				flow.trades[k]['cost_' .. k2].number = nil
			else
				flow.trades[k]['cost_' .. k2].number = multiplier * v2
			end
		end
	end

	
end


function Public.click(event)

	local player = game.players[event.element.player_index]

	local eventname = event.element.name

	if not player.gui.screen[window_name .. '_piratewindow'] then return end
	local flow = player.gui.screen[window_name .. '_piratewindow']

	local memory = Memory.get_crew_memory()

	if eventname == 'buy_button' then
		Shop.main_shop_try_purchase(event.element.parent.name)
	end

end

return Public