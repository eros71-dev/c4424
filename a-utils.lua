--- Recieves a value of any type and converts it into a boolean
function tobool(value)
    local type = type(value)
    if type == "boolean" then
        return value
    elseif type == "number" then
        return value == 1
    elseif type == "string" then
        return value == "true"
    elseif type == "table" or type == "function" or type == "thread" or type == "userdata" then
        return true
    end
    return false
end

--- @param cond boolean
--- Human readable ternary operator
function if_then_else(cond, ifTrue, ifFalse)
    if cond then return ifTrue end
    return ifFalse
end

--- @param m MarioState
--- Checks if the player is active
function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return true
    end
    if not np.connected then
        return false
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return false
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return false
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return false
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return true
end

--- @param param number
--- @param caseTable table
--- Switch statement function
function switch(param, caseTable)
    local case = caseTable[param]
    if case then return case() end
    local def = caseTable['default']
    return def and def() or nil
end

--- @param key string
--- `mod_storage_load_bool` except it returns true by default
function mod_storage_load_bool_2(key)
    local value = mod_storage_load(key)
    if value == nil then return true end
    return tobool(value)
end

-- In loving memory of the stretched widescreen and high pitch options, so long, kings.