--[[ Defend the King v1.0
        \--=======--/
Empresa: OT Projects
        /--=======--\
Scripter responsável: Rômulo Souza de Almeida
]]  

--// HORARIO AUTOMATICO   (horas define em: data/globalevents/globalevents.xml)
-- Coloque: 0 para NAO executar | 1 para executar
config_week = {
        ["domingo"]=1,
        ["segunda"]=1,
        ["terca"]=1,
        ["quarta"]=1,
        ["quinta"]=1,
        ["sexta"]=1,
        ["sabado"]=1,
       }

--// Configurações Básicas
min_event = 2                    -- Minimo de players no evento            
max_event = 10                   -- Maximo de players no evento
tempo_espera = 0.8                 -- Tempo em minutos pelo minimo de jogadores no evento até a lotação maxima
tempo_round = 10                  -- Tempo em minutos para o evento iniciado.  
--// Outfits

outfits = {["attacker"]={lookType = 134, lookHead = 40, lookAddons = 3, lookLegs = 132, lookBody = 132, lookFeet = 77},  -- Outfits dos atacantes
           ["defender"]={lookType = 268, lookHead = 116, lookAddons = 3, lookLegs = 0, lookBody = 0, lookFeet = 114},    -- Outfits dos defensores
           ["default"]={lookType = 128, lookHead = 114, lookAddons = 1, lookLegs = 0, lookBody = 0, lookFeet = 114}   -- Outfit apos o evento
          }
--// Premios 
premios = {2486,2494,2656,5953,8266,5810}   -- ID dos premios
--// Configurações de segurança
block_ip = 0    -- Bloquear a entrada de players com mesmo ip ao teleport? ( 0=NAO, 1=SIM )
min_level = 0  -- Level minimo para entrada no evento.

--// Configurações de Teleport
tp_city = "Cidade de teste"     -- Nome da cidade que sera aberta o TP. Muito simples, usada apenas para a BroadCast, nada demais.

--///Configuração EXTREMAMENTE IMPORTANTE
towns_id = {
["defender"] = 2,
["attacker"] = 3
}
--///////////////////////////////////////

tp_itemid = 1387    -- ID do teleport
tp_pos = {x=153,y=123,z=7,stackpos=1}      -- Posição que será criada o Teleport para o Evento
--[[

//Configuração do gate -> Essa é uma parte importante, qualquer numeros a mais, pode falhar o sistema.

No mapa editor, colocar piso invisivel sobre o Gate que esteje acima do ground ( z maior que 7 ,por exemplo)
                                                          ____
Em position_gate coloque todos os lugares que contenha a |BASE| do Gate ( portão ) daonde os atacantes irão invadir o castelo.
em position_gate_main coloque o lugar onde sera criado o monstro "Gate", para que o portao seja destruido. Ele é geralmente o muro central.
]]

gate_id = 1547      -- ID do gate, tem que ser o mesmo de monsters/gate.xml, onde: <look typeex="1547" <<aqui 
position_gate_main = {x=203,y=156,z=7,stackpos=253}    -- Onde o "monstro" Gate sera criado, geralmente ele é o central

position_gate = {{x=202,y=156,z=7,stackpos=255},  -- Base do portao.Se tiver mais portao acima do ground, favor, adicione na configuração a seguir.
                 {x=203,y=156,z=7,stackpos=255},  -- Base do portao
                 {x=204,y=156,z=7,stackpos=255},  -- Base do portao
                 {x=205,y=156,z=7,stackpos=255}   -- Base do portao
                                                  -- Se for adicionar mais, adicione a mesma linha, seguindo o modelo, se for remover, remova a linha.
                 }
floor = 1        -- Andares do Gate. Ou seja, quantos andares acima, tem seu Gate?


-- //Configurações avançadas, mudar somente em caso de conflito com algum outro Script.
-- Storage
controle_geral = 312211              -- Verifica se o evento esta ativo
controle_atived = 134322             -- Verifica se o evento ja começou!
controle_player = 342315             -- Verifica se o player ja esta participando
controle_tempo = 143261             -- Verifica o tempo do evento para matar o king
controle_started = 142313            -- Verifica se o evento começou.
controle_king = 164231            -- Verifica se o King esta Online
controle_king_death = 343242      -- Verifica se o king morreu ou nao
controle_round = 664326     -- Verifica quantidades de rounds iniciadas
control_attacker = 542353           
control_defender = 254234           
control_total_players = 454322    
controle_walk_king = 734232         -- Rei parado, rei andando.
controle_voice = 374322
death_times = 264323                -- Player Storage
controle_in_delay = 64323
controle_convince_pid = 754233
all_storage = {controle_convince_pid,controle_geral,controle_player,controle_tempo,control_attacker,control_defender,control_total_players,controle_atived,controle_started,controle_king,controle_round,controle_walk_king,controle_voice,controle_king_death}
--##################################################################