function player.GetBySteamID(id)
	return player.GetBySteamIDor64(id)
end

function player.GetBySteamID64(id)
	return player.GetBySteamIDor64(id, true)
end

function player.GetBySteamIDor64(id, find64)
	for _, ply in ipairs(player.GetAll()) do
		if ply:SteamID() == id or (find64 and ply:SteamID64() == id) then
			return ply
		end
	end

	return nil
end
