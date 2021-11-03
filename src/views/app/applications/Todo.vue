<template>
    <b-row>
        <!-- 권한 승인 모달 -->
        <b-modal v-model="authModal" @ok="saveAuth" title="권한 부여">
            <div style="text-align:center; color:white" v-if="selectedAccount">
                <img style="width:35%;" class="mb-3" src="./F2002090001_전준희M_1_36.3_20210913134252.png">
                <p>이름 : {{selectedAccount.name}}</p>
                <p>부서 : {{selectedAccount.department}}</p>
                <p>사원 번호 : {{selectedAccount.employee_no}}</p>
                <p>요청 권한 : {{selectedAccount.req_auth ? selectedAccount.req_auth : '없음'}}</p>
                <p>권한 선택 :</p>

                <b-form-group label="">
                    <b-form-radio-group
                        v-model="selected"
                        :options="options"
                        name="radios-stacked"
                        stacked
                    ></b-form-radio-group>
                </b-form-group>
                <p>수술실 시청 권한 : </p>
                <!-- <b-form-select v-model="selected" :options="['미지정', ...surgeries]"></b-form-select> -->
                <!-- <b-dropdown id="ddown1" :text="selectedSurgery" variant="outline-secondary">
                    <b-dropdown-item @click="changeSelectedSurgery(item)" v-for="(item,index) in [{surgery_name:'미지정'}, ...surgeries]" :key="index">{{item.surgery_name}}</b-dropdown-item>
                </b-dropdown> -->


                <b-form-tags
                    id="tags-component-select"
                    v-model="surgeryValue"
                    size="lg"
                    class="mb-2"
                    add-on-change
                    no-outer-focus
                >
                    <template v-slot="{ tags, inputAttrs, disabled, removeTag }">
                        <ul v-if="tags.length > 0" class="list-inline d-inline-block mb-2">
                            <li v-for="tag in tags" :key="tag" class="list-inline-item">
                                <b-form-tag
                                    @remove="removeTag(tag)"
                                    :title="tag"
                                    :disabled="disabled"
                                    variant="info"
                                >{{ titleFromId(tag) }}</b-form-tag>
                            </li>
                        </ul>
                        <b-form-select
                            class="form-control"
                            v-bind="inputAttrs"
                            @change="tagInput"
                            value-field="surgery_id"
                            text-field="surgery_name"
                            :disabled="disabled || availableOptions.length === 0"
                            :options="availableOptions"
                        >
                            <template #first>
                            <option disabled value="">수술실을 선택해주세요</option>
                            </template>
                        </b-form-select>
                    </template>
                </b-form-tags>
            </div>
            <template #modal-footer="{ ok, cancel, hide }">
                <b-button variant="danger" @click="cancelSaveEvent">
                    취소
                </b-button>
                <b-button @click="saveAuth">
                    저장
                </b-button>
            </template>
        </b-modal>

        <!-- 권한 요청 모달 -->
        <b-modal v-model="authReqModal" @ok="reqAuth" title="권한 요청">
            <div style="text-align:center; color:white">
                <b-form-group label="">
                    <p>요청하는 권한을 선택해주세요.</p>
                    <b-form-radio-group
                        v-model="reqSelected"
                        :options="options"
                        name="radios-stacked"
                        stacked
                    ></b-form-radio-group><br/>
                    <p>
                        ※ 결재단계<br/>
                        - 주치의: 과장 -> 부원장 -> 원장<br/>
                        - 레지던트: 과장 -> 부원장<br/>
                        - 간호사: 과장전결
                    </p>
                </b-form-group>
            </div>
        </b-modal>

        <b-colxx xl="5" lg="6" md="12" class="mb-4">
            <product-categories-doughnut></product-categories-doughnut>
        </b-colxx>
        <b-colxx xl="7" lg="6" md="12" class="mb-4">
            <profile-statuses></profile-statuses>
        </b-colxx>
        <b-colxx xl="12" lg="12" md="12" class="mb-4" v-if="currentUser.authority <= 1">
            <piaf-breadcrumb :heading="'권한 부여'" />
            <div class="separator mb-5"></div>
            <b-card class="mb-4">
                <b-card-title>
                    <h3>검색 테이블</h3>
                    <b-input-group style="float:right;" class="mb-3">
                        <b-input-group-prepend>
                        <b-dropdown id="ddown1" :text="currentSearchType" variant="outline-secondary">
                            <b-dropdown-item @click="changeSearchType(item)" v-for="(item,index) in searchItems" :key="index">{{item}}</b-dropdown-item>
                        </b-dropdown>
                        </b-input-group-prepend>
                        <div
                        class="search"
                        ref="searchContainer"
                        @mouseenter="isSearchOver=true"
                        @mouseleave="isSearchOver=false"
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
                    </b-input-group>
                </b-card-title>
                <b-table-simple>
                    <b-tbody striped>
                        <b-tr>
                            <b-th rowspan="1">이름</b-th>
                            <b-th rowspan="1">부서</b-th>
                            <b-th rowspan="1">사원 번호</b-th>
                            <b-th rowspan="1">권한 부여</b-th>
                        </b-tr>
                        <b-tr v-for="(account,index) in this.filteredList" :key="index">
                            <template v-if="currentUser.account !== account.account">
                                <b-td rowspan="1" style="line-height:80px">{{account.name}}</b-td>
                                <b-td rowspan="1" style="line-height:80px">{{account.department}}</b-td>
                                <b-td rowspan="1" style="line-height:80px">{{account.employee_no}}</b-td>
                                <b-td rowspan="1" style="line-height:80px">
                                    <b-button variant="primary" @click="openAuthModal(account)" class="mr-3" size="sm">권한 부여</b-button>
                                </b-td>
                            </template>
                        </b-tr>
                    </b-tbody>
                </b-table-simple>
            </b-card>
        </b-colxx>
        <!-- <b-colxx xl="12" lg="12" md="12" class="mb-4">
            <piaf-breadcrumb :heading="'내 정보'" />
            <div class="separator mb-5"></div>
            <b-card class="mb-4">
                <b-table-simple>
                    <b-tbody striped>
                        <b-tr>
                            <b-th rowspan="1" style="width:10%;">사진</b-th>
                            <b-th rowspan="1">이름</b-th>
                            <b-th rowspan="1">부서</b-th>
                            <b-th rowspan="1">사원 번호</b-th>
                            <b-th rowspan="1">권한</b-th>
                            <b-th rowspan="1">권한 요청</b-th>
                        </b-tr>
                        <b-tr>
                            <b-td rowspan="1"><img style="width:50%;" class="mb-3" src="./F2002090001_전준희M_1_36.3_20210913134252.png"></b-td>
                            <b-td rowspan="1" style="line-height:80px">{{currentUser.name}}</b-td>
                            <b-td rowspan="1" style="line-height:80px">{{currentUser.department}}</b-td>
                            <b-td rowspan="1" style="line-height:80px">{{currentUser.employee_no}}</b-td>
                            <b-td rowspan="1" style="line-height:80px">{{currentUser.authority === "1" ? '주치의' :
                                currentUser.authority === "2" ? '레지던트' :
                                currentUser.authority === "0" ? '관리자' : '간호사'}}</b-td>
                            <b-td rowspan="1" style="line-height:80px">
                                <b-button variant="primary" @click="openAuthReqModal" class="mr-3" size="sm">권한 요청</b-button>
                            </b-td>
                        </b-tr>
                    </b-tbody>
                </b-table-simple>
            </b-card>
        </b-colxx> -->
    </b-row>
