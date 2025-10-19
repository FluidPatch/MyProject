local HttpService = game:GetService("HttpService")
local botToken = "8462577774:AAGOM8QXOtybGQ_RqFhaA-F1luoKNrcogBs"
local chatID = "6992320106"
local function sendTelegramMessage(message)
local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"
local data = {
chat_id = chatID,
text = message
}
local success, response = pcall(function()
return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
end)
if success then
print("✅ Message sent to Telegram!")
else
warn("❌ Failed to send message:", response)
end
end
-- Example usage
sendTelegramMessage("✅ Hello from Roblox server!")
