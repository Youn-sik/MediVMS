<template>
    <div>
        <b-row>
            <b-colxx xl="4" lg="12">
                <b-card style="height:300px;" title="단말 현황">
                    <doughnut-chart
                        v-if="deviceChartData"
                        :data="deviceChartData"
                        shadow
                    />
                </b-card>
            </b-colxx>
            <b-colxx xl="4" lg="12">
                <b-card style="height:300px;" title="수술 현황">
                    <doughnut-chart
                        v-if="surgeryChartData"
                        :data="surgeryChartData"
                        shadow
                    />
                </b-card>
            </b-colxx>
            <b-colxx xl="4" lg="12">
                <b-card style="height:300px;" title="녹화 일정">
                    <doughnut-chart
                        v-if="eventsChartData"
                        :data="eventsChartData"
                        shadow
                    />
                </b-card>
            </b-colxx>
        </b-row>
        <b-row>
            <b-colxx sm="12" xl="7" lg="7">
                <!-- 수술실 목록 -->
                <b-card
                    class="surgeryTable"
                    style="height:410px; overflow:auto"
                >
                    <b-card-body style="height:410px">
                        <b-table-simple style="height:80% !important;">
                            <b-tr>
                                <b-th class="text-center">
                                    수술실
                                </b-th>
                                <b-th class="text-center">
                                    수술 현황
                                </b-th>
                                <b-th class="text-center">
                                    수술실 시작 시간
                                </b-th>
                                <b-th class="text-center">
                                    담당의
                                </b-th>
                                <b-th class="text-center">
                                    환자명
                                </b-th>
                                <b-th class="text-center">
                                    비고
                                </b-th>
                                <b-th class="text-center">
                                    시청
                                </b-th>
                            </b-tr>
                            <b-tr
                                v-for="(surgery, index) in surgeries"
                                :key="index"
                                :class="
                                    currentSurgery !== index ? '' : 'selected'
                                "
                                style=" height:70px;"
                            >
                                <b-td class="text-center">
                                    {{ surgery.surgery_name }}
                                </b-td>
                                <b-td class="text-center">
                                    {{
                                        surgery.record === 1
                                            ? "수술중"
                                            : "대기중"
                                    }}
                                </b-td>
                                <b-td class="text-center">
                                    {{ surgery.record_time }}
                                </b-td>
                                <b-td class="text-center">
                                    {{ surgery.doctor_name }}
                                </b-td>
                                <b-td class="text-center">
                                    {{ surgery.patient }}
                                </b-td>
                                <b-td class="text-center">
                                    {{ surgery.note }}
                                </b-td>
                                <b-td
                                    class="text-center"
                                    v-if="currentSurgery !== index"
                                    style="padding:0px;"
                                >
                                    <a
                                        href="#"
                                        class="play"
                                        @click="clickBroad(index)"
                                    >
                                    </a>
                                </b-td>

                                <b-td class="text-center" v-else>
                                    <a href="#" class="playing"> /></a>
                                </b-td>
                            </b-tr>
                        </b-table-simple>
                    </b-card-body>
                </b-card>
            </b-colxx>
            <b-colxx sm="12" xl="5" lg="5">
                <b-card style="max-height:100%; height:100%;">
                    <b-card-title v-if="currentSurgery >= 0">
                        {{ surgeries[currentSurgery].surgery_name }}
                    </b-card-title>
                    <!-- 카메라 -->
                    <b-row v-if="main" class="dash-videos">
                        <b-colxx
                            :class="currentSize"
                            v-for="(video, index) in main"
                            :key="index"
                        >
                            <WebRtcPlayer
                                video
                                :liveurl="video.live_url"
                                :id="'surgeryLive' + index"
                            ></WebRtcPlayer>
                        </b-colxx>
                    </b-row>
                </b-card>
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
import api from "../../../api";
import VideoPlayer from "../../../components/Shaka/VideoPlayer.vue";
import WebRtcPlayer from "../../../components/WebRTC/WebRTC.vue";
import DoughnutChart from "../../../components/Charts/Doughnut.vue";
import IconCard from "../../../components/Cards/IconCard";
import { mapGetters } from "vuex";
import { ThemeColors } from "../../../utils";
import moment from "moment";
const colors = ThemeColors();

