P = nil
T = nil
H = nil

serv_url = "http://192.168.8.1/rec.php?sid="


function goto_sleep()
    -- Puts the ESP8266 into DeepSleep mode
    node.dsleep(600000000,2) -- 10 minutes
end


function post_humi()
    sid = 3; -- mysql humidity id
    http.get(serv_url..sid..'&value='..H, nil, function() node.task.post(goto_sleep) end)
end


function post_pres()
    sid = 2; -- mysql pressure id
    http.get(serv_url..sid..'&value='..P, nil, function() node.task.post(post_humi) end)
end


function start_posting()
    sid = 1; -- mysql temperature id
    http.get(serv_url..sid..'&value='..T, nil, function() node.task.post(post_pres) end)
end


function connected()
    -- Managed to connect to WiFi Network
    start_posting()
end


function diconnected()
    -- Didn't manage to connect to WiFi Network => deepsleep
    -- This callback gets called every second or so if no
    -- connection can be created as the ESP tries continously
    -- to establish a connection => I could implement a "tries"
    -- mechanism
    goto_sleep()
end


function parse_data()
    H, T = bme280.humi()
    P, T = bme280.baro()

    P = P*75/100000 -- Pressure in mmHg
    H = H/1000 -- Humidity in %
    T = T/100 -- Temperature in degrees C
    -- Register WiFi events
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, connected)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnected)
    -- And attempt to connect to send Data
    wifi.sta.connect()
end


-- First take measurment => heating of ESP won't affect
bme280.init(7, 5, 5, 5, 5, 2, 0, 0) -- Forced, 16x over, no_delay, filter off
-- Giving it a delay of 0 <=> 113ms delay
bme280.startreadout(0, parse_data)
