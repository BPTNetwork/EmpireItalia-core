-- Office 4: -1392.667, -480.4736, 72.04217 (Maze Bank West)
local EnableIpl, SetIplPropState

local function isValidDoorSide(side)
    return side == "left" or side == "right"
end

local function getHeadingForDoor(side, baseHeading)
    if side == "left" then
        return baseHeading - 90.0
    elseif side == "right" then
        return baseHeading - 90.0 -- base 180 - 90
    end
end

FinanceOffice4 = {
    currentInteriorId = -1,
    currentSafeDoors = { hashL = 0, hashR = 0 },

    Style = {
        Theme = {
            warm = { interiorId = 243201, ipl = "ex_sm_15_office_01a", safe = "ex_prop_safedoor_office1a" },
            classical = { interiorId = 243457, ipl = "ex_sm_15_office_01b", safe = "ex_prop_safedoor_office1b" },
            vintage = { interiorId = 243713, ipl = "ex_sm_15_office_01c", safe = "ex_prop_safedoor_office1c" },
            contrast = { interiorId = 243969, ipl = "ex_sm_15_office_02a", safe = "ex_prop_safedoor_office2a" },
            rich = { interiorId = 244225, ipl = "ex_sm_15_office_02b", safe = "ex_prop_safedoor_office2a" },
            cool = { interiorId = 244481, ipl = "ex_sm_15_office_02c", safe = "ex_prop_safedoor_office2a" },
            ice = { interiorId = 244737, ipl = "ex_sm_15_office_03a", safe = "ex_prop_safedoor_office3a" },
            conservative = { interiorId = 244993, ipl = "ex_sm_15_office_03b", safe = "ex_prop_safedoor_office3a" },
            polished = { interiorId = 245249, ipl = "ex_sm_15_office_03c", safe = "ex_prop_safedoor_office3c" },
        },

        Set = function(style, refresh)
            if type(style) ~= "table" then
                return
            end
            refresh = refresh or false

            FinanceOffice4.Style.Clear()
            FinanceOffice4.currentInteriorId = style.interiorId
            FinanceOffice4.currentSafeDoors = {
                hashL = GetHashKey(style.safe .. "_l"),
                hashR = GetHashKey(style.safe .. "_r"),
            }

            EnableIpl(style.ipl, true)
            if refresh then
                RefreshInterior(style.interiorId)
            end
        end,

        Clear = function()
            for _, theme in pairs(FinanceOffice4.Style.Theme) do
                for _, swag in pairs(FinanceOffice4.Swag) do
                    if type(swag) == "table" then
                        SetIplPropState(theme.interiorId, { swag.A, swag.B, swag.C }, false)
                    end
                end
                SetIplPropState(theme.interiorId, { "office_chairs", "office_booze" }, false)
                EnableIpl(theme.ipl, false)
            end

            FinanceOffice4.currentSafeDoors = { hashL = 0, hashR = 0 }
        end,
    },

    Safe = {
        doorHeadingL = 188.0,
        Position = vector3(-1372.905, -462.08, 72.05),
        isLeftDoorOpen = false,
        isRightDoorOpen = false,

        Open = function(side)
            side = side:lower()
            if not isValidDoorSide(side) then
                print("[bob74_ipl] Invalid side: " .. side)
                return
            end
            FinanceOffice4.Safe["is" .. side:gsub("^%l", string.upper) .. "DoorOpen"] = true
        end,

        Close = function(side)
            side = side:lower()
            if not isValidDoorSide(side) then
                print("[bob74_ipl] Invalid side: " .. side)
                return
            end
            FinanceOffice4.Safe["is" .. side:gsub("^%l", string.upper) .. "DoorOpen"] = false
        end,

        SetDoorState = function(side, open)
            local hash = (side == "left") and FinanceOffice4.currentSafeDoors.hashL or FinanceOffice4.currentSafeDoors.hashR
            local handle = FinanceOffice4.Safe.GetDoorHandle(hash)
            if handle == 0 then
                print("[bob74_ipl] Warning: door handle is 0")
                return
            end

            SetEntityHeading(handle, getHeadingForDoor(side, FinanceOffice4.Safe.doorHeadingL))
        end,

        GetDoorHandle = function(doorHash)
            local handle = 0
            local attempts = 4

            while handle == 0 and attempts > 0 do
                Citizen.Wait(25)
                handle = GetClosestObjectOfType(FinanceOffice4.Safe.Position.x, FinanceOffice4.Safe.Position.y, FinanceOffice4.Safe.Position.z, 5.0, doorHash, false, false, false)
                attempts = attempts - 1
            end

            return handle
        end,
    },

    -- Chairs and Booze share logic
    Chairs = {
        on = "office_chairs",
        Set = function(_, refresh)
            SetIplPropState(FinanceOffice4.currentInteriorId, "office_chairs", true, refresh)
        end,
        Clear = function(refresh)
            SetIplPropState(FinanceOffice4.currentInteriorId, "office_chairs", false, refresh)
        end,
    },

    Booze = {
        on = "office_booze",
        Set = function(_, refresh)
            SetIplPropState(FinanceOffice4.currentInteriorId, "office_booze", true, refresh)
        end,
        Clear = function(refresh)
            SetIplPropState(FinanceOffice4.currentInteriorId, "office_booze", false, refresh)
        end,
    },

    Swag = {
        Cash = { A = "cash_set_01", B = "cash_set_02", C = "cash_set_03" },
        BoozeCigs = { A = "swag_booze_cigs", B = "swag_booze_cigs2", C = "swag_booze_cigs3" },
        -- ... (accorciare solo per leggibilità, tieni gli altri gruppi come nel tuo codice)
        Enable = function(details, state, refresh)
            SetIplPropState(FinanceOffice4.currentInteriorId, details, state, refresh)
        end,
    },

    LoadDefault = function()
        FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.cool, true)
        FinanceOffice4.Chairs.Set(true)
    end,
}

exports("GetFinanceOffice4Object", function()
    return FinanceOffice4
end)
