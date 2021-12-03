<template>
  <div>
    <b-row>
      <b-colxx xl="4" lg="12">
        <b-card style="height:235px;" title="단말 현황">
          <doughnut-chart v-if="deviceChartData" :data="deviceChartData" shadow />
        </b-card>
      </b-colxx>
      <b-colxx xl="4" lg="12">
        <b-card style="height:235px;" title="수술 현황">
          <doughnut-chart v-if="surgeryChartData" :data="surgeryChartData" shadow />
        </b-card>
      </b-colxx>
      <b-colxx xl="4" lg="12">
        <b-card style="height:235px;" title="오늘 일정">
          <doughnut-chart v-if="eventsChartData" :data="eventsChartData" shadow />
        </b-card>
      </b-colxx>
    </b-row>
    <b-row>
      <b-colxx sm="12" xl="7" lg="7">
        <!-- 수술실 목록 -->
        <b-card class="surgeryTable" style="height:330px;">
          <b-card-body style="padding:0px;">
            <b-table-simple>
              <b-tr>
                <b-th class="text-center">
                  수술실
                </b-th>
                <b-th class="text-center">
                  수술실 상황
                </b-th>
                <b-th class="text-center">
                  수술실 시작 시간
                </b-th>
                <b-th class="text-center">
                  비고
                </b-th>
                <b-th class="text-center">
                  송출
                </b-th>
              </b-tr>
              <b-tr v-for="(surgery,index) in surgeries" :key="index" style="height:30px">
                <b-td class="text-center">
                  {{surgery.surgery_name}}
                </b-td>
                <b-td class="text-center">
                  {{surgery.record === 1 ? "수술중" : "대기중"}}
                </b-td>
                <b-td class="text-center">
                  {{surgery.record_time}}
                </b-td>
                <b-td class="text-center">
                  {{surgery.note}}
                </b-td>
                <b-td class="text-center">
                  <b-button
                    v-if="currentSurgery !== index"
                    variant="outline-primary"
                    icon
                    class="ma-2"
                    @click="clickBroad(index)"
                  >
                    송출
                  </b-button>
                  <div style="padding:9px 0 9px 0" v-else>
                    송출중...
                  </div>
                </b-td>
              </b-tr>
            </b-table-simple>
          </b-card-body>
        </b-card>
      </b-colxx>
      <b-colxx sm="12" xl="5" lg="5">
        <!-- 카메라 -->
        <b-row v-if="main">
          <b-colxx :class="currentSize" v-for="(video,index) in main.live_urls" :key="index">
              <WebRtcPlayer
                v-if="parseInt(main.isLives[index])"
                :liveurl="video"
                :id="'surgeryLive'+index"></WebRtcPlayer>
              <VideoPlayer
                v-else
                :isHistory="false"
                :manifest-url="video"
                style="height:100%;"
              />
          </b-colxx>
        </b-row>
      </b-colxx>
    </b-row>
    <!-- <b-row>
      <b-colxx xxs="12">
        <div class="move-video-buttons" v-if="main">
          <b-button :disabled="currentSurgery === 0" class="mb-1" @click="prevSurgery" variant="primary"><</b-button>
          <h2 style="display:inline"><b-badge class="mb-1" pill variant="primary">[ {{ main.surgery_name }} ]</b-badge></h2>
          <b-button :disabled="currentSurgery === surgeries.length-1" @click="nextSurgery" class="mb-1" variant="primary">></b-button>
        </div>
      </b-colxx>
    </b-row> -->
  </div>
</template>

<script>
import IconCardsCarousel from "../../../containers/dashboards/IconCardsCarousel";
import subLives from "../../../containers/dashboards/subLives";
import mainLive from "../../../containers/dashboards/mainLive";
import api from "../../../api"
import VideoPlayer from '../../../components/Shaka/VideoPlayer.vue'
import WebRtcPlayer from '../../../components/WebRTC/WebRTC.vue'
import DoughnutChart from "../../../components/Charts/Doughnut.vue"
import IconCard from "../../../components/Cards/IconCard";
import {
    mapGetters
} from "vuex";
import { ThemeColors } from '../../../utils'
import moment from 'moment'
const colors = ThemeColors()

