<template>
  <div v-if="surgeries.length" data-app class="schedule">
        <!-- more 모달 -->
        <b-modal v-model="moreModal" scrollable title="일일 스케쥴">
            <v-calendar
                ref="daycalendar"
                :events="events"
                category-show-all
                type="day"
                :start='startDay'
                @click:event="showEventFromDay"
                :dark="true"
            ></v-calendar>
            <v-menu
            v-model="selectedOpenFromDay"
            :close-on-content-click="false"
            :activator="selectedElement"
            offset-x
            >
                <v-card
                    color="grey lighten-4"
                    min-width="350px"
                    flat
                >
                    <v-toolbar
                    :color="selectedEvent.color"
                    dark
                    >
                        <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-btn @click="modifySchedule(selectedEvent)" icon>
                            <v-icon>simple-icon-note</v-icon>
                        </v-btn>
                        <v-btn @click="()=>{deleteSchedule(selectedEvent.id)}" icon>
                            <v-icon>simple-icon-trash</v-icon>
                        </v-btn>
                    </v-toolbar>

                    <v-card-text>
                        <span style="color:white" v-html="selectedEvent.note"></span>
                    </v-card-text>

                    <v-card-actions>
                        <v-btn
                            text
                            color="secondary"
                            @click="selectedOpenFromDay = false"
                        >
                            닫기
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-menu>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button @click="cancel()">
                    닫기
                </b-button>
            </template>
        </b-modal>

        <!-- Add 모달 -->
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

                <!-- Modify 모달 -->
        <b-modal
            v-model="modModal"
            id="modalright"
            ref="modalright"
            :title="'일정 수정'"
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
                :value="1"
                :unchecked-value="0"
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
                <b-button @click="patchSchedule">
                    저장
                </b-button>
            </template>
        </b-modal>

    <b-row>
        <!-- <b-colxx xl="12" lg="12" class="mb-4">
          <piaf-breadcrumb :heading="'정보'" />
          <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
              <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
          </b-dropdown>
          <b-button v-if="currentUser.authority <= 0" class="mb-1 mr-3" style="float:right" variant="outline-secondary" @click="()=>{reservModal=true}">수술실 예약</b-button>
          <p v-if="currentSurgery.record" style="float:right; margin-top:8px">녹화 시작 시간 : {{currentSurgery.record_time}}</p>
          <div class="separator mb-5"></div>
        </b-colxx> -->
        <b-colxx xl="12" lg="12" class="mb-4">
            <b-card>
                <div style="width:80%; text-aligm:center; margin: 0 auto;">
                    <div style="text-aligm:center; margin: 0 auto;">
                        <b-button
                            variant="outline-primary"
                            icon
                            class="ma-2"

                            @click="prevMonth"
                        >
                            <!-- <v-icon style="color:white">mdi-chevron-left</v-icon> -->
                            <
                        </b-button>
                        <b-button
                            variant="outline-primary"
                            icon
                            class="ma-2"

                            @click="nextMonth"
                        >
                            <!-- <v-icon style="color:white">mdi-chevron-right</v-icon> -->
                            >
                        </b-button>
                        <b-button
                            variant="outline-primary"
                            icon
                            class="ma-2"

                            @click="openAddModal"
                        >
                            <!-- <v-icon style="color:white">simple-icon-plus</v-icon> -->
                            일정 추가
                        </b-button>
                        <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                            <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
                        </b-dropdown>
                    </div>
                    <v-sheet height="700" :dark="true">
                        {{date}}
                        <v-calendar
                            ref="calendar"
                            v-model="value"
                            :weekdays="weekday"
                            :type="type"
                            :events="events"
                            :event-overlap-mode="mode"
                            @click:more="viewDay"
                            @click:date="viewDayFromDate"
                            @click:event="showEvent"
                            :event-overlap-threshold="30"
                            :event-color="getEventColor"
                            @change="getEvents"
                            :dark="true"
                        ></v-calendar>
                         <v-menu
                        v-model="selectedOpen"
                        :close-on-content-click="false"
                        :activator="selectedElement"
                        offset-x
                        >
                            <v-card
                                color="grey lighten-4"
                                min-width="350px"
                                flat
                            >
                                <v-toolbar
                                :color="selectedEvent.color"
                                dark
                                >
                                    <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
                                    <v-spacer></v-spacer>
                                    <v-btn @click="modifySchedule(selectedEvent)" icon>
                                        <v-icon>simple-icon-note</v-icon>
                                    </v-btn>
                                    <v-btn @click="()=>{deleteSchedule(selectedEvent.id)}" icon>
                                        <v-icon>simple-icon-trash</v-icon>
                                    </v-btn>
                                </v-toolbar>

                                <v-card-text>
                                    <span style="color:white" v-html="selectedEvent.note"></span>
                                </v-card-text>

                                <v-card-actions>
                                    <v-btn
                                        text
                                        color="secondary"
                                        @click="selectedOpen = false"
                                    >
                                        닫기
                                    </v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-menu>
                    </v-sheet>
                </div>
            </b-card>
        </b-colxx>
    </b-row>
  </div>
