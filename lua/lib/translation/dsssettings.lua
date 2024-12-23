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
		en = DeadSeaScrollsMenu and DeadSeaScrollsMenu.menuOpenToolTip or {
			strset = { "toggle menu", "", "keyboard:", "[c] or [f1]", "", "controller:", "press analog" },
			fsize = 2,
		},
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
	unlock_manager = {
		en = "unlock manager",
		ru = "менеджер анлоков"
	},
	unlocks = {
		en = "unlocks",
		ru = "анлоки"
	},
	unlocked = {
		en = "unlocked",
		ru = "разблокировано"
	},
	locked = {
		en = "locked",
		ru = "заблокировано"
	},
	unlock = {
		en = "unlock all",
		ru = "разблокировать все"
	},
	lock = {
		en = "lock all",
		ru = "заблокировать все"
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
		ru = "другие настройки",
	},
	happy_start = {
		en = "happy start",
		ru = "счастливый старт",
	},
	music_button_enable = {
		en = "enables all mod's music and jingles",
		ru = "включает всю музыку и джинглы из мода",
	},
	music_button_disable = {
		en = "disables all mod's music and jingles",
		ru = "выключает всю музыку и джинглы из мода",
	},
}

function RepMMod.GetDSSStr(str)
	local tmpstr = strings
	return tmpstr[str] and (tmpstr[str][Options.Language] or tmpstr[str].en) or str
end

function RepMMod.SplitString(str, size)
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
