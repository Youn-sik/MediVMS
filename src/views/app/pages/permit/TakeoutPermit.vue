<template>
<div>

    <!-- 반출 승인 -->
    <b-modal size="lg" v-if="currentTakeoutData" v-model="permitModal" title="반출 승인">
        <div class="custom-div-takeoutpermit-modal" style="margin-top: 30px !important;">
            <b-form-group label="신청 사유">
                <b-form-textarea v-model="currentTakeoutData.reason" disabled/>
            </b-form-group>
        <!-- <b-form-select v-model="form.status" :options="permitType" class="mb-2 mr-2" plain></b-form-select> -->
            <b-form-group label="승인 여부">
                <vselect label="text" v-model="form.status" :options="permitType" dir="ltr" ></vselect>
            </b-form-group>
            <!-- <template slot="option" slot-scope="option">
                            </template> -->
            <b-form-group label="사유">
                <b-form-textarea v-model="form.reason"/>
            </b-form-group>
        </div>
      <template #modal-footer="{ ok, cancel, hide }">
          <b-button variant="danger" @click="cancel">
              취소
          </b-button>
          <b-button @click="savePermit(form)">
              저장
          </b-button>
      </template>
    </b-modal>
    <div class="custom-div-takeout">
        <b-row>
            <b-colxx xxs="12">
            <piaf-breadcrumb heading="반출 신청 목록"/>
            <div class="separator mb-5"></div>
            </b-colxx>
        </b-row>
        <b-row>
            <b-colxx xxs="12">
            <b-card class="mb-4">
                <vuetable
                    ref="vuetable"
                    :api-mode="false"
                    :data="items"
                    :fields="fields"
                    :data-manager="dataManager"
                    pagination-path
                    @vuetable:pagination-data="onPaginationData"
                >
                    <template slot="status" scope="props">
                        {{props.rowData.status === 'standby' ? '허가 대기중' :
                        props.rowData.status === 'permitted' ? '허가' :
                        props.rowData.status == 'preparingTakeout' || 'waitingTakeout' ? '반출 준비' :
                        props.rowData.status === 'denied' ? '거부' : "권한 없음"}}
                    </template>
                    <template slot="takeout" scope="props">
                        <!--
                        <b-button v-if="props.rowData.status === 'standby'" @click="takeoutPermit(props.rowData)"> 반출 요청 </b-button>
                        <b-button v-else disabled> 열람 요청 </b-button>
                        -->
                        <img v-if="props.rowData.status === 'standby'" @click="takeoutPermit(props.rowData)" src="/assets/img/approval.svg" style="cursor: pointer">
                        <img v-else disabled src="/assets/img/approval-hover.svg" style="cursor: not-allowed; width: 40px; padding-bottom:">
                    </template>
                </vuetable>
                <vuetable-pagination-bootstrap
                    ref="pagination"
                    @vuetable-pagination:change-page="onChangePage"
                ></vuetable-pagination-bootstrap>
            </b-card>
            </b-colxx>
        </b-row>
    </div>
    </div>
