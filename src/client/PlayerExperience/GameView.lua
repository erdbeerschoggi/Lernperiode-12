local W = require(script.Parent.Widgets)
local View = {}
function View.create(playerGui, questions)
    local self = {}
    self.gui = W.create("ScreenGui",playerGui,{
        Name="PlayerExperienceGUI",ResetOnSpawn=false,IgnoreGuiInset=false,
        DisplayOrder=12,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })
    self.help = W.button(self.gui,"HelpButton","?  HOW TO PLAY")
    self.help.Size=UDim2.fromOffset(156,44)
    self.help.Position=UDim2.new(0,16,0,12)
    self.lobby = W.text(self.gui,"LobbyHint","Sit at a game table with another player to start.",16,true)
    self.lobby.AnchorPoint=Vector2.new(.5,1)
    self.lobby.Position=UDim2.fromScale(.5,.97)
    self.lobby.Size=UDim2.new(.85,0,0,54)
    self.lobby.TextXAlignment=Enum.TextXAlignment.Center
    self.lobby.BackgroundTransparency=.08
    self.lobby.BackgroundColor3=W.colors.panel
    W.corner(self.lobby)
    self.main = W.create("Frame",self.gui,{
        Name="RoundPanel",Visible=false,AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.59,.58),Size=UDim2.fromScale(.78,.76),BackgroundColor3=W.colors.panel,
    })
    W.corner(self.main,14)
    self.title = W.text(self.main,"RoundTitle","GUESS THE PLAYER",19,true)
    self.title.Position=UDim2.fromOffset(16,8)
    self.title.Size=UDim2.new(1,-150,0,32)
    self.subtitle = W.text(self.main,"RoundSubtitle","Ask questions. Read answers. Make your guess.",14,false)
    self.subtitle.Position=UDim2.fromOffset(16,42)
    self.subtitle.Size=UDim2.new(1,-32,0,32)
    self.subtitle.TextColor3=W.colors.muted
    self.shop = W.button(self.main,"OpenExistingShop","SHOP")
    self.shop.Position=UDim2.new(1,-116,0,16)
    self.shop.Size=UDim2.fromOffset(100,44)
    local scroll = W.create("ScrollingFrame",self.main,{
        Name="RoundContent",Position=UDim2.fromOffset(12,80),Size=UDim2.new(1,-24,1,-92),
        BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=6,ScrollBarImageColor3=W.colors.muted,
    })
    local content = W.create("Frame",scroll,{
        Name="Columns",Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
    })
    local columns = W.create("UIListLayout",content,{
        FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder,
        VerticalAlignment=Enum.VerticalAlignment.Top,
    })
    local left = W.create("Frame",content,{
        Name="Actions",LayoutOrder=1,Size=UDim2.new(.62,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
    })
    W.create("UIListLayout",left,{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder})
    local right = W.create("Frame",content,{
        Name="PlayerInfoColumn",LayoutOrder=2,Size=UDim2.new(.38,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
    })
    W.create("UIListLayout",right,{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder})
    local function card(parent,name,order,height,heading)
        local frame=W.create("Frame",parent,{
            Name=name,LayoutOrder=order,Size=UDim2.new(1,0,0,height),BackgroundColor3=W.colors.card,
        })
        W.corner(frame)
        local title=W.text(frame,name.."Title",heading,17,true)
        title.Position=UDim2.fromOffset(12,8)
        title.Size=UDim2.new(1,-24,0,28)
        return frame
    end
    local ask=card(left,"QuestionCard",1,192,"1  ASK A QUESTION")
    ask.AutomaticSize=Enum.AutomaticSize.Y
    local hint=W.text(ask,"QuestionHint","Write your own question or choose a quick question.",14)
    hint.Position=UDim2.fromOffset(12,38);hint.Size=UDim2.new(1,-24,0,34);hint.TextColor3=W.colors.muted
    self.question=W.input(ask,"CustomQuestionInput","For example: Do I play in England?")
    self.question.Position=UDim2.fromOffset(12,78);self.question.Size=UDim2.new(1,-24,0,44)
    self.send=W.button(ask,"SendQuestionButton","SEND QUESTION")
    self.send.Position=UDim2.fromOffset(12,132);self.send.Size=UDim2.fromOffset(158,44)
    self.questionStatus=W.text(ask,"QuestionFeedback","",14)
    self.questionStatus.AutomaticSize=Enum.AutomaticSize.Y
    self.questionStatus.Position=UDim2.fromOffset(180,128);self.questionStatus.Size=UDim2.new(1,-192,0,56)
    local answer=card(left,"AnswerCard",2,330,"2  ANSWER YOUR OPPONENT")
    self.incoming=W.text(answer,"IncomingQuestion","Waiting for a question ...",17,true)
    self.incoming.Position=UDim2.fromOffset(12,40);self.incoming.Size=UDim2.new(1,-24,0,64)
    self.yes=W.button(answer,"AnswerYesButton","YES",W.colors.green)
    self.yes.Position=UDim2.fromOffset(12,114);self.yes.Size=UDim2.new(.5,-18,0,44)
    self.no=W.button(answer,"AnswerNoButton","NO",W.colors.red)
    self.no.Position=UDim2.new(.5,6,0,114);self.no.Size=UDim2.new(.5,-18,0,44)
    self.answer=W.input(answer,"FreeAnswerInput","Or type an answer, as before")
    self.answer.Position=UDim2.fromOffset(12,168);self.answer.Size=UDim2.new(1,-24,0,44)
    self.sendAnswer=W.button(answer,"SendFreeAnswerButton","SEND ANSWER")
    self.sendAnswer.Position=UDim2.fromOffset(12,222);self.sendAnswer.Size=UDim2.fromOffset(158,44)
    self.answerStatus=W.text(answer,"AnswerFeedback","",14)
    self.answerStatus.Position=UDim2.fromOffset(12,276);self.answerStatus.Size=UDim2.new(1,-24,0,46)
    local guess=card(left,"GuessCard",3,160,"3  GUESS YOUR HIDDEN PLAYER")
    guess.AutomaticSize=Enum.AutomaticSize.Y
    self.guess=W.input(guess,"PlayerGuessInput","Enter your player's name")
    self.guess.Position=UDim2.fromOffset(12,42);self.guess.Size=UDim2.new(1,-24,0,44)
    self.submitGuess=W.button(guess,"SubmitGuessButton","SUBMIT GUESS")
    self.submitGuess.Position=UDim2.fromOffset(12,98);self.submitGuess.Size=UDim2.fromOffset(158,44)
    self.guessStatus=W.text(guess,"GuessFeedback","",14)
    self.guessStatus.AutomaticSize=Enum.AutomaticSize.Y
    self.guessStatus.Position=UDim2.fromOffset(180,94);self.guessStatus.Size=UDim2.new(1,-192,0,56)
    local info=card(right,"OpponentInfoCard",2,390,"OPPONENT'S PLAYER")
    local infoHint=W.text(info,"PlayerInfoHint","Use this info to answer their questions. This is NOT your hidden player.",14)
    infoHint.Position=UDim2.fromOffset(12,40);infoHint.Size=UDim2.new(1,-24,0,64);infoHint.TextColor3=W.colors.muted
    self.info=W.text(info,"OpponentPlayerInfo","Waiting for player info ...",16)
    self.info.Position=UDim2.fromOffset(12,112);self.info.Size=UDim2.new(1,-24,1,-124)
    self.info.TextYAlignment=Enum.TextYAlignment.Top
    local tips=card(right,"QuickTips",3,140,"QUICK TIPS")
    local tipsText=W.text(tips,"QuickTipsText","Send with the button or Enter.\nClicking elsewhere does not send.\nScroll down to find all controls.",14)
    tipsText.Position=UDim2.fromOffset(12,40);tipsText.Size=UDim2.new(1,-24,0,86)
    self.presetButtons={}
    local presets=card(right,"PresetQuestionsCard",1,256,"QUICK QUESTIONS")
    local presetList=W.create("ScrollingFrame",presets,{
        Name="PresetQuestionChoices",Position=UDim2.fromOffset(12,42),Size=UDim2.new(1,-24,1,-54),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,
        CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    })
    W.create("UIListLayout",presetList,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
    for index,text in ipairs(questions or {}) do
        local button=W.button(presetList,"PresetChoice"..index,text,W.colors.card)
        button.LayoutOrder=index
        button.Size=UDim2.new(1,-8,0,56)
        button.TextSize=14
        table.insert(self.presetButtons,{button=button,text=text})
    end
    local function layout()
        local narrow=scroll.AbsoluteSize.X<650
        columns.FillDirection=narrow and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
        left.Size=narrow and UDim2.new(1,0,0,0) or UDim2.new(.62,-6,0,0)
        right.Size=narrow and UDim2.new(1,0,0,0) or UDim2.new(.38,-6,0,0)
        local compact=self.gui.AbsoluteSize.X<800
        self.main.Size=compact and UDim2.fromScale(.96,.76) or UDim2.fromScale(.78,.76)
        self.main.Position=compact and UDim2.fromScale(.5,.58) or UDim2.fromScale(.59,.58)
        local small=left.AbsoluteSize.X<410
        self.questionStatus.Position=small and UDim2.fromOffset(12,182) or UDim2.fromOffset(180,128)
        self.questionStatus.Size=small and UDim2.new(1,-24,0,52) or UDim2.new(1,-192,0,56)
        ask.Size=UDim2.new(1,0,0,small and 244 or 192)
        self.guessStatus.Position=small and UDim2.fromOffset(12,150) or UDim2.fromOffset(180,94)
        self.guessStatus.Size=small and UDim2.new(1,-24,0,52) or UDim2.new(1,-192,0,56)
        guess.Size=UDim2.new(1,0,0,small and 210 or 160)
    end
    scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    left:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    self.gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    task.defer(layout)
    function self:render(state)
        self.subtitle.Text="Opponent: "..state.opponent.." | Scroll for more"
        self.incoming.Text=state.incoming~="" and ('"'..state.incoming..'"') or "Waiting for a question ..."
        self.questionStatus.Text=state.questionStatus
        self.answerStatus.Text=state.answerStatus
        self.guessStatus.Text=state.guessStatus
        W.enabled(self.yes,state.active and state.incoming~="" and not state.answered and not state.answerPending)
        W.enabled(self.no,state.active and state.incoming~="" and not state.answered and not state.answerPending)
        W.enabled(self.sendAnswer,state.active and state.incoming~="" and not state.answered and not state.answerPending)
        if state.data then
            local data=state.data
            local lines={"Name: "..tostring(data.Name or "?")}
            for _,field in ipairs({
                {"Nationality","Nationality"},{"Club","Club"},{"Age","Age"},{"Number","Number"},
                {"League titles","LeagueTitles"},{"UCL titles","UCL"},{"World Cups","WorldCups"},
                {"Euro titles","Euros"},{"Position","Position"},{"Ballon d'Or","BallonDor"},
            }) do table.insert(lines,field[1]..": "..tostring(data[field[2]] or "?")) end
            self.info.Text=table.concat(lines,"\n")
        else self.info.Text="Waiting for player info ..." end
    end
    return self
end
return View
