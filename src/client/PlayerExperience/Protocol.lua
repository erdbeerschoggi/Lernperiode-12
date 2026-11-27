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
        turnId=0,mode="WAIT",canAsk=false,canAnswer=false,turnMessage="Connecting...",
        questionPending=false,guessPending=false,submittedQuestion="",lastQuestion="",
        lastAnswer="",submittedGuess="",
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
    elseif status=="WIN" or status=="LOSE" or status=="SELECT_CANCEL" then
        state.active=false
        state.canAsk=false
        state.canAnswer=false
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
    elseif status=="TURN_STATE" and type(value)=="table" then
        if type(value.id)~="number" or value.id<state.turnId then return false end
        -- A server sync also recovers an addon that loaded just after START.
        state.active=true
        state.rematchOpen=false
        state.turnId=value.id
        state.mode=value.mode
        state.canAsk=value.canAsk==true
        state.canAnswer=value.canAnswer==true
        state.turnMessage=value.message or ""
        state.opponent=value.opponent or state.opponent
        local incoming=value.question or ""
        if incoming~=state.incoming then
            state.incoming=incoming
            state.questionRevision=state.questionRevision+1
            state.answered=false
        end
    elseif not state.active then return false
    elseif status=="QUESTION_SENT" then
        state.questionPending=false
        state.lastQuestion=state.submittedQuestion
        state.lastAnswer=""
        state.questionStatus="Question sent. Waiting for an answer."
    elseif status=="QUESTION_ERROR" and type(value)=="string" then
        state.questionPending=false
        state.questionStatus=value
    elseif status=="GUESS_ERROR" and type(value)=="string" then
        state.guessPending=false
        state.guessStatus=value
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
        state.lastAnswer=value
    elseif status=="OPPONENT_GUESS" and type(value)=="string" then
        state.guessStatus="Opponent's guess: "..value
    elseif status=="WRONG_GUESS" then
        state.guessPending=false
        state.guessStatus="Wrong guess. Your opponent goes next."
    else return false end
    return true
end
return Protocol
