local event = require 'utils.event'

local damage_per_explosive = 100
local empty_tile_damage_absorption = 50
local out_of_map_tile_health = 500
local replacement_tile = "dirt-5"
local math_random = math.random
local math_sqrt = math.sqrt
local kabooms = {"big-artillery-explosion", "big-explosion", "explosion"}
local circle_size_coordinates = {
	[1] = {{x = 0, y = 0}},
	[2] = {{x = -1, y = -1},{x = 1, y = -1},{x = 0, y = -1},{x = -1, y = 0},{x = -1, y = 1},{x = 0, y = 1},{x = 1, y = 1},{x = 1, y = 0}},
	[3] = {{x = -2, y = -1},{x = -1, y = -2},{x = 1, y = -2},{x = 0, y = -2},{x = 2, y = -1},{x = -2, y = 1},{x = -2, y = 0},{x = 2, y = 1},{x = 2, y = 0},{x = -1, y = 2},{x = 1, y = 2},{x = 0, y = 2}},
	[4] = {{x = -1, y = -3},{x = 1, y = -3},{x = 0, y = -3},{x = -3, y = -1},{x = -2, y = -2},{x = 3, y = -1},{x = 2, y = -2},{x = -3, y = 0},{x = -3, y = 1},{x = 3, y = 1},{x = 3, y = 0},{x = -2, y = 2},{x = -1, y = 3},{x = 0, y = 3},{x = 1, y = 3},{x = 2, y = 2}},
	[5] = {{x = -3, y = -3},{x = -2, y = -3},{x = -1, y = -4},{x = -2, y = -4},{x = 1, y = -4},{x = 0, y = -4},{x = 2, y = -3},{x = 3, y = -3},{x = 2, y = -4},{x = -3, y = -2},{x = -4, y = -1},{x = -4, y = -2},{x = 3, y = -2},{x = 4, y = -1},{x = 4, y = -2},{x = -4, y = 1},{x = -4, y = 0},{x = 4, y = 1},{x = 4, y = 0},{x = -3, y = 3},{x = -3, y = 2},{x = -4, y = 2},{x = -2, y = 3},{x = 2, y = 3},{x = 3, y = 3},{x = 3, y = 2},{x = 4, y = 2},{x = -2, y = 4},{x = -1, y = 4},{x = 0, y = 4},{x = 1, y = 4},{x = 2, y = 4}},
	[6] = {{x = -1, y = -5},{x = -2, y = -5},{x = 1, y = -5},{x = 0, y = -5},{x = 2, y = -5},{x = -3, y = -4},{x = -4, y = -3},{x = 3, y = -4},{x = 4, y = -3},{x = -5, y = -1},{x = -5, y = -2},{x = 5, y = -1},{x = 5, y = -2},{x = -5, y = 1},{x = -5, y = 0},{x = 5, y = 1},{x = 5, y = 0},{x = -5, y = 2},{x = -4, y = 3},{x = 4, y = 3},{x = 5, y = 2},{x = -3, y = 4},{x = -2, y = 5},{x = -1, y = 5},{x = 0, y = 5},{x = 1, y = 5},{x = 3, y = 4},{x = 2, y = 5}},
	[7] = {{x = -4, y = -5},{x = -3, y = -5},{x = -2, y = -6},{x = -1, y = -6},{x = 0, y = -6},{x = 1, y = -6},{x = 3, y = -5},{x = 2, y = -6},{x = 4, y = -5},{x = -5, y = -4},{x = -5, y = -3},{x = -4, y = -4},{x = 4, y = -4},{x = 5, y = -4},{x = 5, y = -3},{x = -6, y = -1},{x = -6, y = -2},{x = 6, y = -1},{x = 6, y = -2},{x = -6, y = 1},{x = -6, y = 0},{x = 6, y = 1},{x = 6, y = 0},{x = -5, y = 3},{x = -6, y = 2},{x = 5, y = 3},{x = 6, y = 2},{x = -5, y = 4},{x = -4, y = 4},{x = -4, y = 5},{x = -3, y = 5},{x = 3, y = 5},{x = 4, y = 4},{x = 5, y = 4},{x = 4, y = 5},{x = -1, y = 6},{x = -2, y = 6},{x = 1, y = 6},{x = 0, y = 6},{x = 2, y = 6}},
	[8] = {{x = -1, y = -7},{x = -2, y = -7},{x = 1, y = -7},{x = 0, y = -7},{x = 2, y = -7},{x = -5, y = -5},{x = -4, y = -6},{x = -3, y = -6},{x = 3, y = -6},{x = 4, y = -6},{x = 5, y = -5},{x = -6, y = -3},{x = -6, y = -4},{x = 6, y = -4},{x = 6, y = -3},{x = -7, y = -1},{x = -7, y = -2},{x = 7, y = -1},{x = 7, y = -2},{x = -7, y = 1},{x = -7, y = 0},{x = 7, y = 1},{x = 7, y = 0},{x = -7, y = 2},{x = -6, y = 3},{x = 6, y = 3},{x = 7, y = 2},{x = -5, y = 5},{x = -6, y = 4},{x = 5, y = 5},{x = 6, y = 4},{x = -3, y = 6},{x = -4, y = 6},{x = -2, y = 7},{x = -1, y = 7},{x = 0, y = 7},{x = 1, y = 7},{x = 3, y = 6},{x = 2, y = 7},{x = 4, y = 6}},
	[9] = {{x = -4, y = -7},{x = -3, y = -7},{x = -2, y = -8},{x = -1, y = -8},{x = 0, y = -8},{x = 1, y = -8},{x = 3, y = -7},{x = 2, y = -8},{x = 4, y = -7},{x = -5, y = -6},{x = -6, y = -6},{x = -6, y = -5},{x = 5, y = -6},{x = 6, y = -5},{x = 6, y = -6},{x = -7, y = -4},{x = -7, y = -3},{x = 7, y = -4},{x = 7, y = -3},{x = -8, y = -2},{x = -8, y = -1},{x = 8, y = -1},{x = 8, y = -2},{x = -8, y = 0},{x = -8, y = 1},{x = 8, y = 1},{x = 8, y = 0},{x = -7, y = 3},{x = -8, y = 2},{x = 7, y = 3},{x = 8, y = 2},{x = -7, y = 4},{x = -6, y = 5},{x = 6, y = 5},{x = 7, y = 4},{x = -5, y = 6},{x = -6, y = 6},{x = -4, y = 7},{x = -3, y = 7},{x = 3, y = 7},{x = 5, y = 6},{x = 4, y = 7},{x = 6, y = 6},{x = -2, y = 8},{x = -1, y = 8},{x = 0, y = 8},{x = 1, y = 8},{x = 2, y = 8}},
	[10] = {{x = -3, y = -9},{x = -1, y = -9},{x = -2, y = -9},{x = 1, y = -9},{x = 0, y = -9},{x = 3, y = -9},{x = 2, y = -9},{x = -5, y = -7},{x = -6, y = -7},{x = -5, y = -8},{x = -4, y = -8},{x = -3, y = -8},{x = 3, y = -8},{x = 5, y = -7},{x = 5, y = -8},{x = 4, y = -8},{x = 6, y = -7},{x = -7, y = -5},{x = -7, y = -6},{x = -8, y = -5},{x = 7, y = -5},{x = 7, y = -6},{x = 8, y = -5},{x = -9, y = -3},{x = -8, y = -4},{x = -8, y = -3},{x = 8, y = -4},{x = 8, y = -3},{x = 9, y = -3},{x = -9, y = -1},{x = -9, y = -2},{x = 9, y = -1},{x = 9, y = -2},{x = -9, y = 1},{x = -9, y = 0},{x = 9, y = 1},{x = 9, y = 0},{x = -9, y = 3},{x = -9, y = 2},{x = -8, y = 3},{x = 8, y = 3},{x = 9, y = 3},{x = 9, y = 2},{x = -7, y = 5},{x = -8, y = 5},{x = -8, y = 4},{x = 7, y = 5},{x = 8, y = 5},{x = 8, y = 4},{x = -7, y = 6},{x = -6, y = 7},{x = -5, y = 7},{x = 5, y = 7},{x = 7, y = 6},{x = 6, y = 7},{x = -5, y = 8},{x = -4, y = 8},{x = -3, y = 8},{x = -3, y = 9},{x = -2, y = 9},{x = -1, y = 9},{x = 0, y = 9},{x = 1, y = 9},{x = 3, y = 8},{x = 2, y = 9},{x = 3, y = 9},{x = 5, y = 8},{x = 4, y = 8}},
	[11] = {{x = -5, y = -9},{x = -4, y = -9},{x = -3, y = -10},{x = -1, y = -10},{x = -2, y = -10},{x = 1, y = -10},{x = 0, y = -10},{x = 3, y = -10},{x = 2, y = -10},{x = 5, y = -9},{x = 4, y = -9},{x = -7, y = -7},{x = -6, y = -8},{x = 7, y = -7},{x = 6, y = -8},{x = -9, y = -5},{x = -8, y = -6},{x = 9, y = -5},{x = 8, y = -6},{x = -9, y = -4},{x = -10, y = -3},{x = 9, y = -4},{x = 10, y = -3},{x = -10, y = -2},{x = -10, y = -1},{x = 10, y = -1},{x = 10, y = -2},{x = -10, y = 0},{x = -10, y = 1},{x = 10, y = 1},{x = 10, y = 0},{x = -10, y = 2},{x = -10, y = 3},{x = 10, y = 3},{x = 10, y = 2},{x = -9, y = 4},{x = -9, y = 5},{x = 9, y = 5},{x = 9, y = 4},{x = -8, y = 6},{x = -7, y = 7},{x = 7, y = 7},{x = 8, y = 6},{x = -6, y = 8},{x = -5, y = 9},{x = -4, y = 9},{x = 4, y = 9},{x = 5, y = 9},{x = 6, y = 8},{x = -3, y = 10},{x = -2, y = 10},{x = -1, y = 10},{x = 0, y = 10},{x = 1, y = 10},{x = 2, y = 10},{x = 3, y = 10}},
	[12] = {{x = -3, y = -11},{x = -2, y = -11},{x = -1, y = -11},{x = 0, y = -11},{x = 1, y = -11},{x = 2, y = -11},{x = 3, y = -11},{x = -7, y = -9},{x = -6, y = -9},{x = -5, y = -10},{x = -4, y = -10},{x = 5, y = -10},{x = 4, y = -10},{x = 7, y = -9},{x = 6, y = -9},{x = -9, y = -7},{x = -7, y = -8},{x = -8, y = -8},{x = -8, y = -7},{x = 7, y = -8},{x = 8, y = -7},{x = 8, y = -8},{x = 9, y = -7},{x = -9, y = -6},{x = -10, y = -5},{x = 9, y = -6},{x = 10, y = -5},{x = -11, y = -3},{x = -10, y = -4},{x = 10, y = -4},{x = 11, y = -3},{x = -11, y = -2},{x = -11, y = -1},{x = 11, y = -1},{x = 11, y = -2},{x = -11, y = 0},{x = -11, y = 1},{x = 11, y = 1},{x = 11, y = 0},{x = -11, y = 2},{x = -11, y = 3},{x = 11, y = 3},{x = 11, y = 2},{x = -10, y = 5},{x = -10, y = 4},{x = 10, y = 5},{x = 10, y = 4},{x = -9, y = 7},{x = -9, y = 6},{x = -8, y = 7},{x = 8, y = 7},{x = 9, y = 7},{x = 9, y = 6},{x = -8, y = 8},{x = -7, y = 8},{x = -7, y = 9},{x = -6, y = 9},{x = 7, y = 8},{x = 7, y = 9},{x = 6, y = 9},{x = 8, y = 8},{x = -5, y = 10},{x = -4, y = 10},{x = -3, y = 11},{x = -2, y = 11},{x = -1, y = 11},{x = 0, y = 11},{x = 1, y = 11},{x = 2, y = 11},{x = 3, y = 11},{x = 4, y = 10},{x = 5, y = 10}},
	[13] = {{x = -5, y = -11},{x = -4, y = -11},{x = -3, y = -12},{x = -1, y = -12},{x = -2, y = -12},{x = 1, y = -12},{x = 0, y = -12},{x = 3, y = -12},{x = 2, y = -12},{x = 4, y = -11},{x = 5, y = -11},{x = -8, y = -9},{x = -7, y = -10},{x = -6, y = -10},{x = 6, y = -10},{x = 7, y = -10},{x = 8, y = -9},{x = -10, y = -7},{x = -9, y = -8},{x = 9, y = -8},{x = 10, y = -7},{x = -11, y = -5},{x = -10, y = -6},{x = 10, y = -6},{x = 11, y = -5},{x = -11, y = -4},{x = -12, y = -3},{x = 11, y = -4},{x = 12, y = -3},{x = -12, y = -1},{x = -12, y = -2},{x = 12, y = -1},{x = 12, y = -2},{x = -12, y = 1},{x = -12, y = 0},{x = 12, y = 1},{x = 12, y = 0},{x = -12, y = 3},{x = -12, y = 2},{x = 12, y = 3},{x = 12, y = 2},{x = -11, y = 5},{x = -11, y = 4},{x = 11, y = 4},{x = 11, y = 5},{x = -10, y = 7},{x = -10, y = 6},{x = 10, y = 6},{x = 10, y = 7},{x = -9, y = 8},{x = -8, y = 9},{x = 9, y = 8},{x = 8, y = 9},{x = -7, y = 10},{x = -5, y = 11},{x = -6, y = 10},{x = -4, y = 11},{x = 5, y = 11},{x = 4, y = 11},{x = 7, y = 10},{x = 6, y = 10},{x = -3, y = 12},{x = -2, y = 12},{x = -1, y = 12},{x = 0, y = 12},{x = 1, y = 12},{x = 2, y = 12},{x = 3, y = 12}},
	[14] = {{x = -3, y = -13},{x = -1, y = -13},{x = -2, y = -13},{x = 1, y = -13},{x = 0, y = -13},{x = 3, y = -13},{x = 2, y = -13},{x = -7, y = -11},{x = -6, y = -11},{x = -5, y = -12},{x = -6, y = -12},{x = -4, y = -12},{x = 5, y = -12},{x = 4, y = -12},{x = 7, y = -11},{x = 6, y = -11},{x = 6, y = -12},{x = -10, y = -9},{x = -9, y = -9},{x = -9, y = -10},{x = -8, y = -10},{x = 9, y = -9},{x = 9, y = -10},{x = 8, y = -10},{x = 10, y = -9},{x = -11, y = -7},{x = -10, y = -8},{x = 11, y = -7},{x = 10, y = -8},{x = -11, y = -6},{x = -12, y = -6},{x = -12, y = -5},{x = 11, y = -6},{x = 12, y = -6},{x = 12, y = -5},{x = -13, y = -3},{x = -12, y = -4},{x = 12, y = -4},{x = 13, y = -3},{x = -13, y = -2},{x = -13, y = -1},{x = 13, y = -1},{x = 13, y = -2},{x = -13, y = 0},{x = -13, y = 1},{x = 13, y = 1},{x = 13, y = 0},{x = -13, y = 2},{x = -13, y = 3},{x = 13, y = 3},{x = 13, y = 2},{x = -12, y = 5},{x = -12, y = 4},{x = 12, y = 5},{x = 12, y = 4},{x = -11, y = 6},{x = -11, y = 7},{x = -12, y = 6},{x = 11, y = 7},{x = 11, y = 6},{x = 12, y = 6},{x = -10, y = 8},{x = -10, y = 9},{x = -9, y = 9},{x = 9, y = 9},{x = 10, y = 9},{x = 10, y = 8},{x = -9, y = 10},{x = -8, y = 10},{x = -7, y = 11},{x = -6, y = 11},{x = 7, y = 11},{x = 6, y = 11},{x = 8, y = 10},{x = 9, y = 10},{x = -6, y = 12},{x = -5, y = 12},{x = -4, y = 12},{x = -3, y = 13},{x = -2, y = 13},{x = -1, y = 13},{x = 0, y = 13},{x = 1, y = 13},{x = 2, y = 13},{x = 3, y = 13},{x = 5, y = 12},{x = 4, y = 12},{x = 6, y = 12}},
	[15] = {{x = -5, y = -13},{x = -6, y = -13},{x = -4, y = -13},{x = -3, y = -14},{x = -1, y = -14},{x = -2, y = -14},{x = 1, y = -14},{x = 0, y = -14},{x = 3, y = -14},{x = 2, y = -14},{x = 5, y = -13},{x = 4, y = -13},{x = 6, y = -13},{x = -9, y = -11},{x = -8, y = -11},{x = -8, y = -12},{x = -7, y = -12},{x = 7, y = -12},{x = 8, y = -12},{x = 8, y = -11},{x = 9, y = -11},{x = -11, y = -9},{x = -10, y = -10},{x = 10, y = -10},{x = 11, y = -9},{x = -12, y = -7},{x = -11, y = -8},{x = -12, y = -8},{x = 11, y = -8},{x = 12, y = -8},{x = 12, y = -7},{x = -13, y = -5},{x = -13, y = -6},{x = 13, y = -5},{x = 13, y = -6},{x = -13, y = -4},{x = -14, y = -3},{x = 13, y = -4},{x = 14, y = -3},{x = -14, y = -2},{x = -14, y = -1},{x = 14, y = -1},{x = 14, y = -2},{x = -14, y = 0},{x = -14, y = 1},{x = 14, y = 1},{x = 14, y = 0},{x = -14, y = 2},{x = -14, y = 3},{x = 14, y = 3},{x = 14, y = 2},{x = -13, y = 4},{x = -13, y = 5},{x = 13, y = 5},{x = 13, y = 4},{x = -13, y = 6},{x = -12, y = 7},{x = 12, y = 7},{x = 13, y = 6},{x = -11, y = 9},{x = -11, y = 8},{x = -12, y = 8},{x = 11, y = 8},{x = 11, y = 9},{x = 12, y = 8},{x = -9, y = 11},{x = -10, y = 10},{x = -8, y = 11},{x = 9, y = 11},{x = 8, y = 11},{x = 10, y = 10},{x = -7, y = 12},{x = -8, y = 12},{x = -6, y = 13},{x = -5, y = 13},{x = -4, y = 13},{x = 5, y = 13},{x = 4, y = 13},{x = 7, y = 12},{x = 6, y = 13},{x = 8, y = 12},{x = -3, y = 14},{x = -2, y = 14},{x = -1, y = 14},{x = 0, y = 14},{x = 1, y = 14},{x = 2, y = 14},{x = 3, y = 14}},
	[16] = {{x = -3, y = -15},{x = -1, y = -15},{x = -2, y = -15},{x = 1, y = -15},{x = 0, y = -15},{x = 3, y = -15},{x = 2, y = -15},{x = -7, y = -13},{x = -8, y = -13},{x = -5, y = -14},{x = -6, y = -14},{x = -4, y = -14},{x = 5, y = -14},{x = 4, y = -14},{x = 7, y = -13},{x = 6, y = -14},{x = 8, y = -13},{x = -9, y = -12},{x = -10, y = -11},{x = 9, y = -12},{x = 10, y = -11},{x = -11, y = -10},{x = -12, y = -9},{x = 11, y = -10},{x = 12, y = -9},{x = -13, y = -7},{x = -13, y = -8},{x = 13, y = -7},{x = 13, y = -8},{x = -14, y = -6},{x = -14, y = -5},{x = 14, y = -5},{x = 14, y = -6},{x = -15, y = -3},{x = -14, y = -4},{x = 15, y = -3},{x = 14, y = -4},{x = -15, y = -2},{x = -15, y = -1},{x = 15, y = -1},{x = 15, y = -2},{x = -15, y = 0},{x = -15, y = 1},{x = 15, y = 1},{x = 15, y = 0},{x = -15, y = 2},{x = -15, y = 3},{x = 15, y = 3},{x = 15, y = 2},{x = -14, y = 5},{x = -14, y = 4},{x = 14, y = 5},{x = 14, y = 4},{x = -13, y = 7},{x = -14, y = 6},{x = 13, y = 7},{x = 14, y = 6},{x = -13, y = 8},{x = -12, y = 9},{x = 12, y = 9},{x = 13, y = 8},{x = -11, y = 10},{x = -10, y = 11},{x = 10, y = 11},{x = 11, y = 10},{x = -9, y = 12},{x = -8, y = 13},{x = -7, y = 13},{x = 7, y = 13},{x = 8, y = 13},{x = 9, y = 12},{x = -6, y = 14},{x = -5, y = 14},{x = -4, y = 14},{x = -3, y = 15},{x = -2, y = 15},{x = -1, y = 15},{x = 0, y = 15},{x = 1, y = 15},{x = 2, y = 15},{x = 3, y = 15},{x = 4, y = 14},{x = 5, y = 14},{x = 6, y = 14}},
	[17] = {{x = -5, y = -15},{x = -6, y = -15},{x = -3, y = -16},{x = -4, y = -16},{x = -4, y = -15},{x = -1, y = -16},{x = -2, y = -16},{x = 1, y = -16},{x = 0, y = -16},{x = 3, y = -16},{x = 2, y = -16},{x = 5, y = -15},{x = 4, y = -15},{x = 4, y = -16},{x = 6, y = -15},{x = -9, y = -13},{x = -10, y = -13},{x = -8, y = -14},{x = -7, y = -14},{x = 7, y = -14},{x = 9, y = -13},{x = 8, y = -14},{x = 10, y = -13},{x = -11, y = -12},{x = -11, y = -11},{x = -12, y = -11},{x = -10, y = -12},{x = 11, y = -11},{x = 11, y = -12},{x = 10, y = -12},{x = 12, y = -11},{x = -13, y = -10},{x = -13, y = -9},{x = -12, y = -10},{x = 13, y = -9},{x = 13, y = -10},{x = 12, y = -10},{x = -14, y = -7},{x = -14, y = -8},{x = 14, y = -7},{x = 14, y = -8},{x = -15, y = -6},{x = -15, y = -5},{x = 15, y = -5},{x = 15, y = -6},{x = -15, y = -4},{x = -16, y = -4},{x = -16, y = -3},{x = 15, y = -4},{x = 16, y = -3},{x = 16, y = -4},{x = -16, y = -2},{x = -16, y = -1},{x = 16, y = -1},{x = 16, y = -2},{x = -16, y = 0},{x = -16, y = 1},{x = 16, y = 1},{x = 16, y = 0},{x = -16, y = 2},{x = -16, y = 3},{x = 16, y = 3},{x = 16, y = 2},{x = -16, y = 4},{x = -15, y = 4},{x = -15, y = 5},{x = 15, y = 5},{x = 15, y = 4},{x = 16, y = 4},{x = -15, y = 6},{x = -14, y = 7},{x = 14, y = 7},{x = 15, y = 6},{x = -13, y = 9},{x = -14, y = 8},{x = 13, y = 9},{x = 14, y = 8},{x = -13, y = 10},{x = -12, y = 10},{x = -12, y = 11},{x = -11, y = 11},{x = 11, y = 11},{x = 12, y = 11},{x = 12, y = 10},{x = 13, y = 10},{x = -11, y = 12},{x = -10, y = 12},{x = -10, y = 13},{x = -9, y = 13},{x = 9, y = 13},{x = 10, y = 13},{x = 10, y = 12},{x = 11, y = 12},{x = -8, y = 14},{x = -7, y = 14},{x = -6, y = 15},{x = -5, y = 15},{x = -4, y = 15},{x = 4, y = 15},{x = 5, y = 15},{x = 7, y = 14},{x = 6, y = 15},{x = 8, y = 14},{x = -4, y = 16},{x = -3, y = 16},{x = -2, y = 16},{x = -1, y = 16},{x = 0, y = 16},{x = 1, y = 16},{x = 2, y = 16},{x = 3, y = 16},{x = 4, y = 16}},
	[18] = {{x = -3, y = -17},{x = -4, y = -17},{x = -1, y = -17},{x = -2, y = -17},{x = 1, y = -17},{x = 0, y = -17},{x = 3, y = -17},{x = 2, y = -17},{x = 4, y = -17},{x = -9, y = -15},{x = -8, y = -15},{x = -7, y = -15},{x = -7, y = -16},{x = -6, y = -16},{x = -5, y = -16},{x = 5, y = -16},{x = 7, y = -15},{x = 7, y = -16},{x = 6, y = -16},{x = 9, y = -15},{x = 8, y = -15},{x = -11, y = -13},{x = -10, y = -14},{x = -9, y = -14},{x = 9, y = -14},{x = 11, y = -13},{x = 10, y = -14},{x = -13, y = -11},{x = -12, y = -12},{x = 13, y = -11},{x = 12, y = -12},{x = -15, y = -9},{x = -14, y = -10},{x = -14, y = -9},{x = 14, y = -10},{x = 14, y = -9},{x = 15, y = -9},{x = -15, y = -8},{x = -15, y = -7},{x = -16, y = -7},{x = 15, y = -8},{x = 15, y = -7},{x = 16, y = -7},{x = -16, y = -6},{x = -16, y = -5},{x = 16, y = -5},{x = 16, y = -6},{x = -17, y = -3},{x = -17, y = -4},{x = 17, y = -3},{x = 17, y = -4},{x = -17, y = -1},{x = -17, y = -2},{x = 17, y = -1},{x = 17, y = -2},{x = -17, y = 1},{x = -17, y = 0},{x = 17, y = 1},{x = 17, y = 0},{x = -17, y = 3},{x = -17, y = 2},{x = 17, y = 3},{x = 17, y = 2},{x = -17, y = 4},{x = -16, y = 5},{x = 16, y = 5},{x = 17, y = 4},{x = -15, y = 7},{x = -16, y = 7},{x = -16, y = 6},{x = 15, y = 7},{x = 16, y = 7},{x = 16, y = 6},{x = -15, y = 9},{x = -15, y = 8},{x = -14, y = 9},{x = 14, y = 9},{x = 15, y = 9},{x = 15, y = 8},{x = -14, y = 10},{x = -13, y = 11},{x = 13, y = 11},{x = 14, y = 10},{x = -12, y = 12},{x = -11, y = 13},{x = 11, y = 13},{x = 12, y = 12},{x = -10, y = 14},{x = -9, y = 14},{x = -9, y = 15},{x = -8, y = 15},{x = -7, y = 15},{x = 7, y = 15},{x = 9, y = 14},{x = 9, y = 15},{x = 8, y = 15},{x = 10, y = 14},{x = -7, y = 16},{x = -6, y = 16},{x = -5, y = 16},{x = -4, y = 17},{x = -3, y = 17},{x = -2, y = 17},{x = -1, y = 17},{x = 0, y = 17},{x = 1, y = 17},{x = 2, y = 17},{x = 3, y = 17},{x = 4, y = 17},{x = 5, y = 16},{x = 6, y = 16},{x = 7, y = 16}},
	[19] = {{x = -7, y = -17},{x = -6, y = -17},{x = -5, y = -17},{x = -3, y = -18},{x = -4, y = -18},{x = -1, y = -18},{x = -2, y = -18},{x = 1, y = -18},{x = 0, y = -18},{x = 3, y = -18},{x = 2, y = -18},{x = 5, y = -17},{x = 4, y = -18},{x = 7, y = -17},{x = 6, y = -17},{x = -10, y = -15},{x = -9, y = -16},{x = -8, y = -16},{x = 9, y = -16},{x = 8, y = -16},{x = 10, y = -15},{x = -13, y = -13},{x = -11, y = -14},{x = -12, y = -14},{x = -12, y = -13},{x = 11, y = -14},{x = 13, y = -13},{x = 12, y = -13},{x = 12, y = -14},{x = -13, y = -12},{x = -14, y = -12},{x = -14, y = -11},{x = 13, y = -12},{x = 14, y = -11},{x = 14, y = -12},{x = -15, y = -10},{x = -16, y = -9},{x = 15, y = -10},{x = 16, y = -9},{x = -17, y = -7},{x = -16, y = -8},{x = 16, y = -8},{x = 17, y = -7},{x = -17, y = -5},{x = -17, y = -6},{x = 17, y = -6},{x = 17, y = -5},{x = -18, y = -3},{x = -18, y = -4},{x = 18, y = -4},{x = 18, y = -3},{x = -18, y = -1},{x = -18, y = -2},{x = 18, y = -2},{x = 18, y = -1},{x = -18, y = 1},{x = -18, y = 0},{x = 18, y = 0},{x = 18, y = 1},{x = -18, y = 3},{x = -18, y = 2},{x = 18, y = 2},{x = 18, y = 3},{x = -17, y = 5},{x = -18, y = 4},{x = 17, y = 5},{x = 18, y = 4},{x = -17, y = 7},{x = -17, y = 6},{x = 17, y = 7},{x = 17, y = 6},{x = -16, y = 9},{x = -16, y = 8},{x = 16, y = 9},{x = 16, y = 8},{x = -15, y = 10},{x = -14, y = 11},{x = 14, y = 11},{x = 15, y = 10},{x = -14, y = 12},{x = -13, y = 12},{x = -13, y = 13},{x = -12, y = 13},{x = 12, y = 13},{x = 13, y = 13},{x = 13, y = 12},{x = 14, y = 12},{x = -12, y = 14},{x = -11, y = 14},{x = -10, y = 15},{x = 10, y = 15},{x = 11, y = 14},{x = 12, y = 14},{x = -9, y = 16},{x = -7, y = 17},{x = -8, y = 16},{x = -5, y = 17},{x = -6, y = 17},{x = 5, y = 17},{x = 7, y = 17},{x = 6, y = 17},{x = 8, y = 16},{x = 9, y = 16},{x = -3, y = 18},{x = -4, y = 18},{x = -1, y = 18},{x = -2, y = 18},{x = 1, y = 18},{x = 0, y = 18},{x = 3, y = 18},{x = 2, y = 18},{x = 4, y = 18}},
	[20] = {{x = -3, y = -19},{x = -4, y = -19},{x = -1, y = -19},{x = -2, y = -19},{x = 1, y = -19},{x = 0, y = -19},{x = 3, y = -19},{x = 2, y = -19},{x = 4, y = -19},{x = -9, y = -17},{x = -7, y = -18},{x = -8, y = -17},{x = -5, y = -18},{x = -6, y = -18},{x = 5, y = -18},{x = 7, y = -18},{x = 6, y = -18},{x = 9, y = -17},{x = 8, y = -17},{x = -11, y = -16},{x = -11, y = -15},{x = -12, y = -15},{x = -10, y = -16},{x = 11, y = -15},{x = 11, y = -16},{x = 10, y = -16},{x = 12, y = -15},{x = -13, y = -14},{x = -14, y = -13},{x = 13, y = -14},{x = 14, y = -13},{x = -15, y = -12},{x = -15, y = -11},{x = -16, y = -11},{x = 15, y = -11},{x = 15, y = -12},{x = 16, y = -11},{x = -17, y = -9},{x = -16, y = -10},{x = 16, y = -10},{x = 17, y = -9},{x = -17, y = -8},{x = -18, y = -7},{x = 17, y = -8},{x = 18, y = -7},{x = -18, y = -6},{x = -18, y = -5},{x = 18, y = -5},{x = 18, y = -6},{x = -19, y = -4},{x = -19, y = -3},{x = 19, y = -3},{x = 19, y = -4},{x = -19, y = -2},{x = -19, y = -1},{x = 19, y = -1},{x = 19, y = -2},{x = -19, y = 0},{x = -19, y = 1},{x = 19, y = 1},{x = 19, y = 0},{x = -19, y = 2},{x = -19, y = 3},{x = 19, y = 3},{x = 19, y = 2},{x = -19, y = 4},{x = -18, y = 5},{x = 18, y = 5},{x = 19, y = 4},{x = -18, y = 7},{x = -18, y = 6},{x = 18, y = 7},{x = 18, y = 6},{x = -17, y = 9},{x = -17, y = 8},{x = 17, y = 9},{x = 17, y = 8},{x = -16, y = 10},{x = -16, y = 11},{x = -15, y = 11},{x = 15, y = 11},{x = 16, y = 11},{x = 16, y = 10},{x = -15, y = 12},{x = -14, y = 13},{x = 14, y = 13},{x = 15, y = 12},{x = -13, y = 14},{x = -12, y = 15},{x = -11, y = 15},{x = 11, y = 15},{x = 12, y = 15},{x = 13, y = 14},{x = -11, y = 16},{x = -10, y = 16},{x = -9, y = 17},{x = -8, y = 17},{x = 9, y = 17},{x = 8, y = 17},{x = 10, y = 16},{x = 11, y = 16},{x = -7, y = 18},{x = -5, y = 18},{x = -6, y = 18},{x = -4, y = 19},{x = -3, y = 19},{x = -2, y = 19},{x = -1, y = 19},{x = 0, y = 19},{x = 1, y = 19},{x = 2, y = 19},{x = 3, y = 19},{x = 4, y = 19},{x = 5, y = 18},{x = 7, y = 18},{x = 6, y = 18}},
	[21] = {{x = -7, y = -19},{x = -5, y = -19},{x = -6, y = -19},{x = -3, y = -20},{x = -4, y = -20},{x = -1, y = -20},{x = -2, y = -20},{x = 1, y = -20},{x = 0, y = -20},{x = 3, y = -20},{x = 2, y = -20},{x = 5, y = -19},{x = 4, y = -20},{x = 7, y = -19},{x = 6, y = -19},{x = -11, y = -17},{x = -10, y = -17},{x = -9, y = -18},{x = -8, y = -18},{x = 9, y = -18},{x = 8, y = -18},{x = 10, y = -17},{x = 11, y = -17},{x = -13, y = -15},{x = -14, y = -15},{x = -12, y = -16},{x = 13, y = -15},{x = 12, y = -16},{x = 14, y = -15},{x = -15, y = -14},{x = -15, y = -13},{x = -14, y = -14},{x = 15, y = -13},{x = 15, y = -14},{x = 14, y = -14},{x = -17, y = -11},{x = -16, y = -12},{x = 16, y = -12},{x = 17, y = -11},{x = -17, y = -10},{x = -18, y = -9},{x = 17, y = -10},{x = 18, y = -9},{x = -19, y = -7},{x = -18, y = -8},{x = 18, y = -8},{x = 19, y = -7},{x = -19, y = -6},{x = -19, y = -5},{x = 19, y = -6},{x = 19, y = -5},{x = -20, y = -4},{x = -20, y = -3},{x = 20, y = -3},{x = 20, y = -4},{x = -20, y = -2},{x = -20, y = -1},{x = 20, y = -1},{x = 20, y = -2},{x = -20, y = 0},{x = -20, y = 1},{x = 20, y = 1},{x = 20, y = 0},{x = -20, y = 2},{x = -20, y = 3},{x = 20, y = 3},{x = 20, y = 2},{x = -20, y = 4},{x = -19, y = 5},{x = 19, y = 5},{x = 20, y = 4},{x = -19, y = 7},{x = -19, y = 6},{x = 19, y = 7},{x = 19, y = 6},{x = -18, y = 9},{x = -18, y = 8},{x = 18, y = 9},{x = 18, y = 8},{x = -17, y = 11},{x = -17, y = 10},{x = 17, y = 11},{x = 17, y = 10},{x = -16, y = 12},{x = -15, y = 13},{x = 15, y = 13},{x = 16, y = 12},{x = -15, y = 14},{x = -14, y = 14},{x = -14, y = 15},{x = -13, y = 15},{x = 13, y = 15},{x = 14, y = 15},{x = 14, y = 14},{x = 15, y = 14},{x = -12, y = 16},{x = -11, y = 17},{x = -10, y = 17},{x = 11, y = 17},{x = 10, y = 17},{x = 12, y = 16},{x = -9, y = 18},{x = -8, y = 18},{x = -7, y = 19},{x = -5, y = 19},{x = -6, y = 19},{x = 5, y = 19},{x = 6, y = 19},{x = 7, y = 19},{x = 9, y = 18},{x = 8, y = 18},{x = -4, y = 20},{x = -3, y = 20},{x = -2, y = 20},{x = -1, y = 20},{x = 0, y = 20},{x = 1, y = 20},{x = 2, y = 20},{x = 3, y = 20},{x = 4, y = 20}},
	[22] = {{x = -3, y = -21},{x = -4, y = -21},{x = -1, y = -21},{x = -2, y = -21},{x = 1, y = -21},{x = 0, y = -21},{x = 3, y = -21},{x = 2, y = -21},{x = 4, y = -21},{x = -10, y = -19},{x = -9, y = -19},{x = -8, y = -19},{x = -7, y = -20},{x = -5, y = -20},{x = -6, y = -20},{x = 5, y = -20},{x = 7, y = -20},{x = 6, y = -20},{x = 9, y = -19},{x = 8, y = -19},{x = 10, y = -19},{x = -13, y = -17},{x = -12, y = -17},{x = -11, y = -18},{x = -10, y = -18},{x = 11, y = -18},{x = 10, y = -18},{x = 13, y = -17},{x = 12, y = -17},{x = -15, y = -15},{x = -13, y = -16},{x = -14, y = -16},{x = 13, y = -16},{x = 15, y = -15},{x = 14, y = -16},{x = -17, y = -13},{x = -16, y = -14},{x = -16, y = -13},{x = 17, y = -13},{x = 16, y = -13},{x = 16, y = -14},{x = -17, y = -12},{x = -18, y = -11},{x = 17, y = -12},{x = 18, y = -11},{x = -19, y = -10},{x = -19, y = -9},{x = -18, y = -10},{x = 18, y = -10},{x = 19, y = -10},{x = 19, y = -9},{x = -19, y = -8},{x = -20, y = -7},{x = 19, y = -8},{x = 20, y = -7},{x = -20, y = -6},{x = -20, y = -5},{x = 20, y = -6},{x = 20, y = -5},{x = -21, y = -4},{x = -21, y = -3},{x = 21, y = -3},{x = 21, y = -4},{x = -21, y = -2},{x = -21, y = -1},{x = 21, y = -1},{x = 21, y = -2},{x = -21, y = 0},{x = -21, y = 1},{x = 21, y = 1},{x = 21, y = 0},{x = -21, y = 2},{x = -21, y = 3},{x = 21, y = 3},{x = 21, y = 2},{x = -21, y = 4},{x = -20, y = 5},{x = 20, y = 5},{x = 21, y = 4},{x = -20, y = 7},{x = -20, y = 6},{x = 20, y = 7},{x = 20, y = 6},{x = -19, y = 9},{x = -19, y = 8},{x = 19, y = 9},{x = 19, y = 8},{x = -19, y = 10},{x = -18, y = 11},{x = -18, y = 10},{x = 18, y = 11},{x = 18, y = 10},{x = 19, y = 10},{x = -17, y = 13},{x = -17, y = 12},{x = -16, y = 13},{x = 16, y = 13},{x = 17, y = 13},{x = 17, y = 12},{x = -16, y = 14},{x = -15, y = 15},{x = 15, y = 15},{x = 16, y = 14},{x = -14, y = 16},{x = -13, y = 16},{x = -13, y = 17},{x = -12, y = 17},{x = 13, y = 16},{x = 13, y = 17},{x = 12, y = 17},{x = 14, y = 16},{x = -11, y = 18},{x = -10, y = 18},{x = -10, y = 19},{x = -9, y = 19},{x = -8, y = 19},{x = 9, y = 19},{x = 8, y = 19},{x = 11, y = 18},{x = 10, y = 18},{x = 10, y = 19},{x = -7, y = 20},{x = -6, y = 20},{x = -5, y = 20},{x = -3, y = 21},{x = -4, y = 21},{x = -1, y = 21},{x = -2, y = 21},{x = 1, y = 21},{x = 0, y = 21},{x = 3, y = 21},{x = 2, y = 21},{x = 4, y = 21},{x = 5, y = 20},{x = 7, y = 20},{x = 6, y = 20}},
	[23] = {{x = -8, y = -21},{x = -7, y = -21},{x = -6, y = -21},{x = -5, y = -21},{x = -3, y = -22},{x = -4, y = -22},{x = -1, y = -22},{x = -2, y = -22},{x = 1, y = -22},{x = 0, y = -22},{x = 3, y = -22},{x = 2, y = -22},{x = 5, y = -21},{x = 4, y = -22},{x = 7, y = -21},{x = 6, y = -21},{x = 8, y = -21},{x = -12, y = -19},{x = -11, y = -19},{x = -10, y = -20},{x = -9, y = -20},{x = -8, y = -20},{x = 9, y = -20},{x = 8, y = -20},{x = 11, y = -19},{x = 10, y = -20},{x = 12, y = -19},{x = -14, y = -17},{x = -13, y = -18},{x = -12, y = -18},{x = 13, y = -18},{x = 12, y = -18},{x = 14, y = -17},{x = -15, y = -16},{x = -16, y = -15},{x = 15, y = -16},{x = 16, y = -15},{x = -17, y = -14},{x = -18, y = -13},{x = 17, y = -14},{x = 18, y = -13},{x = -19, y = -12},{x = -19, y = -11},{x = -18, y = -12},{x = 18, y = -12},{x = 19, y = -12},{x = 19, y = -11},{x = -20, y = -10},{x = -20, y = -9},{x = 20, y = -10},{x = 20, y = -9},{x = -21, y = -8},{x = -21, y = -7},{x = -20, y = -8},{x = 20, y = -8},{x = 21, y = -8},{x = 21, y = -7},{x = -21, y = -6},{x = -21, y = -5},{x = 21, y = -6},{x = 21, y = -5},{x = -22, y = -4},{x = -22, y = -3},{x = 22, y = -3},{x = 22, y = -4},{x = -22, y = -2},{x = -22, y = -1},{x = 22, y = -1},{x = 22, y = -2},{x = -22, y = 0},{x = -22, y = 1},{x = 22, y = 1},{x = 22, y = 0},{x = -22, y = 2},{x = -22, y = 3},{x = 22, y = 3},{x = 22, y = 2},{x = -22, y = 4},{x = -21, y = 5},{x = 21, y = 5},{x = 22, y = 4},{x = -21, y = 7},{x = -21, y = 6},{x = 21, y = 7},{x = 21, y = 6},{x = -21, y = 8},{x = -20, y = 9},{x = -20, y = 8},{x = 20, y = 8},{x = 20, y = 9},{x = 21, y = 8},{x = -19, y = 11},{x = -20, y = 10},{x = 19, y = 11},{x = 20, y = 10},{x = -19, y = 12},{x = -18, y = 13},{x = -18, y = 12},{x = 18, y = 13},{x = 18, y = 12},{x = 19, y = 12},{x = -17, y = 14},{x = -16, y = 15},{x = 16, y = 15},{x = 17, y = 14},{x = -15, y = 16},{x = -14, y = 17},{x = 14, y = 17},{x = 15, y = 16},{x = -13, y = 18},{x = -12, y = 18},{x = -12, y = 19},{x = -11, y = 19},{x = 11, y = 19},{x = 13, y = 18},{x = 12, y = 18},{x = 12, y = 19},{x = -10, y = 20},{x = -9, y = 20},{x = -8, y = 20},{x = -8, y = 21},{x = -7, y = 21},{x = -6, y = 21},{x = -5, y = 21},{x = 5, y = 21},{x = 7, y = 21},{x = 6, y = 21},{x = 8, y = 20},{x = 9, y = 20},{x = 8, y = 21},{x = 10, y = 20},{x = -4, y = 22},{x = -3, y = 22},{x = -2, y = 22},{x = -1, y = 22},{x = 0, y = 22},{x = 1, y = 22},{x = 2, y = 22},{x = 3, y = 22},{x = 4, y = 22}}
	}

