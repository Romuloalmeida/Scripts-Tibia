dofile("config-dtk.lua")
voices = {"Oh god.","o.O help help help","I'll deeead!","HELP","Heeelp","Heeeeeelp me pleeeease"}

function onCombat(cid, target)
if getCreatureName(target):lower() == "the king" then 
   if getPlayerGroup(cid) == "defender" then 
      if getEscolhido():lower() == getCreatureName(cid):lower() then
         if getGlobalStorageValue(controle_walk_king) == -1 then
            doChangeSpeed(target, -getCreatureSpeed(target))
            setGlobalStorageValue(controle_walk_king,1)
            doCreatureSay(cid, "Stop here my Lord!", 1)
            doCreatureSay(target, "ok", 1)
            doPlayerSendTextMessage(cid,MESSAGE_STATUS_CONSOLE_ORANGE,"The king is stop.")
         else
            doChangeSpeed(target,getCreatureBaseSpeed(target))
            setGlobalStorageValue(controle_walk_king,-1)
            doPlayerSendTextMessage(cid,MESSAGE_STATUS_CONSOLE_ORANGE,"The king is following you.")
            doCreatureSay(cid, "Follow me my Lord!", 1)
            doCreatureSay(target, "All right!", 1)
         end
      end
      return FALSE
   else
      if getGlobalStorageValue(controle_voice) == -1 then
         doCreatureSay(target, voices[math.random(1,#voices)], 1)
         for _,name in pairs(getDefendPlayersDefender()) do
             doPlayerSendTextMessage(getCreatureByName(name),MESSAGE_INFO_DESCR,"Your king is under attack. Defend him.")
         end
         setGlobalStorageValue(controle_voice,1)
         addEvent(reset,6000,controle_voice) 
      end
      return TRUE
   end
else
return TRUE
end
end

function reset(storage_global)
setGlobalStorageValue(storage_global,-1)
end