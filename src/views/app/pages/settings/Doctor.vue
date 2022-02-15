<template>
<div>
  <!-- 의사 추가 모달 -->
  <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="addModal" size="lg" title="의사 추가">
      <b-form-group
          id="input-group-1"
          label="이름:"
          label-for="input-1"
      >
          <b-form-input
          id="input-1"
          v-model="form.name"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="진료과:"
          label-for="input-1"
      >
          <b-form-input
          id="input-2"
          v-model="form.department"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="직급:"
          label-for="input-1"
      >
          <b-form-input
          id="input-3"
          v-model="form.rank"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="사번:"
          label-for="input-1"
      >
          <b-form-input
          id="input-3"
          v-model="form.employee_id"
          required
          ></b-form-input>
      </b-form-group>

    <template #modal-footer="{ ok, cancel, hide }">
      <b-button variant="danger" @click="cancelAdd">
        취소
      </b-button>
      <b-button @click="addDoctor">
        저장
      </b-button>
    </template>
  </b-modal>

    <!-- 의사 수정 모달 -->
  <b-modal :hide-header-close="true" :no-close-on-backdrop="true" :no-close-on-esc="true" :no-enforce-focus="true" v-model="modModal" size="lg" title="의사 추가">
      <b-form-group
          id="input-group-1"
          label="이름:"
          label-for="input-1"
      >
          <b-form-input
          id="input-1"
          v-model="form.name"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="진료과:"
          label-for="input-1"
      >
          <b-form-input
          id="input-2"
          v-model="form.department"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="직급:"
          label-for="input-1"
      >
          <b-form-input
          id="input-3"
          v-model="form.rank"
          required
          ></b-form-input>
      </b-form-group>

      <b-form-group
          id="input-group-1"
          label="사번:"
          label-for="input-1"
      >
          <b-form-input
          id="input-3"
          v-model="form.employee_id"
          required
          ></b-form-input>
      </b-form-group>

    <template #modal-footer="{ ok, cancel, hide }">
      <b-button variant="danger" @click="cancelAdd">
        취소
      </b-button>
      <b-button @click="modDoctor">
        저장
      </b-button>
    </template>
  </b-modal>

  <b-row>
    <b-colxx xxs="12">
      <piaf-breadcrumb :heading="'의사 목록'"/>
      <div class="separator mb-5"></div>
    </b-colxx>
  </b-row>
  <b-row>
    <b-colxx xxs="12">
      <b-card class="mb-4">
        <b-button variant="outline-secondary" class="mr-3" style="float:right" @click="deleteDoctor">삭제</b-button>
        <b-button variant="outline-secondary" class="mr-3" style="float:right" @click="openModModal">수정</b-button>
        <b-button variant="outline-secondary" class="mr-3" style="float:right" @click="()=>{addModal=true}">추가</b-button>
        <b-dropdown id="ddown1" :text="String(perPage)" class="mr-3" variant="outline-secondary" style="float:right">
            <b-dropdown-item @click="changePerPage(item)" v-for="(item,index) in perPageList" :key="index">{{item}}</b-dropdown-item>
        </b-dropdown>
        <vuetable
            ref="vuetable"
            :api-mode="false"
            :data="items"
            :fields="vuetableItems.fields"
            :per-page="perPage"
            pagination-path
            @vuetable:pagination-data="onPaginationData"
          ></vuetable>
          <vuetable-pagination-bootstrap
            ref="pagination"
            @vuetable-pagination:change-page="onChangePage"
          ></vuetable-pagination-bootstrap>
      </b-card>
    </b-colxx>
  </b-row>
  </div>
</template>
<script>
import Vuetable from 'vuetable-2/src/components/Vuetable'
import VuetablePaginationBootstrap from '../../../../components/Common/VuetablePaginationBootstrap'
import api from '../../../../api'

export default {
  mounted() {
    this.getItems()
  },
  components: {
    'vuetable' : Vuetable,
    'vuetable-pagination-bootstrap' : VuetablePaginationBootstrap
  },
  data () {
    return {
      perPageList:[7,10,30,50,100],
      vuetableItems: {
        fields: [
          {
            name: '__checkbox',
            titleClass: 'center aligned',
            dataClass: 'center aligned'
          },
          {
            name: 'name',
            sortField: 'name',
            title: '이름',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
          {
            name: 'department',
            sortField: 'department',
            title: '진료과',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
          {
            name: 'rank',
            sortField: 'rank',
            title: '직급',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
          {
            name: 'employee_id',
            sortField: 'employee_id',
            title: '사번',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
        ]
      },
      page: 1,
      perPage: 7,
      totalRows: 0,
      items : [],
      search:'',
      searchType:'',
      sort:'id',
      sortType:'desc',
      addModal:false,
      modModal:false,

      form: {
        name:'',
        department:'',
        rank:'',
        employee_id:'',
      }
    }
  },
  methods: {
    async addDoctor() {
      await api.addDoctors(this.form)
      await this.getItems()

      this.addModal = false

      this.form = {
        name:'',
        department:'',
        rank:'',
        employee_id:'',
      }
    },


    async modDoctor() {
      await api.updateDoctors(this.form)
      await this.getItems()


      this.modModal = false

      this.form = {
        name:'',
        department:'',
        rank:'',
        employee_id:'',
      }
    },

    async deleteDoctor() {
      await api.deleteDoctors({doctors:this.$refs.vuetable.selectedTo})
      await this.getItems()
    },

    cancelAdd() {
      this.form = {
        name:'',
        department:'',
        rank:'',
        employee_id:'',
      },
      this.addModal = false
      this.modModal = false
    },

    openModModal() {
      if(this.$refs.vuetable.selectedTo.length === 1) {
        let index = this.items.findIndex((e) => e.id === this.$refs.vuetable.selectedTo[0])
        this.form = JSON.parse(JSON.stringify(this.items[index]))

        this.modModal = true;
      } else {
        alert("1개의 단말만 선택해 주세요.")
      }

    },

    // perpage 바꿨을때 이벤트
    changePerPage(val) {
      if(this.perPage !== val) {
        this.perPage = val
        // this.page = 1

        // this.getRecords()
        setTimeout(() => {
          this.$refs.vuetable.refresh()
        },0)
      }
    },

    async getItems() {
      let result = await api.getDoctors({
        page : this.page,
        perPage : this.perPage,
        search : this.search,
        searchType : this.searchType,
        sort : this.sort,
        sortType : this.sortType
      })

      this.items = result
    },

    onPaginationData (paginationData) {
      this.$refs.pagination.setPaginationData(paginationData)
    },
    onChangePage (page) {
      this.$refs.vuetable.changePage(page)
    },
    apiParamsConverter (params) {
      let apiParams = {}
      if (params.perPage !== 0) {
        apiParams.per_page = params.perPage
      }
      if (params.page >= 1) {
        apiParams.page = params.page
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
