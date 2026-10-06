local ReplicatedStorage = game:GetService("ReplicatedStorage")
local label = script.Parent:WaitForChild("StatusLabel")

ReplicatedStorage:WaitForChild("StatusUpdate").OnClientEvent:Connect(function(text, seconds)
	label.Text = seconds > 0 and (text .. " " .. seconds) or text
end)
