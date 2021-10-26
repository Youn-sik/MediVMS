import axios from 'axios';
import moment from 'moment';
import {base_url} from './server.json'
axios.defaults.baseURL = `http://${base_url}:3000`

const api = {
    getSurgery(params) {
        return new Promise((resolve, reject) => {
            axios.get('/getSurgery').then(
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
                auth:params.auth,
                account:params.account,
                surgery_room_auth:params.surgeryAuth
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

    getRecords(params) {
        return new Promise((resolve, reject) => {
            axios.get('/getRecords').then(
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
            axios.get('/schedule',params).then(
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
            axios.delete('/schedule',params).then(
                res => {
                    resolve(res.data)
                },
                error => reject(error)
            )
        })
    },
}

export default api