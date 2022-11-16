local AddonName, AddonVars = ...

local dump = DevTools_Dump

local function sample(myTable)
    local keyset = {}
    for k in pairs(myTable) do
        table.insert(keyset, k)
    end
    local key = keyset[math.random(#keyset)]
    return key, myTable[key]
end

local function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

-- naive linear search, for big tables, just index both ways
local function table_index_of(t, element)
    for i, value in pairs(table) do
        if value == element then
          return i
        end
    end
end

local function table_contains(t, element)
    local i = table_index_of(t, element)
    if i then
        return true
    else
        return false
    end
end

local function table_remove_value(t, element)
    local i = table_index_of(t, element)
    return table.remove(t, i)
end


local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	if func then
		return xpcall(func, errorhandler, ...)
	end
end


AddonVars.util = {
    table_remove_value = table_remove_value,
    safecall = safecall,
    dump = dump,
    sample = sample,
    copy = copy
}

