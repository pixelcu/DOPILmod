return function(mod)
	local DSSModName = "Dead Sea Scrolls (Repentance-)"

	local DSSCoreVersion = 6

	local MenuProvider = {}

	function MenuProvider.SaveSaveData()
		mod.StoreSaveData()
	end

	function MenuProvider.GetPaletteSetting()
		return mod.GetMenuSaveData().MenuPalette
	end

	function MenuProvider.SavePaletteSetting(var)
		mod.GetMenuSaveData().MenuPalette = var
	end

	function MenuProvider.GetGamepadToggleSetting()
		return mod.GetMenuSaveData().GamepadToggle
	end

	function MenuProvider.SaveGamepadToggleSetting(var)
		mod.GetMenuSaveData().GamepadToggle = var
	end

	function MenuProvider.GetMenuKeybindSetting()
		return mod.GetMenuSaveData().MenuKeybind
	end

	function MenuProvider.SaveMenuKeybindSetting(var)
		mod.GetMenuSaveData().MenuKeybind = var
	end

	function MenuProvider.GetMenuHintSetting()
		return mod.GetMenuSaveData().MenuHint
	end

	function MenuProvider.SaveMenuHintSetting(var)
		mod.GetMenuSaveData().MenuHint = var
	end

	function MenuProvider.GetMenuBuzzerSetting()
		return mod.GetMenuSaveData().MenuBuzzer
	end

	function MenuProvider.SaveMenuBuzzerSetting(var)
		mod.GetMenuSaveData().MenuBuzzer = var
	end

	function MenuProvider.GetMenusNotified()
		return mod.GetMenuSaveData().MenusNotified
	end

	function MenuProvider.SaveMenusNotified(var)
		mod.GetMenuSaveData().MenusNotified = var
	end

	function MenuProvider.GetMenusPoppedUp()
		return mod.GetMenuSaveData().MenusPoppedUp
	end

	function MenuProvider.SaveMenusPoppedUp(var)
		mod.GetMenuSaveData().MenusPoppedUp = var
	end

	local DSSInitializerFunction = include("lua.lib.dssmenucore")
	local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

	local pdg = Isaac.GetPersistentGameData()

	local function InitMusicSettings()
		local music, _ = RepMMod.GetModdedMusicTable()
		local MM = {}

		for musicId, name in pairs(music) do
			if not RepMMod.saveTable.MusicData.Music[name] then
				RepMMod.saveTable.MusicData.Music[name] = 1
			end
			MM[#MM + 1] = {
				strset = RepMMod.SplitString(name:sub(21):lower(), 18),
				choices = { RepMMod.GetDSSStr("enabled"), RepMMod.GetDSSStr("disabled") },
				variable = name,
				setting = 1,
				load = function()
					return RepMMod.saveTable.MusicData.Music[name] or 1
				end,
				store = function(var)
					RepMMod.saveTable.MusicData.Music[name] = var
					mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), var == 1)
				end,
				tooltip = {
					strset = RepMMod.SplitString(
						'enable/disable "' .. name:sub(21):lower() .. '" music from this mod',
						15
					),
				},
			}
			MM[#MM + 1] = { str = "", nosel = true, fsize = 2 }
		end
		return MM
	end

	local function InitJingleSettings()
		local music, jingle = mod.GetModdedMusicTable()
		local MM = {}

		for jingleId, name in pairs(jingle) do
			if not RepMMod.saveTable.MusicData.Jingle[name] then
				RepMMod.saveTable.MusicData.Jingle[name] = 1
			end
			MM[#MM + 1] = {
				strset = RepMMod.SplitString(name:sub(21):lower(), 18),
				choices = { RepMMod.GetDSSStr("enabled"), RepMMod.GetDSSStr("disabled") },
				variable = name,
				setting = 1,
				load = function()
					return RepMMod.saveTable.MusicData.Jingle[name] or 1
				end,
				store = function(var)
					RepMMod.saveTable.MusicData.Jingle[name] = var
				end,
				tooltip = {
					strset = RepMMod.SplitString(
						'enable/disable "' .. name:sub(21):lower() .. '" jingle from this mod',
						15
					),
				},
			}
			MM[#MM + 1] = { str = "", nosel = true, fsize = 2 }
		end
		return MM
	end

	local function InitUnlockButtons()
		local buttons = {}
		for _,ach in pairs(RepMMod.RepmAchivements) do
			buttons[#buttons + 1] = {
				strset = RepMMod.SplitString(ach.Name:lower(), 18),
				choices = { RepMMod.GetDSSStr("locked"), RepMMod.GetDSSStr("unlocked") },
				variable = "RepMAchievement"..ach.Name,
				setting = 1,
				load = function()
					local val = pdg:Unlocked(ach.ID) and 2 or 1
					return val
				end,
				store = function(var)
					if var == 2 then
						pdg:Unlocked(ach.ID)
					else
						Isaac.ExecuteCommand("lockachievement "..ach.ID)
					end
				end,
				tooltip = {
					strset = RepMMod.SplitString(
						'unlock/lock ' .. ach.Name:lower(),
						15
					),
				},
			}
			buttons[#buttons + 1] = { str = "", nosel = true, fsize = 2 }
		end
		return buttons
	end

	RepMMod.DSSdirectory = {
		main = {
			title = RepMMod.GetDSSStr("Title"),
			format = {
				Panels = {
					{
						Panel = dssmod.panels.main,
						Offset = Vector(-42, 10),
						Color = 1,
					},
					{
						Panel = dssmod.panels.tooltip,
						Offset = Vector(130, -2),
						Color = 1,
					},
				},
			},

			buttons = {
				{ str = RepMMod.GetDSSStr("resume_game"), action = "resume" },
				{ str = "", nosel = true, fsize = 3 },
				{ str = RepMMod.GetDSSStr("music_manager"), dest = "music_manager" },
				{ str = "", nosel = true, fsize = 3 },
				{ str = RepMMod.GetDSSStr("unlocks"), dest = "unlocks" },
				{ str = "", nosel = true, fsize = 3 },
				{
					str = RepMMod.GetDSSStr("happy_start"),
					choices = { RepMMod.GetDSSStr("tu_var1"), RepMMod.GetDSSStr("tu_var2") },
					variable = "StartThumbsUp",
					setting = 1,
					load = function()
						return RepMMod.saveTable.MenuData.StartThumbsUp or 1
					end,
					store = function(var)
						RepMMod.saveTable.MenuData.StartThumbsUp = var
						RepMMod.saveTable.SpelunkersPackEffectType = var
					end,
				},
				{ str = "", nosel = true, fsize = 3 },
			},
			tooltip = RepMMod.GetDSSStr("startTooltip"),
		},
		unlocks = {
			title = RepMMod.GetDSSStr("unlock_manager"),
			buttons = {
				{ str = RepMMod.GetDSSStr("unlocks"), dest = "unlocks_sub",
					tooltip = { strset = { RepMMod.GetDSSStr("unlocks") } },
				},
				{ str = "", nosel = true, fsize = 3 },
				{
					strset = RepMMod.SplitString(RepMMod.GetDSSStr("unlock"), 21),
					func = function(button, page, item)
						for _, ach in pairs(RepMMod.RepmAchivements) do
							Isaac.GetPersistentGameData():TryUnlock(ach.ID, true)
						end
						dssmod.closeMenu(item, false)
					end,
				},
				{ str = "", nosel = true, fsize = 3 },
				{
					strset = RepMMod.SplitString(RepMMod.GetDSSStr("lock"), 21),
					func = function(button, page, item)
						for _, ach in pairs(RepMMod.RepmAchivements) do
							Isaac.ExecuteCommand("lockachievement "..ach.ID)
						end
						dssmod.closeMenu(item, false)
					end,
				},
			},
		},
		unlocks_sub = {
			title = RepMMod.GetDSSStr("unlocks"),
			buttons = InitUnlockButtons(),
		},
		music_manager = {
			title = RepMMod.GetDSSStr("music_manager"),
			buttons = {
				{ str = RepMMod.GetDSSStr("music_settings"), dest = "music_settings" },
				{ str = "", nosel = true, fsize = 2 },
				{ str = RepMMod.GetDSSStr("jingle_settings"), dest = "jingle_settings" },
				{ str = "", nosel = true, fsize = 2 },
				{
					strset = RepMMod.SplitString(RepMMod.GetDSSStr("enable_all_music"), 21),
					func = function(button, page, item)
						local music, jingle = mod.GetModdedMusicTable()
						for musicId, name in pairs(music) do
							RepMMod.saveTable.MusicData.Music[name] = 1
							mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), true)
						end
						for jingleId, name in pairs(jingle) do
							RepMMod.saveTable.MusicData.Jingle[name] = 1
						end
						dssmod.closeMenu(item, false)
					end,
				},
				{ str = "", nosel = true, fsize = 2 },
				{
					strset = RepMMod.SplitString(RepMMod.GetDSSStr("disable_all_music"), 21),
					func = function(button, page, item)
						local music, jingle = mod.GetModdedMusicTable()
						for musicId, name in pairs(music) do
							RepMMod.saveTable.MusicData.Music[name] = 2
							mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), false)
						end
						for jingleId, name in pairs(jingle) do
							RepMMod.saveTable.MusicData.Jingle[name] = 2
						end
						dssmod.closeMenu(item, false)
					end,
				},
			},
			tooltip = { strset = { "manage music", "and jingles" } },
		},
		music_settings = {
			title = RepMMod.GetDSSStr("music_settings"),
			buttons = InitMusicSettings(),
		},
		jingle_settings = {
			title = RepMMod.GetDSSStr("jingle_settings"),
			buttons = InitJingleSettings(),
		},
		warpzone = {
			title = RepMMod.GetDSSStr("settings"),
			buttons = {
				dssmod.gamepadToggleButton,
				dssmod.menuKeybindButton,
			},
		},
	}

	local RepMdirectorykey = {
		Item = RepMMod.DSSdirectory.main,
		Main = "main",
		Idle = false,
		MaskAlpha = 1,
		Settings = {},
		SettingsChanged = false,
		Path = {},
	}

	DeadSeaScrollsMenu.AddMenu("rep-", {
		Run = dssmod.runMenu,
		Open = dssmod.openMenu,
		Close = dssmod.closeMenu,
		Directory = RepMMod.DSSdirectory,
		DirectoryKey = RepMdirectorykey,
		UseSubMenu = true,
	})
end
