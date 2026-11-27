local Protocol = require(script.Parent.Protocol)
local Bridge = require(script.Parent.LegacyBridge)
local GameView = require(script.Parent.GameView)
local Tutorial = require(script.Parent.Tutorial)
local W = require(script.Parent.Widgets)
local Controller = {}
function Controller.start()
    local Players=game:GetService("Players")
    local RS=game:GetService("ReplicatedStorage")
    local UIS=game:GetService("UserInputService")
    local player=Players.LocalPlayer
    local playerGui=player:WaitForChild("PlayerGui")
    -- One bootstrap per client, even after respawn/re-sync.
    if playerGui:FindFirstChild("PlayerExperienceGUI") then return end
    local chairEvent=RS:WaitForChild("ChairGameEvent",30)
    local actionEvent=RS:WaitForChild("GameActionEvent",30)
    local legacyGui=playerGui:WaitForChild("GuessPlayerGUI",30)
    if not chairEvent or not actionEvent or not legacyGui then
        warn("PlayerExperience: game UI/remotes unavailable; original UI kept.")
        return
    end
    local refs=Bridge.find(legacyGui)
    for _=1,50 do
        if refs then break end
        task.wait(.1)
        refs=Bridge.find(legacyGui)
    end
    if not refs then
        warn("PlayerExperience: unfamiliar UI structure; original UI kept.")
        return
    end
    -- Build completely BEFORE hiding anything. A construction error leaves the
    -- original controls untouched and usable.
    local ok,view,tutorial=pcall(function()
        return GameView.create(playerGui,refs.questions),Tutorial.create(playerGui)
    end)
    if not ok then
        for _,name in ipairs({"PlayerExperienceGUI","PlayerExperienceTutorial"}) do
            local partial=playerGui:FindFirstChild(name)
            if partial then partial:Destroy() end
        end
        warn("PlayerExperience: new UI could not be built; original UI kept.")
        return
    end
    local state=Protocol.new()
    state.active=refs.gameFrame.Visible
    local cooldown={QUESTION=0,GUESS=0}
    local pendingRaw={}
    local connections={}
    local stopped=false
    local attached=Bridge.attach(refs,function()
        if stopped then return end
        view.main.Visible=state.active and refs.gameFrame.Visible and not refs.shopFrame.Visible
        view.lobby.Visible=not state.active and not state.rematchOpen and not refs.shopFrame.Visible and not (refs.rematchFrame and refs.rematchFrame.Visible)
    end)
    local function refresh()
        if stopped then return end
        view.main.Visible=state.active and refs.gameFrame.Visible and not refs.shopFrame.Visible
        view.lobby.Visible=not state.active and not state.rematchOpen and not refs.shopFrame.Visible and not (refs.rematchFrame and refs.rematchFrame.Visible)
        view:render(state)
        W.enabled(view.send,state.active and state.canAsk and not state.questionPending and not state.guessPending and os.clock()>=cooldown.QUESTION)
        W.enabled(view.submitGuess,state.active and state.canAsk and not state.questionPending and not state.guessPending and os.clock()>=cooldown.GUESS)
        view.question.TextEditable=state.canAsk and not state.questionPending and not state.guessPending
        view.guess.TextEditable=state.canAsk and not state.questionPending and not state.guessPending
        W.enabled(view.yes,state.active and state.canAnswer and not state.answerPending)
        W.enabled(view.no,state.active and state.canAnswer and not state.answerPending)
        W.enabled(view.sendAnswer,state.active and state.canAnswer and not state.answerPending)
    end
    local function send(action,box)
        if stopped or not state.active or not view.main.Visible or tutorial.overlay.Visible then return end
        if not state.canAsk or state.questionPending or state.guessPending then return end
        if os.clock()<cooldown[action] then return end
        local text,errorMessage=Protocol.validate(box.Text)
        local field=action=="QUESTION" and "questionStatus" or "guessStatus"
        if not text then state[field]=errorMessage refresh() return end
        cooldown[action]=os.clock()+1
        pendingRaw[action]=box.Text
        if action=="QUESTION" then
            state.submittedQuestion=text
            state.questionPending=true
            state.questionStatus="Sending question..."
        else
            state.submittedGuess=text
            state.guessPending=true
            state.guessStatus="Sending guess..."
        end
        refresh()
        -- Keep the draft until the server acknowledges success. Show server errors.
        actionEvent:FireServer(action,text,state.turnId)
        task.delay(1.05,refresh)
    end
    table.insert(connections,view.send.Activated:Connect(function() send("QUESTION",view.question) end))
    table.insert(connections,view.submitGuess.Activated:Connect(function() send("GUESS",view.guess) end))
    -- FocusLost alone NEVER submits. Enter and the visible button share one path.
    table.insert(connections,view.question.FocusLost:Connect(function(enterPressed)
        if enterPressed then send("QUESTION",view.question) end
    end))
    table.insert(connections,view.guess.FocusLost:Connect(function(enterPressed)
        if enterPressed then send("GUESS",view.guess) end
    end))
    local function answer(value)
        if not state.active or not view.main.Visible or tutorial.overlay.Visible
            or not state.canAnswer or state.incoming=="" or state.answered or state.answerPending then return end
        local text,errorMessage=Protocol.validate(value)
        if not text then state.answerStatus=errorMessage refresh() return end
        state.answerPending=true
        state.pendingRevision=state.questionRevision
        state.answerStatus="Sending answer ..."
        refresh()
        actionEvent:FireServer("ANSWER",text,state.turnId)
    end
    table.insert(connections,view.yes.Activated:Connect(function() answer("YES") end))
    table.insert(connections,view.no.Activated:Connect(function() answer("NO") end))
    table.insert(connections,view.sendAnswer.Activated:Connect(function() answer(view.answer.Text) end))
    table.insert(connections,view.answer.FocusLost:Connect(function(enterPressed)
        if enterPressed then answer(view.answer.Text) end
    end))
    for _,choice in ipairs(view.presetButtons) do
        table.insert(connections,choice.button.Activated:Connect(function()
            if not state.active or not view.main.Visible or tutorial.overlay.Visible then return end
            view.question.Text=choice.text
            send("QUESTION",view.question)
        end))
    end
    table.insert(connections,view.help.Activated:Connect(function() tutorial:open() end))
    table.insert(connections,view.shop.Activated:Connect(function() refs.shopFrame.Visible=true end))
    table.insert(connections,UIS.InputBegan:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.Escape and tutorial.overlay.Visible then tutorial:close() end
    end))
    table.insert(connections,chairEvent.OnClientEvent:Connect(function(status,value)
        if Protocol.receive(state,status,value) then
            if status=="QUESTION_SENT" and view.question.Text==pendingRaw.QUESTION then
                view.question.Text=""
            end
            if status=="WRONG_GUESS" and view.guess.Text==pendingRaw.GUESS then
                view.guess.Text=""
            end
            if status=="START" or status=="WIN" or status=="LOSE" or status=="SELECT_CANCEL" then
                view.question.Text=""
                view.guess.Text=""
                view.answer.Text=""
                cooldown.QUESTION=0
                cooldown.GUESS=0
                if status~="START" then tutorial:close() end
            end
            if status=="OPPONENT_QUESTION" or status=="ANSWER_SENT" and state.answered then
                view.answer.Text=""
            end
            refresh()
        end
    end))
    table.insert(connections,player.CharacterAdded:Connect(function()
        state.active=false
        state.incoming=""
        state.rematchOpen=false
        state.answerPending=false
        view.answer.Text=""
        view.question.Text=""
        view.guess.Text=""
        tutorial:close()
        refresh()
    end))
    local function cleanup()
        if stopped then return end
        stopped=true
        for _,connection in ipairs(connections) do connection:Disconnect() end
        attached() -- Restore original controls if the addon is removed.
        tutorial.gui:Destroy()
        if view.gui.Parent then view.gui:Destroy() end
    end
    table.insert(connections,view.gui.Destroying:Connect(cleanup))
    refresh()
    -- Recover turn/data if this addon starts after the native round's START event.
    actionEvent:FireServer("TURN_SYNC")
    return cleanup
end
return Controller