local function on_entity_damaged(event)	
	if event.entity.type == "container" then
		if math_random(1,1) == 1 then kaboom(event.entity) end
	end
end

local function on_tick(event)
	if global.kaboom_schedule then		
		if #global.kaboom_schedule == 0 then global.kaboom_schedule = nil return end
		local tick = game.tick
		for explosion_index = 1, #global.kaboom_schedule, 1 do	
			if global.kaboom_schedule[explosion_index] then
				local surface = global.kaboom_schedule[explosion_index].surface			
				for radius = 1, #global.kaboom_schedule[explosion_index], 1 do
					if global.kaboom_schedule[explosion_index][radius] then
						if global.kaboom_schedule[explosion_index][radius].trigger_tick < tick then				
							for tile_index = 1, #global.kaboom_schedule[explosion_index][radius], 1 do							
								surface.create_entity({name = global.kaboom_schedule[explosion_index][radius][tile_index].animation.name, position = global.kaboom_schedule[explosion_index][radius][tile_index].animation.position})
							end
							global.kaboom_schedule[explosion_index][radius] = nil
						end
					end					
				end
				if #global.kaboom_schedule[explosion_index] == 0 then global.kaboom_schedule[explosion_index] = nil end
			end			
		end		
	end
end

function kaboom(entity)		
	local i = entity.get_inventory(defines.inventory.chest)
	local explosives_amount = i.get_item_count("explosives")
	if explosives_amount < 1 then return end	
	local current_radius = 0
	local center_position = entity.position
	local surface = entity.surface
	
	if not global.kaboom_schedule then global.kaboom_schedule = {} end
	global.kaboom_schedule[#global.kaboom_schedule + 1] = {}
	global.kaboom_schedule[#global.kaboom_schedule].surface = surface
	
	local tiles_count = 0
	
	while explosives_amount > 0 do		
		current_radius = current_radius + 1
		global.kaboom_schedule[#global.kaboom_schedule][current_radius] = {}
		global.kaboom_schedule[#global.kaboom_schedule][current_radius].trigger_tick = game.tick + (current_radius * 5)
		local i = 1
		for x = current_radius * -1, current_radius, 1 do
			for y = current_radius * -1, current_radius, 1 do
				local pos = {x = center_position.x + x, y = center_position.y + y}				
				local distance_to_center = math_sqrt(x^2 + y^2)
				
				--check if position is already in the table
				local entry_already_exists = false
				--[[
				if current_radius > 1 then
					for index = 1, #global.kaboom_schedule[#global.kaboom_schedule][current_radius - 1], 1 do
						local position = global.kaboom_schedule[#global.kaboom_schedule][current_radius - 1][index].animation.position	
						if position.x == pos.x and position.y == pos.y then
							entry_already_exists = true
							game.print("OK")
						end												
					end
				end			
				]]--
				
				if entry_already_exists == false then
					if distance_to_center >= current_radius - 1 and distance_to_center < current_radius then					
						global.kaboom_schedule[#global.kaboom_schedule][current_radius][i] = {}					
						global.kaboom_schedule[#global.kaboom_schedule][current_radius][i].animation = {position = {x = pos.x, y = pos.y}, name = "big-artillery-explosion"}
						tiles_count = tiles_count + 1
						
						local target_entity = surface.find_entities_filtered({position = pos, limit = 1})    ---- some might not have health
						if target_entity[1] and target_entity[1].health then							
							local damage_dealt = 0
							local explosives_needed = math.floor(target_entity[1].health / damage_per_explosive, 0)
							for z = 1, explosives_needed, 1 do
								explosives_amount = explosives_amount - 1
								damage_dealt = damage_dealt + damage_per_explosive
								if explosives_amount < 1 then break end
							end
							global.kaboom_schedule[#global.kaboom_schedule][current_radius][i].entity_to_damage = {target_entity[1], damage_dealt}							
						else
							local tile = surface.get_tile(pos)	
							if tile.name == "out-of-map" then
								local explosives_needed = math.floor(out_of_map_tile_health / damage_per_explosive, 0)
								if explosives_amount >= explosives_needed then
									explosives_amount = explosives_amount - explosives_needed
								end
								if explosives_amount >= 0 then global.kaboom_schedule[#global.kaboom_schedule][current_radius][i].tile_to_convert = {tile, replacement_tile} end						
							else
								local explosives_needed = math.floor(empty_tile_damage_absorption / damage_per_explosive, 0)						
								explosives_amount = explosives_amount - explosives_needed							
							end						
							if explosives_amount < 1 then return end
						end
						i = i + 1
						
						game.print(tiles_count)
					end
				end
			end
		end
	end	
end

event.add(defines.events.on_entity_damaged, on_entity_damaged)
event.add(defines.events.on_tick, on_tick)
