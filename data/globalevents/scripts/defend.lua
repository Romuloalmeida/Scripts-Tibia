dofile("config-dtk.lua")
print("Your server have Defend The King v1.0 by [OTProjects.com.br] Thank you!")


function onTime(interval)

cod_week = {[1]="domingo",[2]="segunda",[3]="terca",[4]="quarta",[5]="quinta",[6]="sexta",[7]="sabado"}
         if config_week[cod_week[getWeek()]] == 1 then            
            setGlobalStorageValue(controle_geral,1)
            doBroadcastMessage("Event Defend the King has been started. Enter in teleport opened in ".. tp_city .." during ".. tempo_espera .." minutes!")
            tp = doCreateItem(tp_itemid,tp_pos)
            doItemSetAttribute(tp, "aid", 99887)
            doSendMagicEffect(getThingPosition(tp), 10)
            addEvent(doPrepareToStart,tempo_espera*60*1000,controle_atived,position_gate,position_gate_main,floor,control_total_players,all_storage,tp_pos,controle_geral,gate_id) 
           end
print("Fooooooooooooi")
return TRUE
end

--############################# Funções ############################

function doPrepareToStart(controle_atived,position_gate,position_gate_main,floor,control_total_players,all_storage,tp_pos,controle_geral,gate_id)
if getDefendTotalValue(control_total_players) == -1 then
   setGlobalStorageValue(control_total_players,0)
end
         if getDefendTotalValue(controle_atived) == -1 and getDefendTotalValue(controle_geral) == 1 then
             if getDefendTotalValue(control_total_players) >= min_event then 
                setGlobalStorageValue(controle_atived,1)
                doBroadcastMessage("The event Defense the King is now starting with ".. getDefendTotalValue(control_total_players) .." players, and teleport remains open until it reaches FULL!")
                delay = 0
                objetivo = {["attacker"]="Invadir o castelo inimigo, e matar o rei, The King, em um tempo maximo de ".. tempo_round .." minutos. Prepare suas Hotkey!!",
                           ["defender"]="Defender o rei The King a todo custo durante " .. tempo_round .." minutos, em seu castelo, escondendo-o. No inicio do evento, o Rei escolherá um membro para controla-lo."} 
                addEvent(doObjetivoForAll,5000,objetivo)
                delay = 5000
                for i=5,1,-1 do
                    delay = delay + 2000
                    addEvent(doSendMessageForAll,delay,MESSAGE_STATUS_CONSOLE_BLUE,"The event start in: "..i)
                    if i == 1 then
                       delay = delay + 3000     
                       --//   Inicio da programaçao quando termina contagem regressiva inicial.                   
                       addEvent(doSendMessageForAll,delay,MESSAGE_STATUS_CONSOLE_BLUE,"The event is now starting...")
                       addEvent(doStart,delay+2000,position_gate,position_gate_main,floor,gate_id)
                    end
                end   
             else
                doBroadcastMessage("Infelizmente, o evento nao vai começar porque nao atingiu a lotação minima de " .. min_event .." players nescessario para o evento.")                                                               
                doCancelEvent(all_storage,tp_pos,position_gate,position_gate_main,gate_id)
             end
         end
end

function doTeleportAll(pos_all,group)
if not(group) then
   for i,v in pairs(getDefendPlayersInEvent()) do
       if isPlayerOnline(v.name) then
          local pid = getCreatureByName(v.name) 
          doTeleportThing(pid,getTownTemplePosition(getPlayerTown(pid)))
          doSendMagicEffect(getCreaturePosition(pid), 10)
       end
   end
else
   for i,v in pairs(getDefendPlayersInEvent(group)) do
       if isPlayerOnline(v.name) then
          local pid = getCreatureByName(v.name) 
          doTeleportThing(pid,getTownTemplePosition(getPlayerTown(pid)))
          doSendMagicEffect(getCreaturePosition(pid), 10)
       end
   end
end
return TRUE
end

function doObjetivoForAll(objetivo)
for _,v in pairs(getDefendPlayersInEvent()) do
    doPlayerSendTextMessage(getCreatureByName(v.name),MESSAGE_STATUS_CONSOLE_ORANGE,"Seu objetivo: "..objetivo[v.group])
end
end                   

function doAddEscolhido(name)
db.executeQuery("UPDATE `players_dtk` SET `escolhido`=1 WHERE `name`='".. name .."';")
return TRUE
end 

function getWeek()
date = os.date("*t")
return date.wday
end