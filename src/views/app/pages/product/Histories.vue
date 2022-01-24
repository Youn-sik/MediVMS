<template>
<div>
  <b-row>
    <b-colxx xxs="12">
      <piaf-breadcrumb :heading=" $route.name === 'browse' ? '열람 기록' :
      $route.name === 'takeout' ? '반출 기록' : ''"/>
      <div class="separator mb-5"></div>
    </b-colxx>
  </b-row>
  <b-row>
    <b-colxx xxs="12">
      <b-card class="mb-4">
        <b-dropdown id="ddown1" :text="perPage" variant="outline-secondary" style="float:right">
            <b-dropdown-item @click="changePerPage(item)" v-for="(item,index) in perPageList" :key="index">{{item}}</b-dropdown-item>
        </b-dropdown>
        <vuetable
            ref="vuetable"
            :api-url="vuetableItems.apiUrl + `?type=${$route.name}`"
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
import {base_url} from "../../../../server.json"
export default {
  components: {
    'vuetable' : Vuetable,
    'vuetable-pagination-bootstrap' : VuetablePaginationBootstrap
  },
  data () {
    return {
      perPageList:[7,10,30,50,100],
      vuetableItems: {
        apiUrl: `https://${base_url}:3000/history`,
        fields: [
          {
            name: 'created_at',
            sortField: 'created_at',
            title: '열람 날짜',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
          {
            name: 'name',
            sortField: 'name',
            title: '열람자',
            titleClass: '',
            dataClass: 'list-item-heading'
          },
          {
            name: 'account',
            sortField: 'account',
            title: '열람 계정',
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
          }
        ]
      },
      currentPage: 1,
      perPage: 7,
      totalRows: 0,
    }
  },
  methods: {
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
