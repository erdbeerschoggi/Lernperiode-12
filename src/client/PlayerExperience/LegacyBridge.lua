-- Adapter for the NEW team UI: preset questions, text answers and rematch.
local Bridge = {}
function Bridge.find(gui)
    local questionFrame
    for _,obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("Frame") and obj.Name=="QuestionsFrame" then questionFrame=obj break end
    end
    if not questionFrame then return nil end
    local gameFrame=questionFrame.Parent
    local questionList=questionFrame:FindFirstChild("QuestionList")
    local shopFrame=gui:FindFirstChild("ShopFrame")
    local answerBox=gameFrame:FindFirstChild("AnswerBox")
    if gameFrame.Parent~=gui or not gameFrame:IsA("Frame") or not questionList
        or not shopFrame or not answerBox then return nil end
    local ordered={}
    for _,obj in ipairs(questionList:GetChildren()) do
        if obj:IsA("TextButton") then
            table.insert(ordered,{text=obj.Text,order=obj.LayoutOrder})
        end
    end
    table.sort(ordered,function(a,b) return a.order<b.order end)
    local questions={}
    for _,entry in ipairs(ordered) do
        -- The old Custom question:.... placeholder is replaced by a real input.
        -- All actual preset questions are read from the TEAM's current UI.
        if not entry.text:lower():match("^custom question") then
            table.insert(questions,entry.text)
        end
    end
    return {
        gui=gui,gameFrame=gameFrame,shopFrame=shopFrame,questions=questions,
        rematchFrame=gui:FindFirstChild("RematchFrame"),
    }
end
function Bridge.attach(refs,refresh)
    local saved,connections={},{}
    local function hide(child)
        if child:IsA("GuiObject") then saved[child]=child.Visible child.Visible=false end
    end
    -- Only the original ROUND controls are locally replaced. The top-level
    -- rematch panel and all original scripts/handlers remain untouched.
    for _,child in ipairs(refs.gameFrame:GetChildren()) do hide(child) end
    table.insert(connections,refs.gameFrame.ChildAdded:Connect(hide))
    for _,obj in ipairs({refs.gameFrame,refs.shopFrame,refs.rematchFrame}) do
        table.insert(connections,obj:GetPropertyChangedSignal("Visible"):Connect(refresh))
    end
    return function()
        for _,connection in ipairs(connections) do connection:Disconnect() end
        for child,visible in pairs(saved) do if child.Parent then child.Visible=visible end end
    end
end
return Bridge
