function getDefendPlayersInEvent(type)
local result = db.getResult("SELECT * FROM `players_dtk`;")
 players = {}
         if result:getID() ~= -1 then
            repeat
               name  = result:getDataString('name') 
               group = result:getDataString("group_name")
               town = result:getDataInt("town")
               table.insert(players,{["name"]=name,["group"]=group,["town"]=town}) 
            until(not result:next())
         return players
         end
return FALSE   
end

function getDefendPlayersAttacker()
if getDefendPlayersInEvent() then
   local players = {}
   for i,v in pairs(getDefendPlayersInEvent()) do
       if v.group == "attacker" then
          table.insert(players,v.name) 
       end
   end
return players
end 
return FALSE                                             
end

function getDefendPlayersDefender()
if getDefendPlayersInEvent() then
   local players = {}
   for i,v in pairs(getDefendPlayersInEvent()) do
       if v.group == "defender" then
          table.insert(players,v.name) 
       end
   end
return players
end 
return FALSE     
end

function getPositionsWithFloor(pos,floor_top)
pos_final = {}
for i,v in pairs(pos) do
    table.insert(pos_final,v)
end            
for floor=1,floor_top do      
    for i=1,#pos_final do
        table.insert(pos_final,{x=pos_final[i].x,y=pos_final[i].y,z=pos_final[i].z-floor,stackpos=pos_final[i].stackpos})
    end
end
--[[for i,v in pairs(pos_final) do
print("x="..v.x.." y=".. v.y .." z=".. v.z .."")
end]]
return pos_final
end

function getDefendTotalValue(storage)
return getGlobalStorageValue(storage) 
end

function getPlayerGroup(cid)
         for _,player in pairs(getDefendPlayersInEvent()) do
             if player.name:lower() == getCreatureName(cid):lower() then
                return player.group
             end
         end
return FALSE
end


function doSendMessageForAll(type,msg,group)
if getDefendPlayersInEvent() ~= FALSE then
if not(group) then                               
   for _,v in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(v.name) and getGlobalStorageValue(controle_atived) ~= -1 then
          pid = getCreatureByName(v.name)
          doPlayerSendTextMessage(pid,type,msg)
       end
   end  
else
   for _,v in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(v.name) and getGlobalStorageValue(controle_atived) ~= -1 then
          pid = getCreatureByName(v.name)
          if getPlayerGroup(pid) == v.group then
             doPlayerSendTextMessage(pid,type,msg)
          end
       end
   end
end 
end     
return TRUE
end

function getThingFromId(id,pos)
local coisa
for i=1,255 do
    coisa = getThingFromPos({x=pos.x,y=pos.y,z=pos.z,stackpos=i})
    if coisa.itemid == id then
       return coisa,i
    end 
end
return FALSE
end

function doStart(position_gate,position_gate_main,floor,gate_id)

