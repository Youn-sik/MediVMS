<template>
  <div v-if="surgeries.length">
    <b-row>
        <b-colxx xl="8" lg="12" class="mb-4">
            <piaf-breadcrumb :heading="'수술실'" />
            <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
            </b-dropdown>
            <div class="separator mb-5"></div>
            <b-row>
                <b-colxx v-for="(url,index) in currentSurgery.live_urls" :key="index" xxs="6" class="mb-4">
                      <WebRtcPlayer
                        v-if="parseInt(currentSurgery.isLives[index])"
                        :liveurl="url"
                        :id="'surgeryLive'+index"
                      />
                      <!-- <VideoPlayer
                          v-else
                          :isHistory="false"
                          :manifest-url="url"
                          style="height:100%;"
                      /> -->
                </b-colxx>
            </b-row>
        </b-colxx>
        <b-colxx xl="4" lg="12" class="mb-4">
          <piaf-breadcrumb :heading="'정보'" />
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
                  <b-td colspan="1">{{currentSchedule.name}}</b-td>
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
                  <b-td colspan="1">{{currentSchedule.patient}}</b-td>
                  <b-td colspan="1">{{currentSchedule.patient_age}}</b-td>
                  <b-td colspan="1">{{currentSchedule.patient_sex}}</b-td>
                  <b-td colspan="1">{{currentSchedule.patient_status}}</b-td>
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

          <div class="mt-2" style="text-align:center;">
            <b-button v-if="schedules.length && !currentSchedule.is_record" @click="startSchedule(currentSchedule)">시작</b-button>
            <b-button v-if="currentSchedule.is_record" variant="danger" @click="endSchedule(currentSchedule)">종료</b-button>
          </div>
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
            surgeries : [],//수술실 목록
            currentSurgery : null,//현재 모니터링 중인 수술실
            currentSurgeryImdex : 0,//현재 모니터링 중인 수술실 인덱스
            mqttClient:null,
            schedules:[],//스케줄 목록
            currentSchedule:{},//현재 스케줄
        }
    },
    components: {
        VideoPlayer,
        WebRtcPlayer,
        datetime: Datetime,
        "vselect": vSelect
    },
    methods: {
        async changeSurgery(val,index) { //수술실 변경 함수
            this.currentSurgery = JSON.parse(JSON.stringify(val))
            let temp = this.currentSurgery.live_urls
            this.$set(this.currentSurgery,'live_urls',[])
            this.currentSurgeryImdex = index

            this.currentSchedule = {}

            this.getSchedule()

            if(typeof(this.currentSurgery.devices) === 'undefined') {
              setTimeout(() => {
                this.currentSurgery.device_names = []
                this.currentSurgery.devices = []
                this.currentSurgery.isLives = []
                this.currentSurgery.live_urls = []
                this.currentSurgery.serial_numbers = []
              },0)
              return 0;
            } else {
              setTimeout(() => {
                this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
                this.currentSurgery.devices = this.currentSurgery.devices.split(',')
                this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
                this.currentSurgery.live_urls = temp.split(',')
                this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')

              },0)
            }
        },

        async getSurgery() { //db에서 수술실 목록 가져오는 함수
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

        async recordStart() { //녹화 시작 함수
          let startTime = moment().format('YYYYMMDDHHmmss')

          await api.recordStart({
            id:this.currentSurgery.surgery_id
          })

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
            video_link : `/stream/${currentSerial}_${startTime}/${currentSerial}_${startTime}.mp4`
          })
        },

        async recordStop() { //녹화 종료 함수
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
        },

        async getSchedule() { //db에서 스케줄 목록 가져오는 함수
          let start = moment().format("YYYY-MM-DD")
          let end = moment().endOf('month').format("YYYY-MM-DD 23:59:59")
          this.schedules = await api.getSchedule({surgery_id:this.currentSurgery.surgery_id,start,end,alltype:0,searchType:'',search:''})

          console.log(this.schedules)
          if(this.schedules.length) {
            this.currentSchedule = this.schedules[0]
          } else {
            this.currentSchedule = {}
          }
        },

        async startSchedule(schedule) { //스케줄 시작하는 함수
            await api.patchSchedule({...schedule, is_record:1});

            await this.getSchedule()

            this.recordStart()
        },

        async endSchedule(schedule) {// 스케줄 종료하는 함수
            await api.patchSchedule({...schedule, is_record:0,is_over:1});

            this.currentSchedule = {}

            await this.getSchedule()

            this.recordStop()
        },

        async newSchedules(type) { //새로운 스케줄 목록 불러오는 함수
          await this.getSchedule()
        },
    },
    async mounted () {
        await this.getSurgery()

        this.mqttClient = mqtt.connect(mqtt_url,{
          protocol:"wss",
          port:8084,
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
            this.newSchedules(data.type)
          }
        })
    },
    destroyed() {
      this.mqttClient.end(true);
    }

};
</script>