</template>
<script>
import Vuetable from 'vuetable-2/src/components/Vuetable'
import VuetablePaginationBootstrap from '../../../../components/Common/VuetablePaginationBootstrap'
import mqtt from "mqtt";
import {base_url, mqtt_url} from "../../../../server.json"
import api from "../../../../api"
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
export default {
  components: {
      'vuetable' : Vuetable,
      'vuetable-pagination-bootstrap' : VuetablePaginationBootstrap,
      'vselect':vSelect
  },
  async mounted() {
    // new Promise((resolve, reject)=> {
        this.mqttClient = mqtt.connect(mqtt_url, {
            protocol: "wss",
            port: 8084,
            keepalive: 0,
            path: "/mqtt",
            clientId:
                "server_" +
                Math.random()
                    .toString(16)
                    .substr(2, 8),
            clean: true
        });

        this.mqttClient.on("connect", test => {
            console.log("MQTT connected.");
            this.mqttClient.subscribe(["/encoding/request/+", "/encoding/request"], (error, result) => {
                if (error) {
                    console.log("MQTT subscribe error.");
                    // reject()
                } else {
                    console.log("MQTT subscribed.");
                    // resolve();
                }
            });
        });

        // mqtt connect or mqtt connection error 이 발생하지 않으면 무한 대기이기 때문에 타임 아웃 걸어두고 엠큐티티 연결 안될 시, 반출 불가 알림 보이기
        // setTimeout(()=> {reject();}, 30000)

    // }).then(()=> {
        this.mqttClient.on("error", function(err) {
            console.log(err);
        });

        this.mqttClient.on("message", (topic, message) => {
            console.log("===mqtt===");
            console.log(topic);
            console.log("==========");

        });
    // }).catch(()=> {
    //     alert("반출 서비스 사용이 불가합니다.\n서버 관리자에게 문의 해 주세요.");
    // }).finally(()=> {
        this.getItems();
    // })
  },

  destroyed() {
        this.mqttClient.end(true);
    },

  data () {
      return {
        mqttClient: null,
        items:[],
        fields: [
            {
                name: 'created_at',
                sortField: 'created_at',
                title: '신청 날짜',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'name',
                sortField: 'name',
                title: '신청자',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'account',
                sortField: 'account',
                title: '신청 계정',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'sergery_name',
                sortField: 'sergery_name',
                title: '수술실명',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'doctor',
                sortField: 'doctor',
                title: '담당의',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'patient_name',
                sortField: 'patient_name',
                title: '환자명',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'patient_status',
                sortField: 'patient_status',
                title: '환자 상태',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: 'date',
                sortField: 'date',
                title: '수술 일시',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: "__slot:status",
                sortField: 'status',
                title: '요청 상태',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: "updated_at",
                sortField: 'updated_at',
                title: '처리 날짜',
                titleClass: '',
                dataClass: 'list-item-heading'
            },
            {
                name: "__slot:takeout",
                title: '반출 요청',
                titleClass: '',
                dataClass: 'list-item-heading'
            }
        ],
        currentPage: 1,
        perPage: 5,
        totalRows: 0,
        currentTakeoutData:null,
        permitModal:false,
        form:{
            status:null,
            reason:null,
        },
        permitType:[
            {
                value:"preparingTakeout",
                text:"승인"
            },
            {
                value:"denied",
                text:"반려"
            }
        ],
        sortType:"desc",
        sort:"id",
    }
  },
    methods: {
        dataManager(sortOrder, pagination) { //sort event
            if(sortOrder.length) {
                let sortInfo = sortOrder[0]
                this.sortType = sortInfo.direction
                this.sort = sortInfo.sortField
                // if(sortInfo.sortField === 'accessStatus') {
                //     this.getSortedStatusRecords('access')
                // } else if(sortInfo.sortField === 'takeoutStatus') {
                //     this.getSortedStatusRecords('takeout')
                // } else {
                //     this.getRecords()
                // }
                this.getItems()
            }
        },
        async savePermit() {
            let temp = await api.patchRequestTakeout({reason:this.form.reason, status:this.form.status.value, id:this.currentTakeoutData.id});
            this.permitModal = false;

            await this.getItems();
            this.sendTakeoutMqtt();
        },
        // async savePermit() {
        //     new Promise((resolve, reject)=> {
        //         api.patchRequestTakeout({reason:this.form.reason, status:this.form.status.value, id:this.currentTakeoutData.id})
        //         resolve();
        //     }).then(()=> {
        //         this.permitModal = false;

        //         this.getItems();
        //         this.sendTakeoutMqtt();
        //     })
        // },
        takeoutPermit(data) {
            this.currentTakeoutData = data
            this.currentTakeoutData = data
            if(this.currentTakeoutData.reason == "null") {
                this.currentTakeoutData.reason = ""
            }
            this.form = {
                status:null,
                reason:null,
            }
            this.permitModal = true
        },
        async getItems() {
            let temp = await api.getTekeoutAccess({
                user_id:'',
                first:'',
                last:'',
                start:'',
                end:'',
                searchType: '',
                search:'',
                status : 'standby',
                page:this.currentPage,
                per_page:this.perPage,
                sort:this.sort,
                sortType:this.sortType
            })
            this.items = temp;
        },
        onPaginationData (paginationData) {
            console.log(paginationData)
            this.$refs.pagination.setPaginationData(paginationData)
        },
        async onChangePage (page) {
            this.currentPage = page
            this.$refs.vuetable.changePage(page)

            await this.getItems()
        },
        apiParamsConverter (params) {
            let apiParams = {}
            if (params.perPage !== 0) {
                apiParams.per_page = params.perPage
            }
            if (params.currentPage >= 1) {
                apiParams.page = params.currentPage
            }
            if (params.sortBy && params.sortBy.length > 0) {
                apiParams.sort = `${params.sortBy}|${params.sortDesc ? 'desc' : 'asc'}`
            }
            if (params.filter && params.filter.length > 0) {
                // Optional
            }
            return apiParams
        },
        async sendTakeoutMqtt() {
            let takeoutObject = this.items.data;
            let vName_serial = [];
            takeoutObject.forEach((element, index) => { // 반출 준비 상태의 값들을 가져온다.
                if(element.status == "preparingTakeout") {
                    let vName_serial_Obj = element;
                    vName_serial.push(vName_serial_Obj);
                }
            });
            if(vName_serial.length != 0) {
                for(let i=0; i<vName_serial.length; i++) { // mqtt 전송을 위한 데이터를 가져온다.
                    let _temp = await api.getVideoSerial({
                        "video_link": vName_serial[i].video_link
                    })
                    let record_info = _temp;
                    let record_takeout_id_after_mqtt = []; // 밑의 주석과 같은 이유로 같은 시간에 영상 녹화를 시작(종료)시 함께 처리하기 위해서

                    record_info.forEach((element, index)=> { // mqtt 전송을 위한 데이터를 가져온다.(한번 더 for 문을 돌리는 이유는 같은 시간에 영상 녹화를 시작(종료)했을 때 함께 처리하기 위해서)
                        // console.log(element);
                        record_takeout_id_after_mqtt.push(element.id);

                        let video_path_arr = [];
                        let devices = element.devices.split(",");

                        for(let j=0; j<devices.length; j++) {
                            let video_path = `/var/www/VMS/backend/record/${devices[j]}_${element.video_link}`;
                            video_path_arr.push(video_path);
                        }

                        // mqtt로 pub 로직
                        this.mqttClient.publish(
                            '/encoding/request',
                            JSON.stringify({
                                "video_path": video_path_arr,
                                "watermark": "/var/www/VMS/backend/record/watermark.png",
                                "serial_numbers": devices,
                                "id": element.id
                            })
                        )
                    });
                }
            }
        }
    }
}
</script>
