RegisterServerEvent("doormanager:s_openDoor")
AddEventHandler("doormanager:s_openDoor", function(doorId)

    --local src = source
    local _source = source
    local isDoorLocked = GetDoorStatus(doorId)
      
        if isDoorLocked == 1 then
            if IsPlayerAceAllowed(_source, "drdoor.unlockdoor") then
                TriggerClientEvent("doormanager:c_openDoor", -1, doorId)
                SetDoorStatus(doorId,0)                   
            else
                TriggerClientEvent("doormanager:c_noDoorKey", _source, doorId)
            end
        end
    end)

RegisterServerEvent("doormanager:s_closeDoor")
AddEventHandler("doormanager:s_closeDoor", function(doorId)

    local _source = source
    local isDoorLocked = GetDoorStatus(doorId)
    
    if isDoorLocked == 0 then
        if IsPlayerAceAllowed(_source, "drdoor.unlockdoor") then
            TriggerClientEvent("doormanager:c_closeDoor", -1, doorId)
            SetDoorStatus(doorId,1)       
        else
            TriggerClientEvent("doormanager:c_noDoorKey", _source, doorId)
        end
    end
end)

RegisterServerEvent("doormanager:s_syncDoors")
AddEventHandler('doormanager:s_syncDoors', function()

    local _source = source    

    MySQL.Async.fetchAll("SELECT * FROM fivem_doors", {}, function(result)        
        if (result) then
            TriggerClientEvent("doormanager:c_getSyncData", _source,result)            
        end    
    end)    
end)


function GetDoorStatus(doorId)
   return MySQL.Sync.fetchScalar("SELECT locked FROM fivem_doors WHERE id = @id", {['@id'] = doorId})
end

function SetDoorStatus(doorId,doorStatus)
    local sql = "UPDATE fivem_doors SET locked = @dStatus WHERE id = @dId"
    local param = {dId = doorId, dStatus = doorStatus}    
    MySQL.Async.execute(sql, param)
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifier(identifiers)
    return player
end

function getIdentifier(id)
    for _, v in ipairs(id) do
        return v
    end
end