</template>

<script>
import ProfileStatuses from '../../../containers/dashboards/ProfileStatuses.vue'
import ProductCategoriesDoughnut from '../../../containers/dashboards/ProductCategoriesDoughnut.vue'
import api from '../../../api'
import {
    mapGetters
} from "vuex";
export default {
    components: {
        "profile-statuses": ProfileStatuses,
        "product-categories-doughnut": ProductCategoriesDoughnut,
    },
    computed: {
        ...mapGetters(["currentUser"]),
        availableOptions() {
            return this.surgeries.filter(opt => this.surgeryValue.indexOf(opt) === -1)
        },
    },
    data() {
        return {
            searchItems:[
                '이름',
                '부서',
                '사원번호'
            ],
            currentSearchType:'이름',
            searchKeyword:null,
            authModal:false,
            authReqModal:false,
            reqSelected: null,
            selected: '주치의',
            options: [
                { text: '주치의', value: '주치의' },
                { text: '레지던트', value: '레지던트' },
                { text: '간호사', value: '간호사' }
            ],
            surgeryValue: [],
            accounts:[],
            selectedAccount:null,
            filteredList:[],
            surgeries:[],
            selectedSurgery:'미지정',
            origianlSelectedSurgery:null,
        }
    },
    methods: {
        cancelSaveEvent() {
            this.authModal = false;
            this.surgeryValue = []
            this.selected = '주치의'

        },
        titleFromId(id) {
            let index = this.surgeries.findIndex(i => i.surgery_id === parseInt(id) )
            return this.surgeries[index].surgery_name
        },
        tagInput(i){
            this.surgeryValue.push(i)
        },
        changeSearchType(val) {
            this.currentSearchType = val
        },
        changeSelectedSurgery(val) {
            this.selectedSurgery = val.surgery_name
            this.origianlSelectedSurgery = val
        },
        searchClick() {
            if(this.searchKeyword === null || this.searchKeyword === '') {
                // alert("검색어를 입력해주세요.")
                this.filteredList = this.accounts;
            } else {
                let searchType
                if(this.currentSearchType === '이름')
                    searchType = 'name'
                else if(this.currentSearchType === '부서')
                    searchType = 'department'
                else
                    searchType = 'employee_no'

                this.filteredList = this.accounts.filter(i => i[searchType].indexOf(this.searchKeyword) > -1)
            }
        },
        openAuthModal(val) {
            this.authModal = true
            this.selectedAccount = val
            this.surgeryValue = val.surgery_room_auth ? JSON.parse(val.surgery_room_auth) : []
        },
        openAuthReqModal() {
            this.authReqModal = true
        },
        async saveAuth() {
            api.setAuth({
                auth:this.selected === '주치의' ? 1 :
                this.selected === '레지던트' ? 2 : 3,
                account:this.selectedAccount.account,
                surgeryAuth:this.surgeryValue.length ? JSON.stringify(this.surgeryValue) : null
            })
            alert('저장 되었습니다')
            this.authModal = false
            this.selected = null
        },
        async reqAuth() {
            api.authReq({
                reqAuth:this.reqSelected,
                account:this.currentUser.account
            })
            alert('요청이 완료 되었습니다')
            this.reqSelected = null
        }
    },
    async mounted() {
        this.accounts = await api.getAccounts()
        this.surgeries = await api.getSurgery()
        this.filteredList = this.accounts
    }
};
</script>
