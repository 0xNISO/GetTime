local breeze, temperature = { speed = 0, degree = 345, dir = "NNW" }, 10
local time, date, hours, minutes, weather = "00:00 AM", "IDK" ,0, 0, "CLEAR"
local requestData, requestToken = json.encode({
    url = ("http://api.weatherstack.com/current?access_key=key&query=" .. Config.Time.Zone):gsub(" ", ,"%20"),
    method = "GET",
    data = "",
    headers = {["Content-type"] = "application/json"},
})

CreateThread(function()
    RestAPI()
        
    while true do
        minutes = minutes + 1

        if minutes >= 60 then
            minutes = 0
            hours = hours + 1

            if hours >= 24 then
                hours = 0
            end
        end

        TriggerClientEvent("fx:sync:time:updateTime", -1, hours, minutes)

        Wait(1000)
    end
end)

local API = 30 * 60 * 1000
function RestAPI()
    requestToken = PerformHttpRequestInternal(requestData, #requestData)
end

function GetWeatherByTable(data)
    return "CLEAR"
end

RegisterServerEvent("__cfx_internal:httpResponse")
AddEventHandler("__cfx_internal:httpResponse", function(token, status, text, header)
    if token == requestToken and status == 200 then
        local data = json.decode(text)
        local dateData = data.location.localtime:split(" ")
        local timeData = dateData:split(":")

        time, hours, minutes = dateData[1], tonumber(timeData[1]), tonumber(timeData[2])
        date = data.current.observation_time
        breeze = { speed = data.current.wind_speed, degree = data.current.wind_degree, dir = data.current.wind_dir }
        weather = GetWeatherByTable(data.current.weather_descriptions)

        if (temperature ~= data.current.temperature) then
            temperature = data.current.temperature
        end

        TriggerClientEvent("fx:sync:time:updateFull", src, breeze, temperature, time, date, weather)
        
        Citizen.SetTimeout(API, requestToken)
    end
end)

RegisterServerEvent("fx:sync:time:init")
AddEventHandler("fx:sync:time:init", function()
    local src = source
    TriggerClientEvent("fx:sync:time:updateFull", src, breeze, temperature, time, date, weather)
    TriggerClientEvent("fx:sync:time:updateTime", src, hours, minutes)
end)

exports("GetDate", function()
    return date
end)

exports("GetTime", function()
    return time
end)

exports("GetCurrentHours", function()
    return hours
end)

exports("GetCurrentMinutes", function()
    return minutes
end)

exports("GetBreze", function()
    return breeze
end)

exports("GetTemperature", function()
    return temperature
end)