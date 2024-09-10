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
	local ig = ImGui

	local strings = {
		Title = {
			en = "rep-",
			es = "rep-",
		},
		resume_game = {
			en = "resume game",
			ru = "вернуться в игру",
		},
		settings = {
			en = "settings",
			ru = "настройки",
		},
		yes = {
			en = "yes",
			ru = "да",
		},
		no = {
			en = "no",
			ru = "нет",
		},
		enable = {
			en = "enable",
			ru = "включить",
		},
		disable = {
			en = "disable",
			ru = "выключить",
		},
		enabled = {
			en = "enabled",
			ru = "включен",
		},
		disabled = {
			en = "disabled",
			ru = "выключен",
		},
		startTooltip = {
			en = dssmod.menuOpenToolTip,
			ru = {
				strset = {
					"переключение",
					"меню",
					"",
					"клавиатура:",
					"[c] или [f1]",
					"",
					"контроллер:",
					"нажатие",
					"на стик",
				},
				fsize = 2,
			},
		},
		thumbs_up = {
			en = "thumbs up",
			--ru = "режим рюкзака",
		},
		tu_var1 = {
			en = "on",
			--ru = "взрывать особые",
		},
		tu_var2 = {
			en = "off",
			--ru = "бомбы в руки",
		},
		music_manager = {
			en = "music manager",
			ru = "менеджер музыки",
		},
		music_settings = {
			en = "music settings",
			ru = "настройки музыки",
		},
		jingle_settings = {
			en = "jingle settings",
			ru = "настройки джинглов",
		},
		enable_all_music = {
			en = "enable all music and jingles",
			ru = "включить всю музыку и джинглы",
		},
        disable_all_music = {
			en = "disable all music and jingles",
			ru = "выключить всю музыку и джинглы",
		},
		other_settings = {
			en = "other settings",
			ru = "другие настройки"
		},
		happy_start = {
			en = "happy start",
			ru = "счастливый старт"
		},
		music_button_enable = {
			en = "enables all mod's music and jingles",
			ru = "включает всю музыку и джинглы из мода",
		},
		music_button_disable = {
			en = "disables all mod's music and jingles",
			ru = "выключает всю музыку и джинглы из мода",
		}
	}

	local function GetStr(str)
		return strings[str] and (strings[str][Options.Language] or strings[str].en) or str
	end

	local function SplitString(str, size)
		local endTable = {}
		size = size or 15
		local currentString = ""
		for w in str:gmatch("%S+") do
			local newString = currentString .. w .. " "
			if newString:len() >= size then
				table.insert(endTable, currentString)
				currentString = ""
			end

			currentString = currentString .. w .. " "
		end

		table.insert(endTable, currentString)
		return endTable
	end

	local function InitMusicSettings()
		local music, _ = RepMMod.GetModdedMusicTable()
		local MM = {}

		for musicId, name in pairs(music) do
			if not RepMMod.saveTable.MusicData.Music[name] then
				RepMMod.saveTable.MusicData.Music[name] = 1
			end
			MM[#MM + 1] = {
				strset = SplitString(name:sub(21):lower(), 18),
				choices = { GetStr("enabled"), GetStr("disabled") },
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
					strset = SplitString('enable/disable "' .. name:sub(21):lower() .. '" music from this mod', 15),
				},
			}
			MM[#MM + 1] = { str = "", nosel = true, fsize = 2 }

			ig.AddCheckbox(
				"RepMModSettingsTabBarMusicTab",
				"RepMModSettingsTabBarMusicTab" .. name:sub(21),
				name:sub(21),
				function(newVal)
					RepMMod.saveTable.MusicData.Music[name] = newVal and 1 or 2
					mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), newVal)
					mod.StoreSaveData()
				end,
				false
			)

			ig.AddCallback("RepMModSettingsTabBarMusicTab" .. name:sub(21), ImGuiCallback.Render, function()
				ig.UpdateData(
					"RepMModSettingsTabBarMusicTab" .. name:sub(21),
					ImGuiData.Value,
					RepMMod.saveTable.MusicData.Music[name] == 1
				)
			end)
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
				strset = SplitString(name:sub(21):lower(), 18),
				choices = { GetStr("enabled"), GetStr("disabled") },
				variable = name,
				setting = 1,
				load = function()
					return RepMMod.saveTable.MusicData.Jingle[name] or 1
				end,
				store = function(var)
					RepMMod.saveTable.MusicData.Jingle[name] = var
				end,
				tooltip = {
					strset = SplitString('enable/disable "' .. name:sub(21):lower() .. '" jingle from this mod', 15),
				},
			}
			MM[#MM + 1] = { str = "", nosel = true, fsize = 2 }

			ig.AddCheckbox(
				"RepMModSettingsTabBarJingleTab",
				"RepMModSettingsTabBarJingleTab" .. name:sub(21),
				name:sub(21),
				function(newVal)
					RepMMod.saveTable.MusicData.Jingle[name] = newVal and 1 or 2
					mod.StoreSaveData()
				end,
				true
			)

			ig.AddCallback("RepMModSettingsTabBarJingleTab" .. name:sub(21), ImGuiCallback.Render, function()
				ig.UpdateData(
					"RepMModSettingsTabBarJingleTab" .. name:sub(21),
					ImGuiData.Value,
					RepMMod.saveTable.MusicData.Jingle[name] == 1
				)
			end)
		end
		return MM
	end

	if not ig.ElementExists("RepMMod") then
		ig.CreateMenu("RepMMod", "Repentance-")
	end

	if not ig.ElementExists("RepMModSettings") then
		ig.AddElement("RepMMod", "RepMModSettings", ImGuiElement.MenuItem, GetStr("settings"))
	end

	if not ig.ElementExists("RepMModSettingsWindow") then
		ig.CreateWindow("RepMModSettingsWindow", "Repentance- Settings")
	end

	ig.LinkWindowToElement("RepMModSettingsWindow", "RepMModSettings")

	if ig.ElementExists("RepMModSettingsTabBar") then
		ig.RemoveElement("RepMModSettingsTabBar")
	end

	ig.AddElement("RepMModSettingsWindow", "RepMModSettingsTabBar", ImGuiElement.TabBar)
	ig.AddElement("RepMModSettingsTabBar", "RepMModSettingsTabMusic", ImGuiElement.Tab, GetStr("music_manager"))
	ig.AddButton("RepMModSettingsTabMusic", "RepMModSettingsTabMusicButtonEnable", GetStr("enable"), function (clickCount)
		local music, jingle = mod.GetModdedMusicTable()
		for musicId, name in pairs(music) do
			RepMMod.saveTable.MusicData.Music[name] = 1
			mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), true)
		end
		for jingleId, name in pairs(jingle) do
			RepMMod.saveTable.MusicData.Jingle[name] = 1
		end
		mod.StoreSaveData()
	end)
	ig.SetTooltip("RepMModSettingsTabMusicButtonEnable", GetStr("music_button_enable"))
	ig.AddButton("RepMModSettingsTabMusic", "RepMModSettingsTabMusicButtonDisable", GetStr("disable"), function (clickCount)
		local music, jingle = mod.GetModdedMusicTable()
		for musicId, name in pairs(music) do
			RepMMod.saveTable.MusicData.Music[name] = 2
			mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), false)
		end
		for jingleId, name in pairs(jingle) do
			RepMMod.saveTable.MusicData.Jingle[name] = 2
		end
		mod.StoreSaveData()
	end)
	ig.SetTooltip("RepMModSettingsTabMusicButtonDisable", GetStr("music_button_disable"))
	ig.AddElement("RepMModSettingsTabMusic", "RepMModSettingsTabBarMusicManager", ImGuiElement.TabBar)

	ig.AddElement(
		"RepMModSettingsTabBarMusicManager",
		"RepMModSettingsTabBarMusicTab",
		ImGuiElement.Tab,
		GetStr("music_settings")
	)
	ig.AddElement(
		"RepMModSettingsTabBarMusicManager",
		"RepMModSettingsTabBarJingleTab",
		ImGuiElement.Tab,
		GetStr("jingle_settings")
	)

	ig.AddElement("RepMModSettingsTabBar", "RepMModSettingsTabMisc", ImGuiElement.Tab, GetStr("other_settings"))

	ig.AddCheckbox("RepMModSettingsTabMisc", "RepMModSettingsTabMiscHappyStart", GetStr("happy_start"), function(newVal)
		RepMMod.saveTable.MenuData.StartThumbsUp = newVal and 1 or 2
		mod.StoreSaveData()
	end, true)

	ig.AddCallback("RepMModSettingsTabMiscHappyStart", ImGuiCallback.Render, function()
		ig.UpdateData(
			"RepMModSettingsTabMiscHappyStart",
			ImGuiData.Value,
			RepMMod.saveTable.MenuData.StartThumbsUp == 1
		)
	end)

	RepMMod.DSSdirectory = {
		main = {
			title = GetStr("Title"),
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
				{ str = GetStr("resume_game"), action = "resume" },
				{ str = "", nosel = true, fsize = 3 },
				{ str = GetStr("music_manager"), dest = "music_manager" },
				{ str = "", nosel = true, fsize = 3 },
				{
					str = GetStr("happy_start"),
					choices = { GetStr("tu_var1"), GetStr("tu_var2") },
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
			tooltip = GetStr("startTooltip"),
		},
		music_manager = {
			title = GetStr("music_manager"),
			buttons = {
				{ str = GetStr("music_settings"), dest = "music_settings" },
				{ str = "", nosel = true, fsize = 2 },
				{ str = GetStr("jingle_settings"), dest = "jingle_settings" },
				{ str = "", nosel = true, fsize = 2 },
				{
					strset = SplitString(GetStr("enable_all_music"), 21),
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
					strset = SplitString(GetStr("disable_all_music"), 21),
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
			title = GetStr("music_settings"),
			buttons = InitMusicSettings(),
		},
		jingle_settings = {
			title = GetStr("jingle_settings"),
			buttons = InitJingleSettings(),
		},
		warpzone = {
			title = GetStr("settings"),
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
