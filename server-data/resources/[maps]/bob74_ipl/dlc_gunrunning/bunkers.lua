local interiorId = 258561
local EnableIpl, SetIplPropState

GunrunningBunker = {
	interiorId = interiorId,

	Ipl = {
		Interior = {
			ipl = "gr_grdlc_interior_placement_interior_1_grdlc_int_02_milo_",
			Load = function() EnableIpl(GunrunningBunker.Ipl.Interior.ipl, true) end,
			Remove = function() EnableIpl(GunrunningBunker.Ipl.Interior.ipl, false) end,
		},
		Exterior = {
			ipl = {
				"gr_case0_bunkerclosed", "gr_case1_bunkerclosed", "gr_case2_bunkerclosed",
				"gr_case3_bunkerclosed", "gr_case4_bunkerclosed", "gr_case5_bunkerclosed",
				"gr_case6_bunkerclosed", "gr_case7_bunkerclosed", "gr_case9_bunkerclosed",
				"gr_case10_bunkerclosed", "gr_case11_bunkerclosed"
			},
			Load = function() EnableIpl(GunrunningBunker.Ipl.Exterior.ipl, true) end,
			Remove = function() EnableIpl(GunrunningBunker.Ipl.Exterior.ipl, false) end,
		},
	},

	-- Generic Set/Clear template
	Property = function(name, values)
		return {
			Set = function(value, refresh)
				GunrunningBunker[name].Clear(false)
				SetIplPropState(interiorId, value, true, refresh)
			end,
			Clear = function(refresh)
				SetIplPropState(interiorId, values, false, refresh)
			end
		}
	end,

	Style = {}, -- Will be filled below
	Tier = {},
	Security = {},

	Details = {
		office = "Office_Upgrade_set",
		officeLocked = "Office_blocker_set",
		locker = "gun_locker_upgrade",
		rangeLights = "gun_range_lights",
		rangeWall = "gun_wall_blocker",
		rangeLocked = "gun_range_blocker_set",
		schematics = "Gun_schematic_set",

		Enable = function(prop, state, refresh)
			SetIplPropState(interiorId, prop, state, refresh)
		end,
	},

	LoadDefault = function()
		local s = GunrunningBunker.Style
		local t = GunrunningBunker.Tier
		local sec = GunrunningBunker.Security
		local d = GunrunningBunker.Details

		GunrunningBunker.Ipl.Interior.Load()
		GunrunningBunker.Ipl.Exterior.Load()

		s.Set(GunrunningBunker.Style.default)
		t.Set(GunrunningBunker.Tier.default)
		sec.Set(GunrunningBunker.Security.default)

		d.Enable(d.office, true)
		d.Enable(d.officeLocked, false)
		d.Enable(d.locker, true)
		d.Enable(d.rangeLights, true)
		d.Enable(d.rangeWall, false)
		d.Enable(d.rangeLocked, false)
		d.Enable(d.schematics, false)

		RefreshInterior(interiorId)
	end,
}

-- Assign style, tier, security props via generic function
GunrunningBunker.Style = GunrunningBunker.Property("Style", {
	"Bunker_Style_A", "Bunker_Style_B", "Bunker_Style_C"
})
GunrunningBunker.Style.default = "Bunker_Style_A"
GunrunningBunker.Style.blue = "Bunker_Style_B"
GunrunningBunker.Style.yellow = "Bunker_Style_C"

GunrunningBunker.Tier = GunrunningBunker.Property("Tier", {
	"standard_bunker_set", "upgrade_bunker_set"
})
GunrunningBunker.Tier.default = "standard_bunker_set"
GunrunningBunker.Tier.upgrade = "upgrade_bunker_set"

GunrunningBunker.Security = GunrunningBunker.Property("Security", {
	"standard_security_set", "security_upgrade"
})
GunrunningBunker.Security.default = "standard_security_set"
GunrunningBunker.Security.upgrade = "security_upgrade"

-- Export access
exports("GetGunrunningBunkerObject", function()
	return GunrunningBunker
end)
