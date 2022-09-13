local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("protein_without", function(source, item)

end)

QBCore.Functions.CreateUseableItem("protein_wpi90", function(source, item)

end)

RegisterNetEvent('ms:server:suplebezopakowania', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otrzymasz = 1
    Player.Functions.AddItem(data, otrzymasz)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[data], "add")
end)

RegisterNetEvent('ms:server:supleopakowanie', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otrzymasz = 1
    local protein_without = Player.Functions.GetItemByName("protein_without")
    local protein_wpi90 = Player.Functions.GetItemByName("protein_wpi90")
    if protein_without ~= nil and oklejina ~= nil then
        if protein_without >= 1 and oklejina >= 1 then
            Player.Functions.RemoveItem("protein_without", 1)
            Player.Functions.RemoveItem("oklejina", 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["protein_wpi90"], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Item Crafted.')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Nie masz wystarczającej ilości itemów', 'error')
        end
    end
end)


QBCore.Functions.CreateCallback("supl:check:items", function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    local invplrotein = Player.Functions.GetItemByName("protein_wpi90")
    if invplrotein.count >= 1 then
        cb(invplrotein.count)
    else
        cb(0)
    end       
end)

