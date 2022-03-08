// const onvif = require('node-onvif')
const express = require("express");
const cors = require("cors");
const app = express();
const cron = require("node-cron");
const moment = require("moment");
const https = require("https");
const http = require("http");
const request = require("request");
const fs = require("fs");
const mqtt = require("mqtt");
const exec = require('child_process').exec;
app.use(express.urlencoded({ extended: true }));
app.use(
    express.json({
        limit: "50mb"
    })
);

var mysql = require("mysql");
const { Console } = require("console");

var connection = mysql.createPool({
    host: "localhost",
    user: "kool",
    password: "master",
    database: "VMS",
    dateStrings: "date"
});

// connection.connect()
connection.on("error", function(err) {
    console.log(err);
});

var mqttClient = mqtt.connect("localhost", {
    protocol: "ws",
    port: 8083,
    keepalive: 0,
    path: "/mqtt",
    clientId:
        "server_" +
        Math.random()
            .toString(16)
            .substr(2, 8),
    clean: true
});

mqttClient.on("connect", test => {
    let serverTime = moment().format("YYYY-MM-DD HH:mm:ss")
    console.log("MQTT connected.");
    console.log(serverTime);
    mqttClient.subscribe(["/nvr/request/stblist"], (error, result) => {
        if (error) {
            console.log("MQTT subscribe error.");
            console.log(serverTime);
        } else {
            console.log("MQTT subscribed.");
            console.log(serverTime);

            exec('touch /var/www/VMS/backend/mqttServerUp', (err, stdout, stderr) => {
                if (err) {
                console.error(`exec error: ${err}`);
                return;
                }
            
                console.log(`stdout: ${stdout}`);
                console.log(`stderr: ${stderr}`);
            });
        }
    });
});

mqttClient.on("message", (topic, message) => {
    connection.query(`SELECT * FROM devices`, function(err, rows, fields) {
        if (err) throw err;

        mqttClient.publish(`/nvr/request/stblist/result`, JSON.stringify(rows));
    });
});

app.use(cors());
app.use("/stream", express.static("/var/www/VMS/backend/record"));

app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send(err);
});

app.get("/surgery", (req, res) => {
    connection.query("SELECT * FROM surgery", function(err, rows, fields) {
        if (err) throw err;

        connection.query(
            "SELECT S.*," +
                "group_concat(D.device_id) as devices," +
                "group_concat(D.device_name) as device_names," +
                "group_concat(D.live_url order by D.live_url desc) as live_urls, " +
                "group_concat(D.isLive) as isLives, " +
                "group_concat(D.serial_number) as serial_numbers, " +
                "count(D.device_id) as numberOfDevices " +
                "From devices D inner join surgery as S on D.surgery_id =S.surgery_id " +
                "group by S.surgery_id",
            function(err, _rows, fields) {
                if (err) throw err;

                if (rows.length === _rows.length) res.send(_rows);
                else {
                    let temp = [];
                    for (let i = rows.length - 1; i > _rows.length - 1; i--) {
                        temp.push(rows[i]);
                    }
                    let reversed = temp.reverse();

                    res.send([..._rows, ...reversed]);
                }

                // res.send([...rows, ..._rows])
            }
        );
    });
});

app.delete("/surgery", (req, res) => {
    req.body.surgeries.forEach(async e => {
        let query = `
        DELETE FROM surgery
        WHERE surgery_id=${e.surgery_id};
        `;

        await connection.query(query);
    });

    res.send({ result: true });
});

