local QBCore = exports['qb-core']:GetCoreObject()
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local blips = {
    --{title="", colour=30, id=108, x = 260.130, y = 204.308, z = 109.287}
}
local x = 0


local src = source
PlayerJob = {}
local onDuty = false
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "producentsupli" then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end) 
    
    isLoggedIn = true
end)
RegisterNetEvent("ms:duty")
AddEventHandler("ms:duty", function()
        onDuty = not onDuty
        TriggerServerEvent("QBCore:ToggleDuty")
end)
--protein_wpi90

Citizen.CreateThread(function()
    for i=1, 1 do
        ped = CreatePed(1, 0x62018559, 150.08, -3099.53, 4.9, 0.0, true)
        FreezeEntityPosition(ped, true)
    end
end)


RegisterNetEvent('ms:client:start', function()
    QBCore.Functions.TriggerCallback('supl:check:items', function(cb)
        if cb >= 5 then
            -- funkcja spawnowania auta
            for v,k in pairs(config.LocalizationsDelivery) do
                local y = 1
                table.insert(blips, {title="Blip #" .. y+1, colour=30, id=108, x = k.x, y = k.y, z = k.z})
            end
            StartChecking(cb)
            Wait(1000)
            --notify ze ma leciec na blipy
            AddBlips()
        else
            -- notify ze nie ma itemow
        end
    end)
end)



function StartChecking(cb)
    if x >= cb then
        -- notify dziekuje za prace
        SetNewWaypoint(config.EndJobCoords)
    else
        while true do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for v,k in pairs(config.LocalizationsDelivery) do
                if Vdist2(playerCoords, k.x, k.y, k.z) < 5 then
                    -- notify zeby kliknal
                    if IsControlJustPressed(0, 38) then
                        if GetVehiclePedIsIn(playerPed, false) == nil then
                            QBCore.Functions.TriggerCallback('supl:check:items', function(cb)
                                if cb then
                                    -- taskbar czy cos
                                    FreezeEntityPosition(playerPed, true)
                                    Wait(60000)
                                    -- notify ze skonczyl
                                    FreezeEntityPosition(playerPed, false)
                                    x = x + 1
                                else
                                    -- notify ze nie ma itemow
                                end
                            end)
                        else
                            -- notify zeby wyszedl
                        end
                    end
                end
            end
            Wait(0)
        end
    end
end

function AddBlips()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end


local odebrane = false 



local ready = true
function Timer()
    if ready then
        ready = false
        return true
    else
        QBCore.Functions.Notify("Musisz jeszcze poczekać!", "error", 5000)
        Wait(10000)
        ready = true
        return false
    end
end

RegisterNetEvent("ms:client:sublebezopakowania")
AddEventHandler("ms:client:sublebezopakowania", function()
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "producentsupli" then
        if Timer() then
            QBCore.Functions.Notify("Gratulacje! Naklejiłeś właśnie paczke białka! Dostarcz teraz produkt do najbliższego sklepu!", "succes", 5000)
            TriggerServerEvent('ms:server:suplebezopakowania', "protein_without")
        else
            Citizen.Wait(0)
        end
    end
end)

--ServerEvent('ms:server:supleopakowanie', "protein_wpi90")


RegisterNetEvent("ms:client:supleopakowanie")
AddEventHandler("ms:client:supleopakowanie", function(src)
        QBCore.Functions.Progressbar('Opakowanie_supli', 'Oklejasz suple', 5000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            }, {
            animDict = "mini@repair",
            anim = "fixing_a_ped",
            }, {}, {},  function()
            QBCore.Functions.Notify("Gratulacje! Oklejiłeś właśnie paczke białka! Dostarcz teraz produkt do najbliższego sklepu!", "success", 5000)
            TriggerServerEvent('ms:server:supleopakowanie')
            ClearPedTasks(ped)
            local success = exports['qb-lock']:StartLockPickCircle(1,30)
            if success then
                ClearPedTasks(ped)
            else
                QBCore.Functions.Notify("Crafting Failed!", "error")
                ClearPedTasks(ped)
            end
    end)
end)

