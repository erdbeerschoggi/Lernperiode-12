-- Isolated turn rules; difficulty, bonus selection, prizes and rematch stay in GameService.
local Turn={}
local function other(pair,player)
    return player==pair.player1 and pair.player2 or pair.player1
end
function Turn.sync(pair,event,recipient)
    local turn=pair.turn
    if not turn then return end
    for _,player in ipairs({pair.player1,pair.player2}) do
        if player.Parent and (not recipient or recipient==player) then
            local asking=turn.actor==player
            event:FireClient(player,"TURN_STATE",{
                id=turn.id,opponent=other(pair,player).Name,
                canAsk=asking and turn.phase=="ASK",
                canAnswer=not asking and turn.phase=="ANSWER",
                mode=asking and turn.phase=="ASK" and "ASK"
                    or not asking and turn.phase=="ANSWER" and "ANSWER" or "WAIT",
                question=not asking and turn.question or "",
                message=turn.phase=="ASK" and (asking and "Your turn: ask or guess." or "Opponent is choosing a question.")
                    or turn.phase=="ANSWER" and (asking and "Waiting for an answer." or "Answer your opponent's question.")
                    or "Sending...",
            })
        end
    end
end
function Turn.start(pair,event)
    pair.turnSerial=(pair.turnSerial or 0)+1
    pair.turnStarter=pair.turnStarter==pair.player1 and pair.player2 or pair.player1
    pair.turn={id=pair.turnSerial,actor=pair.turnStarter,phase="ASK"}
    Turn.sync(pair,event)
end
function Turn.claim(pair,player,action,id)
    local turn=pair.turn
    if not turn or id~=nil and id~=turn.id then return nil end
    local valid=action=="ANSWER" and player~=turn.actor and turn.phase=="ANSWER"
        or (action=="QUESTION" or action=="GUESS") and player==turn.actor and turn.phase=="ASK"
    if not valid then return nil end
    turn.phase=action.."_FILTER"
    return turn
end
function Turn.current(pair,ticket)
    return pair.turn==ticket and pair.started and not pair.finished
end
function Turn.retry(pair,ticket,action,event)
    if not Turn.current(pair,ticket) then return end
    ticket.phase=action=="ANSWER" and "ANSWER" or "ASK"
    Turn.sync(pair,event)
end
function Turn.advance(pair,event)
    local actor=other(pair,pair.turn.actor)
    pair.turnSerial=pair.turnSerial+1
    pair.turn={id=pair.turnSerial,actor=actor,phase="ASK"}
    Turn.sync(pair,event)
end
function Turn.stop(pair) pair.turn=nil end
return Turn
