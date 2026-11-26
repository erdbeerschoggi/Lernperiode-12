-- Presentation only. Reuses the exact controls connected by Controller.lua.
local Layout = {}
function Layout.apply(view, W)
    local main=view.main
    main.Size=UDim2.fromScale(1,1)
    main.Position=UDim2.fromOffset(0,0)
    main.AnchorPoint=Vector2.new(0,0)
    main.BackgroundTransparency=1
    view.title.Visible=false
    view.help.Text="?  HELP"
    view.help.Size=UDim2.fromOffset(100,44)
    view.lobby.Text="Take a seat to play."
    view.lobby.Size=UDim2.new(.7,0,0,44)
    view.shop.Position=UDim2.fromOffset(16,64)
    view.shop.Size=UDim2.fromOffset(100,44)
    view.subtitle.AnchorPoint=Vector2.new(.5,0)
    view.subtitle.TextXAlignment=Enum.TextXAlignment.Center
    view.subtitle.BackgroundColor3=W.colors.panel
    view.subtitle.BackgroundTransparency=.08
    W.corner(view.subtitle)
    local function panel(name)
        local frame=W.create("Frame",main,{Name=name,BackgroundColor3=W.colors.panel,
            BackgroundTransparency=.06,BorderSizePixel=0})
        W.corner(frame,14)
        return frame
    end
    local function place(control,parent,x,y,width,height)
        control.Parent=parent
        control.Position=UDim2.fromOffset(x,y)
        control.Size=UDim2.new(1,width,0,height)
        control.AutomaticSize=Enum.AutomaticSize.None
    end
    local function label(parent,name,value,y,height)
        local result=W.text(parent,name,value,15)
        place(result,parent,0,y,0,height)
        return result
    end
    local dock=panel("ActionDock")
    dock.AnchorPoint=Vector2.new(.5,1)
    dock.Position=UDim2.new(.5,0,1,-12)
    local tabs=W.create("Frame",dock,{Name="ActionTabs",BackgroundTransparency=1,
        Position=UDim2.fromOffset(10,10),Size=UDim2.new(1,-20,0,44)})
    local scroll=W.create("ScrollingFrame",dock,{Name="CompactRoundContent",
        Position=UDim2.fromOffset(14,64),Size=UDim2.new(1,-28,1,-76),
        BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=4})
    local pages,buttons={},{}
    for _,name in ipairs({"Ask","Answer","Guess"}) do
        pages[name]=W.create("Frame",scroll,{Name="Page"..name,BackgroundTransparency=1,
            Size=UDim2.new(1,-8,0,name=="Ask" and 220 or 194),Visible=false})
    end
    local function inputRow(box,button,page,y,placeholder,caption)
        place(box,page,0,y,-104,44)
        box.PlaceholderText=placeholder
        place(button,page,0,y,0,44)
        button.Position=UDim2.new(1,-96,0,y)
        button.Size=UDim2.fromOffset(96,44)
        button.Text=caption
    end
    label(pages.Ask,"YourQuestionLabel","YOUR QUESTION",0,20).TextColor3=W.colors.muted
    inputRow(view.question,view.send,pages.Ask,28,"Ask about your hidden player...","SEND")
    local presetToggle=W.button(pages.Ask,"ToggleQuickQuestions","QUICK QUESTIONS",W.colors.card)
    presetToggle.Position=UDim2.fromOffset(0,82)
    presetToggle.Size=UDim2.fromOffset(170,38)
    place(view.questionStatus,pages.Ask,0,128,0,86)
    view.questionStatus.TextYAlignment=Enum.TextYAlignment.Top
    local lastQuestion=label(pages.Ask,"LastSentQuestion","",128,52)
    lastQuestion.Visible=false
    lastQuestion.TextYAlignment=Enum.TextYAlignment.Top
    label(pages.Answer,"OpponentQuestionLabel","OPPONENT'S QUESTION",0,20).TextColor3=W.colors.muted
    place(view.incoming,pages.Answer,0,22,0,54)
    view.incoming.TextSize=16
    local freeToggle=W.button(pages.Answer,"ToggleFreeAnswer","TYPE",W.colors.card)
    for i,button in ipairs({view.yes,view.no,freeToggle}) do
        button.Parent=pages.Answer
        button.Position=UDim2.new((i-1)/3,i==1 and 0 or 3,0,84)
        button.Size=UDim2.new(1/3,-6,0,44)
    end
    place(view.answerStatus,pages.Answer,0,138,0,56)
    view.answerStatus.TextYAlignment=Enum.TextYAlignment.Top
    local freeArea=W.create("Frame",pages.Answer,{Name="FreeAnswerArea",Visible=false,
        BackgroundTransparency=1,Position=UDim2.fromOffset(0,204),Size=UDim2.new(1,0,0,54)})
    inputRow(view.answer,view.sendAnswer,freeArea,0,"Your answer...","SEND")
    label(pages.Guess,"YourGuessLabel","WHO IS YOUR HIDDEN PLAYER?",0,24).TextColor3=W.colors.muted
    inputRow(view.guess,view.submitGuess,pages.Guess,32,"Player's name...","GUESS")
    place(view.guessStatus,pages.Guess,0,90,0,86)
    view.guessStatus.TextYAlignment=Enum.TextYAlignment.Top
    local infoToggle=W.button(main,"TogglePlayerInfo","PLAYER INFO",W.colors.card)
    infoToggle.AnchorPoint=Vector2.new(1,0)
    infoToggle.Size=UDim2.fromOffset(136,44)
    local infoPanel=panel("PlayerInfoPanel")
    infoPanel.Visible=false
    infoPanel.AnchorPoint=Vector2.new(1,0)
    infoPanel.ZIndex=3
    local heading=label(infoPanel,"InfoHeading","OPPONENT'S PLAYER",12,24)
    heading.Position=UDim2.fromOffset(14,12)
    heading.Size=UDim2.new(1,-68,0,24)
    local hint=label(infoPanel,"InfoHint","Use these facts to answer.",44,24)
    hint.Position=UDim2.fromOffset(14,44)
    hint.Size=UDim2.new(1,-28,0,24)
    hint.TextSize=13
    local closeInfo=W.button(infoPanel,"ClosePlayerInfo","X",W.colors.card)
    closeInfo.Position=UDim2.new(1,-50,0,8)
    closeInfo.Size=UDim2.fromOffset(36,36)
    local infoScroll=W.create("ScrollingFrame",infoPanel,{Name="PlayerInfoScroll",
        Position=UDim2.fromOffset(14,76),Size=UDim2.new(1,-28,1,-88),BackgroundTransparency=1,
        BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y})
    place(view.info,infoScroll,0,0,-10,0)
    view.info.AutomaticSize=Enum.AutomaticSize.Y
    view.info.TextSize=15
    local presets=panel("CompactPresetPanel")
    presets.Visible=false
    presets.ZIndex=4
    presets.AnchorPoint=Vector2.new(.5,1)
    local presetHeading=label(presets,"PresetHeading","QUICK QUESTIONS",12,24)
    presetHeading.Position=UDim2.fromOffset(14,12)
    presetHeading.Size=UDim2.new(1,-68,0,24)
    local closePresets=W.button(presets,"CloseQuickQuestions","X",W.colors.card)
    closePresets.Position=UDim2.new(1,-50,0,8)
    closePresets.Size=UDim2.fromOffset(36,36)
    local presetList=main:FindFirstChild("RoundContent"):FindFirstChild("Columns")
        :FindFirstChild("PlayerInfoColumn"):FindFirstChild("PresetQuestionsCard"):FindFirstChild("PresetQuestionChoices")
    place(presetList,presets,12,52,-24,0)
    presetList.Size=UDim2.new(1,-24,1,-64)
    for _,choice in ipairs(view.presetButtons) do
        choice.button.Activated:Connect(function() presets.Visible=false end)
    end
    local selected="Ask"
    local unreadAnswer=false
    local function selectPage(name)
        selected=name
        if name=="Ask" then
            unreadAnswer=false
            buttons.Ask.Text="ASK"
        end
        for key,frame in pairs(pages) do
            frame.Visible=key==name
            buttons[key].BackgroundColor3=key==name and W.colors.blue or W.colors.card
        end
        scroll.CanvasPosition=Vector2.new()
        presets.Visible=false
    end
    for i,name in ipairs({"Ask","Answer","Guess"}) do
        local button=W.button(tabs,"Tab"..name,string.upper(name),W.colors.card)
        button.Position=UDim2.new((i-1)/3,i==1 and 0 or 3,0,0)
        button.Size=UDim2.new(1/3,-6,1,0)
        buttons[name]=button
        button.Activated:Connect(function() selectPage(name) end)
    end
    infoToggle.Activated:Connect(function() infoPanel.Visible=not infoPanel.Visible presets.Visible=false end)
    closeInfo.Activated:Connect(function() infoPanel.Visible=false end)
    presetToggle.Activated:Connect(function() presets.Visible=not presets.Visible infoPanel.Visible=false end)
    closePresets.Activated:Connect(function() presets.Visible=false end)
    freeToggle.Activated:Connect(function()
        freeArea.Visible=not freeArea.Visible
        pages.Answer.Size=UDim2.new(1,-8,0,freeArea.Visible and 264 or 194)
        scroll.CanvasPosition=Vector2.new(0,freeArea.Visible and 90 or 0)
    end)
    main:GetPropertyChangedSignal("Visible"):Connect(function()
        if not main.Visible then infoPanel.Visible=false presets.Visible=false end
    end)
    local function layout()
        local size=view.gui.AbsoluteSize
        local narrow=size.X<700
        local height=math.min(narrow and 300 or 296,math.floor(size.Y*.48))
        local width=math.min(760,math.max(0,size.X-32))
        dock.Size=UDim2.fromOffset(width,height)
        view.subtitle.Position=UDim2.new(.5,0,0,narrow and 68 or 12)
        view.subtitle.Size=UDim2.fromOffset(narrow and math.max(0,size.X-32) or math.min(360,size.X-400),36)
        infoToggle.Position=UDim2.new(1,-16,0,narrow and 114 or 96)
        infoPanel.Position=UDim2.new(1,-16,0,narrow and 164 or 148)
        infoPanel.Size=UDim2.fromOffset(math.min(300,size.X-32),math.max(100,math.min(350,size.Y-(narrow and 180 or 164))))
        presets.Position=UDim2.new(.5,0,1,-height-20)
        presets.Size=UDim2.fromOffset(width,math.max(86,math.min(230,size.Y-height-88)))
    end
    view.gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    task.defer(layout)
    selectPage("Ask")
    main:FindFirstChild("RoundContent"):Destroy()
    local originalRender=view.render
    local previousActive,previousData=false,nil
    local sentQuestion,previousQuestionStatus="",""
    local initialText={
        ["Write a question or choose a quick question."]=true,
        ["Your opponent's question will appear here."]=true,
        ["Choose YES/NO, or write an answer below."]=true,
        ["Use the answers to work out your hidden player's name."]=true,
    }
    function view:render(state)
        originalRender(self,state)
        local fresh=state.active and (not previousActive or state.data==nil and previousData~=nil)
        if fresh then
            selectPage("Ask")
            infoPanel.Visible=false
            freeArea.Visible=false
            pages.Answer.Size=UDim2.new(1,-8,0,194)
            sentQuestion,previousQuestionStatus="",""
            unreadAnswer=false
        end
        previousActive,previousData=state.active,state.data
        self.subtitle.Text="VS  "..state.opponent
        for _,control in ipairs({self.questionStatus,self.answerStatus,self.guessStatus}) do
            if initialText[control.Text] then control.Text="" end
        end
        -- Keep the question beside its eventual answer, using display state only.
        local submitted=state.questionStatus:match("^Submitted: (.-)\nWait for your opponent's answer%.$")
        if submitted then
            sentQuestion=submitted
            self.questionStatus.Text="Waiting for answer..."
        end
        if previousQuestionStatus~=state.questionStatus
            and state.questionStatus:match("^Your opponent answered:") and selected~="Ask" then
            unreadAnswer=true
        end
        if selected=="Ask" then unreadAnswer=false end
        previousQuestionStatus=state.questionStatus
        buttons.Ask.Text=unreadAnswer and "ASK !" or "ASK"
        lastQuestion.Visible=sentQuestion~=""
        lastQuestion.Text="You asked: "..sentQuestion
        self.questionStatus.Position=UDim2.fromOffset(0,sentQuestion~="" and 186 or 128)
        pages.Ask.Size=UDim2.new(1,-8,0,sentQuestion~="" and 274 or 220)
        buttons.Answer.Text=state.active and state.incoming~="" and not state.answered and "ANSWER !" or "ANSWER"
    end
end
return Layout
