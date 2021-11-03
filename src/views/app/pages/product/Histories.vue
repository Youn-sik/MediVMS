<template>
<div>
  <b-row>
    <b-colxx xxs="12">
      <piaf-breadcrumb heading="열람 기록"/>
      <div class="separator mb-5"></div>
    </b-colxx>
  </b-row>
  <b-row>
    <b-colxx xxs="12">
      <b-card class="mb-4">
        <vuetable
            ref="vuetable"
            :api-url="vuetableItems.apiUrl"
            :fields="vuetableItems.fields"
            :per-page="7"
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

export default {
  components: {
    'vuetable' : Vuetable,
    'vuetable-pagination-bootstrap' : VuetablePaginationBootstrap
  },
  data () {
    return {
      vuetableItems: {
        apiUrl: 'http://localhost:3000/history',
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
      perPage: 5,
      totalRows: 0,
    }
  },
  methods: {
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
