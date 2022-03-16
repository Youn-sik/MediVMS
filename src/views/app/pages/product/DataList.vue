<template>
    <b-row>
        <!-- 반출 로딩 모달 -->
        <b-modal size="sm" v-model="loadingModal" title="반출 요청">
            <div class="progress-bar">
                <div class="progress-bar-value"></div>
            </div>

            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancel">
                    닫기
                </b-button>
            </template>
        </b-modal>

        <!-- 반출 모달 -->
        <b-modal size="sm" v-model="loadingModal" title="반출 요청">
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancel">
                    닫기
                </b-button>
            </template>
        </b-modal>

        <!-- 열람 요청 -->
        <b-modal size="lg" v-model="requestBrowseModal" title="열람 요청">
            <b-form-group label="요청 사유" style="margin-top: 20px;">
                <b-form-textarea v-model="requestBrowseForm.reason" />
            </b-form-group>
            <template #modal-footer="{ ok, cancel, hide }" style="margin-right: 300px;">
                <b-button variant="danger" @click="cancelSaveEvent" style="font-weight: bold;">
                    취소
                </b-button>
                <b-button @click="saveRequestBrowse" style="font-weight: bold;">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- 반출 요청 -->
        <b-modal size="lg" v-model="requestTakeoutModal" title="반출 요청">
            <div style="margin-top: 20px;">
                <b-form-group label="요청 사유">
                    <b-form-textarea v-model="requestTakeoutForm.reason" />
                </b-form-group>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancelSaveEvent">
                    취소
                </b-button>
                <b-button @click="saveRequestTakeout">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- 열람 modal -->
        <b-modal
            v-if="videoData"
            size="lg"
            v-model="videoModal"
            title="데이터 열람"
            class="cutom-need-modal"
        >
            <div style="height: 630px !important;">
                <div class="modal-data-table_custom">
                    <b-table-simple>
                        <!-- <b-tbody striped> -->
                        <b-tbody>
                            <b-tr>
                                <b-th rowspan="1" style="font-size: 16px; padding-left: 20px;">일시</b-th>
                                <b-th rowspan="1" style="font-size: 16px;">수술실</b-th>
                                <b-th rowspan="1" style="font-size: 16px;">진료과</b-th>
                                <b-th rowspan="1" style="font-size: 16px;">주치의</b-th>
                                <b-th rowspan="1" style="font-size: 16px;">환자명</b-th>
                                <b-th rowspan="1" style="font-size: 16px;">환자 상태</b-th>
                            </b-tr>
                            <b-tr>
                                <b-td rowspan="1" style="font-size: 13px; padding-left: 20px; padding-right: 0px;">{{ videoData.date }}</b-td>
                                <b-td rowspan="1" style="font-size: 13px;">{{ videoData.sergery_name }}</b-td>
                                <b-td rowspan="1" style="font-size: 13px;">{{ videoData.department }}</b-td>
                                <b-td rowspan="1" style="font-size: 13px;">{{ videoData.doctor }}</b-td>
                                <b-td rowspan="1" style="font-size: 13px;">{{ videoData.patient_name }}</b-td>
                                <b-td rowspan="1" style="font-size: 13px;">{{ videoData.patient_status }}</b-td>
                            </b-tr>
                        </b-tbody>
                    </b-table-simple>
                </div>
                <div style="width:744px; height:415px;" v-if="videoBool">
		   <SplitVideoPlayer
                        v-if="videoData.split === 1"
                        ref="videoPlayer"
                        :isHistory="true"
                        :recordStartDate="videoData.date"
                        :manifest-url="videoLink"
                    ></SplitVideoPlayer>
                    <AssembleVideoPlayer
                        v-else-if="videoData.split === 2"
                        ref="videoPlayer"
                        :isHistory="true"
                        :recordStartDate="videoData.date"
                        :manifest-url="videoLink"
                    ></AssembleVideoPlayer>
                    <VideoPlayer
                        v-else
                        :isHistory="true"
                        :recordStartDate="videoData.date"
                        :manifest-url="videoLink"
                    ></VideoPlayer>
                </div>

                <div class="modal-data-table-page-camera-num">
                    <span>
                        <a style="padding-left: 5px; padding-right: 5px;" href="#" class="page-btn2 fr-15-r" @click="selectSurgery(0)">1</a>
                        <a style="padding-left: 5px; padding-right: 5px;" href="#" class="page-btn2 fr-15-r" @click="selectSurgery(1)">2</a>
                        <a style="padding-left: 5px; padding-right: 5px;" href="#" class="page-btn2 fr-15-r" @click="selectSurgery(2)">3</a>
                        <a style="padding-left: 5px; padding-right: 5px;" href="#" class="page-btn2 fr-15-r" @click="selectSurgery(3)">4</a>
                    </span>
                </div>

                <!-- <div class="move-video-buttons mt-5">
                    <b-button
                        :disabled="currentVideo === 0"
                        class="mb-1"
                        @click="prevSurgery"
                        variant="primary"
                        ><</b-button
                    >
                    <h2 style="display:inline">
                        <b-badge class="mb-1" pill variant="primary"
                            >[ {{ currentVideo + 1 }}번 카메라 ]</b-badge
                        >
                    </h2>
                    <b-button
                        :disabled="currentVideo === 3"
                        @click="nextSurgery"
                        class="mb-1"
                        variant="primary"
                        >></b-button
                    >
                </div> -->
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button @click="cancel" style="margin-right: 40px">
                    확인
                </b-button>
            </template>
        </b-modal>

        <b-colxx md="12" class="disable-text-selection">
            <list-page-heading
                :title="$t('menu.data-list')"
                :sort="sort"
                :perPage="perPage"
                :startDate="startDate"
                :endDate="endDate"
                :today="today"
                :aWeek="aWeek"
                :aMonth="aMonth"
                :twoMonth="twoMonth"
                :selectStartData="selectStartData"
                :selectEndData="selectEndData"
                :searchClick="searchClick"
                :changeRadio="changeRadio"
                :currentSearchType="currentSearchType"
                :changeSearchType="changeSearchType"
            ></list-page-heading>
        </b-colxx>
        <div style="display: block; height: 80px;">&nbsp;</div>

        <b-dropdown
            id="ddown1"
            :text="String(perPage)"
            variant="outline-secondary"
            style="margin-top: 40px; margin-left: 1430px;"
        >
            <b-dropdown-item
                @click="changePerPage(item)"
                v-for="(item, index) in perPageList"
                :key="index"
                >{{ item }}</b-dropdown-item
            >
        </b-dropdown>

        <b-colxx md="12" style="border: solid 1px #e7e7e7; border-radius: 20px; box-shadow: 2px 2px 6px 0 rgb(223 224 226 / 38%);">
            <b-card style="border: none !important; box-shadow: none !important;">
                <!-- this.$refs.vuetable.selectedTo 선택된 데이터 정보 -->
                <!-- 
                    <b-dropdown
                    id="ddown1"
                    :text="String(perPage)"
                    variant="outline-secondary"
                    style="float:right"
                >
                    <b-dropdown-item
                        @click="changePerPage(item)"
                        v-for="(item, index) in perPageList"
                        :key="index"
                        >{{ item }}</b-dropdown-item
                    >
                </b-dropdown>
                -->
                <vuetable
                    ref="vuetable"
                    :api-mode="false"
                    :data="filteredItems"
                    :fields="
                        $route.name === 'browse' ? browseFields : takeoutFields
                    "
                    :per-page="4"
                    :data-manager="dataManager"
                    pagination-path
                    @vuetable:pagination-data="onPaginationData"
                >
                    <template
                        v-if="$route.name === 'browse'"
                        slot="browse_status"
                        scope="props"
                    >
                        <p>
                            {{
                                props.rowData.expiration
                                    ? "영상 만료"
                                    : props.rowData.browse_status === "standby"
                                    ? "허가 대기중"
                                    : props.rowData.browse_status ===
                                      "permitted"
                                    ? "허용"
                                    : props.rowData.browse_status === "denied"
                                    ? "거부"
                                    : "권한 없음"
                            }}
                        </p>
                    </template>

                    <template
                        v-if="$route.name === 'takeout'"
                        slot="takeout_status"
                        scope="props"
                    >
                        <p>
                            {{
                                props.rowData.expiration
                                    ? "영상 만료"
                                    : props.rowData.takeout_status === "standby"
                                    ? "허가 대기중"
                                    : props.rowData.takeout_status ===
                                      "permitted"
                                    ? "허용"
                                    : props.rowData.takeout_status === "denied"
                                    ? "거부"
                                    : "권한 없음"
                            }}
                        </p>
                    </template>

                    <template
                        v-if="$route.name === 'browse'"
                        slot="browse_request"
                        scope="props"
                    >
                    
                    <span class="request" v-if="
                                (props.rowData.browse_status === null ||
                                    props.rowData.browse_status === undefined ||
                                    props.rowData.browse_status === 'denied') &&
                                    props.rowData.expiration === 0
                            " @click="openBrowseRequestModal(props.rowData.id)">
                        <img style="margin-left: 16px;" src="/assets/img/request.svg">
                    </span>
                    <span class="request-denined" v-else><img style="width: 40px; margin-left: 10px;" src="/assets/img/request-hover.svg"></span>
                    <!--
                        <b-button
                            v-if="
                                (props.rowData.browse_status === null ||
                                    props.rowData.browse_status === undefined ||
                                    props.rowData.browse_status === 'denied') &&
                                    props.rowData.expiration === 0
                            "
                            @click="openBrowseRequestModal(props.rowData.id)"
                        >
                            열람 요청
                        </b-button>
                        <b-button v-else disabled> 열람 요청 </b-button>
                    -->
                    </template>

                    <template
                        v-if="$route.name === 'browse'"
                        slot="browse"
                        scope="props"
                    >

                    <span class="data" v-if="
                                props.rowData.browse_status === 'permitted' &&
                                props.rowData.expiration === 0
                            " @click="openVideoModal(props.rowData)">
                        <img style="margin-left: 4px;" src="/assets/img/data.svg">
                    </span>
                    <span class="data-denined" v-else><img style="width: 40px;" src="/assets/img/data-hover.svg"></span>
                    <!--
                        <b-button
                            v-if="
                                props.rowData.browse_status === 'permitted' &&
                                    props.rowData.expiration === 0
                            "
                            @click="openVideoModal(props.rowData)"
                        >
                            열람
                        </b-button>
                        <b-button v-else disabled> 열람 </b-button>
                    -->
                    </template>

                    <template
                        v-if="$route.name === 'takeout'"
                        slot="takeout_request"
                        scope="props"
                    >

                    <span class="request" v-if="
                                (props.rowData.takeout_status === null ||
                                    props.rowData.takeout_status ===
                                        undefined ||
                                    props.rowData.takeout_status ===
                                        'denied') &&
                                    props.rowData.expiration === 0
                            "
                            @click="openTakeoutRequestModal(props.rowData.id)">
                        <img style="margin-left: 16px;" src="/assets/img/request.svg">
                    </span>
                    <span class="request-denined" v-else><img style="width: 40px; margin-left: 10px;" src="/assets/img/request-hover.svg"></span>

                    <!--
                        <b-button
                            v-if="
                                (props.rowData.takeout_status === null ||
                                    props.rowData.takeout_status ===
                                        undefined ||
                                    props.rowData.takeout_status ===
                                        'denied') &&
                                    props.rowData.expiration === 0
                            "
                            @click="openTakeoutRequestModal(props.rowData.id)"
                        >
                            반출 요청
                        </b-button>
                        <b-button v-else disabled> 반출 요청 </b-button>
                    -->
                    </template>

                    <template
                        v-if="$route.name === 'takeout'"
                        slot="takeout"
                        scope="props"
                    >

                    <span class="data" v-if="
                               props.rowData.takeout_status === 'permitted' &&
                                    props.rowData.expiration === 0
                            " @click="clickTakeout(props.rowData)">
                        <img style="margin-left: 4px;" src="/assets/img/data.svg">
                    </span>
                    <span class="data-denined" v-else><img style="width: 40px;" src="/assets/img/data-hover.svg"></span>
                    <!--
                        <b-button
                            v-if="
                                props.rowData.takeout_status === 'permitted' &&
                                    props.rowData.expiration === 0
                            "
                            @click="clickTakeout(props.rowData)"
                        >
                            반출
                        </b-button>
                        <b-button v-else disabled> 반출 </b-button>
                    -->
                    </template>
                </vuetable>
                <vuetable-pagination-bootstrap
                    ref="pagination"
                    @vuetable-pagination:change-page="onChangePage"
                ></vuetable-pagination-bootstrap>
            </b-card>
        </b-colxx>
    </b-row>
