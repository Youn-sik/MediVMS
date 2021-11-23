<template>
  <div v-if="surgeries.length">
    <b-row>
        <!-- 녹화 설정 모달 -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="recordModal" size="lg" title="녹화 설정" v-if="surgeryData.length > 0">
          <p>수술실 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">수술실</b-th>
                <b-th rowspan="1" width="20%">수술실 온도</b-th>
                <b-th rowspan="1" width="20%">수술실 습도</b-th>
                <b-th rowspan="1" width="20%"></b-th>
                <!-- <b-th rowspan="1">환자 나이</b-th>
                <b-th rowspan="1">환자 성별</b-th>
                <b-th rowspan="1">환자 상태</b-th> -->
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].surgery_name}}</b-td>
                <b-td colspan="1">24°C</b-td>
                <b-td colspan="1">50%</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>환자 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">나이</b-th>
                <b-th rowspan="1" width="20%">성별</b-th>
                <b-th rowspan="1" width="20%">상태</b-th>
                <!-- <b-th rowspan="1">환자 나이</b-th>
                <b-th rowspan="1">환자 성별</b-th>
                <b-th rowspan="1">환자 상태</b-th> -->
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].patient_name}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_age}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_sex}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_status}}</b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>담당 의사 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">사진</b-th>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">진료과목</b-th>
                <b-th rowspan="1" width="20%"></b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">사진</b-td>
                <b-td colspan="1">{{surgeryData[0].doctor_name}}</b-td>
                <b-td colspan="1">외과</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>

          <p>예정 수술 시간 : {{surgeryData[0].start_time}} ~ {{surgeryData[0].end_time}}</p>

          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancel()">
              취소
            </b-button>
            <b-button @click="recordStart">
              녹화 시작
            </b-button>
          </template>
        </b-modal>

        <!-- 수술 종료 -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="endSurgeryModal" size="lg" title="수술 종료 설정" v-if="surgeryData.length > 0">
          <p>수술실 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">수술실</b-th>
                <b-th rowspan="1" width="20%">수술실 온도</b-th>
                <b-th rowspan="1" width="20%">수술실 습도</b-th>
                <b-th rowspan="1" width="20%"></b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].surgery_name}}</b-td>
                <b-td colspan="1">24°C</b-td>
                <b-td colspan="1">50%</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>환자 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">나이</b-th>
                <b-th rowspan="1" width="20%">성별</b-th>
                <b-th rowspan="1" width="20%">상태</b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].patient_name}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_age}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_sex}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_status}}</b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>담당 의사 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">사진</b-th>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">진료과목</b-th>
                <b-th rowspan="1" width="20%"></b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">사진</b-td>
                <b-td colspan="1">{{surgeryData[0].doctor_name}}</b-td>
                <b-td colspan="1">외과</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>

          <p>예정 수술 시간 : {{surgeryData[0].start_time}} ~ {{surgeryData[0].end_time}}</p>

          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelEndSurgeryModal(surgeryData[0].id)">
              취소
            </b-button>
            <!-- <b-button @click="cancelSurgery(surgeryData[0].id,'종료')">
              종료
            </b-button> -->
          </template>
        </b-modal>

        <!-- 다음 예약 설정 -->
        <!-- <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="nextModal" size="lg" title="다음 예약 설정" v-if="surgeryData.length > 0">
          <p>수술실 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">수술실</b-th>
                <b-th rowspan="1" width="20%">수술실 온도</b-th>
                <b-th rowspan="1" width="20%">수술실 습도</b-th>
                <b-th rowspan="1" width="20%"></b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].surgery_name}}</b-td>
                <b-td colspan="1">24°C</b-td>
                <b-td colspan="1">50%</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>환자 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">나이</b-th>
                <b-th rowspan="1" width="20%">성별</b-th>
                <b-th rowspan="1" width="20%">상태</b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">{{surgeryData[0].patient_name}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_age}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_sex}}</b-td>
                <b-td colspan="1">{{surgeryData[0].patient_status}}</b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>


          <p>담당 의사 정보</p>
          <b-table-simple>
            <b-tbody striped>
              <b-tr>
                <b-th rowspan="1" width="20%">사진</b-th>
                <b-th rowspan="1" width="20%">이름</b-th>
                <b-th rowspan="1" width="20%">진료과목</b-th>
                <b-th rowspan="1" width="20%"></b-th>
              </b-tr>
              <b-tr>
                <b-td colspan="1">사진</b-td>
                <b-td colspan="1">{{surgeryData[0].doctor_name}}</b-td>
                <b-td colspan="1">외과</b-td>
                <b-td colspan="1"></b-td>
              </b-tr>
            </b-tbody>
          </b-table-simple>

          <p>예정 수술 시간 : {{surgeryData[0].start_time}} ~ {{surgeryData[0].end_time}}</p>

          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelNextModal(surgeryData[0].id)">
              취소
            </b-button>
            <b-button @click="startSurgery(surgeryData[0].id)">
              시작
            </b-button>
          </template>
        </b-modal> -->

        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="reservModal" size="lg" title="수술실 예약">
          <b-form-group id="input-group-2" label="담당 의사명" label-for="input-2">
            <b-form-input
              id="input-2"
              v-model="form.doctorName"
              placeholder=""
              required
            ></b-form-input>
          </b-form-group>
          <b-form-group id="input-group-2" label="수술 환자명" label-for="input-2">
            <b-form-input
              id="input-2"
              v-model="form.patientName"
              placeholder=""
              required
            ></b-form-input>
          </b-form-group>
          <b-form-group id="input-group-2" label="환자 나이" label-for="input-2">
            <b-form-input
              id="input-2"
              v-model="form.patientAge"
              placeholder=""
              required
            ></b-form-input>
          </b-form-group>
          <b-form-group id="input-group-2" label="진단명" label-for="input-2">
            <b-form-input
              id="input-2"
              v-model="form.patientStatus"
              placeholder=""
              required
            ></b-form-input>
          </b-form-group>
          <div style="display:flex; justify-content:space-around;" class="mt-5">
            <div style="text-align:center">
              <b-time v-model="form.startTime" locale="ko"></b-time>
              <p>수술 시작 시간</p>
            </div>

            <div style="text-align:center">
              <b-time v-model="form.endTime" locale="ko"></b-time>
              <p>수술 종료 시간</p>
            </div>
          </div>
          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancel()">
              취소
            </b-button>
            <b-button @click="saveSurgeryReserv">
              저장
            </b-button>
          </template>
        </b-modal>
        <b-colxx xl="12" lg="12" class="mb-4">
          <piaf-breadcrumb :heading="'정보'" />
          <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
              <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
          </b-dropdown>
          <b-button class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="()=>{reservModal=true}">수술실 예약</b-button>
          <p v-if="currentSurgery.record" style="float:right; margin-top:8px">녹화 시작 시간 : {{currentSurgery.record_time}}</p>
          <div class="separator mb-5"></div>
          <template v-for="(i,index) in surgeryData.slice(this.currentPage * this.perPage - 3 , this.currentPage * this.perPage)">
            <b-card class="mb-3" :key="index">
              <div v-if="i.status === '1'" style="width:20px; height:20px; border-radius: 100px; background:#81B214" class="mb-3"></div>
              <div v-if="i.status === '2'" style="width:20px; height:20px; border-radius: 100px; background:gray" class="mb-3"></div>
              <div v-if="i.status === '3'" style="width:20px; height:20px; border-radius: 100px; background:#FF2626" class="mb-3"></div>
              <b-table-simple>
                <b-tbody striped>
                  <b-tr>
                    <b-th rowspan="1">수술실</b-th>
                    <!-- <b-th rowspan="1">시작 기간</b-th>
                    <b-th rowspan="1">종료 시간</b-th> -->
                    <b-th rowspan="1">담당 의사명</b-th>
                    <b-th rowspan="1">환자명</b-th>
                    <b-th rowspan="1">환자 나이</b-th>
                    <b-th rowspan="1">환자 성별</b-th>
                    <b-th rowspan="1">환자 상태</b-th>
                  </b-tr>
                  <b-tr>
                    <b-td colspan="1">{{i.surgery_name}}</b-td>
                    <!-- <b-td colspan="1">{{i.start_time}}</b-td>
                    <b-td colspan="1">{{i.end_time}}</b-td> -->
                    <b-td colspan="1">{{i.doctor_name}}</b-td>
                    <b-td colspan="1">{{i.patient_name}}</b-td>
                    <b-td colspan="1">{{i.patient_age}}</b-td>
                    <b-td colspan="1">{{i.patient_sex}}</b-td>
                    <b-td colspan="1">{{i.patient_status}}</b-td>
                  </b-tr>
                </b-tbody>
              </b-table-simple>
              <div style="float:left">수술 시간 : {{i.start_time}} ~ {{i.end_time}}</div>
              <div style="float:right" v-if="i.status === '2'">
                <!-- <b-button class="mr-3" @click="startSurgery(i.id)">시작</b-button> -->
                <b-button variant="danger" @click="cancelSurgery(i.id,'취소')">취소</b-button>
              </div>
              <div style="float:right" v-else-if="i.status === '1'">
                <!-- <b-button variant="danger" @click="cancelSurgery(i.id,'종료')">종료</b-button> -->
              </div>
            </b-card>
          </template>
          <b-pagination
            align="center"
            v-model="currentPage"
            :total-rows="surgeryData.length"
            :per-page="3"
            aria-controls="my-table"
          ></b-pagination>
        </b-colxx>
    </b-row>
  </div>
