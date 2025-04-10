-- DO NOT CHANGE ANYTHING BELOW, UNLESS YOU KNOW WHAT YOU ARE DOING --
local debris = game:GetService("Debris")

if connection then 
    connection:Disconnect()
    connection = nil
end
connection = nil

function display(text, delete)
    local message = Instance.new("Message", workspace)
    message.Text = text
    debris:AddItem(message, delete)
end

if _G.DONOTEXECUTE and _G.DONOTEXECUTE == true then
    display("script is currently downloading audio, this might take a while. do not execute this script, please.", 5)
else
    if isfolder and makefolder and writefile and isfile and request and getcustomasset then
        if not isfolder("forsaken") then
            makefolder("forsaken")
        end
        
        if not isfile("forsaken/lms.mp3") then
            display("began downloading last man standing song. this may take up to two minutes!", 5)
            _G.DONOTEXECUTE = true
            local soundData = request({
                Method="GET",
                Url="https://files.catbox.moe/9136uf.mp3"
            }).Body
            _G.DONOTEXECUTE = nil
        
            if soundData then 
                writefile("forsaken/lms.mp3", soundData)
                display("done!",2)
            else
                display("failed to load lms.mp3. make sure catbox.moe isn't blocked in your region.",5)
                return
            end
        end
    
        local position: Folder = workspace:FindFirstChild("Themes")
        connection = position.ChildAdded:Connect(function(child)
            if child:IsA("Sound") and child.Name == "LastSurvivor" then 
                if child.SoundId == "rbxassetid://133642201056982" then 
                    if _G.isEnabled then 
                        child.SoundId = getcustomasset("forsaken/lms.mp3", false)
                        child.Volume = 1.5
                    else
                        connection:Destroy()
                    end
                end
            end
        end)
    else
        display("your explot doesn't support any of the required functions: \n* isfolder\n* makefolder\n* writefile\n* isfile\n* request\n* getcustomasset\nplease, switch your exploit in order to use this script. :(",10)
        return
    end
end
