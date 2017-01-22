dofile("config-dtk.lua")
function onPrepareDeath(cid, deathList)
         if getPlayerStorageValue(cid,death_times) == -1 then setPlayerStorageValue(cid,death_times,1) end
         local delay = 0
         local times = 5*getPlayerStorageValue(cid,death_times)
         doCreatureSetNoMove(cid,TRUE)
         setPlayerStorageValue(cid,controle_in_delay,1)
         for i=times,0,-1 do
                addEvent(doMessageWithCheck,delay,cid,MESSAGE_STATUS_CONSOLE_ORANGE,"Respawn to back: "..i)
                delay = 2000 + delay                 
                if i == 0 then
                   addEvent(doMovePlayer,delay+1000,cid)
                end
         end
         
return TRUE
end

function onDeath(cid, deathList)
doConvinceCreature(getGlobalStorageValue(controle_convince_pid),cid)
return TRUE
end

function doMessageWithCheck(cid,type,msg)
if isPlayerOnline(getCreatureName(cid)) and getGlobalStorageValue(controle_atived) ~= -1 then
   doPlayerSendTextMessage(cid,type,msg)
else
    stopEvent(doMessageWithCheck)
end
return TRUE
end

function doMovePlayer(cid)
         if isPlayerOnline(getCreatureName(cid)) and getGlobalStorageValue(controle_atived) ~= -1 then 
               doCreatureSetNoMove(cid, FALSE)
               doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Go Go GO!")
               setPlayerStorageValue(cid,death_times,getPlayerStorageValue(cid,death_times)+1)
               setPlayerStorageValue(cid,controle_in_delay,-1)
         end
end