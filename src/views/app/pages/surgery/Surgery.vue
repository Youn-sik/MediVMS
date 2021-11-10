<template>
  <div v-if="surgeries.length">
    <b-row>
        <div v-if="currentUser.authority === '0'" class="reservBtn" style="position:fixed; right:0px; top:50%; background: #1e2022; width:50px; height:50px; text-align:center" variant="outline-secondary" @click="()=>{rightModal=true}">
          <i class="simple-icon-calendar" style="font-size:30px; line-height:50px;"></i>
        </div>

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
        <b-modal v-model="rightModal" :title="'이번달 일정'" size="lg" modal-class="modal-right">
            <template #modal-title>
                <div class="">
                    이번달 일정
                    <b-button class="mb-1 ml-3" variant="outline-secondary" @click="()=>{addModal=true}">수술실 예약</b-button>
                </div>
            </template>
            <div>
            <p v-if="currentSurgery.record" style="float:right; margin-top:8px">녹화 시작 시간 : {{currentSurgery.record_time}}</p>
            <template v-for="(i,index) in schedules.slice(this.currentPage * this.perPage - 3 , this.currentPage * this.perPage)">
              <b-card :key="index"
              class="mb-3 schedule-list"
              >
                <div>
                  <div :class="i.is_record === 1 ? 'started' :
                  i.emergency === 1 ? 'emergency ' :
                  i.start <= now ? 'standby' : ''"
                  style="width:20px; height:20px; border-radius: 100px; display:inline-block; float:left" class="mb-3">
                  </div>
                  <p class="ml-2" style="display:inline-block; float:left">
                    {{i.is_record === 1 ? '진행중' :
                    i.emergency === 1 ? '긴급 예약' :
                    i.start <= now ? '시작 대기중' : '대기중'}}
                  </p>
                </div>
                <b-table-simple>
                  <b-tbody striped>
                    <b-tr>
                      <b-th rowspan="1" width="25%">일정명</b-th>
                      <b-th rowspan="1" width="25%">담당 의사명</b-th>
                      <b-th rowspan="1" width="25%">환자명</b-th>
                      <b-th rowspan="1" width="25%">비고</b-th>
                      <!-- <b-th rowspan="1">환자 나이</b-th>
                      <b-th rowspan="1">환자 성별</b-th>
                      <b-th rowspan="1">환자 상태</b-th> -->
                    </b-tr>
                    <b-tr>
                      <b-td rowspan="1">{{i.name}}</b-td>
                      <b-td colspan="1">{{i.doctor_name}}</b-td>
                      <b-td colspan="1">{{i.patient_name}}</b-td>
                      <b-td colspan="1">{{i.note}}</b-td>
                      <!-- <b-td colspan="1">{{i.patient_age}}</b-td>
                      <b-td colspan="1">{{i.patient_sex}}</b-td>
                      <b-td colspan="1">{{i.patient_status}}</b-td> -->
                    </b-tr>
                  </b-tbody>
                </b-table-simple>
                <div style="float:left" v-if="i.start.length > 10">수술 시간 : {{i.start}} ~ {{i.end}}</div>
                <div style="float:left" v-else>긴급 수술</div>
                <div style="float:right" v-if="i.is_record === 0">
                  <b-button class="mr-3" @click="startSchedule(i)">시작</b-button>
                  <b-button class="mr-3" variant="danger" @click="deleteSchedule(i.id)">취소</b-button>
                </div>
                <div style="float:right" v-else>
                  <b-button class="mr-3" variant="danger" @click="endSchedule(i)">종료</b-button>
                </div>
              </b-card>
            </template>
            <b-pagination
              align="center"
              v-model="currentPage"
              :total-rows="schedules.length"
              :per-page="3"
              aria-controls="my-table"
            ></b-pagination>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
              <b-button variant="danger" @click="ok()">
                닫기
              </b-button>
            </template>
          </b-modal>

        <!-- <b-modal :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" :hide-header-close="true" v-model="reservModal" size="lg" title="수술실 예약">
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
        </b-modal> -->

        <b-colxx xl="8" lg="12" class="mb-4">
            <piaf-breadcrumb :heading="'수술실'" />
            <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
            </b-dropdown>
            <b-button v-if="currentSurgery.record && currentUser.authority > 1" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="recordStop">녹화 종료</b-button>
            <div class="separator mb-5"></div>
            <b-row>
                <b-colxx v-for="(url,index) in currentSurgery.live_urls" :key="index" xxs="6" class="mb-4">
                      <div v-if="currentUser.authority !== '0' && currentUser.surgery_room_auth.indexOf(currentSurgery.surgery_id) === -1" style="text-align:center; padding-top:100px; height:200px">
                        시청 권한이 없습니다.
                      </div>
                      <WebRtcPlayer
                        v-else-if="parseInt(currentSurgery.isLives[index])"
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
        <b-colxx xl="4" lg="12" class="mb-4" v-if="schedules.length">
          <piaf-breadcrumb :heading="'정보'" />
          <!-- <b-button v-if="currentUser.authority <= 0" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="()=>{reservModal=true}">수술실 예약</b-button> -->
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
                  <b-td colspan="1">{{schedules[0].patient_name}}</b-td>
                  <b-td colspan="1">{{schedules[0].patient_age}}</b-td>
                  <b-td colspan="1">{{schedules[0].patient_sex}}</b-td>
                  <b-td colspan="1">{{schedules[0].patient_status}}</b-td>
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
                  <b-td colspan="1" v-if="schedules[0].doctor_name">사진</b-td>
                  <b-td colspan="1">{{schedules[0].doctor_name}}</b-td>
                  <b-td colspan="1" v-if="schedules[0].doctor_name">외과</b-td>
                  <b-td colspan="1"></b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </b-card>
        </b-colxx>
        <b-colxx xl="4" lg="12" class="mb-4" v-else>
          <piaf-breadcrumb :heading="'정보'" />
          <!-- <b-button v-if="currentUser.authority <= 0" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="()=>{reservModal=true}">수술실 예약</b-button> -->
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
            now:moment().format('YYYY-MM-DD HH:mm:ss'),

            // 스케줄 추가 데이터
            addModal:false,
            newEvent:{
                color:'',
                name:'',
                timed:true,
                start:'',
                end:'',
                emergency:false,
            },
            colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange'],
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
                start:'',
                end:'',
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

            alert('저장되었습니다.')

            this.getSchedule()

            this.addModal = false;

            this.newEvent = {
                color:'',
                name:'',
                timed:true,
                start:'',
                end:'',
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


          this.getSchedule()
        },
        async recordStart() {
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
          }
        },
        async getSchedule() {
          let start = moment().format("YYYY-MM-DD")
          let end = moment().endOf('month').format("YYYY-MM-DD 23:59:59")
          this.schedules = await api.getSchedule({surgery_id:this.currentSurgery.surgery_id,start,end,alltype:1})
        },

        async startSchedule(schedule) {
            if(this.schedules[0].is_record === 1) {
                if(confirm('이미 진행중인 일정을 종료해야만 다음 일정을 시작할 수 있습니다\n종료 하시겠습니까? ')) {
                    this.endSchedule(this.schedules[0])
                } else
                    return false;
            }

            await api.patchSchedule({...schedule, is_record:1});

            this.getSchedule()

            this.recordStart()
        },

        async endSchedule(schedule) {
            await api.patchSchedule({...schedule, is_record:0,is_over:1});

            this.getSchedule()
        }
    },
    async mounted () {
        await this.getSurgery()

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
          this.mqttClient.subscribe([
            '/detect/emergancy/+',
          ], (error, result) => {
            if (error) {
              console.log('MQTT subscribe error.');
            } else {
              console.log('MQTT subscribed.');
            }
          });
        })

        this.mqttClient.on('message', (topic, message) => {
          if(topic === '/detect/emergancy/'){
            this.getSchedule()
          }
        })
    },
    destroyed() {
      this.mqttClient.end(true);
    }

};
</script>