export default {
  components: {
    VideoPlayer,
    "icon-cards-carousel": IconCardsCarousel,
    "sub-lives": subLives,
    "main-live":mainLive,
    WebRtcPlayer,
    "doughnut-chart": DoughnutChart,
    "icon-card": IconCard
  },
  computed: {
    ...mapGetters(["currentUser", "processing", "loginError"]),
    currentSize() {
      return this.main.live_urls.length !== 1 ? "col-sm-6" : "col-sm-12"
    }
  },
  data () {
    return {
      surgeries : [],
      main : null,
      sub : null,
      currentSurgery:0,
      mosaicChecked:true,
      broadcastSurgery:0,
      deviceChartData : null,
      surgeryChartData : null,
      eventsChartData : null,
      devices:[],
      activatedDevicesCount:0,
      surgeries:[],
      activatedSurgeriesCount:0,
      todaySchedules:[],
      standardEvent:0,
      recordingEvent:0
    }
  },

  async beforeCreate () {
    let result = await api.getSurgery()
    this.surgeries = result
    let temp = JSON.parse(JSON.stringify(result[0]))
    temp.device_names = temp.device_names.split(',')
    temp.live_urls = temp.live_urls.split(',')
    temp.devices = temp.devices.split(',')
    temp.isLives = temp.isLives.split(',')

    this.main = temp

    this.sub = result;
  },

  async mounted() {
    this.surgeries = await api.getSurgery()

    let start = moment().format("YYYY-MM-DD")
    let end = moment().format("YYYY-MM-DD 23:59:59")

    for(let i = 0; i < this.surgeries.length; i++) {
      let temp = await api.getDevices(this.surgeries[i])
      this.devices = this.devices.concat(temp)

      let _temp = await api.getSchedule({alltype:1,start,end,surgery_id:this.surgeries[i].surgery_id,searchType:this.currentSearchType, search:''})
      this.todaySchedules = this.todaySchedules.concat(_temp)

      if(this.surgeries[i].record)
        this.activatedSurgeriesCount++;
    }

    for(let i = 0; i < this.todaySchedules.length; i++) {
      if(this.todaySchedules[i].is_record)
        this.recordingEvent++;
      else
        this.standardEvent++;
    }

    // 스트리밍 서버있을때 용
    // let temp = await api.getConnectecDevices()
    let temp = []
    this.activatedDevicesCount = temp.length
    this.deviceChartData = {
      labels: ['ON', 'OFF'],
      datasets: [
        {
          label: '',
          borderColor: [colors.themeColor2,colors.themeColor3],
          backgroundColor: [
            colors.themeColor2_10,
            colors.themeColor3_10,
          ],
          borderWidth: 2,
          data: [this.activatedDevicesCount,this.devices.length-this.activatedDevicesCount]
        }
      ]
    }

    this.surgeryChartData = {
      labels: ['수술중', '대기중'],
      datasets: [
        {
          label: '',
          borderColor: [colors.themeColor2,colors.themeColor3],
          backgroundColor: [
            colors.themeColor2_10,
            colors.themeColor3_10,
          ],
          borderWidth: 2,
          data: [this.activatedSurgeriesCount,this.surgeries.length]
        }
      ]
    }

    this.eventsChartData = {
      labels: ['시작중', '대기'],
      datasets: [
        {
          label: '',
          borderColor: [colors.themeColor2,colors.themeColor3],
          backgroundColor: [
            colors.themeColor2_10,
            colors.themeColor3_10,
          ],
          borderWidth: 2,
          data: [this.recordingEvent,this.standardEvent]
        }
      ]
    }
  },

  methods: {
    nextSurgery() {
      this.currentSurgery++
      this.changeVideo()
    },
    prevSurgery() {
      this.currentSurgery--
      this.changeVideo()
    },
    clickBroad(val) {
      this.currentSurgery = val
      this.main.isLives = [0,0,0,0]
      this.changeVideo()
    },
    changeVideo() {
      console.log(this.surgeries,this.currentSurgery)
      let temp = JSON.parse(JSON.stringify(this.surgeries[this.currentSurgery]))
      temp.device_names = temp.device_names.split(',')
      temp.live_urls = temp.live_urls.split(',')
      temp.devices = temp.devices.split(',')
      temp.isLives = temp.isLives.split(',')
      this.main = temp
    },
    mosaicToggle(val) {
      console.log(val);
    }
  }
};
</script>