--// Dar o The King a alguem do grupo dos defensores
defensores = getDefendPlayersDefender()
repeat
  random = math.random(1,#defensores)
  escolhido_name = defensores[random]
until(isPlayerOnline(escolhido_name))
doPlayerSendTextMessage(getCreatureByName(escolhido_name),MESSAGE_EVENT_DEFAULT,"o rei escolheu-te para controla-lo e esconder dos invasores. Para paraliza-lo num local ou faze-lo andar, basta \"ataca-lo\". Boa sorte.")
pid = doCreateMonster("the king", getCreaturePosition(getCreatureByName(escolhido_name)),TRUE,TRUE)
setGlobalStorageValue(controle_king,pid)
doConvinceCreature(getCreatureByName(escolhido_name), pid)
setGlobalStorageValue(controle_convince_pid,getCreatureByName(escolhido_name))
registerCreatureEvent(pid, "king_sinc")
doAddEscolhido(escolhido_name)
setGlobalStorageValue(controle_king_death,-1)
--###### DADO ########
addEvent(doReallyStart,2*1000,position_gate,position_gate_main,floor,gate_id)
return TRUE
end

function doReallyStart(position_gate,position_gate_main,floor,gate_id)
doCreateGate(position_gate,position_gate_main,floor,1,gate_id)
if getGlobalStorageValue(controle_round) == -1 then
   setGlobalStorageValue(controle_round,1)
end
doSendMessageForAll(MESSAGE_INFO_DESCR,"The round was started. Go Go Go!")
for i,v in pairs(getDefendPlayersInEvent()) do
    if isPlayerOnline(v.name) then
       local pid = getCreatureByName(v.name) 
        registerCreatureEvent(pid, "death_king")
      	registerCreatureEvent(pid, "player_death_dtk")
	    registerCreatureEvent(pid, "king") 
    end
end

local delay = tempo_round*60*1000
local delay_msg = 1*60*1000       
addEvent(doAttackerLost,delay)
for i=tempo_round,1,-1 do
    if getGlobalStorageValue(controle_atived) ~= -1 then
       if i-1 ~= 0 then
          addEvent(doSendMessageForAll,delay_msg,MESSAGE_INFO_DESCR,"Falta".. (i-1>1 and "m" or "") .." ".. i-1 .." minuto".. (i-1>1 and "s" or "") .." para acabar.")
          delay_msg = delay_msg + 1*60*1000
       end
    end
end
return TRUE
end                                                                                                

function doAttackerLost()
dofile("config-dtk.lua")
if getDefendTotalValue(controle_atived) == 1 and getGlobalStorageValue(controle_king_death) == -1 then           -- Se o rei continua vivo entao
   doBroadcastMessage("Defenders winners! Time limit was exceed")
   local msg = {["attacker"]="The King Says: Hahaha, i am live, You lost",["defender"]="The King Says: Oh yeah, the king is live! Thank for protect me soldiers!"}
   for _,info in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(info.name) then
          local pid = getCreatureByName(info.name)
          doTeleportThing(pid,getTownTemplePosition(getPlayerTown(pid)))
          doPlayerSendTextMessage(pid,6,msg[getPlayerGroup(pid)])
          if getPlayerGroup(pid) == "defender" then
             premio = doPlayerAddItem(pid,premios[math.random(1,#premios)])
             doPlayerSendTextMessage(pid,MESSAGE_EVENT_DEFAULT,"Voce ganhou 1 ".. getItemName(premio).."")
          end
       end                
   end
doCancelEvent(all_storage,tp_pos,position_gate,position_gate_main,gate_id)
end
return TRUE
end


function getEscolhido()
return db.getResult("SELECT `name` FROM `players_dtk` WHERE `escolhido`=1;"):getDataString("name")
end

function doCancelEvent(all_storage,tp_pos,position_gate,position_gate_main,gate_id)
if isCreature(getGlobalStorageValue(controle_king)) then
   doRemoveCreature(getGlobalStorageValue(controle_king))
end
for _,v in pairs(all_storage) do                     
    setGlobalStorageValue(v,-1)
end
tp = getThingFromPos(tp_pos)
if tp.itemid == tp_itemid and not(nil) then
   doRemoveItem(tp.uid)                         
end
if getDefendPlayersInEvent() ~= FALSE then 
   for _,info in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(info.name) then  
          local pid = getCreatureByName(info.name)
          doPlayerSetTown(pid, info.town)                
          doTeleportThing(pid,getTownTemplePosition(info.town))
          setPlayerStorageValue(pid,death_times,-1)
          setPlayerStorageValue(pid,controle_in_delay,-1)
          unregisterCreatureEvent(pid, "death_king")
       	  unregisterCreatureEvent(pid, "player_death_dtk")
      	  unregisterCreatureEvent(pid, "player_combat")
	      unregisterCreatureEvent(pid, "king") 
	      doSetCreatureOutfit(pid, outfits.default)
          if getPlayerGroup(pid) == "defender" then
             doCreatureSetNoMove(getCreatureByName(info.name), FALSE)
          end
       end
   end
end
doResetGate(position_gate,position_gate_main,gate_id)
db.executeQuery("Delete From `players_dtk`;")
return TRUE
end

function doCreateGate(position_gate,position_gate_main,floor,monster,gate_id)
for i,v in pairs(getPositionsWithFloor(position_gate,floor))  do
    local fence = getThingFromId(gate_id,v)
    local monster_thing = getThingFromPos(position_gate_main)
    if v.x == position_gate_main.x and v.y == position_gate_main.y and v.z == position_gate_main.z and monster == 1 then
       if isCreature(monster_thing) then
          doRemoveCreature(monster_thing)
          doCreateMonster("Gate", position_gate_main)
       elseif fence ~= FALSE then
              doRemoveItem(fence.uid) 
              doCreateMonster("Gate", position_gate_main)
       else
          doCreateMonster("Gate", position_gate_main)     
       end
    else
       if not(fence) then     
          doCreateItem(gate_id,v)
       end
    end
end
end
                                  
function doResetGate(position_gate,position_gate_main,gate_id)
for i,v in pairs(getPositionsWithFloor(position_gate,floor))  do
    local fence = getThingFromId(gate_id,v)
    local monster_thing = getThingFromPos(position_gate_main)
    if not(fence) then        -- Se nao existir fence naquela pos entao...
       doCreateItem(gate_id,v)
    elseif isCreature(monster_thing.uid) then
           doRemoveCreature(monster_thing.uid)
           doCreateItem(gate_id,v)
    end
end
end

function doPlayerSendTextMessageByName(name,type,msg)
if isPlayerOnline(name) then
   doPlayerSendTextMessage(getCreatureByName(name), type, msg)
   return TRUE
end
return FALSE
end


function isPlayerOnline(name)
players=getPlayersOnline()
for _,pid in ipairs(players) do
    if getCreatureName(pid):lower() == name:lower() then
       return true
    end
end
return false
end 

function getWeek()
date = os.date("*t")
return date.wday
end