-- metatables maxxing for the first time, ts is NOT done and so gay

local ModuleScript = script
local CacheManager = {}

CacheManager.Connections = {}
CacheManager.Coroutines = {}

setmetatable(CacheManager.Connections, {
	__newindex = function(Table, Key: any, Value: RBXScriptConnection | nil)
		if Value == nil then
			if rawget(CacheManager.Connections, Key) then
				CacheManager.Connections[Key]:Disconnect()
				rawset(CacheManager.Connections, Key, nil)
			end
			return
		end
		
		if typeof(Value) == "RBXScriptConnection" then
			if rawget(CacheManager.Connections, Key) then
				CacheManager.Connections[Key]:Disconnect()
			end

			rawset(CacheManager.Connections, Key, Value)
		end
	end,
	
	__index = CacheManager.Connections
})

setmetatable(CacheManager.Coroutines, {
	__newindex = function(Table, Key: any, Value: () -> () | nil)
		if Value == nil then
			if rawget(CacheManager.Coroutines, Key) then
				coroutine.close(CacheManager.Coroutines[Key])
				rawset(CacheManager.Coroutines, Key, nil)
			end
			return
		end
		
		if type(Value) == "function" then
			if rawget(CacheManager.Coroutines, Key) then
				if coroutine.status(CacheManager.Coroutines[Key]) ~= "dead" then
					coroutine.close(CacheManager.Coroutines[Key])
				end
			end
		end
		
		rawset(CacheManager.Coroutines, Key, coroutine.create(Value))
		return
	end,
	
	__index = CacheManager.Coroutines
})

return CacheManager
