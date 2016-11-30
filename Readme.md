Instructions
------------
*this sketch is desined for sending bme280 sensor data to my local home server
server receives data as get request having sensor id and value in it, like 
http://192.168.8.1/rec.php?sid=3&value=11
php gets the value and puts it in mysql database sensor history table
*

The BME280 is, by default, assumed to be connected this way: 

**VCC** -> 3.3V

**SDA** -> GPIO13(aka pin no. 7)

**SCL** -> GPIO14(aka pin no. 5)

**GND** -> GND
<br>

Make sure your ESP8266 has a version of NodeMCU with the following modules installed:
*bme280, file, gpio, http, i2c, net, node, tmr, uart, wifi*.
Some, such as *http* might not be needed, however this is the configuration I had on my ESP8266.


Using the Lua interactive prompt, **make sure you configure your Wi-Fi connectivity**
so that the settings get saved on the ESP8266 flash. This can be done with the following commands:

```lua
wifi.setmode(wifi.STATION)
-- wifi.setphymode(wifi.PHYMODE_B)  -- Optional, longer range but less battery life
wifi.sta.config(your_ssid, ssid_password, 0)  -- 0 means no autoconnect
```

***NOTE:*** All the above settings are **persistent**. Even after restart, these commands do not need to be set again.
This is why you don't see them anywhere in the *init.lua* again. 
See [**the wifi module's documentation**](https://nodemcu.readthedocs.io/en/master/en/modules/wifi/)
for more info.


Edit the *init.lua* file with your details. To get the *temp_url*, *pres_url* and *humi_url* for
your case, navigate to your Ubidots dashboard and click the **API credentials** button:



<pre><code>
<i>http://192.168.8.1/rec.php?sid=</i><b>sensor_id</b><i>&value=</i><b>sensor_value</b
</code></pre>



**Finally**, I use a tool named ESP8266Flasher to flash a firmware, and ESPLorer to 
upload the *init.lua* file to the ESP8266. 



My home server then can display graphs in browser.
