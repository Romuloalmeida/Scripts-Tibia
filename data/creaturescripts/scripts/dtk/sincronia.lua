dofile("config-dtk.lua")
function onThink(pid, interval)
    if isCreature(pid) then
       cid = getCreatureMaster(pid)       -- Player que sumonou
       pos = getCreaturePosition(cid)     -- Posiçao do player que sumonou
       pos_summon = getCreaturePosition(pid)          
       if pos.z ~= pos_summon.z and getGlobalStorageValue(controle_walk_king) == -1 then
          doTeleportThing(pid,pos)
          doSendMagicEffect(pos,2)
          doSendMagicEffect(pos_summon,2)
       end
    end
return TRUE
end

-- 36 animated efeito