app.patch("/surgery", (req, res) => {
    connection.query(
        `UPDATE surgery
    SET
    surgery_name = "${req.body.surgery_name}",
    note = "${req.body.note}"
    WHERE surgery_id = ${req.body.surgery_id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/surgery", (req, res) => {
    connection.query(
        "INSERT INTO VMS.surgery" +
            "(surgery_name, note)" +
            `VALUES("${req.body.surgery_name}", "${req.body.note}");`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/getAccounts", (req, res) => {
    connection.query("SELECT * FROM accounts", function(err, rows, fields) {
        if (err) throw err;

        res.send(rows);
    });
});

app.post("/login", (req, res) => {
    connection.query(
        `SELECT *
    FROM accounts
    WHERE account = "${req.body.account}"
    AND password = "${req.body.password}"`,
        function(err, rows, fields) {
            if (err) throw err;

            if (rows.length === 0) res.status(401);

            res.send(rows);
        }
    );
});

app.patch("/authReq", (req, res) => {
    connection.query(
        `UPDATE accounts
    SET req_auth = "${req.body.reqAuth}"
    WHERE account = "${req.body.account}"`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/setAuth", (req, res) => {
    connection.query(
        `UPDATE accounts
    SET
    dashboard = ${req.body.dashboard},
    surgery = ${req.body.surgery},
    schedule = ${req.body.schedule},
    browse = ${req.body.browse},
    admin = ${req.body.admin},
    setting = ${req.body.setting}
    WHERE account = "${req.body.account}"`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/recordStart", (req, res) => {
    connection.query(
        `UPDATE surgery
    SET record = 1, record_time = "${req.body.dateTime}"
    WHERE surgery_id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/recordStop", (req, res) => {
    let endTime = moment().format("YYYY-MM-DD HH:mm:ss");
    connection.query(
        `UPDATE records
    SET end_date = "${endTime}"
    WHERE surgery_id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            connection.query(
                `UPDATE surgery
        SET record = 0
        WHERE surgery_id = ${req.body.id}`,
                function(err, _rows, fields) {
                    if (err) throw err;

                    res.send(_rows);
                }
            );
        }
    );
});

app.post("/saveRecord", (req, res) => {
    connection.query(
        "INSERT INTO VMS.records (surgery_id, sergery_name, department, doctor, surgery_desc, patient_status, video_link, `date`, patient_name, devices, expiration)" +
            `VALUES(${req.body.surgery_id}, '${req.body.sergery_name}', '${req.body.department}', '${req.body.doctor}', '${req.body.surgery_desc}', '${req.body.patient_status}', '${req.body.video_link}', '${req.body.date}', '${req.body.patient_name}','${req.body.devices}',0);`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
    // connection.query('INSERT INTO records VALUES ?',
    // [[null,req.body.sergery_name,req.body.department,req.body.doctor,req.body.surgery_desc,req.body.patient_status,req.body.date,req.body.video_link]],
    // function (err, rows, fields) {
    //     if (err) throw err

    //     res.send(rows)
    // })
});

app.get("/splited_records", (req, res) => {
    let record_id = parseInt(req.query.record_id);

    connection.query(
        `
    SELECT sr.id,sr.video_link,sr.date,sr.takeout_link,sr.record_id,r.devices
    FROM splited_records sr
    JOIN records r
    on sr.record_id = r.id
    where sr.record_id = ${record_id}
    `,
        function(err, rows, fields) {
            if (err) next(err);

            res.send(rows);
        }
    );
});

app.get("/getRecords", (req, res) => {
    let per_page = parseInt(req.query.per_page);
    let page = parseInt(req.query.page) - 1;
    let start = req.query.start;
    let end = req.query.end;
    let status = req.query.status;
    let searchType = req.query.searchType;
    let search = req.query.search;
    let sort = req.query.sort;
    let sort_type = req.query.sortType;

    connection.query(
        `
    SELECT
    count(*) as 'count'
    FROM records
    WHERE expiration IS NOT NULL
    AND end_date is NOT NULL
    ${
        start && end
            ? "AND date >= '" + start + "' AND date <= '" + end + "'"
            : ""
    }
    ${status ? "AND patient_status = '" + status + "'" : ""}
    ${
        searchType && search
            ? "AND " + searchType + " LIKE '%" + search + "%'"
            : ""
    }`,
        function(err, rows, fields) {
            if (err) next(err);

            let last_page =
                parseInt(rows[0].count / per_page) +
                (rows[0].count % per_page > 0 ? 1 : 0);
            let count = rows[0].count;

            connection.query(
                `
        SELECT *
        FROM records
        WHERE expiration IS NOT NULL
        AND end_date is NOT NULL
        ${
            start && end
                ? "AND date >= '" + start + "' AND date <= '" + end + "'"
                : ""
        }
        ${status ? "AND patient_status = '" + status + "'" : ""}
        ${
            searchType && search
                ? "AND " + searchType + " LIKE '%" + search + "%'"
                : ""
        }
        ORDER BY ${sort}
        ${sort_type}
        LIMIT ${page * per_page},${per_page};
        `,
                function(err, _rows, fields) {
                    res.send({
                        last_page,
                        from: page * per_page + 1,
                        current_page: page + 1,
                        per_page,
                        total: count,
                        data: _rows ? _rows : []
                    });
                }
            );
        }
    );
});

app.get("/record_auth", (req, res) => {
    let per_page = parseInt(req.query.per_page);
    let page = parseInt(req.query.page) - 1;
    let start = req.query.start;
    let end = req.query.end;
    let status = req.query.status;
    let searchType = req.query.searchType;
    let search = req.query.search;
    let sort = req.query.sort;
    let sort_type = req.query.sortType;
    let auth_type =
        req.query.authType === "access"
            ? "record_access"
            : req.query.authType === "takeout"
            ? "takeout_access"
            : "";
    let statusName =
        req.query.authType === "access"
            ? "browse_status"
            : req.query.authType === "takeout"
            ? "takeout_status"
            : "";

    connection.query(
        `
    SELECT
    count(*) as 'count'
    FROM records
    WHERE expiration IS NOT NULL
    ${
        start && end
            ? "AND date >= '" + start + "' AND date <= '" + end + "'"
            : ""
    }
    ${status ? "AND patient_status = '" + status + "'" : ""}
    ${
        searchType && search
            ? "AND " + searchType + " LIKE '%" + search + "%'"
            : ""
    }`,
        function(err, rows, fields) {
            if (err) next(err);

            let last_page =
                parseInt(rows[0].count / per_page) +
                (rows[0].count % per_page > 0 ? 1 : 0);
            let count = rows[0].count;

            connection.query(
                `
        SELECT r.*, ra.status AS ${statusName}
        FROM ${auth_type} AS ra
        RIGHT JOIN records r
        ON ra.record_id = r.id
        WHERE expiration IS NOT NULL
        ${
            start && end
                ? "AND r.date >= '" + start + "' AND r.date <= '" + end + "'"
                : ""
        }
        ${status ? "AND patient_status = '" + status + "'" : ""}
        ${
            searchType && search
                ? "AND r." + searchType + " LIKE '%" + search + "%'"
                : ""
        }
        ORDER BY ${sort}
        ${sort_type}
        LIMIT ${page * per_page},${per_page};
        `,
                function(err, _rows, fields) {
                    res.send({
                        last_page,
                        from: page * per_page + 1,
                        current_page: page + 1,
                        per_page,
                        total: count,
                        data: _rows ? _rows : []
                    });
                }
            );
        }
    );
});

app.get("/getReserv", (req, res) => {
    connection.query(
        `SELECT * FROM surgery_reserv JOIN surgery ON surgery_reserv.surgery_id = surgery.surgery_id WHERE surgery_reserv.surgery_id=${req.query.surgeryId} AND NOT status='0' ORDER BY surgery_reserv.status, surgery_reserv.start_time`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/saveReserv", (req, res) => {
    connection.query(
        "INSERT INTO VMS.surgery_reserv" +
            "(surgery_id, patient_name, doctor_name, start_time, end_time, patient_sex, patient_status, patient_age)" +
            `VALUES(${req.body.surgeryId}, "${req.body.patientName}", "${req.body.doctorName}", "${req.body.startTime}", "${req.body.endTime}", "${req.body.patientSex}", "${req.body.patientStatus}", "${req.body.patientAge}");`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/pathReserv", (req, res) => {
    connection.query(
        `UPDATE surgery_reserv
    SET status = ${req.body.status}
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            connection.query(
                `SELECT * FROM surgery_reserv JOIN surgery ON surgery_reserv.surgery_id = surgery.surgery_id WHERE surgery_reserv.surgery_id=${req.body.surgeryId} AND NOT status='0' ORDER BY surgery_reserv.status, surgery_reserv.start_time`,
                function(err, rows, fields) {
                    if (err) throw err;

                    res.send(rows);
                }
            );
        }
    );
});

