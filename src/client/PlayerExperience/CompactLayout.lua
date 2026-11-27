-- Full-screen presentation; original Controller and network actions are reused.
local Layout={}
function Layout.apply(view,W)
    local main=view.main
    main.Size=UDim2.fromScale(1,1)
    main.Position=UDim2.fromOffset(0,0)
    main.AnchorPoint=Vector2.new(0,0)
    main.BackgroundTransparency=1
    view.title.Visible=false
    view.help.Text="?  HELP"
    view.help.Size=UDim2.fromOffset(94,44)
    view.shop.Position=UDim2.fromOffset(118,12)
    view.shop.Size=UDim2.fromOffset(86,44)
    view.lobby.Text="Take a seat to play."
    view.lobby.Size=UDim2.new(.7,0,0,44)
    view.subtitle.AnchorPoint=Vector2.new(.5,0)
    view.subtitle.TextXAlignment=Enum.TextXAlignment.Center
    view.subtitle.BackgroundColor3=W.colors.panel
    view.subtitle.BackgroundTransparency=.25
    W.corner(view.subtitle)
    local function frame(parent,name)
        return W.create("Frame",parent,{Name=name,BackgroundTransparency=1,BorderSizePixel=0})
    end
    local function move(control,parent)
        control.Parent=parent
        control.AutomaticSize=Enum.AutomaticSize.None
        control.Position=UDim2.fromOffset(0,0)
        control.Size=UDim2.fromScale(1,1)
        return control
    end
    local function label(parent,name,value,size)
        return move(W.text(parent,name,value,size or 16),parent)
    end
    local function fitText(control,minSize,maxSize)
        control.TextScaled=true
        W.create("UITextSizeConstraint",control,{MinTextSize=minSize or 12,MaxTextSize=maxSize or 20})
    end
    local shell=frame(main,"ActionDock")
    shell.BackgroundColor3=W.colors.panel
    shell.BackgroundTransparency=.3
    W.corner(shell,18)
    W.create("UIStroke",shell,{Color=W.colors.blue,Transparency=.35,Thickness=2})
    local tabs=frame(shell,"ActionTabs")
    local body=frame(shell,"FullscreenContent")
    local pages,buttons={},{}
    for _,name in ipairs({"Ask","Answer","Guess","Info","Presets","Wait"}) do
        pages[name]=frame(body,"Page"..name)
        pages[name].Size=UDim2.fromScale(1,1)
        pages[name].Visible=false
    end
    local waitTitle=label(pages.Wait,"TurnWaiting","Waiting for opponent...",20)
    local waitHistory=label(pages.Wait,"LastExchange","",17)
    -- No ScrollingFrames. Long lists use explicit previous/next pages instead.
    local askTitle=label(pages.Ask,"YourQuestionLabel","ASK ABOUT YOUR PLAYER",19)
    local lastQuestion=label(pages.Ask,"LastSentQuestion","",16)
    lastQuestion.Visible=false
    local presetToggle=W.button(pages.Ask,"ToggleQuickQuestions","QUICK QUESTIONS",W.colors.card)
    move(view.question,pages.Ask)
    move(view.send,pages.Ask).Text="SEND"
    view.question.PlaceholderText="Your question..."
    move(view.questionStatus,pages.Ask)
    local answerTitle=label(pages.Answer,"OpponentQuestionLabel","OPPONENT'S QUESTION",19)
    move(view.incoming,pages.Answer)
    view.incoming.BackgroundColor3=W.colors.card
    view.incoming.BackgroundTransparency=.15
    W.corner(view.incoming,12)
    W.padding(view.incoming,8)
    move(view.yes,pages.Answer)
    move(view.no,pages.Answer)
    move(view.answerStatus,pages.Answer)
    local freeToggle=W.button(pages.Answer,"ToggleFreeAnswer","TYPE",W.colors.card)
    local freeArea=frame(pages.Answer,"FreeAnswerArea")
    freeArea.Visible=false
    move(view.answer,freeArea).PlaceholderText="Your answer..."
    move(view.sendAnswer,freeArea).Text="SEND"
    local guessTitle=label(pages.Guess,"YourGuessLabel","WHO IS YOUR HIDDEN PLAYER?",19)
    move(view.guess,pages.Guess).PlaceholderText="Player's name..."
    move(view.submitGuess,pages.Guess).Text="GUESS"
    move(view.guessStatus,pages.Guess)
    local infoTitle=label(pages.Info,"InfoHeading","OPPONENT'S PLAYER",19)
    -- Keep this original reference for the existing renderer; display the same
    -- data as individual fact tiles so every fact fits without a scroll area.
    move(view.info,pages.Info)
    view.info.Visible=false
    local facts={}
    local fields={
        {"Name","Name"},{"Nationality","Nationality"},{"Club","Club"},{"Age","Age"},
        {"Number","Number"},{"Position","Position"},{"League titles","LeagueTitles"},
        {"UCL titles","UCL"},{"World Cups","WorldCups"},{"Euro titles","Euros"},{"Ballon d'Or","BallonDor"},
    }
    for i,field in ipairs(fields) do
        local tile=label(pages.Info,"PlayerFact"..i,field[1]..": ?",16)
        tile.BackgroundColor3=W.colors.card
        tile.BackgroundTransparency=.18
        fitText(tile,11,18)
        W.corner(tile,8)
        W.padding(tile,4)
        facts[i]=tile
    end
    local presetHeading=label(pages.Presets,"PresetHeading","QUICK QUESTIONS",19)
    local choices=view.presetButtons
    for _,choice in ipairs(choices) do
        move(choice.button,pages.Presets)
        fitText(choice.button,12,18)
    end
    local previous=W.button(pages.Presets,"PreviousQuestions","< BACK",W.colors.card)
    local nextButton=W.button(pages.Presets,"NextQuestions","NEXT >",W.colors.card)
    local pageNumber=label(pages.Presets,"QuestionPageNumber","",15)
    pageNumber.TextXAlignment=Enum.TextXAlignment.Center
    local selected="Wait"
    local mode="WAIT"
    local unreadAnswer=false
    local listPage,perPage=1,4
    local updateLayout
    local function selectPage(name)
        local allowed=mode=="ASK" and (name=="Ask" or name=="Guess" or name=="Presets")
            or mode=="ANSWER" and (name=="Answer" or name=="Info")
            or mode=="WAIT" and name=="Wait"
        if not allowed then return end
        selected=name
        if name=="Ask" then unreadAnswer=false end
        for key,page in pairs(pages) do page.Visible=key==name end
        for key,button in pairs(buttons) do
            local active=key==name or key=="Ask" and name=="Presets"
            button.BackgroundColor3=active and W.colors.blue or W.colors.card
        end
        if not unreadAnswer then buttons.Ask.Text="ASK" end
    end
    for i,name in ipairs({"Ask","Answer","Guess","Info"}) do
        local caption=name=="Info" and "PLAYER INFO" or string.upper(name)
        local button=W.button(tabs,"Tab"..name,caption,W.colors.card)
        buttons[name]=button
        button.Activated:Connect(function() selectPage(name) end)
    end
    local function setFree(open)
        freeArea.Visible=open
        view.yes.Visible=not open
        view.no.Visible=not open
        freeToggle.Text=open and "YES / NO" or "TYPE"
    end
    freeToggle.Activated:Connect(function() setFree(not freeArea.Visible) end)
    presetToggle.Activated:Connect(function() selectPage("Presets") end)
    previous.Activated:Connect(function() listPage=math.max(1,listPage-1) updateLayout() end)
    nextButton.Activated:Connect(function()
        listPage=math.min(math.max(1,math.ceil(#choices/perPage)),listPage+1)
        updateLayout()
    end)
    for _,choice in ipairs(choices) do
        choice.button.Activated:Connect(function() selectPage("Ask") end)
    end
    local function rect(control,x,y,width,height)
        control.Position=UDim2.fromOffset(x,y)
        control.Size=UDim2.fromOffset(math.max(0,width),math.max(0,height))
    end
    local sentQuestion=""
    updateLayout=function()
        local screen=view.gui.AbsoluteSize
        local narrow=screen.X<700
        local top=narrow and 112 or 68
        local shellWidth=math.max(0,screen.X-24)
        local shellHeight=math.max(0,screen.Y-top-12)
        rect(shell,12,top,shellWidth,shellHeight)
        view.subtitle.Position=UDim2.new(.5,0,0,narrow and 64 or 12)
        view.subtitle.Size=UDim2.fromOffset(narrow and screen.X-32 or math.min(340,screen.X-460),36)
        local available=mode=="ASK" and {"Ask","Guess"} or mode=="ANSWER" and {"Answer","Info"} or {}
        local tabHeight=#available>0 and 44 or 0
        rect(tabs,12,12,shellWidth-24,tabHeight)
        local contentWidth=math.min(960,shellWidth-32)
        local contentHeight=math.max(0,shellHeight-tabHeight-40)
        rect(body,(shellWidth-contentWidth)/2,tabHeight+24,contentWidth,contentHeight)
        for _,button in pairs(buttons) do button.Visible=false end
        for i,name in ipairs(available) do
            local width=(shellWidth-30)/#available
            buttons[name].Visible=true
            rect(buttons[name],(i-1)*(width+2),0,width-4,44)
        end
        local w,h=contentWidth,contentHeight
        local heading=28
        local gap=10
        local rowHeight=44
        rect(waitTitle,0,0,w,math.min(80,h*.3))
        rect(waitHistory,0,math.min(80,h*.3)+12,w,h-math.min(80,h*.3)-12)
        -- ASK: title, input, quick choice, previous question and latest answer.
        rect(askTitle,0,0,w,heading)
        rect(view.question,0,38,w-104,rowHeight)
        rect(view.send,w-96,38,96,rowHeight)
        rect(presetToggle,0,92,math.min(190,w),rowHeight)
        rect(lastQuestion,0,146,w,math.max(0,(h-156)*.44))
        lastQuestion.Visible=sentQuestion~=""
        local feedbackTop=sentQuestion~="" and 146+math.max(0,(h-156)*.44)+gap or 146
        rect(view.questionStatus,0,feedbackTop,w,h-feedbackTop)
        -- ANSWER: same space for YES/NO or a typed answer, never below the fold.
        rect(answerTitle,0,0,w-110,heading)
        rect(freeToggle,w-104,0,104,36)
        local incomingHeight=math.max(48,math.min(110,(h-108)*.5))
        rect(view.incoming,0,42,w,incomingHeight)
        local actionTop=52+incomingHeight
        rect(view.yes,0,actionTop,(w-gap)/2,rowHeight)
        rect(view.no,(w+gap)/2,actionTop,(w-gap)/2,rowHeight)
        rect(freeArea,0,actionTop,w,rowHeight)
        rect(view.answer,0,0,w-104,rowHeight)
        rect(view.sendAnswer,w-96,0,96,rowHeight)
        rect(view.answerStatus,0,actionTop+rowHeight+gap,w,h-actionTop-rowHeight-gap)
        rect(guessTitle,0,0,w,heading)
        rect(view.guess,0,44,w-104,rowHeight)
        rect(view.submitGuess,w-96,44,96,rowHeight)
        rect(view.guessStatus,0,100,w,h-100)
        rect(infoTitle,0,0,w,heading)
        local columns=w>=700 and 3 or 2
        local rows=math.ceil(#facts/columns)
        local tileWidth=(w-gap*(columns-1))/columns
        local tileHeight=(h-40-gap*(rows-1))/rows
        for i,tile in ipairs(facts) do
            rect(tile,((i-1)%columns)*(tileWidth+gap),40+math.floor((i-1)/columns)*(tileHeight+gap),tileWidth,tileHeight)
        end
        rect(presetHeading,0,0,w,heading)
        perPage=math.max(1,math.floor((h-96)/54))
        local count=math.max(1,math.ceil(#choices/perPage))
        listPage=math.min(listPage,count)
        for i,choice in ipairs(choices) do
            local slot=i-(listPage-1)*perPage
            choice.button.Visible=slot>=1 and slot<=perPage
            if choice.button.Visible then rect(choice.button,0,38+(slot-1)*54,w,44) end
        end
        rect(previous,0,h-44,100,44)
        rect(nextButton,w-100,h-44,100,44)
        rect(pageNumber,104,h-44,w-208,44)
        pageNumber.Text=listPage.." / "..count
        W.enabled(previous,listPage>1)
        W.enabled(nextButton,listPage<count)
    end
    for _,control in ipairs({askTitle,answerTitle,guessTitle,infoTitle,presetHeading,view.incoming,
        lastQuestion,view.questionStatus,view.answerStatus,view.guessStatus,waitTitle,waitHistory}) do fitText(control,12,20) end
    main:FindFirstChild("RoundContent"):Destroy()
    view.gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
    task.defer(updateLayout)
    selectPage("Wait")
    local originalRender=view.render
    local previousActive,previousData=false,nil
    local previousQuestionStatus=""
    local initialText={
        ["Write a question or choose a quick question."]=true,
        ["Your opponent's question will appear here."]=true,
        ["Choose YES/NO, or write an answer below."]=true,
        ["Use the answers to work out your hidden player's name."]=true,
    }
    function view:render(state)
        originalRender(self,state)
        if state.active and (not previousActive or state.data==nil and previousData~=nil) then
            mode="WAIT"
            selectPage("Wait")
            sentQuestion,previousQuestionStatus="",""
        end
        previousActive,previousData=state.active,state.data
        local nextMode=state.canAsk and not state.questionPending and not state.guessPending and "ASK"
            or state.canAnswer and "ANSWER" or "WAIT"
        if nextMode~=mode then
            mode=nextMode
            selectPage(mode=="ASK" and "Ask" or mode=="ANSWER" and "Answer" or "Wait")
            if mode=="ANSWER" then setFree(true) end
        end
        self.subtitle.Text=(mode=="ASK" and "YOUR TURN" or mode=="ANSWER" and "YOUR ANSWER" or "OPPONENT'S TURN").."  |  "..state.opponent
        for _,control in ipairs({self.questionStatus,self.answerStatus,self.guessStatus}) do
            if initialText[control.Text] then control.Text="" end
        end
        sentQuestion=state.lastQuestion or ""
        if previousQuestionStatus~=state.questionStatus and state.questionStatus:match("^Your opponent answered:") and selected~="Ask" then unreadAnswer=true end
        if selected=="Ask" then unreadAnswer=false end
        previousQuestionStatus=state.questionStatus
        buttons.Ask.Text=unreadAnswer and "ASK !" or "ASK"
        buttons.Answer.Text=state.active and state.incoming~="" and not state.answered and "ANSWER !" or "ANSWER"
        lastQuestion.Text="You asked: "..sentQuestion
        waitTitle.Text=state.questionPending and "Sending your question..."
            or state.guessPending and "Checking your guess..."
            or state.turnMessage or "Waiting for opponent..."
        local exchange={}
        if sentQuestion~="" then table.insert(exchange,"You asked: "..sentQuestion) end
        if state.lastAnswer and state.lastAnswer~="" then table.insert(exchange,"Answer: "..state.lastAnswer) end
        if state.guessStatus~="" and not initialText[state.guessStatus] then table.insert(exchange,state.guessStatus) end
        if state.questionPending then table.insert(exchange,"Sending your question...") end
        waitHistory.Text=table.concat(exchange,"\n\n")
        for i,field in ipairs(fields) do facts[i].Text=field[1]..": "..tostring(state.data and state.data[field[2]] or "?") end
        updateLayout()
    end
end
return Layout
