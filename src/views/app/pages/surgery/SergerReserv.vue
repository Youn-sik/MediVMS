<template>
  <div v-if="surgeries.length" data-app class="schedule">
        <!-- more 모달 -->
        <b-modal v-model="moreModal" scrollable title="일일 스케쥴">
            <!-- <v-calendar
                ref="daycalendar"
                :events="events"
                category-show-all
                type="day"
                :start='startDay'
                @click:event="showEventFromDay"
                :dark="true"
            ></v-calendar> -->
            <v-calendar
                ref="daycalendar"
                v-model="value"
                :weekdays="weekday"
                type="day"
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

        <!-- DragAdd 모달 -->
        <b-modal
            v-model="DragaddModal"
            id="modalright"
            ref="modalright"
            :title="'수술 추가'"
            modal-class="modal-right"
            :hide-header-close="true" :no-close-on-esc="true" :no-enforce-focus="true"
            @hide="dragcancelSaveEvent"
        >
            <div style="margin-top: 20px !important">
            <b-form>
                <b-form-group label="수술명">
                    <b-form-input v-model="newEvent.name" />
                </b-form-group>
                <b-form-group label="수술 시작 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.start"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="수술 종료 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.end"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="환자명">
                    <b-form-input v-model="newEvent.patient" />
                </b-form-group>
                <b-form-group label="환자 코드">
                    <b-form-input v-model="newEvent.patient_code" />
                </b-form-group>
                <b-form-group label="생년 월일">
                    <b-form-input v-model="newEvent.patient_birthday" />
                </b-form-group>
                <!-- <b-form-group label="담당의 명">
                    <b-form-input v-model="newEvent.doctor" />
                </b-form-group> -->
                <b-form-group label="담당의 명">
                    <vselect label="name" :options="doctors" v-model="newEvent.doctor" :reduce="doctor => doctor.id" dir="ltr" >
                        <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <div :class="'color-sample ' + option.name" style="display:inline-block; margin-right:5px;"></div>
                                {{ option.name }}
                            </div>
                        </template>
                    </vselect>
                </b-form-group>
                <b-form-group label="수술실">
                    <vselect label="surgery_name" :options="surgerySelection" v-model="newEvent.surgery" dir="ltr" >
                        <!-- <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <div style="display:inline-block; margin-right:5px;"></div>
                                {{ option.surgery_name }}
                            </div>
                        </template> -->
                    </vselect>
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
                <b-form-group label="비고">
                    <b-form-input v-model="newEvent.note" />
                </b-form-group>
                <!-- <b-form-checkbox
                id="emergency"
                v-model="newEvent.emergency"
                name="emergency"
                >
                긴급 녹화&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                ※ 체크시 시간과 관계없이 해당 스케줄을 최상위로 표시합니다
                </b-form-checkbox> -->
            </b-form>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancel" style = "font-weight: bold;">
                    취소
                </b-button>
                <b-button @click="addSchedule" style = "font-weight: bold;">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- Add 모달 -->
        <b-modal
            v-model="addModal"
            id="modalright"
            ref="modalright"
            :title="'수술 추가'"
            modal-class="modal-right"
            :hide-header-close="true" :no-close-on-esc="true" :no-enforce-focus="true"
        >
            <div style="margin-top: 20px !important">
            <b-form>
                <b-form-group label="수술명">
                    <b-form-input v-model="newEvent.name" />
                </b-form-group>
                <b-form-group label="수술 시작 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.start"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="수술 종료 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.end"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="환자명">
                    <b-form-input v-model="newEvent.patient" />
                </b-form-group>
                <b-form-group label="환자 코드">
                    <b-form-input v-model="newEvent.patient_code" />
                </b-form-group>
                <b-form-group label="생년 월일">
                    <b-form-input v-model="newEvent.patient_birthday" />
                </b-form-group>
                <!-- <b-form-group label="담당의 명">
                    <b-form-input v-model="newEvent.doctor" />
                </b-form-group> -->
                <b-form-group label="담당의 명">
                    <vselect label="name" :options="doctors" v-model="newEvent.doctor" :reduce="doctor => doctor.id" dir="ltr" >
                        <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <div :class="'color-sample ' + option.name" style="display:inline-block; margin-right:5px;"></div>
                                {{ option.name }}
                            </div>
                        </template>
                    </vselect>
                </b-form-group>
                <b-form-group label="수술실">
                    <vselect label="surgery_name" :options="surgerySelection" v-model="newEvent.surgery" dir="ltr" >
                        <!-- <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <div style="display:inline-block; margin-right:5px;"></div>
                                {{ option.surgery_name }}
                            </div>
                        </template> -->
                    </vselect>
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
                <b-form-group label="비고">
                    <b-form-input v-model="newEvent.note" />
                </b-form-group>
                <!-- <b-form-checkbox
                id="emergency"
                v-model="newEvent.emergency"
                name="emergency"
                >
                긴급 녹화&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                ※ 체크시 시간과 관계없이 해당 스케줄을 최상위로 표시합니다
                </b-form-checkbox> -->
            </b-form>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancelSaveEvent" style = "font-weight: bold;">
                    취소
                </b-button>
                <b-button @click="addSchedule" style = "font-weight: bold;">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- Modify 모달 -->
        <b-modal
            v-model="modModal"
            id="modalright"
            ref="modalright"
            :title="'수술 수정'"
            modal-class="modal-right"
        >
	<div style="margin-top: 20px !important">
            <b-form>
                <b-form-group label="수술명">
                    <b-form-input v-model="newEvent.name" />
                </b-form-group>
                <b-form-group label="수술 시작 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.start"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="수술 종료 시간">
                    <datetime
                    type="datetime"
                    v-model="newEvent.end"
                    placeholder="날짜를 선택해주세요"
                    input-class="form-control"></datetime>
                </b-form-group>
                <b-form-group label="환자명">
                    <b-form-input v-model="newEvent.patient" />
                </b-form-group>
                <b-form-group label="환자 코드">
                    <b-form-input v-model="newEvent.patient_code" />
                </b-form-group>
                <b-form-group label="생년 월일">
                    <b-form-input v-model="newEvent.patient_birthday" />
                </b-form-group>

                <b-form-group label="담당의 명">
                    <vselect label="name" :options="doctors" v-model="newEvent.doctor" :reduce="doctor => doctor.id" dir="ltr" >
                        <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <div :class="'color-sample ' + option.name" style="display:inline-block; margin-right:5px;"></div>
                                {{ option.name }}
                            </div>
                        </template>
                    </vselect>
                </b-form-group>
                <b-form-group label="수술실">
                    <vselect label="surgery_name" :options="surgerySelection.slice(0)" v-model="newEvent.surgery" dir="ltr" >
                        <template slot="option" slot-scope="option">
                            <div class="d-center">
                                <!-- <img :src="option.owner.avatar_url" height="25" /> -->
                                <div style="display:inline-block; margin-right:5px;"></div>
                                {{ option.surgery_name }}
                            </div>
                        </template>
                    </vselect>
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
                <b-form-group label="비고">
                    <b-form-input v-model="newEvent.note" />
                </b-form-group>
                <!-- <b-form-checkbox
                id="emergency"
                v-model="newEvent.emergency"
                :value="1"
                :unchecked-value="0"
                name="emergency"
                > -->
                <!-- 긴급 녹화&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                ※ 체크시 시간과 관계없이 해당 스케줄을 최상위로 표시합니다 -->
                <!-- </b-form-checkbox> -->
            </b-form>
	</div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancelModEvent">
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
                <!-- <div style=""> -->
                    
                <!-- </div> -->
                <div style="width:80%; text-aligm:center; margin: 0 auto;">
                    <b-input-group class="mb-1">
                        <b-input-group-prepend style="margin-top: 5px; height: 30px !important;">
                            <b-dropdown id="ddown1" :text="currentSearchType" variant="outline-secondary">
                                <b-dropdown-item @click="changeSearchType(item)" v-for="(item,index) in searchItems" :key="index">{{item}}</b-dropdown-item>
                            </b-dropdown>
                        </b-input-group-prepend>
                        <!-- <b-form-input/> -->
                        <div
                        class="search"
                        ref="searchContainer"
                        style="margin-top: 5px;"
                        >
                            <b-input
                                placeholder="검색"
                                @keypress.native.enter="searchClick"
                                v-model="searchKeyword"
                                style=""
                            />
                            <span class="search-icon" @click="searchClick" style="margin-bottom: 39px !important">
                                <i class="simple-icon-magnifier"></i>
                            </span>
                        </div>

                        <div style="text-aligm:center;margin-left: 260px;">
                            <div class="cal-btn" style="width:260px; margin:0 auto; text-align:center; padding-top: 5px; padding-right: 30px">
                                <div style="padding-left: 0px;">
                                    <a href="#">
                                        <img @click="prevDate" src="/assets/img/prev.svg">
                                    </a>
                                </div>
                                <!-- <b-button
                                    variant="outline-primary"
                                    icon
                                    v-if="$refs.calendar0"
                                    class="ma-2 year-month"
                                > -->
                                <div v-if="$refs.calendar0" class="cal-date fr-16-b fc-fff" style="padding-top: 4px;">
                                {{
                                $refs.calendar0.title

                                /*
                                (!!$refs.calendar0.title.split("월")[2]) ?
                                    $refs.calendar0.title.split("월")[0].length == 1 ?
                                        $refs.calendar0.title.split("월")[2] + " - " + "0"+ $refs.calendar0.title.split("월")[0] + $refs.calendar0.title.split("월")[1]
                                        :
                                        $refs.calendar0.title.split("월")[2] + " - " + $refs.calendar0.title.split("월")[0] + $refs.calendar0.title.split("월")[1]
                                    :
                                    $refs.calendar0.title.split("월")[0].length == 1 ?
                                        $refs.calendar0.title.split("월")[1] + " - " + "0"+ $refs.calendar0.title.split("월")[0]
                                        :
                                        $refs.calendar0.title.split("월")[1] + " - " + $refs.calendar0.title.split("월")[0]
                                */
                                }}
                                </div>
                                <!-- </b-button> -->
                                <div style="padding-right: 0px;"><a href="#"><img @click="nextDate" src="/assets/img/next.svg"></a></div>
                            </div>
                        </div>

                        <div style="margin-bottom: 20px;margin-left: 50px;">
                            <b-button
                                variant="outline-primary"
                                icon
                                class="ma-2 reserve"

                                @click="openAddModal"
                            >
                                <div class="fn-12-b fc-cc"><img src="/assets/img/add.svg">예약</div>
                            </b-button>
                            <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary" style="width:107px; top: 5px; left: 45px;">
                                <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
                            </b-dropdown>
                            
                            <!-- <b-button
                                :variant="calendarType === '일간' ? 'primary' : 'outline-primary'"
                                icon
                                class="ma-2 day"

                                @click="changeCalendarType('일간')"
                            >
                                일간
                            </b-button>
                            <b-button
                                :variant="calendarType === '주간' ? 'primary' : 'outline-primary'"
                                icon
                                class="ma-2 week"

                                @click="changeCalendarType('주간')"
                            >
                                주간
                            </b-button>
                            <b-button
                                :variant="calendarType === '월간' ? 'primary' : 'outline-primary'"
                                icon
                                class="ma-2 month"

                                @click="changeCalendarType('월간')"
                            >
                                월간
                            </b-button> -->

                            <div class="cal-tab" style="width: 230px;">
                                <ul>
                                    <li @click="changeCalendarType('일간')" :class="(calendarType === '일간' ? 'active' : '') + ' fn-12-r day'">일간</li>
                                    <li @click="changeCalendarType('주간')" :class="(calendarType === '주간' ? 'active' : '') + ' fn-12-b week'">주간</li>
                                    <li @click="changeCalendarType('월간')" :class="(calendarType === '월간' ? 'active' : '') + ' fn-12-r month'">월간</li>
                                </ul>
                            </div>
                            

                            <!-- <b-dropdown id="surgeriesDropdown" :text="calendarType" variant="outline-secondary">
                                <b-dropdown-item @click="changeCalendarType(type,index)" v-for="(type,index) in calendarTypes" :key="index">{{ type }}</b-dropdown-item>
                            </b-dropdown> -->
                        </div>
                    </b-input-group>

                    <v-sheet height="700" :dark="true">
                        <!-- <template v-if="calendarType === '일간'">
                            <b-row style="height:100%">
                                <b-colxx style="height:100%" sm="12" xl="3" lg="3" v-for="(surgery,index) in surgeries" :key="index">
                                    <v-calendar
                                        :ref="'calendar'+index"
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
                                </b-colxx>
                            </b-row>
                        </template>
                        <template v-else> -->
                            <v-calendar
                                ref="calendar0"
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
                                    <div style="padding-left: 6px;">
                                        환자명 : {{event.patient}}
                                    </div>
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
                                            <v-icon color="#fff">simple-icon-note</v-icon>
                                        </v-btn>
                                        <v-btn @click="()=>{deleteSchedule(selectedEvent.id)}" icon>
                                            <v-icon color="#fff">simple-icon-trash</v-icon>
                                        </v-btn>
                                    </v-toolbar>

                                    <v-card-text>
                                        <span style="color:black" v-html="selectedEvent.note"></span>
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
                        <!-- </template> -->
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
import calender from './calender.vue'
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
        "vselect": vSelect,
        Calender:calender
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
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                doctor:'',
                patient_code:'',
                patient_birthday:'',
                surgery:null,
                emergency:false,
            },
            DragaddModal:false,
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
            calendarType:"일간",
            calendarTypes:["월간","주간","일간"],
            dragEvent: null,
            dragStart: null,
            createEvent: null,
            createStart: null,
            extendOriginal: null,
            sizeMod : false,
            surgerySelection:[],

            doctors:[],
            currentDoctor:[],

            dragIsNotClick: false,
            dragIsNotClickTmpTimeStart: null,
            dragIsNotClickTmpTimeEnd: null,
        }
    },
    methods:{
        async getDoctors() {
            this.doctors = await api.getDoctors({
                page : 1,
                perPage : 1000,
                search : '',
                searchType : 'name',
                sort : 'id',
                sortType : 'desc'
            })
        },

        startDrag ({ event, timed }) {
            this.dragIsNotClickTmpTimeStart = event.start;
            this.dragIsNotClickTmpTimeEnd = event.end;

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
                console.log(this.createEvent)
                await api.patchSchedule(this.createEvent);
                this.sizeMod = false
            } else if (this.dragEvent && this.dragTime !== null) {
                await api.patchSchedule(this.dragEvent);
            } else if (this.createEvent && this.createStart !== null) {
                this.newEvent = {
                    ...this.newEvent,
                    ...this.createEvent,
                    surgery:this.currentSurgery.surgery_id === 0 ? this.surgeries[1] : this.currentSurgery,
                    start:moment(this.createEvent.start).format('YYYY-MM-DDTHH:mm:ssZ'),
                    end:moment(this.createEvent.end).format('YYYY-MM-DDTHH:mm:ssZ'),
                }
                this.DragaddModal = true
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

            this.newEvent = {...i,surgery:this.currentSurgery, start:moment(i.start).format('YYYY-MM-DDTHH:mm:ssZ'), end:moment(i.end).format('YYYY-MM-DDTHH:mm:ssZ')}
        },
        prevDate() {
            this.getSchedule()
            this.$refs.calendar0.prev()
        },
        nextDate() {
            this.getSchedule()
            this.$refs.calendar0.next()
        },
        dragcancelSaveEvent() {
            this.newEvent = {
                color:'',
                name:'',
                surgery:null,
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                patient_code:'',
                patient_birthday:'',
                doctor:'',
                emergency:false,
            }

            this.emergency = false;

            this.DragaddModal = false;
            this.addModal = false;
            this.modModal = false;

            this.events.pop()
        },
        cancelSaveEvent() {
            this.newEvent = {
                color:'',
                name:'',
                surgery:null,
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                patient_code:'',
                patient_birthday:'',
                doctor:'',
                emergency:false,
            }

            this.emergency = false;

            this.DragaddModal = false;
            this.addModal = false;
            this.modModal = false;

            // this.events.pop()
        },
        cancelModEvent() {
            this.newEvent = {
                color:'',
                name:'',
                surgery:null,
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                patient_code:'',
                patient_birthday:'',
                doctor:'',
                emergency:false,
            }

            this.emergency = false;

            this.DragaddModal = false;
            this.addModal = false;
            this.modModal = false;
        },
        openAddModal() {
            this.newEvent = {
                color:'',
                name:'',
                surgery:this.currentSurgery.surgery_id === 0 ? this.surgeries[1] : this.currentSurgery,
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                patient_code:'',
                patient_birthday:'',
                doctor:'',
                emergency:false,
            }
            this.addModal = true;
        },
        showEvent ({ nativeEvent, event }) {

            console.log(event.start);
            console.log(event.end);

            console.log(this.dragIsNotClickTmpTimeStart);
            console.log(this.dragIsNotClickTmpTimeEnd);

            this.dragIsNotClick = false;
            if(event.start == this.dragIsNotClickTmpTimeStart && event.end == this.dragIsNotClickTmpTimeEnd) this.dragIsNotClick = true;
               
            if(this.dragIsNotClick){
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
            }
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
            this.getSchedule()

            this.currentSurgeryImdex = index
            if(typeof(this.currentSurgery.devices) === 'undefined'){
                this.currentSurgery.live_urls = []
                this.currentSurgery.device_names = []
                this.currentSurgery.devices = []
                this.currentSurgery.isLives = []
                this.currentSurgery.serial_numbers = []
                return 0;
            } else {
                this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
                this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
                this.currentSurgery.devices = this.currentSurgery.devices.split(',')
                this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
                this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')
                return 0;
            }
        },
        changeCalendarType(val,index) {

            // if(this.calendarType === '일간'){
            //     this.getSchedule()
            // } else if(val === '일간') {
            //     this.getAllSchedule()
            // }
            this.calendarType = val
        },
        async getSurgery() {
            let result = await api.getSurgery()
            this.surgeries = [{surgery_id:0, surgery_name:'전체'}, ...result]
            this.surgerySelection = result;
            this.changeSurgery(this.surgeries[this.currentSurgeryImdex])
        },
        getEventColor (event) {
            return event.color
        },
        rnd (a, b) {
            return Math.floor((b - a + 1) * Math.random()) + a
        },

        async getSchedule() {
            console.log(this.currentSurgery)
            let start = moment(this.date).startOf('month').format('YYYY-MM-DD');
            let end = moment(this.date).endOf('month').format('YYYY-MM-DD 23:59:59');
            this.events = []
            this.events = await api.getSchedule({start,end,surgery_id:this.currentSurgery.surgery_id,alltype:1,searchType:this.currentSearchType, search:this.commitedSearchKeyword})

            this.todaySchedules
        },

        async getAllSchedule() {
            let start = moment(this.date).startOf('month').format('YYYY-MM-DD');
            let end = moment(this.date).endOf('month').format('YYYY-MM-DD 23:59:59');
            for(let surgery in this.surgeries) {
                let temp = await api.getSchedule({start,end,surgery_id:this.surgeries[surgery].surgery_id,alltype:1,searchType:this.currentSearchType, search:this.commitedSearchKeyword})
                this.$set(this.surgeries[surgery],'schedules',temp)
            }
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

            await api.addSchedule({...this.newEvent})

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
            this.DragaddModal = false;
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
                surgery:null,
                timed:true,
                start:moment().format('YYYY-MM-DDTHH:mm:ssZ'),
                end:moment().add(1,'hour').format('YYYY-MM-DDTHH:mm:ssZ'),
                patient:'',
                patient_code:'',
                patient_birthday:'',
                doctor:'',
                emergency:false
            }
        },

        async recordStart() {
          let startTime = moment().format('YYYYMMDDHHmmssSSS')

        //   await api.recordStart({
        //     id:this.currentSurgery.surgery_id
        //   })

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
            video_link : `${currentSerial}_${startTime}`
          })
        },

        async patchSchedule(id) {
            if(confirm("정말 수정 하시겠습니까?")){
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

                alert("수정 되었습니다.")
            }
        },

        async deleteSchedule(id) {
            if(confirm("정말 삭제 하시겠습니까?")){
                await api.deleteSchedule({id})
                this.getSchedule()
                this.selectedOpen = false
                this.selectedOpenFromDay = false

                this.mqttClient.publish(`/send/schedule/`, JSON.stringify({
                    type:"delete"
                }))
                alert("삭제 되었습니다.")
            }
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
        this.getDoctors()
        this.getSurgery()

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
