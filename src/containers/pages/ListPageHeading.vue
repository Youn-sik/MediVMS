<template>
  <b-row>
    <b-colxx xxs="12">
      <h3>{{ '열람검색' }}</h3>
      <div class="top-right-button-container">
        <b-button-group>
        </b-button-group>
      </div>
      <add-new-modal :categories="categories" :statuses="statuses"></add-new-modal>
      <piaf-breadcrumb />
      <div class="mb-2 mt-2">
        <b-button
          variant="empty"
          class="pt-0 pl-0 d-inline-block d-md-none"
          v-b-toggle.displayOptions
        >
          {{ $t('pages.display-options') }}
          <i class="simple-icon-arrow-down align-middle" />
        </b-button>
        <b-collapse class="d-md-block">
          <div class="d-block d-md-inline-block pt-1" style="width:100%;">
            <b-table-simple>
              <b-tbody striped>
                <b-tr>
                  <b-th rowspan="1">수술 기간</b-th>
                  <b-td rowspan="1">
                    <b-row class="mb-0">
                      <b-colxx xxs="12">
                        <datepicker
                          :language="ko"
                          format="yyyy년 MMM dd일"
                          :bootstrap-styling="true"
                          :value="startDate"
                          placeholder="날짜 선택"
                          @selected="selectStartData"
                          wrapper-class="surgery-date-picker"
                        ></datepicker>&nbsp;&nbsp;~&nbsp;
                        <datepicker
                          :language="ko"
                          format="yyyy년 MMM dd일"
                          :bootstrap-styling="true"
                          :value="endDate"
                          placeholder="날짜 선택"
                          @selected="selectEndData"
                          wrapper-class="surgery-date-picker"
                        ></datepicker>

                        <b-button variant="primary" @click="today" class="ml-3 mr-3">오늘</b-button>
                        <b-button variant="primary" @click="aWeek" class="mr-3">일주일</b-button>
                        <b-button variant="primary" @click="aMonth" class="mr-3">한달</b-button>
                        <b-button variant="primary" @click="twoMonth" class="mr-3">두달</b-button>
                      </b-colxx>
                    </b-row>
                  </b-td>
                </b-tr>
                <b-tr>
                  <b-th rowspan="1">처리 상태</b-th>
                  <b-td rowspan="1">
                    <b-form-group v-slot="{ ariaDescribedby }">
                      <b-form-radio-group
                        :aria-describedby="ariaDescribedby"
                        v-model="processStatus"
                      >
                        <template v-for="(item,index) in processingStatuses">
                            <b-form-radio :key="index" @change="changeRadio" :value="index">{{item}}</b-form-radio>
                        </template>
                      </b-form-radio-group>
                    </b-form-group>
                  </b-td>
                </b-tr>
                <b-tr>
                  <b-th rowspan="1">검색 구분</b-th>
                  <b-td rowspan="1">
                    <b-colxx xxs="12" class="pl-0">
                      <b-input-group class="mb-0">
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
                            @keypress.native.enter="searchClick(searchKeyword)"
                            v-model="searchKeyword"
                          />
                          <span class="search-icon" @click="searchClick(searchKeyword)">
                            <i class="simple-icon-magnifier"></i>
                          </span>
                        </div>
                      </b-input-group>
                    </b-colxx>
                  </b-td>
                </b-tr>
              </b-tbody>
            </b-table-simple>
          </div>
        </b-collapse>
      </div>
      <div class="separator mb-5" />
    </b-colxx>
  </b-row>
</template>
<script>
import {
  DataListIcon,
  ThumbListIcon,
  ImageListIcon
} from "../../components/Svg";
import AddNewModal from "./AddNewModal";
import Datepicker from "vuejs-datepicker";
import {ko} from 'vuejs-datepicker/dist/locale'

export default {
  components: {
    "data-list-icon": DataListIcon,
    "thumb-list-icon": ThumbListIcon,
    "image-list-icon": ImageListIcon,
    "add-new-modal": AddNewModal,
    datepicker: Datepicker
  },
  mounted() {

  },
  props: [
    'changeSearchType',
    'currentSearchType',
    "title",
    "sort",
    "perPage",
    "startDate",
    "endDate",
    "today",
    "aWeek",
    "aMonth",
    "twoMonth",
    "selectStartData",
    "selectEndData",
    "searchClick",
    "changeRadio"
  ],
  data() {
    return {
      processStatus:0,
      processingStatuses:[
        '전체',
        '수술 완료',
        '수술 취소',
        '입원',
        '퇴원'
      ],
      isSearchOver:true,
      searchKeyword:null,
      ko:ko,
      // startDate:null,
      // endDate:null,
      categories: [
        {
          label: "Cakes",
          value: "Cakes"
        },
        {
          label: "Cupcakes",
          value: "Cupcakes"
        },
        {
          label: "Desserts",
          value: "Desserts"
        }
      ],
      statuses: [
        {
          text: "ON HOLD",
          value: "ON HOLD"
        },
        {
          text: "PROCESSED",
          value: "PROCESSED"
        }
      ],
      sortOptions: [
        {
          column: "title",
          label: "Product Name"
        },
        {
          column: "category",
          label: "Category"
        },
        {
          column: "status",
          label: "Status"
        }
      ],
      searchItems: [
        '주치의',
        '환자명',
        '수술실',
        '진료과'
      ]
    };
  },
  methods:{
    search() {

    },
  }
};
</script>