app.get("/getDevices", (req, res) => {
    let surgery_id = req.query.surgery_id;
    let subQuery = "";
    let subQuery2 = "JOIN surgery ON devices.surgery_id = surgery.surgery_id ";
    if (surgery_id) subQuery = "WHERE devices.surgery_id = " + surgery_id;
    connection.query(`SELECT * FROM devices ` + subQuery2 + subQuery, function(
        err,
        rows,
        fields
    ) {
        if (err) throw err;

        res.send(rows);
    });
});

app.post("/deleteDevice", (req, res) => {
    req.body.devices.forEach(async e => {
        let query = `
        DELETE FROM devices
        WHERE device_id=${e.device_id};
        `;

        await connection.query(query);
    });

    res.send({ result: true });
});

app.patch("/updateDevice", (req, res) => {
    connection.query(
        `UPDATE devices
    SET
    device_name = "${req.body.device_name}",
    live_url = "${req.body.live_url}",
    serial_number = "${req.body.serial_number}",
    surgery_id = ${req.body.surgery_id},
    note = "${req.body.note}"
    WHERE device_id = ${req.body.device_id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/addDevice", (req, res) => {
    connection.query(
        "INSERT INTO VMS.devices" +
            "(device_name, live_url, serial_number, surgery_id, note)" +
            `VALUES("${req.body.device_name}", "${req.body.live_url}", "${req.body.serial_number}", ${req.body.surgery_id}, "${req.body.note}");`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/controlDevice", (req, res) => {
    connection.query(
        `UPDATE devices
    SET
    target_name = "${req.body.target}"
    WHERE device_id = ${req.body.device_id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/schedule", (req, res) => {
    connection.query(
        `
    SELECT s.id,s.name,s.start,s.end,s.note,s.color,s.emergency,s.surgery_id,s.is_record,s.is_over,s.patient,s.doctor,s.patient_code,s.patient_birthday,dr.id as did,dr.name as dname,dr.department,dr.rank,dr.employee_id
    FROM schedule s
    JOIN doctors dr
    ON dr.id = doctor
    WHERE is_record = 1
    ${
        parseInt(req.query.surgery_id)
            ? "AND surgery_id = " + req.query.surgery_id
            : ""
    }

    UNION ALL

    SELECT s.id,s.name,s.start,s.end,s.note,s.color,s.emergency,s.surgery_id,s.is_record,s.is_over,s.patient,s.doctor,s.patient_code,s.patient_birthday,dr.id as did,dr.name as dname,dr.department,dr.rank,dr.employee_id
    FROM schedule s
    JOIN doctors dr
    ON dr.id = doctor
    WHERE start >= "${req.query.start}"
    AND end <= "${req.query.end}"
    ${parseInt(req.query.alltype) === 1 ? "" : `AND is_over = 0`}
    ${
        parseInt(req.query.surgery_id)
            ? "AND surgery_id = " + req.query.surgery_id
            : ""
    }
    ${
        req.query.search !== ""
            ? req.query.searchType === "patient"
                ? "AND patient LIKE '%" + req.query.search + "%'"
                : "AND doctor LIKE '%" + req.query.search + "%'"
            : ""
    }
    AND is_record = 0
    ORDER BY is_record DESC, emergency DESC, start;
    `,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/schedule", (req, res) => {
    connection.query(
        `INSERT INTO schedule
    VALUES (NULL,"${req.body.name}","${req.body.start}","${req.body.end}","${req.body.note}","${req.body.color}",${req.body.emergency},${req.body.surgery.surgery_id},0,0,"${req.body.patient}","${req.body.doctor}","${req.body.patient_code}","${req.body.patient_birthday}")`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/schedule", (req, res) => {
    connection.query(
        `UPDATE schedule
    SET name = "${req.body.name}",
    start = "${req.body.start}",
    end = "${req.body.end}",
    color = "${req.body.color}",
    note = "${req.body.note}",
    is_record = ${req.body.is_record},
    is_over = ${req.body.is_over},
    patient = "${req.body.patient}",
    doctor = "${req.body.doctor}",
    surgery_id = ${req.body.surgery_id}
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.delete("/schedule", (req, res) => {
    connection.query(`DELETE FROM schedule WHERE id = ${req.body.id}`, function(
        err,
        rows,
        fields
    ) {
        if (err) throw err;

        res.send(rows);
    });
});

app.post("/history", (req, res) => {
    connection.query(
        `INSERT INTO history
    VALUES (NULL,"${req.body.record_id}","${req.body.created_at}","${req.body.account_id}","${req.body.type}")`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/history", (req, res) => {
    let per_page = parseInt(req.query.per_page);
    let page = parseInt(req.query.page) - 1;
    let temp =
        req.query.sort === ""
            ? ["created_at", "desc"]
            : req.query.sort.split("|");
    let sort = temp[0];
    let sort_type = temp[1];
    let type = req.query.type;

    connection.query(
        `SELECT count(*) as "count" FROM history WHERE type = "${type}"`,
        function(err, rows, fields) {
            if (err) throw err;

            let last_page =
                parseInt(rows[0].count / per_page) +
                (rows[0].count % per_page > 0 ? 1 : 0);
            let count = rows[0].count;
            connection.query(
                `
        SELECT *
        FROM history
        JOIN accounts
        ON history.account_id = accounts.id
        JOIN records
        ON records.id = history.record_id
        WHERE type = "${type}"
        ORDER BY ${sort} ${sort_type}
        LIMIT ${page * per_page},${per_page};

        `,
                function(err, rows, fields) {
                    if (err) throw err;

                    res.send({
                        last_page,
                        from: page * per_page + 1,
                        current_page: page + 1,
                        per_page,
                        total: count,
                        data: rows
                    });
                }
            );
        }
    );
});

app.post("/history", (req, res) => {
    connection.query(
        `INSERT INTO history
    VALUES (NULL,"${req.body.record_id}","${req.body.created_at}","${req.body.account_id}")`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/history", (req, res) => {
    let per_page = parseInt(req.query.per_page);
    let page = parseInt(req.query.page) - 1;
    let temp =
        req.query.sort === ""
            ? ["created_at", "desc"]
            : req.query.sort.split("|");
    let sort = temp[0];
    let sort_type = temp[1];

    connection.query('SELECT count(*) as "count" FROM history', function(
        err,
        rows,
        fields
    ) {
        if (err) throw err;

        let last_page =
            parseInt(rows[0].count / per_page) +
            (rows[0].count % per_page > 0 ? 1 : 0);
        let count = rows[0].count;
        connection.query(
            `
        SELECT *
        FROM history
        JOIN accounts
        ON history.account_id = accounts.id
        JOIN records
        ON records.id = history.record_id
        ORDER BY ${sort} ${sort_type}
        LIMIT ${page * per_page},${per_page};

        `,
            function(err, rows, fields) {
                if (err) throw err;

                res.send({
                    last_page,
                    from: page * per_page + 1,
                    current_page: page + 1,
                    per_page,
                    total: count,
                    data: rows
                });
            }
        );
    });
});

app.get("/record_access", function(req, res) {
    let start = req.query.start;
    let end = req.query.end;
    let status = req.query.status;
    let searchType = req.query.searchType;
    let search = req.query.search;
    let first = parseInt(req.query.first);
    let last = parseInt(req.query.last);
    let user_id = parseInt(req.query.user_id);

    let sort = req.query.sort;
    let sort_type = req.query.sortType;

    let per_page = req.query.per_page;
    let page = req.query.page;
    connection.query(
        `
    SELECT record_access.id, status,reason,created_at,sergery_name,records.department as department,doctor,surgery_desc,patient_status,video_link,date,patient_name,account,name,record_id,user_id,updated_at
    FROM record_access
    JOIN records
    ON record_id = records.id
    JOIN accounts
    ON user_id = accounts.id
    WHERE expiration IS NOT NULL
    ${user_id ? "AND user_id = " + user_id : ""}
    ${
        start && end
            ? "AND date >= '" + start + "' AND date <= '" + end + "'"
            : ""
    }
    -- ${status ? "AND status = '" + status + "'" : ""}
    ${
        searchType && search
            ? "AND " + searchType + " LIKE '%" + search + "%'"
            : ""
    }
    ${first ? "AND record_id >= " + first : ""}
    ${last ? "AND record_id <= " + last : ""}
    ORDER BY ${sort}
    ${sort_type}
    ${
        per_page && page
            ? "LIMIT " +
              (parseInt(page) - 1) * parseInt(per_page) +
              " , " +
              parseInt(per_page)
            : ""
    };
    `,
        function(err, rows, fields) {
            if ((per_page, page)) {
                //페이징 사용시 db count 구함
                connection.query(
                    'SELECT count(*) as "count" FROM record_access',
                    function(err, _rows, fields) {
                        let last_page =
                            parseInt(_rows[0].count / parseInt(per_page)) +
                            (_rows[0].count % parseInt(per_page) > 0 ? 1 : 0);
                        res.send({
                            last_page,
                            from: parseInt(page) * parseInt(per_page),
                            current_page: parseInt(page),
                            per_page: parseInt(per_page),
                            total: _rows[0].count,
                            data: rows ? rows : []
                        });
                    }
                );
            } else {
                res.send({
                    data: rows ? rows : []
                });
            }
        }
    );
});

app.post("/record_access", (req, res) => {
    connection.query(
        `INSERT INTO record_access
    VALUES (NULL,"${req.body.user_id}","${req.body.record_id}","${req.body.status}","${req.body.reason}","${req.body.created_at}", NULL)`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/record_access", (req, res) => {
    connection.query(
        `UPDATE record_access
    SET
    reason = "${req.body.reason}",
    status = "${req.body.status}",
    updated_at = "${moment().format("YYYY-MM-DD HH:mm:ss")}"
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/takeout_access", function(req, res) {
    let start = req.query.start;
    let end = req.query.end;
    let status = req.query.status;
    let searchType = req.query.searchType;
    let search = req.query.search;
    let first = parseInt(req.query.first);
    let last = parseInt(req.query.last);
    let user_id = parseInt(req.query.user_id);

    let sort = req.query.sort;
    let sort_type = req.query.sortType;

    let per_page = req.query.per_page;
    let page = req.query.page;

    connection.query(
        `
    SELECT takeout_access.id, status,reason,created_at,sergery_name,records.department as department,doctor,surgery_desc,patient_status,video_link,date,patient_name,account,name,record_id,user_id,updated_at
    FROM takeout_access
    JOIN records
    ON record_id = records.id
    JOIN accounts
    ON user_id = accounts.id
    WHERE expiration IS NOT NULL
    ${user_id ? "AND user_id = " + user_id : ""}
    ${
        start && end
            ? "AND date >= '" + start + "' AND date <= '" + end + "'"
            : ""
    }
    -- ${status ? "AND status = '" + status + "'" : ""}
    ${
        searchType && search
            ? "AND " + searchType + " LIKE '%" + search + "%'"
            : ""
    }
    ${first ? "AND record_id >= " + first : ""}
    ${first ? "AND record_id <= " + last : ""}
    ORDER BY ${sort}
    ${sort_type}
    ${
        per_page && page
            ? "LIMIT " +
              (parseInt(page) - 1) * parseInt(per_page) +
              " , " +
              parseInt(per_page)
            : ""
    };
    `,
        function(err, rows, fields) {
            if (per_page && page) {
                //페이징 사용시 db count 구함
                connection.query(
                    'SELECT count(*) as "count" FROM takeout_access',
                    function(err, _rows, fields) {
                        let last_page =
                            parseInt(_rows[0].count / parseInt(per_page)) +
                            (_rows[0].count % parseInt(per_page) > 0 ? 1 : 0);
                        res.send({
                            last_page,
                            from: parseInt(page) * parseInt(per_page),
                            current_page: parseInt(page),
                            per_page: parseInt(per_page),
                            total: _rows[0].count,
                            data: rows ? rows : []
                        });
                    }
                );
            } else {
                res.send({
                    data: rows ? rows : []
                });
            }
        }
    );
});

app.patch("/takeout_access", (req, res) => {
    connection.query(
        `UPDATE takeout_access
    SET
    reason = "${req.body.reason}",
    status = "${req.body.status}",
    updated_at = "${moment().format("YYYY-MM-DD HH:mm:ss")}"
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/takeout_access", (req, res) => {
    connection.query(
        `INSERT INTO takeout_access
    VALUES (NULL,"${req.body.user_id}","${req.body.record_id}","${req.body.status}","${req.body.reason}","${req.body.created_at}", NULL)`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/settings", (req, res) => {
    connection.query("SELECT * FROM settings", function(err, rows, fields) {
        if (err) throw err;

        res.send(rows[0]);
    });
});

app.patch("/settings", (req, res) => {
    if (req.body.file !== null) {
        let path = "/var/www/VMS/backend/record/watermark.png";
        let base64 = req.body.base64;
        fs.writeFileSync(path, base64, "base64");
    }

    connection.query(
        `UPDATE settings
    SET
    watermark = ${req.body.watermark},
    face = ${req.body.face},
    human = ${req.body.human},
    voice = ${req.body.voice}
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.get("/doctor", (req, res) => {
    let searchType = req.query.searchType;
    let search = req.query.search;

    let sort = req.query.sort;
    let sort_type = req.query.sortType;

    let per_page = req.query.per_page;
    let page = req.query.page;

    connection.query(
        `SELECT *
    FROM doctors
    ${
        searchType && search
            ? "WHERE " + searchType + " LIKE '%" + search + "%'"
            : ""
    }
    ${
        per_page && page
            ? "LIMIT " +
              (parseInt(page) - 1) * parseInt(per_page) +
              " , " +
              parseInt(per_page)
            : ""
    };`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.post("/doctor", (req, res) => {
    connection.query(
        `INSERT INTO doctors
    VALUES (NULL, "${req.body.name}","${req.body.department}","${req.body.rank}","${req.body.employee_id}")`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.patch("/doctor", (req, res) => {
    connection.query(
        `UPDATE doctors
    SET
    name = "${req.body.name}",
    department = "${req.body.department}",
    doctors.rank = "${req.body.rank}",
    employee_id = "${req.body.employee_id}"
    WHERE id = ${req.body.id}`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

app.delete("/doctor", (req, res) => {
    req.body.doctors.forEach(async e => {
        let query = `
        DELETE FROM doctors
        WHERE id=${e};
        `;

        console.log(query);

        connection.query(query);
    });

    res.send({ result: true });
});

app.post("/getDoctorName", (req, res) => {
    let doctor_id = req.body.doctor_id;
    connection.query(
        `SELECT *
    FROM doctors
    WHERE id = ${doctor_id};`,
        function(err, rows, fields) {
            if (err) throw err;

            res.send(rows);
        }
    );
});

// 30일 지난 record 삭제
cron.schedule(
    "0 4 * * *",
    () => {
        let before30days = moment()
            .subtract(30, "days")
            .format("YYYY-MM-DD HH:mm:ss");
        let before7days = moment()
            .subtract(7, "days")
            .format("YYYY-MM-DD HH:mm:ss");

        connection.query(`UPDATE records
        SET expiration = 1
        WHERE date <= "${before30days}"`);

        connection.query(`UPDATE record_access
        SET status = NULL
        WHERE status = "permitted"
        AND updated_at <= "${before7days}"`);

        connection.query(`UPDATE takeout_access
        SET status = NULL
        WHERE status = "permitted"
        AND updated_at <= "${before7days}"`);
    },
    {
        timezone: "Asia/Seoul"
    }
);

// 서버 재시작 됐을경우 이어서 녹화
function continueRecords() {
    connection.query(
        `
        SELECT *
        FROM records
        WHERE end_date IS NULL;
    `,
        function(err, rows, fields) {
            if (err) throw err;

            rows.forEach(e => {
                let deviceTime = moment().format("YYYYMMDDHHmmssSSS");
                let serverTime = moment().format("YYYY-MM-DD HH:mm:ss");
                let devices = e.devices.split(",");

                connection.query(`UPDATE records
            SET split = 2
            WHERE id = ${e.id}`);

                connection.query(
                    `INSERT INTO splited_records VALUES (NULL, "${deviceTime}", "${serverTime}", NULL, ${e.id})`
                );

                devices.forEach(device => {
                    mqttClient.publish(
                        `/record/start/${device}`,
                        JSON.stringify({
                            serial_number: device,
                            status: true,
                            start_time: deviceTime
                        })
                    );
                });
            });
        }
    );
}

continueRecords();

const sslOptions = {
    key: fs.readFileSync("/etc/nginx/ssl/nginx.key"),
    cert: fs.readFileSync("/etc/nginx/ssl/nginx-certificate.crt")
};

https.createServer(sslOptions, app).listen(3000);
