local Public = {}

-- one table to rule them all!
local Global = require 'utils.global'
local Event = require 'utils.event'

local this = {}

Global.register(
    this,
    function(tbl)
        this = tbl
    end
)

function Public.reset_table()
    this.requests = {}
    this.town_kill_message = {}
    this.town_centers = {}
    this.cooldowns_town_placement = {}
    this.last_respawn = {}
    this.last_death = {}
    this.strikes = {}
    this.score_gui_frame = {}
    this.testing_mode = false
    this.spawn_point = {}
    this.winner = nil
    this.buffs = {}
    this.swarms = {}
    this.fluid_explosion_schedule = {}
    this.mining = {}
    this.mining_target = {}
    this.spaceships = {}
    this.pvp_shields = {}
    this.previous_leagues = {}
    this.tutorials = {}
    this.suicides = {}
    this.town_evo_warned = {}
    this.treasure_hint = {}
    this.labs_destroy_events = {}
    this.uranium_patch_location = nil
    this.entity_labels = {}
    this.last_damage_multiplier_shown = {}
    this.next_high_score_announcement = 0
    this.laser_turrets_destroy_events = {}
end

function Public.get_table()
    return this
end

function Public.get(key)
    if key then
        return this[key]
    else
        return this
    end
end

function Public.set(key, value)
    if key and (value or value == false) then
        this[key] = value
        return this[key]
    elseif key then
        return this[key]
    else
        return this
    end
end

Event.on_init(
    function()
        Public.reset_table()
    end
)

return Public
