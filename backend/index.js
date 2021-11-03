// const onvif = require('node-onvif')
const express = require("express")
const cors = require('cors');
const app = express()
const cron = require('node-cron');
const moment = require('moment');
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

var mysql = require('mysql')

var connection = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '6126',
    database: 'VMS',
    dateStrings: 'date'
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
    connection.query(`SELECT *
    FROM accounts
    WHERE account = "${req.body.account}"
    AND password = "${req.body.password}"`,
    function (err, rows, fields) {
        if (err) throw err

        if(rows.length === 0)
            res.status(401)

        rows[0].surgery_room_auth = JSON.parse(rows[0].surgery_room_auth)
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
    SET authority = "${req.body.auth}", req_auth = NULL, surgery_room_auth = "${req.body.surgery_room_auth}"
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
    `VALUES('${req.body.sergery_name}', '${req.body.department}', '${req.body.doctor}', '${req.body.surgery_desc}', '${req.body.patient_status}', '${req.body.video_link}', '${req.body.date}', '${req.body.patient_name}',0);`,
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
    connection.query("SELECT * FROM records WHERE expiration = 0 ORDER BY id DESC", function (err, rows, fields) {
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

app.get('/schedule',(req,res) => {
    connection.query(`
    SELECT *
    FROM schedule
    WHERE start >= "${req.query.start}"
    ${req.body.alltype ? null : `AND is_over = 0`}
    AND end <= "${req.query.end}"
    AND surgery_id = ${req.query.surgery_id}
    ORDER BY is_record DESC, emergency DESC, start
    `, function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.post('/schedule',(req,res) => {
    connection.query(`INSERT INTO schedule
    VALUES (NULL,"${req.body.name}","${req.body.start}","${req.body.end}","${req.body.note}","${req.body.color}",${req.body.emergency},${req.body.surgery_id},0,0)`, function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.patch('/schedule',(req,res) => {
    connection.query(`UPDATE schedule
    SET name = "${req.body.name}",
    start = "${req.body.start}",
    end = "${req.body.end}",
    color = "${req.body.color}",
    note = "${req.body.note}",
    is_record = ${req.body.is_record},
    is_over = ${req.body.is_over}
    WHERE id = ${req.body.id}`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.delete('/schedule',(req,res) => {
    connection.query(`DELETE FROM schedule WHERE id = ${req.body.id}`,
    function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.post('/history', (req,res) => {
    connection.query(`INSERT INTO browsing_history
    VALUES (NULL,"${req.body.record_id}","${req.body.created_at}","${req.body.account_id}")`, function (err, rows, fields) {
        if (err) throw err

        res.send(rows)
    })
})

app.get('/history',(req,res) => {
    let per_page = parseInt(req.query.per_page);
    let page = parseInt(req.query.page)-1;
    let temp = req.query.sort === '' ?  ['created_at','desc'] : req.query.sort.split('|')
    let sort = temp[0];
    let sort_type = temp[1];

    connection.query('SELECT count(*) as "count" FROM browsing_history', function (err, rows, fields) {
        if (err) throw err

        let last_page = parseInt(rows[0].count / per_page) + (rows[0].count % per_page > 0 ? 1 : 0)

        connection.query(`
        SELECT *
        FROM browsing_history
        JOIN accounts
        ON browsing_history.account_id = accounts.id
        JOIN records
        ON records.id = browsing_history.record_id
        ORDER BY ${sort} ${sort_type}
        LIMIT ${page*per_page},${per_page};

        `, function (err, rows, fields) {
            if (err) throw err

            res.send({
                last_page,
                from:page*per_page+1,
                current_page:page+1,
                per_page,
                total:rows[0].count,
                data:rows
            })
        })
    })
})

// 30일 지난 record 삭제
cron.schedule('0 4 * * *', () => {
        let now = moment().subtract(30, 'days').format("YYYY-MM-DD HH:mm:ss")

        connection.query(`UPDATE records
        SET expiration = 1
        WHERE date <= "${now}"`)
    }, {
        timezone: "Asia/Seoul"
    }
);

const start = () => {
    app.listen(3000,'0.0.0.0')
}
start()