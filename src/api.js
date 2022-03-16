import axios from 'axios';
import moment from 'moment';
import {base_url} from './server.json'
axios.defaults.baseURL = `https://${base_url}:3000`

let ipport = window.location.href.split('/')[2]
let ip = ipport.split(":")[0]

if(base_url !== ip && "localhost" !== ip)
    axios.defaults.baseURL = `https://${ip}:13000`

const api = {
    getConnectecDevices(params) {
        return new Promise((resolve, reject) => {
            axios.get(`https://${base_url}:8443/api/getMediaList`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getSurgery(params) {
        return new Promise((resolve, reject) => {
            axios.get('/surgery').then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    addSurgery(params) {
        return new Promise((resolve, reject) => {
            axios.post('/surgery',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    updateSurgery(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/surgery',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    deleteSurgery(params) {
        return new Promise((resolve, reject) => {
            axios.delete('/surgery',{
                data:{
                    surgeries:params
                }
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    getAccounts() {
        return new Promise((resolve, reject) => {
            axios.get('/getAccounts').then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    login(email,password) {
        return new Promise((resolve, reject) => {
            axios.post('/login',{
                account:email,
                password:password
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    authReq(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/authReq',{
                reqAuth:params.reqAuth,
                account:params.account
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
    setAuth(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/setAuth',{
                ...params
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    recordStart(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/recordStart',{
                dateTime:moment().format('YYYY-MM-DD HH:mm:ss'),
                id:params.id,
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    recordStop(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/recordStop',{
                id:params.id,
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getRecrodAccess(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/record_access?per_page=${params.per_page}&page=${params.page}&user_id=${params.user_id}&first=${params.first}&last=${params.last}&status=${params.status}&searchType=${params.searchType}&search=${params.search}&start=${params.start}&end=${params.end}&sort=${params.sort}&sortType=${params.sortType}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    saveRequestBrowse(params) {
        return new Promise((resolve, reject) => {
            axios.post('/record_access',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    parchRequestBrowse(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/record_access',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getTekeoutAccess(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/takeout_access?per_page=${params.per_page}&page=${params.page}&user_id=${params.user_id}&first=${params.first}&last=${params.last}&status=${params.status}&searchType=${params.searchType}&search=${params.search}&start=${params.start}&end=${params.end}&sort=${params.sort}&sortType=${params.sortType}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    saveRequestTakeout(params) {
        return new Promise((resolve, reject) => {
            axios.post('/takeout_access',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    patchRequestTakeout(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/takeout_access',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getRecords(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/getRecords?per_page=${params.per_page}&page=${params.page}&status=${params.status}&searchType=${params.searchType}&search=${params.search}&start=${params.start}&end=${params.end}&sort=${params.sort}&sortType=${params.sortType}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getRecordAuth(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/record_auth?per_page=${params.per_page}&page=${params.page}&status=${params.status}&searchType=${params.searchType}&search=${params.search}&start=${params.start}&end=${params.end}&sort=${params.sort}&sortType=${params.sortType}&authType=${params.authType}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getSplitedRecords(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/splited_records?record_id=${params.record_id}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    saveRecord(params) {
        return new Promise((resolve, reject) => {
            axios.post('/saveRecord',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    saveReserv(params) {
        return new Promise((resolve, reject) => {
            axios.post('/saveReserv',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getReserv(params) {
        return new Promise((resolve, reject) => {
            axios.get('/getReserv?'+'surgeryId='+params.surgeryId).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    pathReserv(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/pathReserv',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    addSchedule(params) {
        return new Promise((resolve, reject) => {
            axios.post('/schedule',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getSchedule(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/schedule?start=${params.start}&end=${params.end}&surgery_id=${params.surgery_id}&alltype=${params.alltype}&searchType=${params.searchType}&search=${params.search}`,params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    patchSchedule(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/schedule',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    deleteSchedule(params) {
        return new Promise((resolve, reject) => {
            axios.delete('/schedule',{
                data:params
            }).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    saveHistory(params) {
        return new Promise((resolve, reject) => {
            axios.post('/history',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getDevices(params) {
        return new Promise((resolve, reject) => {
            axios.get('/getDevices?surgery_id='+params.surgery_id).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    addDevice(params) {
        return new Promise((resolve, reject) => {
            axios.post('/addDevice',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    updateDevice(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/updateDevice',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    deleteDevice(params) {
        return new Promise((resolve, reject) => {
            axios.post('/deleteDevice',{devices:params}).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    controlDevice(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/controlDevice',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getSettings() {
        return new Promise((resolve, reject) => {
            axios.get('/settings').then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },


    updateSettings(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/settings',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    getDoctors(params) {
        return new Promise((resolve, reject) => {
            axios.get(`/doctor?page=${params.page}&per_page=${params.perPage}&search=${params.search}&searchType=${params.searchType}&sort=${params.sort}&sortType=${params.sortType}`).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    addDoctors(params) {
        return new Promise((resolve, reject) => {
            axios.post('/doctor',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    updateDoctors(params) {
        return new Promise((resolve, reject) => {
            axios.patch('/doctor',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },

    deleteDoctors(params) {
        return new Promise((resolve, reject) => {
            axios.delete('/doctor', params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },


    getDoctorName(params) {
        return new Promise((resolve, reject) => {
            axios.post('/getDoctorName', params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    }

}

export default api