</template>

<script>
import api from "../../../../api";
import ListPageHeading from "../../../../containers/pages/ListPageHeading";
import { mapGetters } from "vuex";
import Vuetable from "vuetable-2/src/components/Vuetable";
import VuetablePaginationBootstrap from "../../../../components/Common/VuetablePaginationBootstrap";
import moment from "moment";
import VideoPlayer from "../../../../components/Shaka/VideoPlayer.vue";
import SplitVideoPlayer from "../../../../components/Shaka/SplitVideoPlayer.vue";
import AssembleVideoPlayer from "../../../../components/Shaka/AssembleVideoPlayer.vue";
import { base_url } from "../../../../server.json";

export default {
    components: {
        "list-page-heading": ListPageHeading,
        vuetable: Vuetable,
        "vuetable-pagination-bootstrap": VuetablePaginationBootstrap,
        VideoPlayer,
        SplitVideoPlayer,
        AssembleVideoPlayer
    },
    computed: {
        ...mapGetters({
            currentUser: "currentUser"
        }),
        isSelectedAll() {
            return this.selectedItems.length >= this.filteredItems.length;
        }
    },
    data() {
        return {
            loadingModal: false, //반출 로딩 모달
            isLoad: false,
            sort: {
                column: "title",
                label: "Product Name"
            },
            page: 1,
            perPage: 4,
            search: "",
            lastPage: 0,
            startDate: "",
            endDate: "",
            currentProcessingStatus: 0,

            // perpage변경
            perPageList: [4, 10, 30, 50, 100],

            //단말
            videoData: null,
            videoModal: false,
            videoLink: null,
            devices: [],
            date: null,
            currentVideo: 0,
            splitedList: [],
            timeList: [],
            videoBool: true,

            // sort
            sort: "id",
            sortType: "desc",

            items: [],
            filteredItems: [],
            selectedItems: [],
            currentSearchType: "주치의",
            searchItems: ["주치의", "수술실", "진료과"],

            //열람 컬럼
            browseFields: [
                // {
                //     name: "__checkbox",
                //     titleClass: "center aligned",
                //     dataClass: "center aligned"
                // },
                {
                    name: "date",
                    sortField: "date",
                    title: "수술 날짜",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "sergery_name",
                    sortField: "sergery_name",
                    title: "수술실",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "department",
                    sortField: "department",
                    title: "진료과",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "doctor",
                    sortField: "doctor",
                    title: "주치의",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "patient_name",
                    sortField: "patient_name",
                    title: "환자명",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "patient_status",
                    sortField: "patient_status",
                    title: "환자 상태",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:browse_status",
                    title: "열람 권한",
                    sortField: "accessStatus",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:browse_request",
                    title: "열람 요청",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:browse",
                    title: "열람",
                    titleClass: "",
                    dataClass: "list-item-heading"
                }
            ],

            //반출 컬럼
            takeoutFields: [
                // {
                //     name: "__checkbox",
                //     titleClass: "center aligned",
                //     dataClass: "center aligned"
                // },
                {
                    name: "date",
                    sortField: "date",
                    title: "수술 날짜",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "sergery_name",
                    sortField: "sergery_name",
                    title: "수술실",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "department",
                    sortField: "department",
                    title: "진료과",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "doctor",
                    sortField: "doctor",
                    title: "주치의",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "patient_name",
                    sortField: "patient_name",
                    title: "환자명",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "patient_status",
                    sortField: "patient_status",
                    title: "환자 상태",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:takeout_status",
                    title: "반출 권한",
                    sortField: "takeoutStatus",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:takeout_request",
                    title: "반출 요청",
                    titleClass: "",
                    dataClass: "list-item-heading"
                },
                {
                    name: "__slot:takeout",
                    title: "반출",
                    titleClass: "",
                    dataClass: "list-item-heading"
                }
            ],

            recordAccess: [], //열람 권한
            recordTakeout: [], //반출 권한

            requestBrowseModal: false, //열람 요청 모달 변수
            requestBrowseForm: {
                user_id: null,
                record_id: null,
                status: null,
                reason: null,
                created_at: null
            },

            requestTakeoutModal: false, //반출 요청 모달 변수
            requestTakeoutForm: {
                user_id: null,
                record_id: null,
                status: null,
                reason: null,
                created_at: null
            }
        };
    },
    methods: {
        dataManager(sortOrder, pagination) {
            if (sortOrder.length) {
                let sortInfo = sortOrder[0];
                this.sortType = sortInfo.direction;
                this.sort = sortInfo.sortField;
                if (sortInfo.sortField === "accessStatus") {
                    this.getSortedStatusRecords("access");
                } else if (sortInfo.sortField === "takeoutStatus") {
                    this.getSortedStatusRecords("takeout");
                } else {
                    this.getRecords();
                }
            }
        },

        async getSortedStatusRecords(val) {
            this.items = await api.getRecordAuth({
                start:
                    this.startDate === ""
                        ? ""
                        : moment(this.startDate).format("YYYY-MM-DD 00:00:00"),
                end:
                    this.endDate === ""
                        ? ""
                        : moment(this.endDate).format("YYYY-MM-DD 00:00:00"),
                searchType:
                    this.currentSearchType === "주치의"
                        ? "doctor"
                        : this.currentSearchType === "수술실"
                        ? "surgery_name"
                        : "department",
                search: this.search ? this.search : "",
                page: this.page,
                per_page: this.perPage,
                status:
                    this.currentProcessingStatus === 0
                        ? ""
                        : this.currentProcessingStatus === 1
                        ? "수술 완료"
                        : this.currentProcessingStatus === 2
                        ? "수술 취소"
                        : this.currentProcessingStatus === 3
                        ? "입원"
                        : "퇴원",
                sort: "status",
                sortType: this.sortType,
                authType: val
            });

            this.filteredItems = this.items;

            this.items.data.forEach((record, index) => {
                if (val === "access") {
                    this.recordTakeout.data.forEach(access => {
                        if (record.id === access.record_id) {
                            this.items.data[index] = {
                                ...this.items.data[index],
                                takeout_status: access.status,
                                takeout_reason: access.reason
                            };
                        }
                    });
                } else if (val === "takeout") {
                    this.recordAccess.data.forEach(access => {
                        if (record.id === access.record_id) {
                            this.items.data[index] = {
                                ...record,
                                browse_status: access.status,
                                browse_reason: access.reason
                            };
                        }
                    });
                }
            });
        },

        // perpage 바꿨을때 이벤트
        changePerPage(val) {
            if (this.perPage !== val) {
                this.perPage = val;
                this.page = 1;

                this.getRecords();
            }
        },

        //반출 버튼 클릭 이벤트
        clickTakeout(data) {
            if (data.takeout_link === null || data.takeout_link === "") {
                // this.mqtt
                this.loadingModal = true;
            }
            this.saveRecord(data);
        },
        //열람시 기록 저장
        saveRecord(data) {
            api.saveHistory({
                record_id: data.id,
                account_id: this.currentUser.id,
                created_at: moment().format("YYYY-MM-DD HH:mm:ss"),
                type: this.$route.name
            });
        },
        //열람 요청, 반출 요청 form 초기화
        cancelSaveEvent() {
            this.requestBrowseModal = false;
            this.requestTakeoutModal = false;
        },
        //열람 요청 모달
        openBrowseRequestModal(data) {
            this.requestBrowseForm = {
                user_id: this.currentUser.id,
                record_id: data,
                status: "standby",
                reason: null,
                created_at: moment().format("YYYY-MM-DD HH:mm:ss")
            };

            this.requestBrowseModal = true;
        },
        //열람 요청 저장
        async saveRequestBrowse() {
            await api.saveRequestBrowse(this.requestBrowseForm);

            this.getRecords();

            this.requestBrowseModal = false;
        },
        //열람 요청 모달
        openTakeoutRequestModal(data) {
            this.requestTakeoutForm = {
                user_id: this.currentUser.id,
                record_id: data,
                status: "standby",
                reason: null,
                created_at: moment().format("YYYY-MM-DD HH:mm:ss")
            };

            this.requestTakeoutModal = true;
        },
        //열람 요청 저장
        async saveRequestTakeout() {
            await api.saveRequestTakeout(this.requestTakeoutForm);

            this.getRecords();

            this.requestTakeoutModal = false;
        },
        async openVideoModal(data) {
            this.videoBool = true;
            this.currentVideo = 0;
            this.videoData = data;
            this.devices = data.devices.split(",");
            this.devices.sort();

            this.date = data.video_link;
            if (data.split === 0) {
                this.videoLink = `https://${base_url}:3000/stream/${this.devices[0]}_${this.date}/${this.devices[0]}_${this.date}.mpd`;
            } else if (data.split === 1) {
                this.split = 1;

                this.videoLink = data.files[0];
            } else if (data.split === 2) {
                this.videoLink = [];

                this.split = 2;
                this.videoLink.push(
                    `${this.devices[0]}_${this.date}/${this.devices[0]}_${this.date}.mpd`
                );
                this.timeList.push(data.date);

                this.splitedList = await api.getSplitedRecords({
                    record_id: data.id
                });

                let list = [];
                this.splitedList.forEach(e => {
                    this.timeList.push(e.date);
                    this.videoLink.push(
                        `${this.devices[0]}_${e.video_link}/${this.devices[0]}_${e.video_link}.mpd`
                    );
                });

                this.videoLink = this.videoLink.concat(list);
            }
            this.videoModal = true;

            this.saveRecord(data);
        },
        selectSurgery(num) {
            this.currentVideo = num;
            this.videoBool = false;

            if (this.videoData.split === 0) {
                this.videoLink = `https://${base_url}:3000/stream/${
                    this.devices[this.currentVideo]
                }_${this.date}/${this.devices[this.currentVideo]}_${
                    this.date
                }.mpd`;
            } else if (this.videoData.split === 1) {
                this.videoLink = this.videoData.files[this.currentVideo];
            } else if (this.videoData.split === 2) {
                this.videoLink = [];

                this.videoLink.push(
                    `${this.devices[this.currentVideo]}_${this.date}/${
                        this.devices[this.currentVideo]
                    }_${this.date}.mpd`
                );
                this.timeList.push(this.videoData.date);

                let list = [];
                this.splitedList.forEach(e => {
                    this.timeList.push(e.date);
                    this.videoLink.push(
                        `${this.devices[this.currentVideo]}_${e.video_link}/${
                            this.devices[this.currentVideo]
                        }_${e.video_link}.mpd`
                    );
                });

                this.videoLink = this.videoLink.concat(list);
            }
            setTimeout(() => {
                this.videoBool = true;
            }, 0);
        },
        prevSurgery() {
            this.currentVideo--;
            this.videoBool = false;

            if (this.videoData.split === 0) {
                this.videoLink = `https://${base_url}:3000/stream/${
                    this.devices[this.currentVideo]
                }_${this.date}/${this.devices[this.currentVideo]}_${
                    this.date
                }.mpd`;
            } else if (this.videoData.split === 1) {
                this.videoLink = this.videoData.files[this.currentVideo];
            } else if (this.videoData.split === 2) {
                this.videoLink = [];

                this.videoLink.push(
                    `${this.devices[this.currentVideo]}_${this.date}/${
                        this.devices[this.currentVideo]
                    }_${this.date}.mpd`
                );
                this.timeList.push(this.videoData.date);

                let list = [];
                this.splitedList.forEach(e => {
                    this.timeList.push(e.date);
                    this.videoLink.push(
                        `${this.devices[this.currentVideo]}_${e.video_link}/${
                            this.devices[this.currentVideo]
                        }_${e.video_link}.mpd`
                    );
                });

                this.videoLink = this.videoLink.concat(list);
            }
            setTimeout(() => {
                this.videoBool = true;
            }, 0);
        },
        nextSurgery() {
            this.currentVideo++;
            this.videoBool = false;

            if (this.videoData.split === 0) {
                this.videoLink = `https://${base_url}:3000/stream/${
                    this.devices[this.currentVideo]
                }_${this.date}/${this.devices[this.currentVideo]}_${
                    this.date
                }.mpd`;
            } else if (this.videoData.split === 1) {
                this.videoLink = this.videoData.files[this.currentVideo];
            } else if (this.videoData.split === 2) {
                this.videoLink = [];

                this.videoLink.push(
                    `${this.devices[this.currentVideo]}_${this.date}/${
                        this.devices[this.currentVideo]
                    }_${this.date}.mpd`
                );
                this.timeList.push(this.videoData.date);

                let list = [];
                this.splitedList.forEach(e => {
                    this.timeList.push(e.date);
                    this.videoLink.push(
                        `${this.devices[this.currentVideo]}_${e.video_link}/${
                            this.devices[this.currentVideo]
                        }_${e.video_link}.mpd`
                    );
                });

                this.videoLink = this.videoLink.concat(list);
            }
            setTimeout(() => {
                this.videoBool = true;
            }, 0);
        },
        onPaginationData(paginationData) {
            this.$refs.pagination.setPaginationData(paginationData);
        },
        async onChangePage(page) {
            this.$refs.vuetable.changePage(page);
            this.page = page;

            if (this.sort === "accessStatus") {
                await this.getSortedStatusRecords("access");
            } else if (this.sort === "takeoutStatus") {
                await this.getSortedStatusRecords("takeout");
            } else {
                await this.getRecords();
            }
        },
        changeSearchType(item) {
            this.currentSearchType = item;
        },
        loadItems() {
            this.isLoad = true;
        },

        selectAll(isToggle) {
            if (this.selectedItems.length >= this.filteredItems.length) {
                if (isToggle) this.selectedItems = [];
            } else {
                this.selectedItems = this.filteredItems.map(x => x.id);
            }
        },
        getIndex(value, arr, prop) {
            for (var i = 0; i < arr.length; i++) {
                if (arr[i][prop] === value) {
                    return i;
                }
            }
            return -1;
        },
        toggleItem(event, itemId) {
            if (event.shiftKey && this.selectedItems.length > 0) {
                let itemsForToggle = this.filteredItems;
                var start = this.getIndex(itemId, itemsForToggle, "id");
                var end = this.getIndex(
                    this.selectedItems[this.selectedItems.length - 1],
                    itemsForToggle,
                    "id"
                );
                itemsForToggle = itemsForToggle.slice(
                    Math.min(start, end),
                    Math.max(start, end) + 1
                );
                this.selectedItems.push(
                    ...itemsForToggle.map(item => {
                        return item.id;
                    })
                );
            } else {
                if (this.selectedItems.includes(itemId)) {
                    this.selectedItems = this.selectedItems.filter(
                        x => x !== itemId
                    );
                } else this.selectedItems.push(itemId);
            }
        },
        changePage(pageNum) {
            this.page = pageNum;
        },
        today() {
            this.startDate = new Date();
            this.endDate = new Date();
        },
        aWeek() {
            const today = new Date();

            const aWeekAgo = today.setDate(today.getDate() - 7);

            this.startDate = aWeekAgo;
            this.endDate = new Date();
        },
        aMonth() {
            const today = new Date();

            const aMonthAgo = today.setMonth(today.getMonth() - 1);

            this.startDate = aMonthAgo;
            this.endDate = new Date();
        },
        twoMonth() {
            const today = new Date();

            const twoMonthAgo = today.setMonth(today.getMonth() - 2);

            this.startDate = twoMonthAgo;
            this.endDate = new Date();
        },
        selectStartData(val) {
            this.startDate = val;
        },
        selectEndData(val) {
            this.endDate = val;
        },
        async searchClick(val) {
            this.search = val;
            await this.getRecords();
        },
        changeRadio(val) {
            this.currentProcessingStatus = val;
        },
        async getRecords() {
            this.items = await api.getRecords({
                start:
                    this.startDate === ""
                        ? ""
                        : moment(this.startDate).format("YYYY-MM-DD 00:00:00"),
                end:
                    this.endDate === ""
                        ? ""
                        : moment(this.endDate).format("YYYY-MM-DD 00:00:00"),
                searchType:
                    this.currentSearchType === "주치의"
                        ? "doctor"
                        : this.currentSearchType === "수술실"
                        ? "surgery_name"
                        : "department",
                search: this.search ? this.search : "",
                page: this.page,
                per_page: this.perPage,
                status:
                    this.currentProcessingStatus === 0
                        ? ""
                        : this.currentProcessingStatus === 1
                        ? "수술 완료"
                        : this.currentProcessingStatus === 2
                        ? "수술 취소"
                        : this.currentProcessingStatus === 3
                        ? "입원"
                        : "퇴원",
                sort: this.sort,
                sortType: this.sortType
            });

            //열람 권한 조회
            if (this.items.data.length) {
                this.recordAccess = await api.getRecrodAccess({
                    user_id: this.currentUser.id,
                    first: this.items.data[this.items.data.length - 1].id,
                    last: this.items.data[0].id,
                    start:
                        this.startDate === ""
                            ? ""
                            : moment(this.startDate).format(
                                  "YYYY-MM-DD 00:00:00"
                              ),
                    end:
                        this.endDate === ""
                            ? ""
                            : moment(this.endDate).format(
                                  "YYYY-MM-DD 00:00:00"
                              ),
                    searchType:
                        this.currentSearchType === "주치의"
                            ? "doctor"
                            : this.currentSearchType === "수술실"
                            ? "surgery_name"
                            : "department",
                    search: this.search ? this.search : "",
                    status:
                        this.currentProcessingStatus === 0
                            ? ""
                            : this.currentProcessingStatus === 1
                            ? "수술 완료"
                            : this.currentProcessingStatus === 2
                            ? "수술 취소"
                            : this.currentProcessingStatus === 3
                            ? "입원"
                            : "퇴원",
                    per_page: "",
                    page: "",
                    sort: this.sort,
                    sortType: this.sortType
                });

                //반출 권한 조회
                this.recordTakeout = await api.getTekeoutAccess({
                    user_id: this.currentUser.id,
                    first: this.items.data[this.items.data.length - 1].id,
                    last: this.items.data[0].id,
                    start:
                        this.startDate === ""
                            ? ""
                            : moment(this.startDate).format(
                                  "YYYY-MM-DD 00:00:00"
                              ),
                    end:
                        this.endDate === ""
                            ? ""
                            : moment(this.endDate).format(
                                  "YYYY-MM-DD 00:00:00"
                              ),
                    searchType:
                        this.currentSearchType === "주치의"
                            ? "doctor"
                            : this.currentSearchType === "수술실"
                            ? "surgery_name"
                            : "department",
                    search: this.search ? this.search : "",
                    status:
                        this.currentProcessingStatus === 0
                            ? ""
                            : this.currentProcessingStatus === 1
                            ? "수술 완료"
                            : this.currentProcessingStatus === 2
                            ? "수술 취소"
                            : this.currentProcessingStatus === 3
                            ? "입원"
                            : "퇴원",
                    per_page: "",
                    page: "",
                    sort: this.sort,
                    sortType: this.sortType
                });

                //조건에 맞는 권한이 존재하면 id 비교후 합치기
                // if(this.recordAccess.length){
                this.items.data.forEach((record, index) => {
                    this.recordAccess.data.forEach(access => {
                        if (record.id === access.record_id) {
                            this.items.data[index] = {
                                ...record,
                                browse_status: access.status,
                                browse_reason: access.reason
                            };
                        }
                    });

                    this.recordTakeout.data.forEach(access => {
                        if (record.id === access.record_id) {
                            this.items.data[index] = {
                                ...this.items.data[index],
                                takeout_status: access.status,
                                takeout_reason: access.reason
                            };
                        }
                    });
                });
                // }
            }
            this.filteredItems = this.items;
        }
    },
    watch: {
        search() {
            this.page = 1;
        }
    },
    async mounted() {
        this.loadItems();

        this.getRecords();
    }
};
</script>

<style>
.progress-bar {
    height: 4px;
    background-color: rgba(5, 114, 206, 0.2);
    width: 100%;
    overflow: hidden;
}

.progress-bar-value {
    width: 100%;
    height: 100%;
    background-color: rgb(5, 114, 206);
    animation: indeterminateAnimation 1s infinite linear;
    transform-origin: 0% 50%;
}

@keyframes indeterminateAnimation {
    0% {
        transform: translateX(0) scaleX(0);
    }
    40% {
        transform: translateX(0) scaleX(0.4);
    }
    100% {
        transform: translateX(100%) scaleX(0.5);
    }
}
</style>
