<template>
    <div v-if="surgeries.length">
        <!-- add -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="addModal" size="lg" title="단말기 추가">
            <b-form-group
                id="input-group-1"
                label="단말기 이름:"
                label-for="input-1"
            >
                <b-form-input
                id="input-1"
                v-model="form.device_name"
                required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="input-group-1"
                label="단말기 Live Url:"
                label-for="input-1"
            >
                <b-form-input
                id="input-2"
                v-model="form.live_url"
                required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="input-group-1"
                label="시리얼 넘버:"
                label-for="input-1"
            >
                <b-form-input
                id="input-3"
                v-model="form.Serial_number"
                required
                ></b-form-input>
            </b-form-group>

            <!-- <b-form-group
                id="input-group-1"
                label="단말기 위치:"
                label-for="input-1"
            >
                <b-form-input
                id="input-4"
                v-model="form.device_location"
                required
                ></b-form-input>
            </b-form-group> -->

            <b-form-group
                id="input-group-1"
                label="비고:"
                label-for="input-1"
            >
                <b-form-input
                id="input-5"
                v-model="form.note"
                required
                ></b-form-input>
            </b-form-group>

             <b-form-group
                id="input-group-1"
                label="단말기 위치:"
                label-for="input-1"
            >
                <v-select v-model="selectedSurgery" :options="surgeries" label="surgery_name" value="surgery_id"/>
             </b-form-group>

            <!-- <b-form-group
                id="input-group-1"
                label="단말 타입:"
                label-for="input-1"
            >
                <b-input-group  class="mb-3">
                    <b-form-select v-model="form.target" :options="options"  plain  />
                    <b-input-group-append>
                        <b-button variant="outline-secondary">{{ '타입 목록' }}</b-button>
                    </b-input-group-append>
                </b-input-group>
            </b-form-group> -->

          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelAdd">
              취소
            </b-button>
            <b-button @click="add">
              저장
            </b-button>
          </template>
        </b-modal>

        <!-- update -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="updateModal" size="lg" title="단말기 수정">
            <b-form-group
                id="input-group-1"
                label="단말기 이름:"
                label-for="input-1"
            >
                <b-form-input
                id="input-1"
                v-model="form.device_name"
                required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="input-group-1"
                label="단말기 Live Url:"
                label-for="input-1"
            >
                <b-form-input
                id="input-2"
                v-model="form.live_url"
                required
                ></b-form-input>
            </b-form-group>

            <b-form-group
                id="input-group-1"
                label="시리얼 넘버:"
                label-for="input-1"
            >
                <b-form-input
                id="input-3"
                v-model="form.Serial_number"
                required
                ></b-form-input>
            </b-form-group>

            <!-- <b-form-group
                id="input-group-1"
                label="단말기 위치:"
                label-for="input-1"
            >
                <b-form-input
                id="input-4"
                v-model="form.device_location"
                required
                ></b-form-input>
            </b-form-group> -->

            <b-form-group
                id="input-group-1"
                label="비고:"
                label-for="input-1"
            >
                <b-form-input
                id="input-5"
                v-model="form.note"
                required
                ></b-form-input>
            </b-form-group>


             <b-form-group
                id="input-group-1"
                label="단말기 위치:"
                label-for="input-1"
            >
                <v-select v-model="selectedSurgery" :options="surgeries" label="surgery_name" value="surgery_id"/>
             </b-form-group>

            <!-- <b-form-group
                id="input-group-1"
                label="단말 타입:"
                label-for="input-1"
            >
                <b-input-group  class="mb-3">
                    <b-form-select v-model="form.target" :options="options"  plain  />
                    <b-input-group-append>
                        <b-button variant="outline-secondary">{{ '타입 목록' }}</b-button>
                    </b-input-group-append>
                </b-input-group>
            </b-form-group> -->
          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelUpdate">
              취소
            </b-button>
            <b-button @click="update">
              수정
            </b-button>
          </template>
        </b-modal>

        <!-- device control -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="deviceControlModal" size="lg" title="단말기 제어">
            <template v-if="bootstrapTable.selected.length">
                <b-form-group
                    v-if="bootstrapTable.selected[0].target === 'license_plate'"
                    id="input-group-1"
                    label="감지 번호판:"
                    label-for="input-1"
                >
                    <b-form-input
                    id="input-1"
                    v-model="target"
                    required
                    ></b-form-input>
                </b-form-group>

                <b-form-group
                    v-else
                    id="input-group-1"
                    label="감지 대상 이름:"
                    label-for="input-1"
                >
                    <b-form-input
                    id="input-1"
                    v-model="target"
                    required
                    ></b-form-input>
                </b-form-group>
            </template>
          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelControl">
              취소
            </b-button>
            <b-button @click="control">
              수정
            </b-button>
          </template>
        </b-modal>

        <b-row>
            <b-colxx xxs="12">
            <piaf-breadcrumb :heading="'단말기 목록'"/>
            <div style="float:right;">
                <!-- <b-button variant="outline-secondary" class="mr-3" v-if="bootstrapTable.selected.length === 1" @click="clickControl">단말 제어</b-button>
                <b-button variant="outline-secondary" class="mr-3" v-else disabled @click="clickControl">단말 제어</b-button> -->

                <b-button variant="outline-secondary" class="mr-3" @click="()=>{this.addModal=true}">추가</b-button>

                <b-button variant="outline-secondary" class="mr-3" v-if="bootstrapTable.selected.length === 1" @click="clickUpdate">수정</b-button>
                <b-button variant="outline-secondary" class="mr-3" v-else disabled @click="clickUpdate">수정</b-button>

                <b-button variant="outline-secondary" class="mr-3" v-if="bootstrapTable.selected.length" @click="deleteDevice">삭제</b-button>
                <b-button variant="outline-secondary" class="mr-3" v-else disabled @click="deleteDevice">삭제</b-button>


                <b-dropdown id="surgeriesDropdown" :text="currentSurgery.surgery_name" variant="outline-secondary">
                    <b-dropdown-item @click="changeSurgery(surgery,index)" v-for="(surgery,index) in surgeries" :key="index">{{ surgery.surgery_name }}</b-dropdown-item>
                </b-dropdown>
            </div>
            <div class="separator mb-5"></div>
            </b-colxx>
        </b-row>
        <b-row class="mb-5">
            <b-colxx xxs="12">
            <b-card class="mb-4">
                <b-table
                    ref="custom-table"
                    class="vuetable"
                    @row-selected="rowSelected"
                    selectable
                    :select-mode="bootstrapTable.selectMode"
                    :current-page="currentPage"
                    selectedVariant="primary"
                    :fields="bootstrapTable.fields"
                    :items="items"
                >
                <template slot="status" slot-scope="data">
                    <b-badge class="mb-1" :variant="data.item.statusColor">{{ data.value }}</b-badge>
                </template>
                </b-table>
            </b-card>
            </b-colxx>
        </b-row>
    </div>