</template>
<script>
import api from "../../../../api"
import {
    mapGetters
} from "vuex";
import moment from 'moment'
import { Datetime } from 'vue-datetime';
import vSelect from "vue-select";
import {mqtt_url} from '../../../../server.json'
import mqtt from 'mqtt';
import "vue-select/dist/vue-select.css";
moment.locale("ko");
export default {
    computed: {
      ...mapGetters(["currentUser"]),
      minusMonth() {
          this.date = moment(this.data).subtract(1,'M').format("YYYY-MM")
      }
    },
    components: {
        datetime: Datetime,
        "vselect": vSelect
    },
    data() {
        return {
            date:moment().format("YYYY-MM"),
            addDateTime:'',
            emergency:false,
            newEvent: {
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false,
            },
            addModal:false,
            modModal:false,
            moreModal:false,
            surgeryData:null,
            mqttClient:null,
            currentSurgery:null,
            currentSurgeryImdex:0,
            selectedEvent: {},
            selectedElement: null,
            selectedOpen: false,
            selectedOpenFromDay: false,
            surgeries:[],
            type: 'month',
            types: ['month', 'week', 'day', '4day'],
            mode: 'stack',
            modes: ['stack', 'column'],
            weekday: [0, 1, 2, 3, 4, 5, 6],
            weekdays: [
                { text: 'Sun - Sat', value: [0, 1, 2, 3, 4, 5, 6] },
                { text: 'Mon - Sun', value: [1, 2, 3, 4, 5, 6, 0] },
                { text: 'Mon - Fri', value: [1, 2, 3, 4, 5] },
                { text: 'Mon, Wed, Fri', value: [1, 3, 5] },
            ],
            value: '',
            events: [],
            colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange'],
            names: ['Meeting', 'Holiday', 'PTO', 'Travel', 'Event', 'Birthday', 'Conference', 'Party'],
            startDay: '',
            // todaySchedules: [],
        }
    },
    methods:{
        modifySchedule(i) {
            this.modModal = true

            this.newEvent = {...i, start:moment(i.start).format('YYYY-MM-DDTHH:mm:ssZ'), end:moment(i.end).format('YYYY-MM-DDTHH:mm:ssZ')}
        },
        prevMonth() {
            this.date = moment(this.date).subtract(1,'M').format("YYYY-MM")
            this.getSchedule()
            this.$refs.calendar.prev()
            console.log(this.$refs.calendar.prev())
        },
        nextMonth() {
            this.date = moment(this.date).add(1,'M').format("YYYY-MM")
            this.getSchedule()
            this.$refs.calendar.next()
        },
        cancelSaveEvent() {
            this.newEvent = {
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false,
            }

            this.emergency = false;

            this.addModal = false;
            this.modModal = false;
        },
        openAddModal() {
            this.addModal = true;
        },
        showEvent ({ nativeEvent, event }) {
            console.log(nativeEvent, event)
            const open = () => {
            this.selectedEvent = event
            this.selectedElement = nativeEvent.target
            requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpen = true))
            }

            if (this.selectedOpen) {
            this.selectedOpen = false
            requestAnimationFrame(() => requestAnimationFrame(() => open()))
            } else {
            open()
            }

            nativeEvent.stopPropagation()
        },
        showEventFromDay ({ nativeEvent, event }) {
            console.log(nativeEvent, event)
            const open = () => {
            this.selectedEvent = event
            this.selectedElement = nativeEvent.target
            requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpenFromDay = true))
            }

            if (this.selectedOpenFromDay) {
            this.selectedOpenFromDay = false
            requestAnimationFrame(() => requestAnimationFrame(() => open()))
            } else {
            open()
            }

            nativeEvent.stopPropagation()
        },
        viewDay(e) {
            this.startDay = e.date
            this.moreModal = true
        },
        viewDayFromDate(e) {
            this.date = moment(e.date).format("YYYY-MM")

            this.startDay = e.date
            this.moreModal = true
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

          this.changeSurgery(result[this.currentSurgeryImdex])
        },
        getEvents ({ start, end }) {
            // const events = []

            // const min = new Date(`${start.date}T00:00:00`)
            // const max = new Date(`${end.date}T23:59:59`)
            // const days = (max.getTime() - min.getTime()) / 86400000
            // const eventCount = this.rnd(days, days + 20)

            // for (let i = 0; i < eventCount; i++) {
            // const allDay = this.rnd(0, 3) === 0
            // const firstTimestamp = this.rnd(min.getTime(), max.getTime())
            // const first = new Date(firstTimestamp - (firstTimestamp % 900000))
            // const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000
            // const second = new Date(first.getTime() + secondTimestamp)

            // events.push({
            //     name: this.names[this.rnd(0, this.names.length - 1)],
            //     start: first,
            //     end: second,
            //     color: this.colors[this.rnd(0, this.colors.length - 1)],
            //     timed: !allDay,
            // })
            // }
            // console.log(events)
            // this.events = events
        },
        getEventColor (event) {
            return event.color
        },
        rnd (a, b) {
            return Math.floor((b - a + 1) * Math.random()) + a
        },

        async getSchedule() {
            let start = moment(this.date).startOf('month').format('YYYY-MM-DD');
            let end = moment(this.date).endOf('month').format('YYYY-MM-DD');
            this.events = await api.getSchedule({start,end,surgery_id:this.currentSurgery.surgery_id,alltype:1})

            this.todaySchedules
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
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                emergency:false
            }


            this.emergency = false;

            this.mqttClient.publish(`/detect/emergancy/`, JSON.stringify({
                surgery_name:this.currentSurgery.surgery_name,
                account:this.currentUser.account
            }))
        },

        async patchSchedule(id) {
            if(this.newEvent.emergency) {
                this.newEvent.start = moment(this.newEvent.start).format('YYYY-MM-DD')
                this.newEvent.end = moment(this.newEvent.end).format('YYYY-MM-DD')
            } else {
                this.newEvent.start = moment(this.newEvent.start).format('YYYY-MM-DD HH:mm')
                this.newEvent.end = moment(this.newEvent.end).format('YYYY-MM-DD HH:mm')
            }

            await api.patchSchedule({...this.newEvent})

            this.getSchedule()

            this.modModal = false;
        },

        async deleteSchedule(id) {
            await api.deleteSchedule({id})
            this.getSchedule()
            this.selectedOpen = false
            this.selectedOpenFromDay = false
        },
    },
    mounted () {
        this.getSurgery()

        this.mqttClient = mqtt.connect(mqtt_url,{
          protocol:"wss",
          port:8084,
          keepalive:0,
          path:'/mqtt',
          clean: true,
        })

        this.mqttClient.on('error',function (err) {
          console.log(err)
        })
    },
    destroyed() {
      this.mqttClient.end(true);
    }
};
</script>

<style>
    .color-sample {
        width:7px;
        height: 7px;
        border-radius: 7px;
    }
</style>