AddEventHandler("ms:client:spawnaut")
RegisterNetEvent("ms:client:spawnaut", function ()
    while true do
    local coordsss = vector3(163.53, -3093.47, 6.01)
        CreateVehicle(0xC1632BEB, 163.53, -3093.47, 5.93, 0.0, true, false)
    end
end)



local blips = {
    --{title="", colour=30, id=108, x = 260.130, y = 204.308, z = 109.287}
}

local x = 0
RegisterNetEvent('supl:start', function()
    print('start')
        while true do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            if Vdist2(playerCoords, k.x, k.y, k.z) < 5 then
                -- TUtaj notify
                if IsControlJustReleased(0, 38) then
                    if GetVehiclePedIsIn(playerPed, false) == nil then
                        -- notify ze zaczl
                        QBCore.Functions.TriggerCallback('supl:check:items', function(cb)
                            if cb then
                                for v,k in pairs(config.LocalizationsDelivery) do
                                    local y = 1
                                    table.insert(blips, {title="Blip #" .. y+1, colour=30, id=108, x = k.x, y = k.y, z = k.z})
                                end
                                StartChecking()
                                Wait(1000)
                                --notify ze ma leciec na blipy
                                AddBlips()
                            else
                                -- notify ze nie ma itemow
                            end
                        end)
                    else
                        -- notify zeby wyszedl
                    end
                end
            end
            Wait(0)
        end
end)

function StartChecking()
    if x >= config.MaxLocalzationsDelivery then
        -- notify ze zakonczyl juz i zeby udal sie na gps
        SetNewWaypoint(config.EndJobCoords)
    else
        while true do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for v,k in pairs(config.LocalizationsDelivery) do
                if Vdist2(playerCoords, k.x, k.y, k.z) < 5 then
                    -- notify zeby kliknal
                    if IsControlJustPressed(0, 38) then
                        if GetVehiclePedIsIn(playerPed, false) == nil then
                            QBCore.Functions.TriggerCallback('supl:check:items', function(cb)
                                if cb then
                                    -- taskbar czy cos
                                    FreezeEntityPosition(playerPed, true)
                                    Wait(60000)
                                    -- notify ze skonczyl
                                    FreezeEntityPosition(playerPed, false)
                                    x = x + 1
                                else
                                    -- notify ze nie ma itemow
                                end
                            end)
                        else
                            -- notify zeby wyszedl
                        end
                    end
                end
            end
            Wait(0)
        end
    end
end

function AddBlips()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end


-- exporty
Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("tata", vector3(150.08, -3099.53, 4.5), 1.6, 3.2, {
        name="tata",
        heading=0,
        debugPoly=false,
        minZ = 6.14,
        maxZ = 8.94,
        }, {
            options = {
                {
                    type = "client",
                    event = "ms:client:spawnaut",
                    icon = "fas fa-list",
                    label = "auta",
                    job = "producentsupli",
                },
        },
            distance = 3.5
    })
end)


Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("suplebezoklejiny", vector3(129.3, -3019.28, 8.04), 1.6, 3.2, {
        name="suplebezoklejiny",
        heading=0,
        debugPoly=false,
        minZ = 6.14,
        maxZ = 8.94,
        }, {
            options = {
                {
                    type = "client",
                    event = "ms:client:sublebezopakowania",
                    icon = "fas fa-list",
                    label = "Produkcja",
                    job = "producentsupli",
                },
        },
            distance = 3.5
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("dutyy", vector3(125.43, -3014.84, 7.04), 0.6, 0.6, {
        name="dutyy",
        heading=0,
        debugPoly=false,
        minZ = 6.79,
        maxZ = 7.19,
        }, {
            options = {
                {
                    type = "client",
                    event = "ms:duty",
                    icon = "fas fa-clipboard",
                    label = "Sign on duty",
                    job = "producentsupli",
                },
            },
            distance = 3.5
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("przetwornia", vector3(140.99, -3008.29, 7.04), 1.6, 3.2, {
        name="przetwornia",
        heading=0,
        debugPoly=false,
        minZ = 6.79,
        maxZ = 8.19,
        }, {
            options = {
                {
                    type = "client",
                    event = "ms:client:supleopakowanie",
                    icon = "fas fa-clipboard",
                    label = "Naklej opakowania",
                    job = "producentsupli",
                },
            },
            distance = 3.5
    })
end)
