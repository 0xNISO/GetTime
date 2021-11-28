local breeze, temperature = { speed = 0, degree = 345, dir = "NNW" }, 10
local time, date, hours, minutes, weather = "00:00 AM", "IDK" ,0, 0, "CLEAR"

RegisterNetEvent("th:sync:time:updateFull")
AddEventHandler("th:sync:time:updateFull", function(getBreeze, getTemperature, getTime, getDate, getWeather)
    time, date, breeze, temperature, weather = getTime, getDate, getBreeze, getTemperature, getWeather

    SetWind(breeze['speed'])
    SetWindDirection(breeze['dir'] or 0.0)
end)

RegisterNetEvent("th:sync:time:updateTime")
AddEventHandler("th:sync:time:updateTime", function(getHours, getMinutes)
    hours, minutes = getHours, getMinutes
    NetworkOverrideClockTime(hours, minutes, 0)
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

CreateThread(function()
    TriggerServerEvent("th:sync:time:init")
end)