dofile("config-dtk.lua")

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
if item.actionid == 99887 then
   if getDefendTotalValue(control_attacker) == -1 then
            setGlobalStorageValue(control_attacker,0)
   end
   if getDefendTotalValue(control_defender) == -1 then
      setGlobalStorageValue(control_defender,0)
   end
   if getDefendTotalValue(control_total_players) == -1 then
      setGlobalStorageValue(control_total_players,0)
   end
   if block_ip == 1 then
      if getDefendPlayersInEvent() ~= FALSE then
         for _,info in pairs(getDefendPlayersInEvent()) do
             if isPlayerOnline(info.name) then
                if getPlayerIp(cid) == getIpByName(info.name) then
                   doPlayerSendCancel(cid,"Ja existe um membro com mesmo IP no evento.")
                   doTeleportThing(cid,fromPosition)
                   return TRUE
                end
             end
         end
      end
   end
   if getPlayerLevel(cid) <= min_level then
      doPlayerSendCancel(cid,"Sorry, you need level ".. min_level .." to enter in event.")
      doTeleportThing(cid,fromPosition)
      return TRUE
   end
   storage_groups = {["attacker"]=control_attacker,["defender"]=control_defender}
   if (getDefendTotalValue(control_attacker) < getDefendTotalValue(control_defender)) or (getDefendTotalValue(control_attacker) == 0) then
       doDefendTp(cid,"attacker",control_total_players,storage_groups)
        doSetCreatureOutfit(cid, outfits.attacker)
   else                                            
       doDefendTp(cid,"defender",control_total_players,storage_groups)
        doSetCreatureOutfit(cid, outfits.defender)
    
   end
   if getDefendTotalValue(control_total_players) >= max_event then
      doRemoveItem(item.uid)
      doBroadcastMessage("Event is FULL. Teleport has been closed...")
   end
   registerCreatureEvent(cid, "player_combat")
end
return TRUE
end           


function doDefendTp(cid,name_group,storage_total_player,storage_groups--[[Table]])
   setGlobalStorageValue(storage_groups[name_group],getDefendTotalValue(storage_groups[name_group])+1)
   setGlobalStorageValue(storage_total_player,getDefendTotalValue(storage_total_player)+1)
   db.executeQuery("INSERT INTO `players_dtk` VALUES('".. getCreatureName(cid):lower() .."','"..name_group.."',0,".. getPlayerTown(cid) ..");")
   doPlayerSetTown(cid, towns_id[name_group])
   doTeleportThing(cid,getTownTemplePosition(getPlayerTown(cid)))
   doSendMagicEffect(getCreaturePosition(cid), 10)
   addEvent(doSendMagicEffect,1000,getCreaturePosition(cid), 36)
   --// Config rapida das palavras atacando e defendendo
   mode_player = {["attacker"]="attacker",["defender"]="defender"}
   doPlayerSendCancel(cid,"You are " .. mode_player[name_group] ..". Have now ".. getDefendTotalValue(storage_groups["attacker"]) .." attackers and ".. getDefendTotalValue(storage_groups["defender"])  .." defender")
end