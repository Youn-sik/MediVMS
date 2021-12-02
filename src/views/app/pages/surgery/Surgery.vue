<template>
  <div v-if="surgeries.length">
    <b-row>
        <!-- <div v-if="currentUser.authority === '0'" class="reservBtn" style="position:fixed; right:0px; top:50%; background: #1e2022; width:50px; height:50px; text-align:center" variant="outline-secondary" @click="()=>{rightModal=true}">
          <i class="simple-icon-calendar" style="font-size:30px; line-height:50px;"></i>
        </div> -->

        <!-- 일정 추가 modal -->
         <b-modal
            v-model="addModal"
            id="modalright"
            ref="modalright"
            :title="'일정 추가'"
            modal-class="modal-right"
        >
            <b-form>
                <b-form-group label="일정 이름">
                    <b-form-input v-model="newEvent.name" />
                </b-form-group>
                <b-form-group label="일정 시작 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.start"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="일정 종료 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.end"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="비고">
                    <b-form-input v-model="newEvent.note" />
                </b-form-group>
                <b-form-group label="색상">
                    <vselect label="name" :options="colors" v-model="newEvent.color" dir="ltr" >
                        <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <!-- <img :src="option.owner.avatar_url" height="25" /> -->
                                <div :class="'color-sample ' + option.name" style="display:inline-block; margin-right:5px;"></div>
                                {{ option.name }}
                            </div>
                        </template>
                    </vselect>
                </b-form-group>
                <b-form-checkbox
                id="emergency"
                v-model="newEvent.emergency"
                name="emergency"
                >
                긴급 녹화&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                ※ 체크시 시간과 관계없이 해당 스케줄을 최상위로 표시합니다
                </b-form-checkbox>
            </b-form>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancelSaveEvent">
                    취소
                </b-button>
                <b-button @click="addSchedule">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- 오른쪽 모달 -->
        <b-modal v-model="rightModal" :title="'일정'" size="lg" modal-class="modal-right">
            <template #modal-title>
                <div class="">
                    일정
                    <b-button class="mb-1 ml-3" variant="outline-secondary" @click="()=>{addModal=true}">수술실 예약</b-button>
                </div>
            </template>
            <div>
            <template>
              <div>
                  <div :class="currentSchedule.is_record === 1 ? 'started' :
                  currentSchedule.emergency === 1 ? 'emergency ' :
                  currentSchedule.start <= now ? 'standby' : ''"
                  style="width:20px; height:20px; border-radius: 100px; display:inline-block; float:left" class="mb-3">
                  </div>
                  <p class="ml-2" style="display:inline-block; float:left">
                    {{currentSchedule.is_record === 1 ? '진행중' :
                    currentSchedule.emergency === 1 ? '긴급 예약' :
                    currentSchedule.start <= now ? '시작 대기중' : '대기중'}}
                  </p>
              </div><br/><br/>
              <b-card>
                <p>예약 정보</p>
                <b-table-simple>
                  <b-tbody striped>
                    <b-tr>
                      <b-th rowspan="1" width="20%">일정명</b-th>
                      <b-th rowspan="1" width="20%">수술실</b-th>
                      <b-th rowspan="1" width="20%">비고</b-th>
                      <b-th rowspan="1" width="20%"></b-th>
                    </b-tr>
                    <b-tr>
                      <b-td colspan="1">{{currentSchedule.name}}</b-td>
                      <b-td colspan="1">{{currentSurgery.surgery_name}}</b-td>
                      <b-td colspan="1">{{currentSchedule.note}}</b-td>
                      <b-td colspan="1"></b-td>
                    </b-tr>
                  </b-tbody>
                </b-table-simple>
              </b-card>

              <b-card class="mt-3">
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
                      <b-td colspan="1">{{currentSchedule.patient}}</b-td>
                      <b-td colspan="1"></b-td>
                      <b-td colspan="1"></b-td>
                      <b-td colspan="1"></b-td>
                    </b-tr>
                  </b-tbody>
                </b-table-simple>
              </b-card>

              <b-card class="mt-3">
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
                      <b-td colspan="1"></b-td>
                      <b-td colspan="1">{{currentSchedule.doctor}}</b-td>
                      <b-td colspan="1"></b-td>
                      <b-td colspan="1"></b-td>
                    </b-tr>
                  </b-tbody>
                </b-table-simple>
              </b-card>
            </template>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
              <b-button @click="startSchedule(currentSchedule)">
                시작
              </b-button>
              <b-button variant="danger" @click="nextSchedule">
                스킵
              </b-button>
            </template>
          </b-modal>

        <b-colxx xl="8" lg="12" class="mb-4">
            <piaf-breadcrumb :heading="'수술실'" />
            <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
            </b-dropdown>
            <b-button class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="reset">일정 새로고침</b-button>
            <b-button v-if="recordingSchedule.is_record" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="endSchedule(recordingSchedule)">일정 종료</b-button>
            <div class="separator mb-5"></div>
            <b-row>
                <b-colxx v-for="(url,index) in currentSurgery.live_urls" :key="index" xxs="6" class="mb-4">
                      <WebRtcPlayer
                        v-if="parseInt(currentSurgery.isLives[index])"
                        :liveurl="url"
                        :id="'surgeryLive'+index"
                      />
                      <VideoPlayer
                          v-else
                          :isHistory="false"
                          :manifest-url="url"
                          style="height:100%;"
                      />
                </b-colxx>
            </b-row>
        </b-colxx>
        <b-colxx xl="4" lg="12" class="mb-4">
          <piaf-breadcrumb :heading="'정보'" />
          <!-- <b-button v-if="currentUser.authority <= 0" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="()=>{reservModal=true}">수술실 예약</b-button> -->
          <!-- <p v-if="currentSurgery.record" style="float:right; margin-top:8px">녹화 시작 시간 : {{currentSurgery.record_time}}</p> -->
          <div class="separator mb-5"></div>
          <b-card>
            <p>일정 정보</p>
            <b-table-simple>
              <b-tbody striped>
                <b-tr>
                  <b-th rowspan="1" width="20%">수술실</b-th>
                  <b-th rowspan="1" width="20%">일정명</b-th>
                  <b-th rowspan="1" width="20%">일정 상태</b-th>
                  <b-th rowspan="1" width="20%"></b-th>
                </b-tr>
                <b-tr>
                  <b-td colspan="1">{{currentSurgery.surgery_name}}</b-td>
                  <b-td colspan="1">{{recordingSchedule.name}}</b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>

          <b-card class="mt-3">
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
                  <b-td colspan="1">{{recordingSchedule.patient}}</b-td>
                  <b-td colspan="1">{{recordingSchedule.patient_age}}</b-td>
                  <b-td colspan="1">{{recordingSchedule.patient_sex}}</b-td>
                  <b-td colspan="1">{{recordingSchedule.patient_status}}</b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>

          <b-card class="mt-3">
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
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1">{{recordingSchedule.doctor}}</b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>
        </b-colxx>
        <!-- <b-colxx xl="4" lg="12" class="mb-4" v-else>
          <piaf-breadcrumb :heading="'정보'" />
          <p v-if="currentSurgery.record" style="float:right; margin-top:8px">녹화 시작 시간 : {{currentSurgery.record_time}}</p>
          <div class="separator mb-5"></div>
          <b-card>
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
                  <b-td colspan="1">{{currentSurgery.surgery_name}}</b-td>
                  <b-td colspan="1">24°C</b-td>
                  <b-td colspan="1">50%</b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>

          <b-card class="mt-3">
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
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>

          <b-card class="mt-3">
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
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>
        </b-colxx> -->
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
import { Datetime } from 'vue-datetime';
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
import moment from 'moment'
moment.locale("ko");
export default {
    computed: {
      ...mapGetters(["currentUser"]),
      rows() {
        return this.schedules.length
      },
    },
    data () {
        return {
            rightModal:false,
            currentPage:1,
            perPage:3,
            surgeries : [],
            currentSurgery : null,
            recordEndModal : false,
            currentSurgeryImdex : 0,
            recordModal : false,
            mqttClient:null,
            reservModal:null,
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
            schedules:[],
            currentSchedule:{},
            currentScheduleIndex:0,
            waitinhScheduleIndex:0,
            nextSchedulePanding:false,
            now:moment().format('YYYY-MM-DD HH:mm:ss'),

            // 스케줄 추가 데이터
            addModal:false,
            newEvent:{
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false,
            },
            colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange'],

            recordingSchedule:{}, //녹화중인 스케줄

            scheduleInterval:null,

            pendingSchedule:null //시간대로 인해 대기중인 스케줄
        }
    },
    components: {
        VideoPlayer,
        WebRtcPlayer,
        datetime: Datetime,
        "vselect": vSelect
    },
    methods: {
        // 스케줄 추가 메소드
        cancelSaveEvent() {
            this.newEvent = {
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false,
            }

            this.addModal = false;
        },
        async addSchedule() {
            if(this.newEvent.emergency) {
                this.newEvent.start = moment(this.newEvent.start).format('YYYY-MM-DD')
                this.newEvent.end = moment(this.newEvent.end).format('YYYY-MM-DD')
            } else {
                this.newEvent.start = moment(this.newEvent.start).format('YYYY-MM-DD HH:mm')
                this.newEvent.end = moment(this.newEvent.end).format('YYYY-MM-DD HH:mm')
            }
            await api.addSchedule({...this.newEvent, surgery_id:this.currentSurgery.surgery_id})

            this.getSchedule()

            this.addModal = false;

            this.newEvent = {
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false
            }
        },
        async deleteSchedule(id) {
            await api.deleteSchedule({id})
            this.getSchedule()
        },

        async changeSurgery(val,index) {
            this.currentSurgery = JSON.parse(JSON.stringify(val))
            this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
            this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
            this.currentSurgery.devices = this.currentSurgery.devices.split(',')
            this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
            this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')
            this.currentSurgeryImdex = index

            this.getSchedule()
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


          await this.getSchedule()
        },
        async recordStart() {
          let startTime = moment().format('YYYYMMDDHHmmss')

          await api.recordStart({
            id:this.currentSurgery.surgery_id
          })


          console.log("record_start");
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
            department : '임시 정보',
            doctor : '임시 정보',
            patient_name : '임시 정보',
            surgery_desc : '임시 정보',
            patient_status : "수술 완료",
            devices:this.currentSurgery.serial_numbers.join(','),
            date : moment().format('YYYY-MM-DD HH:mm:ss'),
            video_link : `http://172.16.41.105:3000/stream/${currentSerial}_${startTime}.mp4`
          })
        },
        async recordStop() {
          await api.recordStop({
            id:this.currentSurgery.surgery_id
          })

          console.log("record_stop");
          this.currentSurgery.serial_numbers.forEach(e => {
              this.mqttClient.publish(`/record/stop/${e}`, JSON.stringify({
                serial_number:`${e}`,
                status:true,
                end_time:moment().format('YYYY-MM-DD HH:mm:ss')
              }))
            });
        },
        async getSchedule() {
          let start = moment().format("YYYY-MM-DD")
          let end = moment().endOf('month').format("YYYY-MM-DD 23:59:59")
          this.schedules = await api.getSchedule({surgery_id:this.currentSurgery.surgery_id,start,end,alltype:0,searchType:'',search:''})

          if(this.schedules.length && this.schedules[0].is_record)
            this.recordingSchedule = this.schedules[0]
        },

        async startSchedule(schedule) {
            if(this.recordingSchedule.is_record === 1) {
              this.endSchedule(this.schedules[0])
              this.currentSurgeryImdex--;
            }

            this.recordingSchedule = {...schedule, is_record:1}

            await api.patchSchedule({...schedule, is_record:1});

            this.recordStart()

            this.rightModal = false;
        },

        async endSchedule(schedule) {
            await api.patchSchedule({...schedule, is_record:0,is_over:1});

            // this.currentSurgery.serial_numbers.forEach(e => {
            //   this.mqttClient.publish(`/record/stop/${e}`, JSON.stringify({
            //     serial_number:`${e}`,
            //     status:true,
            //     end_time:moment().format('YYYY-MM-DD HH:mm:ss')
            //   }))
            // });

            this.recordingSchedule = {}

            this.recordStop()

            // this.currentScheduleIndex--;

            this.reset()
        },

        setCurrentSchedule(schedule) {
          let now = moment().format("YYYY-MM-DD HH:mm")
          console.log(schedule,this.schedules.length, schedule.is_over, schedule.is_record)
          if(!schedule.emergency &&
          schedule.start > now){

            this.pendingSchedule = schedule;
            this._setInterval()

            this.rightModal = false;
            return 0;
          } else if((this.schedules.length === 0 || !schedule.is_over) && !schedule.is_record) {
            this.currentSchedule = schedule;
            this.rightModal = true
          } else{
            this.nextSchedule()
          }
        },

        nextSchedule() {
          // if(this.schedules[this.currentScheduleIndex]) {
          // } else
          let now = moment().format("YYYY-MM-DD HH:mm")
          console.log(this.schedules.length-1 , this.currentScheduleIndex)
          if(this.schedules.length-1 === this.currentScheduleIndex) {
            console.log("1")
            this.rightModal = false
          } else if(!this.schedules[this.currentScheduleIndex+1].emergency && this.schedules[this.currentScheduleIndex+1].start > now){
            console.log("2")
            this.pendingSchedule = this.schedules[this.currentScheduleIndex+1]
            this._setInterval()

            this.rightModal = false
            return 0;
          } else if(!this.schedules[this.currentScheduleIndex+1].emergency && this.schedules[this.currentScheduleIndex+1].end < now) {
            console.log("3")
            this.currentSurgeryImdex++
            return 0;
          } else if(!this.schedules[0].is_over) {
            console.log("4")
            this.rightModal = false
            setTimeout(() => {
              this.rightModal = true
            },500)
            this.currentSchedule = this.schedules[++this.currentScheduleIndex]
          } else {
            console.log("5")
            this.rightModal = false
            ++this.currentScheduleIndex
            this.nextSchedule()
          }
        },

        async newSchedules(type) {
          let start = moment().format("YYYY-MM-DD")
          let end = moment().endOf('month').format("YYYY-MM-DD 23:59:59")
          let newSchedules = await api.getSchedule({surgery_id:this.currentSurgery.surgery_id,start,end,alltype:0,searchType:'',search:''})
          if(type === 'start'){
            this.rightModal = false;
            await this.getSchedule()
          } else if(type === 'emergancy') {
            if(this.schedules.length) {
              let newItem = null
              newSchedules.forEach((item,index) => {
                let dupl = false
                this.schedules.forEach((j,_index) => {
                  if(item.id === j.id)
                    dupl = true
                })

                if(!dupl)
                  newItem = item
                return false
              })

              this.schedules.splice(this.currentScheduleIndex+1,0,newItem)
              console.log(this.schedules)
              this.nextSchedule()
            } else {
              this.schedules = newSchedules
              this.setCurrentSchedule(this.schedules[0])
            }
          } else if(type === 'patch') {
            this.schedules = newSchedules
          } else if(type === 'add') {
            if(!this.schedules.length){
              this.schedules = newSchedules
              this.setCurrentSchedule(this.schedules[0])
            } else if(newSchedules.length !== this.currentScheduleIndex
            && newSchedules[this.currentScheduleIndex].id === this.schedules[this.currentScheduleIndex].id){ //현재 modal창 이후 시간대에 추가된 경우
              console.log("after",newSchedules)
              this.schedules = newSchedules

              if(!this.rightModal) //modal 꺼져 있을경우
                this.nextSchedule()
            } else { //현재 modal창 이전 시간대에 추가된 경우
              console.log("before",newSchedules)
              this.schedules = newSchedules
              this.currentSurgeryImdex++;

              //TODO : 필요한지 고민 필요
              if(this.schedules.length-1 === this.currentScheduleIndex){
                this.schedules = newSchedules
                this.nextSchedule()
                return
              }
              let newItem = null
              newSchedules.forEach((item,index) => {
                let dupl = false
                this.schedules.forEach((j,_index) => {
                  if(item.id === j.id)
                    dupl = true
                })

                if(!dupl)
                  newItem = item
                return false
              })

              let now = moment().format("YYYY-MM-DD HH:mm:ss")
              console.log(newItem)
              if(newItem && newItem.start <= now && newItem.end > now) {
                this.schedules.splice(this.currentScheduleIndex+1,0,newItem)
                if(!this.rightModal)
                  this.nextSchedule();
              }else {
                return false;
              }
            }
          } else if(type === 'delete') {
            if( newSchedules.length !== this.currentScheduleIndex
            && newSchedules.length
            && newSchedules[this.currentScheduleIndex].id === this.schedules[this.currentScheduleIndex].id){ //현재 modal창 이후 시간대에 삭제된 경우
              this.schedules = newSchedules
            } else { //현재 modal창 이전 ~ 현재 시간대에 삭제된 경우
              if(!newSchedules.length){
                this.nextSchedule()
                this.schedules = newSchedules
                return
              }

              let deletedItem = null
              this.schedules.forEach((item,index) => {
                let dupl = false
                newSchedules.forEach((j,_index) => {
                  if(item.id === j.id)
                    dupl = true
                })

                if(!dupl)
                  deletedItem = item
                return false
              })

              if(deletedItem) { //삭제된 스케줄이 존재하는 경우
                if(deletedItem.id === this.schedules[this.currentScheduleIndex].id) {//현재 스케줄이 삭제된 경우
                  this.nextSchedule()
                }

                this.schedules = newSchedules
                this.currentScheduleIndex--;
              }
            }
          }
        },

        _setInterval() {
          this._clearInterval()
          this.scheduleInterval = setInterval(() => {
            let now = moment().format("YYYY-MM-DD HH:mm")
            console.log(this.pendingSchedule , now)
            if(!this.rightModal && this.pendingSchedule.start <= now) {
              if(this.currentScheduleIndex < 0)
                --this.currentScheduleIndex;
              this.nextSchedule()
              this.pendingSchedule = null;
              this._clearInterval()
            }
          },5000)
        },

        _clearInterval() {
          clearInterval(this.scheduleInterval)
        },

        async reset() {
          await this.getSchedule()
          this.currentScheduleIndex = 0
          if(this.schedules.length) {
            this.setCurrentSchedule(this.schedules[0])
          }
        }
    },
    async mounted () {
        await this.getSurgery()

        if(this.schedules.length) {
          this.setCurrentSchedule(this.schedules[0])
        }

        this.mqttClient = mqtt.connect(mqtt_url,{
          protocol:"ws",
          port:8083,
          keepalive:0,
          path:'/mqtt',
          clientId: 'server_' + Math.random().toString(16).substr(2, 8),
          clean: true,
        })

        this.mqttClient.on('error',function (err) {
          console.log(err)
        })


        this.mqttClient.on('connect', (test) => {
          console.log('MQTT connected.')
          this.mqttClient.subscribe([
            '/send/schedule/+',
          ], (error, result) => {
            if (error) {
              console.log('MQTT subscribe error.');
            } else {
              console.log('MQTT subscribed.');
            }
          });
        })

        this.mqttClient.on('message', (topic, message) => {
          if(topic === '/send/schedule/'){
            let data = JSON.parse(message)
            // this.schedules.push(data.schedule)
            // if(!this.rightModal) {
            //   this.nextSchedule()
            // }
            this.newSchedules(data.type)
          }
        })
    },
    destroyed() {
      this.mqttClient.end(true);
    }

};
</script>