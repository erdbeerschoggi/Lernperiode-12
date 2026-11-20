local Protocol={}
function Protocol.validate(value)
    if type(value)~="string" then return nil,"Please enter some text." end
    local text=value:gsub("%c"," "):match("^%s*(.-)%s*$")
    if text=="" then return nil,"Please enter some text first." end
    -- Same byte limit as the unchanged TextUtils.filterText module.
    if #text>100 then return nil,"This text is too long. Please shorten it." end
    return text
end
function Protocol.new()
    return {
        active=false,opponent="",incoming="",answered=false,answerPending=false,
        questionRevision=0,pendingRevision=0,rematchOpen=false,
        questionStatus="Write a question or choose a quick question.",
        answerStatus="Your opponent's question will appear here.",
        guessStatus="Use the answers to work out your hidden player's name.",
    }
end
function Protocol.receive(state,status,value)
    if status=="START" then
        local fresh=Protocol.new()
        for key,val in pairs(fresh) do state[key]=val end
        state.data=nil
        state.active=true
        state.opponent=type(value)=="string" and value or "Opponent"
    elseif status=="WIN" or status=="LOSE" then
        state.active=false
        state.incoming=""
        state.answerPending=false
        state.answered=false
    elseif status=="REMATCH_PROMPT" or status=="REMATCH_UPDATE" then
        state.active=false
        state.rematchOpen=true
    elseif status=="REMATCH_END" then
        state.active=false
        state.rematchOpen=false
    elseif status=="WAITING" then
        state.active=false
    elseif not state.active then return false
    elseif status=="PLAYER_DATA" and type(value)=="table" then
        state.data=value
    elseif status=="OPPONENT_QUESTION" and type(value)=="string" then
        state.incoming=value
        state.questionRevision=state.questionRevision+1
        state.answered=false
        state.answerStatus="Choose YES/NO, or write an answer below."
    elseif status=="ANSWER_SENT" then
        if state.answerPending and state.pendingRevision==state.questionRevision then
            state.answered=true
            state.answerStatus="Answer sent!"
        end
        state.answerPending=false
    elseif status=="ANSWER_ERROR" and type(value)=="string" then
        state.answerPending=false
        state.answered=false
        state.answerStatus=value
    elseif status=="OPPONENT_ANSWER" and type(value)=="string" then
        -- Keep free-text answers introduced by the team, not only YES/NO.
        state.questionStatus="Your opponent answered: "..value
    elseif status=="OPPONENT_GUESS" and type(value)=="string" then
        state.guessStatus="Opponent's guess: "..value
    elseif status=="WRONG_GUESS" then
        state.guessStatus="Not correct yet. Ask another question and try again."
    else return false end
    return true
end
return Protocol
