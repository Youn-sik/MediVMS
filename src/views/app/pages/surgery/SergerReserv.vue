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
                <b-form-group label="환자 이름">
                    <b-form-input v-model="newEvent.patient" />
                </b-form-group>
                <b-form-group label="담당의 이름">
                    <b-form-input v-model="newEvent.doctor" />
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
                <b-form-group label="환자 이름">
                    <b-form-input v-model="newEvent.patient" />
                </b-form-group>
                <b-form-group label="담당의 이름">
                    <b-form-input v-model="newEvent.doctor" />
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
        <b-colxx xl="12" lg="12" class="mb-4">
            <b-card>
                <div style="width:80%; text-aligm:center; margin: 0 auto;">

                    <b-input-group class="mb-1">
                        <b-input-group-prepend>
                            <b-dropdown id="ddown1" :text="currentSearchType" variant="outline-secondary">
                                <b-dropdown-item @click="changeSearchType(item)" v-for="(item,index) in searchItems" :key="index">{{item}}</b-dropdown-item>
                            </b-dropdown>
                        </b-input-group-prepend>
                        <!-- <b-form-input/> -->
                        <div
                        class="search"
                        ref="searchContainer"
                        >
                            <b-input
                                placeholder="검색"
                                @keypress.native.enter="searchClick"
                                v-model="searchKeyword"
                            />
                            <span class="search-icon" @click="searchClick">
                                <i class="simple-icon-magnifier"></i>
                            </span>
                        </div>

                        <div style="text-aligm:center; margin: 0 auto; padding-left:28px;">
                            <b-button
                                variant="outline-primary"
                                icon
                                class="ma-2"

                                @click="prevDate"
                            >
                                <
                            </b-button>
                            <b-button
                                variant="outline-primary"
                                icon
                                v-if="$refs.calendar"
                                class="ma-2"
                            >
                                {{$refs.calendar.title}}
                            </b-button>
                            <b-button
                                variant="outline-primary"
                                icon
                                class="ma-2"

                                @click="nextDate"
                            >
                                >
                            </b-button>
                        </div>

                        <div style="text-aligm:center;">
                            <b-button
                                variant="outline-primary"
                                icon
                                class="ma-2"

                                @click="openAddModal"
                            >
                                일정 추가
                            </b-button>
                            <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                                <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
                            </b-dropdown>
                            <b-dropdown id="surgeriesDropdown" :text="calendarType" variant="outline-secondary">
                                <b-dropdown-item @click="changeCalendarType(type,index)" v-for="(type,index) in calendarTypes" :key="index">{{ type }}</b-dropdown-item>
                            </b-dropdown>
                        </div>
                    </b-input-group>

                    <v-sheet height="700" :dark="true">
                        <v-calendar
                            ref="calendar"
                            v-model="value"
                            :weekdays="weekday"
                            :type="calendarType === '월간' ? 'month' :
                            calendarType === '주간' ? 'week' : 'day'"
                            :events="events"
                            :event-overlap-mode="mode"
                            @click:more="viewDay"
                            @click:date="viewDayFromDate"
                            @click:event="showEvent"
                            :event-overlap-threshold="30"
                            :event-color="getEventColor"
                            @change="getEvents"
                            @mousedown:event="startDrag"
                            @mousedown:time="startTime"
                            @mousemove:time="mouseMove"
                            @mouseup:time="endDrag"
                            @mouseleave.native="cancelDrag"
                            :dark="true"
                        >
                            <template v-slot:event="{ event, timed, eventSummary }">
                                <div
                                class="v-event-draggable"
                                v-html="eventSummary()"
                                ></div>
                                <div
                                v-if="timed"
                                class="v-event-drag-bottom"
                                @mousedown.stop="extendBottom(event)"
                                ></div>
                            </template>
                        </v-calendar>
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
                patient:'',
                doctor:'',
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
            currentSearchType: "주치의",
            searchItems: [
                '주치의',
                '환자명',
            ],
            searchKeyword:'',
            commitedSearchKeyword:'',
            calendarType:"월간",
            calendarTypes:["월간","주간","일간"],
            dragEvent: null,
            dragStart: null,
            createEvent: null,
            createStart: null,
            extendOriginal: null,
        }
    },
    methods:{
        startDrag ({ event, timed }) {
            if (event && timed) {
                this.dragEvent = event
                this.dragTime = null
                this.extendOriginal = null
            }
        },
        startTime (tms) {
            const mouse = this.toTime(tms)
            if (this.dragEvent && this.dragTime === null) {
                const start = new Date(this.dragEvent.start)

                this.dragTime = mouse - start
            } else {
                this.createStart = this.roundTime(mouse)
                this.createEvent = {
                    name: `Event #${this.events.length}`,
                    color: 'blue',
                    start: moment(this.createStart).format("YYYY-MM-DD HH:mm:ss"),
                    end: moment(this.createStart).format("YYYY-MM-DD HH:mm:ss"),
                    timed: true,
                }

                this.events.push(this.createEvent)
            }
        },
        extendBottom (event) {
            this.createEvent = event
            this.createStart = new Date(event.start)
            this.extendOriginal = new Date(event.end)
        },
        mouseMove (tms) {
            const mouse = this.toTime(tms)

            if (this.dragEvent && this.dragTime !== null) {
                const start = new Date(this.dragEvent.start)
                const end = new Date(this.dragEvent.end)
                const duration = end - start
                const newStartTime = mouse - this.dragTime
                const newStart = this.roundTime(newStartTime)
                const newEnd = newStart + duration

                this.dragEvent.start = moment(newStart).format("YYYY-MM-DD HH:mm:ss")
                this.dragEvent.end = moment(newEnd).format("YYYY-MM-DD HH:mm:ss")
            } else if (this.createEvent && this.createStart !== null) {
                const mouseRounded = this.roundTime(mouse, false)
                const min = Math.min(mouseRounded, this.createStart)
                const max = Math.max(mouseRounded, this.createStart)

                this.createEvent.start = moment(min).format("YYYY-MM-DD HH:mm:ss")
                this.createEvent.end = moment(max).format("YYYY-MM-DD HH:mm:ss")
            }
        },
        async endDrag () {
            if (this.dragEvent && this.dragTime !== null) {
                await api.patchSchedule(this.dragEvent);
            } else if (this.createEvent && this.createStart !== null) {
                this.newEvent = {
                    ...this.newEvent,
                    ...this.createEvent,
                    start:moment(this.createEvent.start).format('YYYY-MM-DDTHH:mm:ssZ'),
                    end:moment(this.createEvent.end).format('YYYY-MM-DDTHH:mm:ssZ')
                }
                this.addModal = true
            }

            this.dragTime = null
            this.dragEvent = null
            this.createEvent = null
            this.createStart = null
            this.extendOriginal = null
        },
        cancelDrag () {
            if (this.createEvent) {
                if (this.extendOriginal) {
                    this.createEvent.end = moment(this.extendOriginal).format("YYYY-MM-DD HH:mm:ss")
                } else {
                    const i = this.events.indexOf(this.createEvent)
                    if (i !== -1) {
                        this.events.splice(i, 1)
                    }
                }
            }

            this.createEvent = null
            this.createStart = null
            this.dragTime = null
            this.dragEvent = null
        },
        roundTime (time, down = true) {
            const roundTo = 15 // minutes
            const roundDownTime = roundTo * 60 * 1000

            return down
            ? time - time % roundDownTime
            : time + (roundDownTime - (time % roundDownTime))
        },
        toTime (tms) {
            return new Date(tms.year, tms.month - 1, tms.day, tms.hour, tms.minute).getTime()
        },

        modifySchedule(i) {
            this.modModal = true

            this.newEvent = {...i, start:moment(i.start).format('YYYY-MM-DDTHH:mm:ssZ'), end:moment(i.end).format('YYYY-MM-DDTHH:mm:ssZ')}
        },
        prevDate() {
            // if(this.calendarType === '월간'){
            //     this.date = moment(this.date).subtract(1,'M').format("YYYY-MM")
            // } else if(this.calendarType === '주간'){
            //     this.date = moment(this.date).subtract(7,'days').format("YYYY-MM-DD")
            // } else {
            //     this.date = moment(this.date).subtract(1,'days').format("YYYY-MM-DD")
            // }
            this.getSchedule()
            this.$refs.calendar.prev()
        },
        nextDate() {
            // if(this.calendarType === '월간'){
            //     this.date = moment(this.date).add(1,'M').format("YYYY-MM")
            // } else if(this.calendarType === '주간'){
            //     this.date = moment(this.date).add(7,'days').format("YYYY-MM-DD")
            // } else {
            //     this.date = moment(this.date).add(1,'days').format("YYYY-MM-DD")
            // }
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
                patient:'',
                doctor:'',
                emergency:false,
            }

            this.emergency = false;

            this.addModal = false;
            this.modModal = false;

            this.events.pop()
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
        changeCalendarType(val,index) {
            this.calendarType = val
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
            let end = moment(this.date).endOf('month').format('YYYY-MM-DD 23:59:59');
            this.events = []
            this.events = await api.getSchedule({start,end,surgery_id:this.currentSurgery.surgery_id,alltype:1,searchType:this.currentSearchType, search:this.commitedSearchKeyword})

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

            let startSchedule = false
            let newEvent = null

            await this.getSchedule()

            if((!this.events.length || !this.events[0].is_record) && this.newEvent.emergency ) {
                startSchedule = true
            }

            await api.addSchedule({...this.newEvent, surgery_id:this.currentSurgery.surgery_id})

            await this.getSchedule()

            if(startSchedule) {
                this.events.forEach((item) => {
                    console.log(item,this.newEvent)
                    if(item.name === this.newEvent.name && item.doctor === this.newEvent.doctor && item.patient === this.newEvent.patient) {
                        newEvent = item
                    }
                })
            }

            if(newEvent) {
                await api.patchSchedule({...newEvent, is_record:1});

                this.recordStart()
            }

            this.addModal = false;

            this.emergency = false;

            // let firstEvent = true
            // let now = moment().format("YYYY-MM-DD")

            // this.events.forEach((item) => {
            //     if(moment(item.start).format("YYYY-MM-DD") === now && item.is_record) {
            //         return 0;
            //     }
            // })
            if(newEvent) {
                this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                    type:"start"
                }))

                newEvent = null
                this.getSchedule()
            } else if(this.newEvent.emergency) {
                this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                    type:"emergancy"
                }))
            } else {
                this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                    type:"add"
                }))
            }


            this.newEvent = {
                color:'',
                name:'',
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                doctor:'',
                emergency:false
            }
        },

        async recordStart() {
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
            video_link : `http://172.16.41.105:3000/stream/${currentSerial}_${startTime}.mp4`
          })
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

            this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                type:"patch"
            }))
        },

        async deleteSchedule(id) {
            await api.deleteSchedule({id})
            this.getSchedule()
            this.selectedOpen = false
            this.selectedOpenFromDay = false

            this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                type:"delete"
            }))
        },

        changeSearchType(item) {
            this.currentSearchType = item
        },

        searchClick() {
            this.commitedSearchKeyword = this.searchKeyword

            this.getSchedule()
        }
    },
    mounted () {
        this.getSurgery()

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