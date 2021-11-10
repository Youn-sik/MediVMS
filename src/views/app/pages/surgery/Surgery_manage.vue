<template>
    <div>
        <!-- add -->
        <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="addModal" size="lg" title="단말기 추가">
            <b-form-group
                id="input-group-1"
                label="수술실 이름:"
                label-for="input-1"
            >
                <b-form-input
                id="input-1"
                v-model="form.surgery_name"
                required
                ></b-form-input>
            </b-form-group>

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
                v-model="form.surgery_name"
                required
                ></b-form-input>
            </b-form-group>

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
          <template #modal-footer="{ ok, cancel, hide }">
            <b-button variant="danger" @click="cancelUpdate">
              취소
            </b-button>
            <b-button @click="update">
              수정
            </b-button>
          </template>
        </b-modal>

        <b-row>
            <b-colxx xxs="12">
            <piaf-breadcrumb :heading="'수술실 목록'"/>
            <div style="float:right;">

                <b-button variant="outline-secondary" class="mr-3" @click="()=>{this.addModal=true}">추가</b-button>

                <b-button variant="outline-secondary" class="mr-3" v-if="bootstrapTable.selected.length === 1" @click="clickUpdate">수정</b-button>
                <b-button variant="outline-secondary" class="mr-3" v-else disabled @click="clickUpdate">수정</b-button>

                <b-button variant="outline-secondary" class="mr-3" v-if="bootstrapTable.selected.length" @click="deleteSurgery">삭제</b-button>
                <b-button variant="outline-secondary" class="mr-3" v-else disabled @click="deleteSurgery">삭제</b-button>

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
            selectedSurgery:{},
            form:{
                surgery_name:'',
                note:'',
            },
            addModal:false,
            updateModal:false,
            currentPage: 1,
            perPage: 5,
            totalRows: 0,
            bootstrapTable: {
                selected: [],
                selectMode: 'multi',
                fields: [
                { key: 'surgery_name', label: '수술실 이름', sortable: false, sortDirection: 'desc', tdClass: 'list-item-heading' },
                { key: 'note', label: '비고', sortable: false, tdClass: 'text-muted' },
                { key: 'device_list', label: '단말기 목록', sortable: false, tdClass: 'text-muted' },
                // { key: 'target', label: '타입', sortable: false, tdClass: 'text-muted' }
                ]
            },
            items:[],

        }
    },
    async mounted() {
        this.dataProvider()
    },
    methods: {
        async getSurgery() {
            let result = await api.getSurgery()
            this.selectedSurgery = result[0]
            this.surgeries = result
        },
        clickUpdate() {
            this.form = JSON.parse(JSON.stringify(this.bootstrapTable.selected[0]))
            console.log(this.form)

            this.updateModal = true;
        },

        cancelUpdate() {
            this.form = {
                surgery_name:'',
                note:'',
            }

            this.updateModal = false;
        },

        cancelAdd() {
            this.form = {
                surgery_name:'',
                note:'',
            }
            this.addModal=false;
        },

        async add() {
            if(this.form.surgery_name === '') {
                alert('수술실 이름을 입력해주세요')
            } else {
                let result = await api.addSurgery(this.form)

                this.dataProvider()
                this.form = {
                    surgery_name:'',
                    note:'',
                }
                this.addModal = false;
            }
        },

        async deleteSurgery() {
            await api.deleteSurgery(this.bootstrapTable.selected)

            this.dataProvider()
        },

        async update() {
            if(this.form.surgery_name === '') {
                alert('수술실 이름을 입력해주세요')
            } else {
                let result = await api.updateSurgery(this.form)

                this.dataProvider()

                this.updateModal = false;
            }
        },
        rowSelected (items) {
            this.bootstrapTable.selected = items
        },
        async dataProvider () {
            let result = await api.getSurgery()

            this.items = result
        },
    }
}
</script>