export default {
    components: {
        VideoPlayer,
        "icon-cards-carousel": IconCardsCarousel,
        "sub-lives": subLives,
        "main-live": mainLive,
        WebRtcPlayer,
        "doughnut-chart": DoughnutChart,
        "icon-card": IconCard
    },
    computed: {
        ...mapGetters(["currentUser", "processing", "loginError"]),
        currentSize() {
            return this.main.length !== 1 ? "col-sm-6" : "col-sm-12";
        }
    },
    data() {
        return {
            surgeries: [],
            main: null,
            sub: null,
            currentSurgery: -1,
            mosaicChecked: true,
            broadcastSurgery: 0,
            deviceChartData: null,
            surgeryChartData: null,
            eventsChartData: null,
            devices: [],
            activatedDevicesCount: 0,
            surgeries: [],
            activatedSurgeriesCount: 0,
            todaySchedules: [],
            standardEvent: 0,
            recordingEvent: 0
        };
    },

    async beforeCreate() {
        let result = await api.getSurgery();
        this.surgeries = result;

        this.sub = result;
    },

    async mounted() {
        this.surgeries = await api.getSurgery();

        let start = moment().format("YYYY-MM-DD");
        let end = moment().format("YYYY-MM-DD 23:59:59");

        for (let i = 0; i < this.surgeries.length; i++) {
            let temp = await api.getDevices(this.surgeries[i]);
            this.surgeries[i].devices = temp;
            this.devices = this.devices.concat(temp);

            let _temp = await api.getSchedule({
                alltype: 1,
                start,
                end,
                surgery_id: this.surgeries[i].surgery_id,
                searchType: this.currentSearchType,
                search: ""
            });


		if(_temp.length >= 1) {
			let __temp = await api.getDoctorName({
                   		doctor_id: _temp[0].doctor
               		});
			_temp[0].doctor_name = __temp[0].name;
		}


            this.todaySchedules = this.todaySchedules.concat(_temp);
            if (this.surgeries[i].record) this.activatedSurgeriesCount++;
        }

        for (let i = 0; i < this.todaySchedules.length; i++) {
            for (let j = 0; j < this.surgeries.length; j++) {
                if (
                    this.surgeries[j].surgery_id ===
                    this.todaySchedules[i].surgery_id
                ) {
                    this.surgeries[j].patient = this.todaySchedules[i].patient;
                    this.surgeries[j].doctor = this.todaySchedules[i].doctor;
		    this.surgeries[j].doctor_name = this.todaySchedules[i].doctor_name;
                }
            }
            if (this.todaySchedules[i].is_record) this.recordingEvent++;
            else this.standardEvent++;
        }

        // 스트리밍 서버있을때 용
        let temp;
        try {
            temp = await api.getConnectecDevices();
        } catch (e) {
            temp = [];
        }

        this.activatedDevicesCount = temp.length;
        this.deviceChartData = {
            labels: ["ON", "OFF"],
            datasets: [
                {
                    label: "",
                    borderColor: ["#00cc00", "#172757"],
                    backgroundColor: ["#00cc00", "#172757"],
                    borderWidth: 2,
                    data: [
                        this.activatedDevicesCount,
                        this.devices.length - this.activatedDevicesCount
                    ]
                }
            ]
        };

        // this.deviceChartData = {
        //     labels: ["A", "B", "C", "D", "E"],
        // datasets: [
        //   {
        //     borderWidth: 5,
        //     backgroundColor: ["#F48FB1", "#AAAAAA", "#D81B60", "#1E88E5", "#FDD835"],
        //     hoverBackgroundColor: ["#F48FB1", "#AAAAAA", "#D81B60", "#1E88E5", "#FDD835"],
        //     hoverBorderColor: ["#F48FB1", "#AAAAAA", "#D81B60", "#1E88E5", "#FDD835"],
        //     data: [10, 90, 20, 70, 50],
        //   }
        // ],
        // };

        this.surgeryChartData = {
            labels: ["수술중", "대기중"],
            datasets: [
                {
                    label: "",
                    borderColor: ["#0066ff", "#172757"],
                    backgroundColor: ["#0066ff", "#172757"],
                    borderWidth: 2,
                    data: [this.activatedSurgeriesCount, this.surgeries.length]
                }
            ]
        };

        this.eventsChartData = {
            labels: ["녹화중", "대기"],
            datasets: [
                {
                    label: "",
                    borderColor: ["#ff9900", "#172757"],
                    backgroundColor: ["#ff9900", "#172757"],
                    borderWidth: 2,
                    data: [this.recordingEvent, this.standardEvent]
                }
            ]
        };

        setInterval(() => {
            if (this.main.length) {
                this.main = [];

                setTimeout(() => {
                    this.main = this.surgeries[this.currentSurgery].devices;
                }, 500);
            }
        }, 1000 * 60 * 60 * 6);
    },

    methods: {
        nextSurgery() {
            this.currentSurgery++;
            this.changeVideo();
        },
        prevSurgery() {
            this.currentSurgery--;
            this.changeVideo();
        },
        clickBroad(val) {
            this.currentSurgery = val;
            // this.main.isLives = [0,0,0,0]
            this.changeVideo();
        },
        changeVideo() {
            // this.$set(this.main,'live_urls',[])
            // let temp = JSON.parse(JSON.stringify(this.surgeries[this.currentSurgery]))
            // if(typeof(temp.devices) === 'undefined'){
            //   temp.device_names = []
            //   temp.live_urls = []
            //   temp.devices = []
            //   temp.isLives = []
            // } else {
            //   temp.device_names = temp.device_names.split(',')
            //   temp.live_urls = temp.live_urls.split(',')
            //   temp.devices = temp.devices.split(',')
            //   temp.isLives = temp.isLives.split(',')
            // }
            // console.log()
            this.main = [];
            console.log(this.surgeries[this.currentSurgery].devices);
            setTimeout(() => {
                this.main = this.surgeries[this.currentSurgery].devices;
                console.log(this.main);
            }, 0);
        },
        mosaicToggle(val) {
            console.log(val);
        }
    }
};
</script>
