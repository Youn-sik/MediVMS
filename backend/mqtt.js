const mqtt = require('mqtt');

const client = mqtt.connect({
    clientId: "core-mqtt-demon",
    clean: true,
    keepalive: 60,
    reconnectPeriod: 5000,
    connectTimeout: 15000,
    host: '172.16.41.105',
    port: 1883,
    protocol: 'mqtt',
    resubscribe: false,
    useNewUrlParser: true,
});


client.on('error',function (err) {
    console.log(err)
})
cd .
client.on('connect', function(test) {
    console.log('MQTT connected.')
    client.subscribe([
        '/record/start/+',
        '/record/stop/+'
    ], (error, result) => {
        if (error) {
            console.log('MQTT subscribe error.');
        } else {
            console.log('MQTT subscribed.');
        }
    });
})

client.on('message', function(topic,message) {
    console.log(topic);
})