</template>
<script>
import api from "../../../../api"
import mqtt from "mqtt"
import {mqtt_url} from '../../../../server.json'
import Vuetable from 'vuetable-2/src/components/Vuetable'
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
import VuetablePaginationBootstrap from '../../../../components/Common/VuetablePaginationBootstrap'

export default {
    props:['mqttClient'],
    components: {
        'vuetable' : Vuetable,
        'v-select' : vSelect,
        'vuetable-pagination-bootstrap' : VuetablePaginationBootstrap
    },
    data () {
        return {
            surgeries:[],
            currentSurgery:{},
            currentSurgeryImdex:0,
            selectedSurgery:{},
            form:{
                device_name:'',
                Serial_number:'',
                live_url:'',
                device_location:'',
                note:'',
                target: 'face'
            },
            options:[
                {value:"face",text:"face(얼굴)"},
                {value:"license_plate",text:"license_plate(번호판)"}
            ],
            target:'',
            deviceControlModal:false,
            addModal:false,
            updateModal:false,
            currentPage: 1,
            perPage: 5,
            totalRows: 0,
            bootstrapTable: {
                selected: [],
                selectMode: 'multi',
                fields: [
                { key: 'device_name', label: '단말기 이름', sortable: false, sortDirection: 'desc', tdClass: 'list-item-heading' },
                { key: 'live_url', label: '단말기 Live Url', sortable: false, tdClass: 'text-muted' },
                { key: 'Serial_number', label: '시리얼 넘버', sortable: false, tdClass: 'text-muted' },
                { key: 'device_location', label: '단말기 위치', sortable: false, tdClass: 'text-muted' },
                { key: 'note', label: '비고', sortable: false, tdClass: 'text-muted' },
                // { key: 'target', label: '타입', sortable: false, tdClass: 'text-muted' }
                ]
            },
            items:[],

        }
    },
    async mounted() {
        await this.getSurgery()
        this.dataProvider()

        // this.mqttClient = mqtt.connect(mqtt_url,{
        //     protocol:"ws",
        //     port:8083,
        //     keepalive:0,
        //     path:'/mqtt',
        //     clean: true,
        // })

        // this.mqttClient.on('error',function (err) {
        //     console.log(err)
        // })


        // this.mqttClient.on('connect', (test) => {
        //     console.log('MQTT connected.')
        // })
    },
    methods: {
            async changeSurgery(val,index) {
                this.currentSurgery = JSON.parse(JSON.stringify(val))
                this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
                this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
                this.currentSurgery.devices = this.currentSurgery.devices.split(',')
                this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
                this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')
                this.currentSurgeryImdex = index

                this.dataProvider()
            },
            async getSurgery() {
                let result = await api.getSurgery()
                this.selectedSurgery = result[0]
                this.surgeries = result
                this.currentSurgery = JSON.parse(JSON.stringify(result[this.currentSurgeryImdex]))
                this.currentSurgery.live_urls = this.currentSurgery.live_urls.split(',')
                this.currentSurgery.device_names = this.currentSurgery.device_names.split(',')
                this.currentSurgery.devices = this.currentSurgery.devices.split(',')
                this.currentSurgery.isLives = this.currentSurgery.isLives.split(',')
                this.currentSurgery.serial_numbers = this.currentSurgery.serial_numbers.split(',')
            },
            clickUpdate() {
                this.form = this.bootstrapTable.selected[0]
                this.selectedSurgery = {
                    surgery_id:this.bootstrapTable.selected[0].surgery_id,
                    surgery_name:this.bootstrapTable.selected[0].surgery_name
                }

                this.updateModal = true;
            },

            cancelUpdate() {
                this.form = {
                    device_name:'',
                    Serial_number:'',
                    live_url:'',
                    device_location:'',
                    note:'',
                    target: 'face'
                }

                this.updateModal = false;
            },


            clickControl() {
                this.target = this.bootstrapTable.selected[0].target_name

                this.deviceControlModal = true;
            },

            cancelControl() {
                this.target = '',

                this.deviceControlModal = false;
            },

            async control() {
                await api.controlDevice({
                    device_id : this.bootstrapTable.selected[0].device_id,
                    target : this.target
                })

                this.mqttClient.publish(`/control/detect/target/${this.bootstrapTable.selected[0].Serial_number}`,JSON.stringify({
                    serial_number : this.bootstrapTable.selected[0].Serial_number,
                    target : this.target
                }))

                this.dataProvider();

                this.deviceControlModal = false
            },

            cancelAdd() {
                this.form = {
                    device_name:'',
                    Serial_number:'',
                    live_url:'',
                    device_location:'',
                    note:'',
                    target: 'face'
                }
                this.addModal=false;
            },

            async add() {
                if(this.form.device_name === '') {
                    alert('단말기 이름을 입력해주세요')
                } else if(this.form.live_url === '') {
                    alert('단말기 Live Url를 입력해주세요')
                } else if(this.form.Serial_number === '') {
                    alert("시리얼 넘버를 입력해주세요")
                }
                // else if(this.form.device_location === '') {
                //     alert("단말기 위치를 입력해주세요")
                // }
                else {
                    let result = await api.addDevice({...this.form, surgery_id : this.selectedSurgery.surgery_id})

                    let splitedUrl = this.form.live_url.split(':')
                    if(splitedUrl.length === 3) {
                        let _splitedUrl = splitedUrl[1].split('//')
                        let ip = _splitedUrl[1]

                        this.mqttClient.publish(`/control/detect/target/${this.bootstrapTable.selected[0].Serial_number}`,JSON.stringify({
                            serial_number : this.bootstrapTable.selected[0].Serial_number,
                            target : this.target
                        }))
                    }

                    this.dataProvider()
                    this.form = {
                        device_name:'',
                        Serial_number:'',
                        live_url:'',
                        device_location:'',
                        note:'',
                        target: 'face'
                    }
                    this.addModal = false;
                }
            },

            async deleteDevice() {
                await api.deleteDevice(this.bootstrapTable.selected)

                this.dataProvider()
            },

            async update() {
                if(this.form.device_name === '') {
                    alert('단말기 이름을 입력해주세요')
                } else if(this.form.live_url === '') {
                    alert('단말기 Live Url를 입력해주세요')
                } else if(this.form.Serial_number === '') {
                    alert("시리얼 넘버를 입력해주세요")
                } else if(this.form.device_location === '') {
                    alert("단말기 위치를 입력해주세요")
                } else {
                    let result = await api.updateDevice({...this.form,surgery_id : this.selectedSurgery.surgery_id})
                    // this.mqttClient.publish(`/control/detect/${this.bootstrapTable.selected[0].Serial_number}`,JSON.stringify({
                    //     type:this.form.target,
                    //     serial_number:this.bootstrapTable.selected[0].Serial_number,
                    // }))

                    this.dataProvider()

                    this.updateModal = false;
                }
            },
            rowSelected (items) {
                this.bootstrapTable.selected = items
            },
            async dataProvider () {
                let result = await api.getDevices({surgery_id : this.currentSurgery.surgery_id})

                this.items = result
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
            }
    }
}
</script>
