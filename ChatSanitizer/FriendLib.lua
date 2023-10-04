if not FriendLib then

	FriendLib = {}

	FriendLib.debug = false
	FriendLib.friends = {}
	FriendLib.scm = SendChatMessage

	SendChatMessage = function(text, type, lang, chan)
		if type == "WHISPER" and chan then
			FriendLib:AddFriend(chan)
		end
		FriendLib.scm(text, type, lang, chan)
	end

	function FriendLib.DebugPrint(m)
		if FriendLib.debug then
			DEFAULT_CHAT_FRAME:AddMessage("FriendLib: " .. m)
		end
	end

	function FriendLib:AddFriend(name)
		FriendLib.friends[strupper(name)] = 1
		FriendLib.DebugPrint("Add: " .. strupper(name))
	end

	function FriendLib:CheckFriendList()
		for i = 1, GetNumFriends() do
			local name = GetFriendInfo(i)
			if name then
				FriendLib:AddFriend(name)
			end
		end
	end

	function FriendLib:CheckGuild()
		for i = 1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i)
			if name then
				FriendLib:AddFriend(name)
			end
		end
	end

	function FriendLib:CheckParty()
		for i = 1, 5 do
			local name = GetUnitName("party" .. i)
			if name then
				FriendLib:AddFriend(name)
			end
		end
	end

	function FriendLib:CheckRaid()
		for i = 1, 40 do
			local name = GetUnitName("raid" .. i)
			if name then
				FriendLib:AddFriend(name)
			end
		end
	end

	function FriendLib:IsFriend(name)
		return FriendLib.friends[strupper(name)]
	end

	FriendLib.frame = CreateFrame("frame")
	FriendLib.frame:RegisterEvent("FRIENDLIST_UPDATE")
	FriendLib.frame:RegisterEvent("GUILD_ROSTER_UPDATE")
	FriendLib.frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
	FriendLib.frame:SetScript("OnEvent", function()
		if event == "FRIENDLIST_UPDATE" then
			FriendLib:CheckFriendList()
		elseif event == "GUILD_ROSTER_UPDATE" then
			FriendLib:CheckGuild()
		else
			FriendLib:CheckParty()
			FriendLib:CheckRaid()
		end
	end)
end
