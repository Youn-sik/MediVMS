// const onvif = require('node-onvif')
const express = require("express")
const cors = require('cors');
const app = express()
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

var mysql = require('mysql')

var connection = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '6126',
    database: 'VMS'
})

// connection.connect()
connection.on('error', function(err) {
    console.log(err)
});
app.use(cors())
app.use('/stream',express.static('./record'));

app.get('/getSurgery',(req,res) => {
    connection.query("SELECT S.*,"+
    "group_concat(D.device_id) as devices,"+
    "group_concat(D.device_name) as device_names,"+
    "group_concat(D.live_url order by D.live_url desc) as live_urls, "+
    "group_concat(D.isLive) as isLives, "+
    "group_concat(D.Serial_number) as serial_numbers, "+
    "count(D.device_id) as numberOfDevices "+
    "From devices D inner join surgery as S on D.surgery_id =S.surgery_id "+
    "group by S.surgery_id", function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.get('/getAccounts', (req,res) => {
    connection.query("SELECT * FROM accounts WHERE authority > 0", function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.post('/login',(req,res) => {
    console.log(req.body)
    connection.query(`SELECT *
    FROM accounts
    WHERE account = "${req.body.account}"
    AND password = "${req.body.password}"`,
    function (err, rows, fields) {
        if (err) throw err

        if(rows.length === 0)
            res.status(401)
        res.send(rows)
    })
})

app.patch('/authReq',(req,res) => {
    connection.query(`UPDATE accounts
    SET req_auth = "${req.body.reqAuth}"
    WHERE account = "${req.body.account}"`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.patch('/setAuth',(req,res) => {
    connection.query(`UPDATE accounts
    SET authority = "${req.body.auth}", req_auth = NULL, surgery_room_auth = ${req.body.surgery_room_auth}
    WHERE account = "${req.body.account}"`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.patch('/recordStart',(req,res) => {
    connection.query(`UPDATE surgery
    SET record = 1, record_time = "${req.body.dateTime}"
    WHERE surgery_id = ${req.body.id}`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.patch('/recordStop',(req,res) => {
    connection.query(`UPDATE surgery
    SET record = 0, record_time = NULL
    WHERE surgery_id = ${req.body.id}`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.post('/saveRecord', (req,res) => {

    connection.query("INSERT INTO VMS.records (sergery_name, department, doctor, surgery_desc, patient_status, video_link, `date`, patient_name)"+
    `VALUES('${req.body.sergery_name}', '${req.body.department}', '${req.body.doctor}', '${req.body.surgery_desc}', '${req.body.patient_status}', '${req.body.video_link}', '${req.body.date}', '${req.body.patient_name}');`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
    // connection.query('INSERT INTO records VALUES ?',
    // [[null,req.body.sergery_name,req.body.department,req.body.doctor,req.body.surgery_desc,req.body.patient_status,req.body.date,req.body.video_link]],
    // function (err, rows, fields) {
    //     if (err) throw err

    //     res.send(rows)
    // })
})

app.get('/getRecords', (req,res) => {
    connection.query("SELECT * FROM records ORDER BY id DESC", function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.get('/getReserv',(req,res) => {
    connection.query(`SELECT * FROM surgery_reserv JOIN surgery ON surgery_reserv.surgery_id = surgery.surgery_id WHERE surgery_reserv.surgery_id=${req.query.surgeryId} AND NOT status='0' ORDER BY surgery_reserv.status, surgery_reserv.start_time`, function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})



app.post('/saveReserv',(req,res) => {
    connection.query("INSERT INTO VMS.surgery_reserv"+
    "(surgery_id, patient_name, doctor_name, start_time, end_time, patient_sex, patient_status, patient_age)"+
    `VALUES(${req.body.surgeryId}, "${req.body.patientName}", "${req.body.doctorName}", "${req.body.startTime}", "${req.body.endTime}", "${req.body.patientSex}", "${req.body.patientStatus}", "${req.body.patientAge}");`, function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.patch('/pathReserv',(req,res) => {
    connection.query(`UPDATE surgery_reserv
    SET status = ${req.body.status}
    WHERE id = ${req.body.id}`,
    function (err, rows, fields) {
        if (err) throw err

        connection.query(`SELECT * FROM surgery_reserv JOIN surgery ON surgery_reserv.surgery_id = surgery.surgery_id WHERE surgery_reserv.surgery_id=${req.body.surgeryId} AND NOT status='0' ORDER BY surgery_reserv.status, surgery_reserv.start_time`, function (err, rows, fields) {
            if (err) throw err

            res.send(rows)
        })
    })
})

// app.get('/getDevices',(req,res) => {
//     onvif.startProbe().then((device_info_list) => {
//         console.log(device_info_list.length + ' devices were found.');

//         res.send(device_info_list)
//     }).catch((error) => {
//         console.error(error);
//     });
// })


const start = () => {
    app.listen(3000,'0.0.0.0')
}
start()