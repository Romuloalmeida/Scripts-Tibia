dofile("config-dtk.lua")

function onDeath(cid, corpse, deathList)
                
for i,v in pairs(getPositionsWithFloor(position_gate,floor))  do
    local fence = getThingFromId(gate_id,v)
    if fence ~= FALSE then
       doRemoveItem(fence.uid) 
    end
end        
doSendMessageForAll(MESSAGE_STATUS_WARNING,"The gate was destroyed!")
return TRUE
end