</template>
<script>
import api from "../../../../api"
import mqtt from 'mqtt';
import VideoPlayer from '../../../../components/Shaka/VideoPlayer.vue'
import WebRtcPlayer from '../../../../components/WebRTC/WebRTC.vue'
import {
    mapGetters
} from "vuex";
import {mqtt_url} from '../../../../server.json'
import moment from 'moment'
moment.locale("ko");
export default {
    computed: {
      rows() {
        return this.surgeryData.length
      }
    },
    data () {
        return {
            currentPage:1,
            perPage:3,
            surgeries : [],
            nextModal : false,
            currentSurgery : null,
            currentSurgeryImdex : 0,
            recordModal : false,
            startTime:null,
            endTime:null,
            mqttClient:null,
            reservModal:null,
            currentReserv:[],
            reservInterval:null,
            endSurgeryModal:false,
            form:{
              startTime:null,
              endTime:null,
              sugeryId:null,
              doctorName:null,
              patientName:null,
              patientSex:'남자',
              patientAge:null,
              patientStatus:null,
            },
            surgeryData:[
            ]
        }
    },
    computed: {
      ...mapGetters(["currentUser"])
    },
    components: {
        VideoPlayer,
        WebRtcPlayer
    },
    methods: {
        cancelEndSurgeryModal(id) {
          this.endSurgeryModal = false

          localStorage.setItem(this.currentSurgery.surgery_name+"_end",id)
        },
        cancelNextModal(id){
          this.nextModal = false

          localStorage.setItem(this.currentSurgery.surgery_name,id)
        },
        async startSurgery(id) {
          if(this.surgeryData[0].status === '1') {
            alert("이미 수술중인 수술실이 존재합니다.")
          }
          else {
            this.surgeryData = await api.pathReserv({id,status:"1",surgeryId:this.currentSurgery.surgery_id})
            this.nextModal = false
          }
        },
        async cancelSurgery(id,msg) {
          this.surgeryData = await api.pathReserv({id,status:"0",surgeryId:this.currentSurgery.surgery_id})

          if(msg === '종료' && this.currentSurgery.record) {
            this.recordStop(true)
          }

          if(msg === '종료' && this.surgeryData.length){
            this.nextModal = true;
          }

          this.recordStop(true);
        },
        async saveSurgeryReserv() {
          if(this.form.doctorName === null) {
            alert("담당 의사명을 입력해주세요.");
            return false
          } else if(this.form.patientName === null) {
            alert('수술 환자명을 입력해주세요.');
            return false
          } else if(this.form.startTime === null) {
            alert("시작 시간을 입력해주세요.")
            return false
          } else if(this.form.endTime === null) {
            alert("종료 시간을 입력해주세요.")
          } else {
            let currentDate = moment().format("YYYY-MM-DD")
            let nextDay = moment().add(1, 'days').format('YYYY-MM-DD');
            let startTime = null;
            let endTime = null;
            let surgeryId = this.currentSurgery.surgery_id
            startTime = currentDate + ' '+this.form.startTime
            console.log(startTime)
            if(this.form.startTime >= this.form.endTime){
              endTime = nextDay + ' '+this.form.endTime
            }
            else
              endTime = currentDate + ' '+this.form.endTime

            await api.saveReserv({...this.form, startTime,endTime,surgeryId})
            // this.surgeryData[this.currentSurgeryImdex] = {...this.form, surgeryName:this.currentSurgery.surgery_name}

            this.surgeryData = await api.getReserv({surgeryId:this.currentSurgery.surgery_id})

            if(this.surgeryData.length === 1) {
              this.startSurgery(this.surgeryData[0].id)
            }

            this.form = {
              startTime:null,
              endTime:null,
              sugeryId:this.currentSurgery.surgery_id,
              doctorName:null,
              patientName:null,
              patientSex:'남자',
              patientAge:null,
              patientStatus:null,
            }

            this.reservModal = false
          }

          // console.log(this.currentSurgery)
        },
        async changeSurgery(val,index) {
            this.currentSurgery = JSON.parse(JSON.stringify(val))
            this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
            this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
            this.currentSurgery.devices = this.currentSurgery.devices.split(',')
            this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
            this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')
            this.currentSurgeryImdex = index

            this.surgeryData = await api.getReserv({surgeryId:this.currentSurgery.surgery_id})
        },
        saveRecord() {
        },
        async getSurgery() {
          let result = await api.getSurgery()
          this.surgeries = result
          this.currentSurgery = JSON.parse(JSON.stringify(result[this.currentSurgeryImdex]))
          this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
          this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
          this.currentSurgery.devices = this.currentSurgery.devices.split(',')
          this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
          this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')


          this.surgeryData = await api.getReserv({surgeryId:this.currentSurgery.surgery_id})
        },
        setRecordModal() {

          if(this.surgeryData.length === 0|| this.surgeryData[0].status !== '1')
            alert("수술중인 일정이 없습니다\n예약 설정 후 다시 시도해주세요")
          else
            this.recordModal = true
        },
        async recordStart() {
          let now = moment().format('YYYY-MM-DD HH:mm:ss');
          if(now < this.surgeryData[0].start_time || now > this.surgeryData[0].end_time) {
            if(confirm("예약된 수술시간이 되지 않았습니다\n녹화를 시작하시겠습니까?")) {
              await api.recordStart({
                id:this.currentSurgery.surgery_id
              })

              this.currentSurgery.serial_numbers.forEach(e => {
                if(e !== 11){
                  this.mqttClient.publish(`/record/start/${e}`, JSON.stringify({
                    serial_number:`${e}`,
                    status:true,
                    start_time:moment().format('YYYY-MM-DD HH:mm:ss')
                  }))
                }
              });

              this.getSurgery()

              alert('녹화가 시작 되었습니다')
            }
          } else {
            await api.recordStart({
              id:this.currentSurgery.surgery_id
            })

            let startTime = moment().format('YYYYMMDDHHmmss')
            let currentSerial = null

            this.currentSurgery.serial_numbers.forEach(e => {
              currentSerial = e
              this.mqttClient.publish(`/record/start/${e}`, JSON.stringify({
                serial_number:`${e}`,
                status:true,
                start_time:startTime
              }))
            });

            await api.saveRecord({
              sergery_name : this.currentSurgery.surgery_name,
              department : '외과',
              doctor : this.surgeryData[0].doctor_name ? this.surgeryData[0].doctor_name : '정보 없음',
              patient_name : this.surgeryData[0].patient_name ? this.surgeryData[0].patient_name : '정보 없음',
              surgery_desc : '갑상선암',
              patient_status : "수술 완료",
              date : moment().format('YYYY-MM-DD HH:mm:ss'),
              video_link : `http://172.16.41.105:3000/stream/${currentSerial}_${startTime}.mp4`
            })

            this.getSurgery()

            alert('녹화가 시작 되었습니다')
          }

          this.recordModal = false
          // if(confirm()) {
          //   await api.recordStart({
          //     id:this.currentSurgery.surgery_id
          //   })

          //   this.currentSurgery.serial_numbers.forEach(e => {
          //     this.mqttClient.publish(`/record/start/${e}`, JSON.stringify({
          //       serial_number:`${e}`,
          //       status:true,
          //       start_time:moment().format('YYYY-MM-DD HH:mm:ss')
          //     }))
          //   });

          //   this.getSurgery()

          //   alert('녹화가 시작 되었습니다')
          // }
        },
        async recordStop(skip = false) {
          if(skip || confirm('녹화를 종료하시겠습니까?')) {
            await api.recordStop({
              id:this.currentSurgery.surgery_id
            })
            this.currentSurgery.serial_numbers.forEach(e => {
              this.mqttClient.publish(`/record/stop/${e}`, JSON.stringify({
                serial_number:`${e}`,
                status:true,
                end_time:moment().format('YYYY-MM-DD HH:mm:ss')
              }))
            });

            // await api.saveRecord({
            //   sergery_name : this.currentSurgery.surgery_name,
            //   department : '외과',
            //   doctor : this.surgeryData[0].doctor_name ? this.surgeryData[0].doctor_name : '정보 없음',
            //   patient_name : this.surgeryData[0].patient_name ? this.surgeryData[0].patient_name : '정보 없음',
            //   surgery_desc : '갑상선암',
            //   patient_status : "수술 완료",
            //   date : moment().format('YYYYMMDDHHmmss'),
            //   video_link : 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4'
            // })

            this.getSurgery()

            // alert('녹화가 종료 되었습니다')
          }
        },
        async getReserv() {
          this.surgeryData = await api.getReserv({surgeryId:this.currentSurgery.surgery_id})
          let now = moment().format('YYYY-MM-DD HH:mm:ss')

          if(this.surgeryData.length && this.surgeryData[0].status === '2'){
            console.log('1')
            let timeInList = this.surgeryData.filter((e) => {
              return (e.status === '2' && now >= e.start_time)
            })

            if(timeInList.length > 0) {
              if(timeInList[0].id !== parseInt(localStorage.getItem(this.currentSurgery.surgery_name))){
                this.nextModal = true;
              }
            }
          } else if(this.surgeryData.length && this.surgeryData[0].status === '1') {
            let timeOutList = this.surgeryData.filter((e) => {
              return (e.status === '1' && now >= e.end_time)
            })
            if(timeOutList.length > 0) {
              if(timeOutList[0].id !== parseInt(localStorage.getItem(this.currentSurgery.surgery_name+'_end'))){
                this.endSurgeryModal = true;
              }
            }
          }
        }
    },
    beforeDestroy() {
      clearInterval(this.reservInterval)
    },
    async mounted () {
        this.getSurgery()

        this.reservInterval = setInterval(() => {
          this.getReserv()
        },1000 * 2)

        this.mqttClient = mqtt.connect(mqtt_url,{
          protocol:"ws",
          port:8083,
          keepalive:0,
          path:'/mqtt',
          clean: true,
        })

        this.mqttClient.on('error',function (err) {
          console.log(err)
        })


        this.mqttClient.on('connect', (test) => {
          console.log('MQTT connected.')
          // this.mqttClient.subscribe([
          //   '/control/mosaic/result/+',
          //   '/login/+',
          //   '/logout/+',
          // ], (error, result) => {
          //   if (error) {
          //     console.log('MQTT subscribe error.');
          //   } else {
          //     console.log('MQTT subscribed.');
          //   }
          // });
        })
    },
    destroyed() {
      this.mqttClient.end(true);
    }

};
</script>