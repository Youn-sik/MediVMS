<template>
<div>

    <!-- 열람 승인 -->
    <b-modal size="lg" v-if="currentTakeoutData" v-model="permitModal" title="열람 승인">
        <div class="custom-browsePermit-div-modal-body">
            <b-form-group label="신청 사유">
                <b-form-textarea v-model="currentTakeoutData.reason" disabled/>
            </b-form-group>
        <!-- <b-form-select v-model="form.status" :options="permitType" class="mb-2 mr-2" plain></b-form-select> -->
            <b-form-group label="승인 여부">
                <vselect label="text" v-model="form.status" :options="permitType" dir="ltr" class="vselect1"></vselect>
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

    <div class="custom-browsePermit-div">

        <b-row>
            <b-colxx xxs="12">
            <piaf-breadcrumb heading="열람 신청 목록"/>
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
                        props.rowData.status === 'standbyNVR' ? '반출 준비중' :
                        props.rowData.status === 'permitted' ? '허가' :
                        props.rowData.status === 'denied' ? '거부' : "만료"}}
                    </template>
                    <template slot="browse" scope="props">
                        <!--
                        <b-button v-if="props.rowData.status === 'standby'" @click="browsePermit(props.rowData)"> 열람 요청 </b-button>
                        <b-button v-else disabled> 열람 요청 </b-button>
                        -->
                        <img v-if="props.rowData.status === 'standby'" @click="browsePermit(props.rowData)" src="/assets/img/approval.svg" style="cursor: pointer">
                        <img v-else disabled src="/assets/img/approval-hover.svg" style="cursor: not-allowed; width: 40px;">
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
import {base_url} from "../../../../server.json"
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
      this.getItems()
  },
  data () {
      return {
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
                name: "__slot:browse",
                title: '열람 요청',
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
                value:"permitted",
                text:"승인"
            },
            {
                value:"denied",
                text:"반려"
            }
        ],
        sortType:"desc",
        sort:"id",
        OpenIndicator: {
            render: createElement => createElement('span', {class: {'toggle': true}}),
        },
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
            console.log(this.form.status)
            await api.parchRequestBrowse({reason:this.form.reason, status:this.form.status.value, id:this.currentTakeoutData.id})
            this.permitModal = false;

            this.getItems()
        },
        browsePermit(data) {
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
            let temp = await api.getRecrodAccess({
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
            this.items = temp
        },
        onPaginationData (paginationData) {
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
        }
    }
}
</script>
