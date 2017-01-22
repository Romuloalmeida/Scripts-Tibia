dofile("config-dtk.lua")
function onKill(cid, target, lastHit)
if getCreatureName(target):lower() == "the king" and getPlayerGroup(cid) == "attacker" then
   doSendMessageForAll(14,"The king was killed by ".. getCreatureName(cid))
   for _,name in pairs(getDefendPlayersAttacker()) do
             doPlayerSendTextMessage(getCreatureByName(name),MESSAGE_STATUS_CONSOLE_ORANGE,"Congratulations Attackers, you are the winner of Defend the King!")
   end
   for _,name in pairs(getDefendPlayersDefender()) do
             doPlayerSendTextMessage(getCreatureByName(name),MESSAGE_STATUS_CONSOLE_ORANGE,"You Lost the event Defend The King!")
   end
   for _,info in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(info.name) then
          local pid = getCreatureByName(info.name)
          doTeleportThing(pid,getTownTemplePosition(getPlayerTown(pid)))
          if getPlayerGroup(pid) == "attacker" then
             premio = doPlayerAddItem(pid,premios[math.random(1,#premios)])
             doPlayerSendTextMessage(pid,MESSAGE_EVENT_DEFAULT,"You gain 1 ".. getItemName(premio).."")
          end
       end                
   end
   setGlobalStorageValue(controle_king_death,1)
   doCancelEvent(all_storage,tp_pos,position_gate,position_gate_main,gate_id)
end
return TRUE
end