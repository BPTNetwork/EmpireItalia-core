-- Finance Office 1: Arcadius Business Centre (-141.1987, -620.913, 168.8205)
local EnableIpl, SetIplPropState

FinanceOffice1 = {
    currentInteriorId = -1,
    currentSafeDoors = { hashL = "", hashR = "" },

    Style = {
        Theme = {
            warm = { interiorId = 236289, ipl = "ex_dt1_02_office_01a", safe = "ex_prop_safedoor_office1a" },
            classical = { interiorId = 236545, ipl = "ex_dt1_02_office_01b", safe = "ex_prop_safedoor_office1b" },
            vintage = { interiorId = 236801, ipl = "ex_dt1_02_office_01c", safe = "ex_prop_safedoor_office1c" },
            contrast = { interiorId = 237057, ipl = "ex_dt1_02_office_02a", safe = "ex_prop_safedoor_office2a" },
            rich = { interiorId = 237313, ipl = "ex_dt1_02_office_02b", safe = "ex_prop_safedoor_office2a" },
            cool = { interiorId = 237569, ipl = "ex_dt1_02_office_02c", safe = "ex_prop_safedoor_office2a" },
            ice = { interiorId = 237825, ipl = "ex_dt1_02_office_03a", safe = "ex_prop_safedoor_office3a" },
            conservative = { interiorId = 238081, ipl = "ex_dt1_02_office_03b", safe = "ex_prop_safedoor_office3a" },
            polished = { interiorId = 238337, ipl = "ex_dt1_02_office_03c", safe = "ex_prop_safedoor_office3c" },
        },
        Set = function(style, refresh)
            if type(style) == "table" then
                FinanceOffice1.Style.Clear()
                FinanceOffice1.currentInteriorId = style.interiorId
                FinanceOffice1.currentSafeDoors = {
                    hashL = GetHashKey(style.safe .. "_l"),
                    hashR = GetHashKey(style.safe .. "_r"),
                }
                EnableIpl(style.ipl, true)
                if refresh then
                    RefreshInterior(style.interiorId)
                end
            end
        end,
        Clear = function()
            for _, theme in pairs(FinanceOffice1.Style.Theme) do
                for _, swag in pairs(FinanceOffice1.Swag) do
                    if type(swag) == "table" then
                        SetIplPropState(theme.interiorId, { swag.A, swag.B, swag.C }, false)
                    end
                end
                SetIplPropState(theme.interiorId, "office_chairs", false, false)
                SetIplPropState(theme.interiorId, "office_booze", false, true)
                EnableIpl(theme.ipl, false)
            end
            FinanceOffice1.currentSafeDoors = { hashL = 0, hashR = 0 }
        end,
    },

    Safe = {
        doorHeadingL = 96.0,
        Position = vector3(-124.25, -641.30, 168.87),
        isLeftDoorOpen = false,
        isRightDoorOpen = false,

        Open = function(door)
            if door:lower() == "left" then
                FinanceOffice1.Safe.isLeftDoorOpen = true
            elseif door:lower() == "right" then
                FinanceOffice1.Safe.isRightDoorOpen = true
            else
                print("[bob74_ipl] Warning: Invalid safe door - use 'left' or 'right'")
            end
        end,

        Close = function(door)
            if door:lower() == "left" then
                FinanceOffice1.Safe.isLeftDoorOpen = false
            elseif door:lower() == "right" then
                FinanceOffice1.Safe.isRightDoorOpen = false
            else
                print("[bob74_ipl] Warning: Invalid safe door - use 'left' or 'right'")
            end
        end,

        SetDoorState = function(door, open)
            local heading = FinanceOffice1.Safe.doorHeadingL
            local handle = door:lower() == "left" and FinanceOffice1.Safe.GetDoorHandle(FinanceOffice1.currentSafeDoors.hashL) or FinanceOffice1.Safe.GetDoorHandle(FinanceOffice1.currentSafeDoors.hashR)

            heading = heading - (door:lower() == "left" and 90 or 180) + (open and 90 or 0)
            if handle == 0 then
                return print("[bob74_ipl] Warning: safe door handle is 0")
            end
            SetEntityHeading(handle, heading)
        end,

        GetDoorHandle = function(hash)
            local timeout, handle = 4, 0
            repeat
                handle = GetClosestObjectOfType(FinanceOffice1.Safe.Position.x, FinanceOffice1.Safe.Position.y, FinanceOffice1.Safe.Position.z, 5.0, hash, false, false, false)
                if handle == 0 then
                    Citizen.Wait(25)
                    timeout = timeout - 1
                end
            until handle ~= 0 or timeout <= 0
            return handle
        end,
    },

    Swag = {
        Cash = { A = "cash_set_01", B = "cash_set_02", C = "cash_set_03" },
        BoozeCigs = { A = "swag_booze_cigs", B = "swag_booze_cigs2", C = "swag_booze_cigs3" },
        Counterfeit = { A = "swag_counterfeit", B = "swag_counterfeit2", C = "swag_counterfeit3" },
        DrugBags = { A = "swag_drugbags", B = "swag_drugbags2", C = "swag_drugbags3" },
        DrugStatue = { A = "swag_drugstatue", B = "swag_drugstatue2", C = "swag_drugstatue3" },
        Electronic = { A = "swag_electronic", B = "swag_electronic2", C = "swag_electronic3" },
        FurCoats = { A = "swag_furcoats", B = "swag_furcoats2", C = "swag_furcoats3" },
        Gems = { A = "swag_gems", B = "swag_gems2", C = "swag_gems3" },
        Guns = { A = "swag_guns", B = "swag_guns2", C = "swag_guns3" },
        Ivory = { A = "swag_ivory", B = "swag_ivory2", C = "swag_ivory3" },
        Jewel = { A = "swag_jewelwatch", B = "swag_jewelwatch2", C = "swag_jewelwatch3" },
        Med = { A = "swag_med", B = "swag_med2", C = "swag_med3" },
        Painting = { A = "swag_art", B = "swag_art2", C = "swag_art3" },
        Pills = { A = "swag_pills", B = "swag_pills2", C = "swag_pills3" },
        Silver = { A = "swag_silver", B = "swag_silver2", C = "swag_silver3" },
        Enable = function(props, state, refresh)
            SetIplPropState(FinanceOffice1.currentInteriorId, props, state, refresh)
        end,
    },

    Chairs = {
        on = "office_chairs",
        Set = function(_, refresh)
            FinanceOffice1.Chairs.Clear(false)
            SetIplPropState(FinanceOffice1.currentInteriorId, "office_chairs", true, refresh)
        end,
        Clear = function(refresh)
            SetIplPropState(FinanceOffice1.currentInteriorId, "office_chairs", false, refresh)
        end,
    },

    Booze = {
        on = "office_booze",
        Set = function(_, refresh)
            FinanceOffice1.Booze.Clear(false)
            SetIplPropState(FinanceOffice1.currentInteriorId, "office_booze", true, refresh)
        end,
        Clear = function(refresh)
            SetIplPropState(FinanceOffice1.currentInteriorId, "office_booze", false, refresh)
        end,
    },

    LoadDefault = function()
        FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.polished)
        FinanceOffice1.Chairs.Set(true, true)
    end,
}

exports("GetFinanceOffice1Object", function()
    return FinanceOffice1
end)
