local EnableIpl
TunerMeetup = {
	InteriorId = 285697,

	Ipl = {
		Interior = {
			ipl = {
				"tr_tuner_meetup",
				"tr_tuner_race_line",
			},

			Load = function()
				EnableIpl(TunerMeetup.Ipl.Interior.ipl, true)
			end,

			Remove = function()
				EnableIpl(TunerMeetup.Ipl.Interior.ipl, false)
			end,
		},
	},

	Entities = {
		entity_set_meet_crew = true,
		entity_set_meet_lights = true,
		entity_set_meet_lights_cheap = true,
		entity_set_player = true,
		entity_set_test_crew = false,
		entity_set_test_lights = true,
		entity_set_test_lights_cheap = true,
		entity_set_time_trial = true,

		-- Cambia lo stato di un singolo entity set e aggiorna la scena
		Set = function(name, state)
			if TunerMeetup.Entities[name] ~= nil then
				TunerMeetup.Entities[name] = state
				TunerMeetup.Entities.Clear()
				TunerMeetup.Entities.Load()
			else
				print("[TunerMeetup] Entity set non valido: " .. tostring(name))
			end
		end,

		-- Attiva tutti gli entity set abilitati
		Load = function()
			for entity, state in pairs(TunerMeetup.Entities) do
				if state and type(entity) == "string" then
					ActivateInteriorEntitySet(TunerMeetup.InteriorId, entity)
				end
			end
		end,

		-- Disattiva tutti gli entity set
		Clear = function()
			for entity, _ in pairs(TunerMeetup.Entities) do
				if type(entity) == "string" then
					DeactivateInteriorEntitySet(TunerMeetup.InteriorId, entity)
				end
			end
		end,
	},

	-- Carica la configurazione di default del Tuner Meetup
	LoadDefault = function()
		TunerMeetup.Ipl.Interior.Load()
		TunerMeetup.Entities.Load()
		RefreshInterior(TunerMeetup.InteriorId)
	end,
}

-- Export access
exports("GetTunerMeetupObject", function()
	return TunerMeetup
end)
