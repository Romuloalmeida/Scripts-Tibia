function onCombat(cid, target)
if isPlayer(cid) then
   if getPlayerGroup(cid) ~= getPlayerGroup(target) and getGlobalStorageValue(controle_round) == 1 then
      return TRUE
   else
       return FALSE
   end
end
end