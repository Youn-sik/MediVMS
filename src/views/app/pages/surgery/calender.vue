<template>
    <div>
        <v-calendar
            v-modal="value"
            ref="calendar"
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
    </div>
</template>

<script>
import api from "../../../../api"
import moment from 'moment'
import { Datetime } from 'vue-datetime';
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
export default {
    props:[
        'events',
        'type',
        'calendarType',
        'value',
    ],
    computed: {
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
            modModal:false,
            newEvent:null,
            moreModal:false,
            mqttClient:null,
            selectedEvent: {},
            selectedElement: null,
            selectedOpen: false,
            selectedOpenFromDay: false,
            mode: 'stack',
            modes: ['stack', 'column'],
            weekday: [0, 1, 2, 3, 4, 5, 6],
            weekdays: [
                { text: 'Sun - Sat', value: [0, 1, 2, 3, 4, 5, 6] },
                { text: 'Mon - Sun', value: [1, 2, 3, 4, 5, 6, 0] },
                { text: 'Mon - Fri', value: [1, 2, 3, 4, 5] },
                { text: 'Mon, Wed, Fri', value: [1, 3, 5] },
            ],
            colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange'],
            startDay: '',
            dragEvent: null,
            dragStart: null,
            createEvent: null,
            createStart: null,
            extendOriginal: null,
            sizeMod : false,
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
            this.sizeMod = true
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
            if(this.sizeMod){
                await api.patchSchedule(this.createEvent);
                this.sizeMod = false
            } else if (this.dragEvent && this.dragTime !== null) {
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
        showEvent ({ nativeEvent, event }) {
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
        changeCalendarType(val,index) {
            this.calendarType = val
        },
        getEventColor (event) {
            return event.color
        },
        rnd (a, b) {
            return Math.floor((b - a + 1) * Math.random()) + a
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
    },
};
</script>