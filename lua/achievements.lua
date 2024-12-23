local mod = RepMMod

local ig = ImGui
local pdg = Isaac.GetPersistentGameData()

if not ig.ElementExists("RepMMod") then
	ig.CreateMenu("RepMMod", "Repentance-")
end

if not ig.ElementExists("RepMModUnlocks") then
	ig.AddElement("RepMMod", "RepMModUnlocks", ImGuiElement.MenuItem, RepMMod.GetDSSStr("unlock_manager"))
end

if ig.ElementExists("RepMModUnlocksWindow") then
	ig.RemoveWindow("RepMModUnlocksWindow")
end

ig.CreateWindow("RepMModUnlocksWindow", "Repentance- "..RepMMod.GetDSSStr("unlock_manager"))

ig.LinkWindowToElement("RepMModUnlocksWindow", "RepMModUnlocks")

ig.AddButton(
	"RepMModUnlocksWindow",
	"RepMModUnlocksButtonUnlockAll",
	RepMMod.GetDSSStr("unlock"),
	function(clickCount)
		for _, ach in pairs(RepMMod.RepmAchivements) do
            pdg:TryUnlock(ach.ID, true)
        end
	end
)

ig.AddButton(
	"RepMModUnlocksWindow",
	"RepMModUnlocksButtonLockAll",
	RepMMod.GetDSSStr("lock"),
	function(clickCount)
		for _, ach in pairs(RepMMod.RepmAchivements) do
            Isaac.ExecuteCommand("lockachievement "..ach.ID)
        end
	end
)

for name, ach in pairs(RepMMod.RepmAchivements) do
    ig.AddCheckbox(
		"RepMModUnlocksWindow",
		"RepMModUnlocks" .. ach.Name,
		ach.Name,
		function(newVal)
			if newVal then
                pdg:TryUnlock(ach.ID, false)
            else
                Isaac.ExecuteCommand("lockachievement "..ach.ID)
            end
		end,
		false
	)
	ig.AddCallback("RepMModUnlocks" .. ach.Name, ImGuiCallback.Render, function()
		ig.UpdateData(
			"RepMModUnlocks" .. ach.Name,
			ImGuiData.Value,
			Isaac.GetPersistentGameData():Unlocked(ach.ID)
		)
	end)
end
