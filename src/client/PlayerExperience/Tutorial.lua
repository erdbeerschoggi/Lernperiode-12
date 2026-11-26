local W = require(script.Parent.Widgets)
local Tutorial = {}
local steps = {
    {"1  FIND A GAME", "Sit on a game seat at a table. The round begins when a second player sits opposite you.\n\nWhile you wait, you can open the shop or read this guide."},
    {"2  KNOW WHICH PLAYER IS WHICH", "You need to guess YOUR hidden football player.\n\nThe facts under PLAYER INFO belong to your OPPONENT. Use that information to answer their questions. It does not reveal your own answer."},
    {"3  ASK YOUR OWN QUESTION", "Write a short question that can be answered with YES or NO.\n\nFor example: Do I play in England?\n\nOpen ASK, write your question and use SEND or Enter. QUICK QUESTIONS opens the existing list. Clicking outside a text field does not send it. Wait for your opponent's answer."},
    {"4  ANSWER YOUR OPPONENT", "Open ANSWER when its tab shows an exclamation mark. Your opponent's latest question appears there.\n\nCheck their player info and choose YES or NO. TYPE opens a free-text answer field. Use SEND or Enter to submit it. Wait for the server confirmation; the buttons become available again for the next question."},
    {"5  MAKE YOUR GUESS", "When you think you know your hidden player, open GUESS and enter the player's name.\n\nUse GUESS or press Enter. A wrong guess lets you keep playing. The first correct guess wins the round."},
    {"6  FIND HELP AND THE SHOP", "ASK, ANSWER and GUESS switch the controls at the bottom. Scroll there if needed. PLAYER INFO opens all opponent facts; X closes them.\n\nSHOP opens the existing shop and its preview/accessories.\n\nOpen HELP whenever you need this guide. Close it with X or Escape. After a round, use the existing PLAY AGAIN? panel for a rematch. Reading this guide does not pause the round."},
}
function Tutorial.create(playerGui)
    local self = {index=1}
    self.gui=W.create("ScreenGui",playerGui,{
        Name="PlayerExperienceTutorial",ResetOnSpawn=false,IgnoreGuiInset=false,DisplayOrder=80,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })
    self.overlay=W.create("Frame",self.gui,{
        Name="TutorialOverlay",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=.25,Active=true,Visible=false,
    })
    local panel=W.create("Frame",self.overlay,{
        Name="TutorialPanel",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
        Size=UDim2.fromScale(.9,.85),BackgroundColor3=W.colors.panel,
    })
    W.create("UISizeConstraint",panel,{MaxSize=Vector2.new(700,590)})
    W.corner(panel,14)
    local heading=W.text(panel,"TutorialHeading","HOW TO PLAY",22,true)
    heading.Position=UDim2.fromOffset(18,12);heading.Size=UDim2.new(1,-94,0,36)
    self.closeButton=W.button(panel,"CloseTutorial","X",W.colors.card)
    self.closeButton.Position=UDim2.new(1,-62,0,12);self.closeButton.Size=UDim2.fromOffset(44,44)
    self.progress=W.text(panel,"TutorialProgress","",14)
    self.progress.Position=UDim2.fromOffset(18,56);self.progress.Size=UDim2.new(1,-36,0,26)
    local scroller=W.create("ScrollingFrame",panel,{
        Name="TutorialContent",Position=UDim2.fromOffset(18,92),Size=UDim2.new(1,-36,1,-170),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=6,
        CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    })
    local content=W.create("Frame",scroller,{
        Size=UDim2.new(1,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
    })
    W.create("UIListLayout",content,{Padding=UDim.new(0,18),SortOrder=Enum.SortOrder.LayoutOrder})
    self.title=W.text(content,"StepTitle","",20,true)
    self.title.LayoutOrder=1;self.title.Size=UDim2.new(1,0,0,0);self.title.AutomaticSize=Enum.AutomaticSize.Y
    self.body=W.text(content,"StepBody","",18)
    self.body.LayoutOrder=2;self.body.Size=UDim2.new(1,0,0,0);self.body.AutomaticSize=Enum.AutomaticSize.Y
    self.body.TextYAlignment=Enum.TextYAlignment.Top
    self.previous=W.button(panel,"PreviousStep","BACK",W.colors.card)
    self.previous.Position=UDim2.new(0,18,1,-62);self.previous.Size=UDim2.new(.45,-18,0,44)
    self.next=W.button(panel,"NextStep","NEXT")
    self.next.Position=UDim2.new(.55,0,1,-62);self.next.Size=UDim2.new(.45,-18,0,44)
    function self:render()
        self.title.Text=steps[self.index][1]
        self.body.Text=steps[self.index][2]
        self.progress.Text="Step "..self.index.." of "..#steps.." | The round keeps running"
        self.next.Text=self.index==#steps and "DONE" or "NEXT"
        W.enabled(self.previous,self.index>1)
        scroller.CanvasPosition=Vector2.new()
    end
    function self:open()
        self.index=1
        self:render()
        self.overlay.Visible=true
    end
    function self:close() self.overlay.Visible=false end
    self.closeButton.Activated:Connect(function() self:close() end)
    self.previous.Activated:Connect(function()
        if self.index>1 then self.index=self.index-1 self:render() end
    end)
    self.next.Activated:Connect(function()
        if self.index==#steps then self:close() else self.index=self.index+1 self:render() end
    end)
    return self
end
return Tutorial
