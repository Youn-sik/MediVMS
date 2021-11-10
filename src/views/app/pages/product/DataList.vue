<template>
  <b-row>
    <b-colxx class="disable-text-selection">
      <list-page-heading
        :title="$t('menu.data-list')"
        :isAnyItemSelected="isAnyItemSelected"
        :keymap="keymap"
        :displayMode="displayMode"
        :changeDisplayMode="changeDisplayMode"
        :changeOrderBy="changeOrderBy"
        :changePageSize="changePageSize"
        :sort="sort"
        :searchChange="searchChange"
        :from="from"
        :to="to"
        :total="total"
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
        :currentProcessingStatus="currentProcessingStatus"
        :currentSearchType="currentSearchType"
        :changeSearchType="changeSearchType"
      ></list-page-heading>
      <template v-if="isLoad">
        <list-page-listing
          :displayMode="displayMode"
          :selectAll="selectAll"
          :isSelectedAll="isSelectedAll"
          :items="filteredItems"
          :selectedItems="selectedItems"
          :toggleItem="toggleItem"
          :lastPage="lastPage"
          :perPage="perPage"
          :page="page"
          :changePage="changePage"
          :handleContextMenu="handleContextMenu"
          :onContextMenuAction="onContextMenuAction"
        ></list-page-listing>
      </template>
      <template v-else>
        <div class="loading"></div>
      </template>
    </b-colxx>
  </b-row>
</template>

<script>
import api from '../../../../api'
import ListPageHeading from "../../../../containers/pages/ListPageHeading";
import ListPageListing from "../../../../containers/pages/ListPageListing";

export default {
  components: {
    "list-page-heading": ListPageHeading,
    "list-page-listing": ListPageListing
  },
  data() {
    return {
      isLoad: false,
      displayMode: "list",
      sort: {
        column: "title",
        label: "Product Name"
      },
      page: 1,
      perPage: 4,
      search: "",
      from: 0,
      to: 0,
      total: 0,
      lastPage: 0,
      startDate:null,
      endDate:null,
      currentProcessingStatus:0,
      items: [
        // {
        //   head: false,
        //   date:'2021-09-09 11:53:05',
        //   surgeryNo: '수술실 #1',
        //   department: '외과',
        //   doctor: '전준희',
        //   surgeryDetails: '갑상선암',
        //   patientDischarge: '퇴원',
        //   browseAuth: '열람 가능',
        //   videoLink: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4'
        // },
        // {
        //   head: false,
        //   date:'2021-09-09 15:23:15',
        //   surgeryNo: '수술실 #2',
        //   department: '외과',
        //   doctor: '전준희2',
        //   surgeryDetails: '갑상선암',
        //   patientDischarge: '퇴원',
        //   browseAuth: '열람 가능',
        //   videoLink: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'
        // },
        // {
        //   head: false,
        //   date:'2021-09-10 11:53:05',
        //   surgeryNo: '수술실 #3',
        //   department: '외과',
        //   doctor: '전준희3',
        //   surgeryDetails: '갑상선암',
        //   patientDischarge: '퇴원',
        //   browseAuth: '열람 가능',
        //   videoLink: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4'
        // }
      ],
      filteredItems:[],
      selectedItems: [],
      currentSearchType:'주치의',
      searchItems: [
        '주치의',
        // '환자명',
        '수술실',
        '진료과'
      ]
    };
  },
  methods: {
    changeSearchType(item) {
      this.currentSearchType = item
    },
    loadItems() {
      this.isLoad = true;
    },

    changeDisplayMode(displayType) {
      this.displayMode = displayType;
    },
    changePageSize(perPage) {
      this.page = 1;
      this.perPage = perPage;
    },
    changeOrderBy(sort) {
      this.sort = sort;
    },
    searchChange(val) {
      this.search = val;
      this.page = 1;
    },

    selectAll(isToggle) {
      if (this.selectedItems.length >= this.filteredItems.length) {
        if (isToggle) this.selectedItems = [];
      } else {
        this.selectedItems = this.filteredItems.map(x => x.id);
      }
    },
    keymap(event) {
      switch (event.srcKey) {
        case "select":
          this.selectAll(false);
          break;
        case "undo":
          this.selectedItems = [];
          break;
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
          this.selectedItems = this.selectedItems.filter(x => x !== itemId);
        } else this.selectedItems.push(itemId);
      }
    },
    handleContextMenu(vnode) {
      if (!this.selectedItems.includes(vnode.key)) {
        this.selectedItems = [vnode.key];
      }
    },
    onContextMenuAction(action) {
      console.log(
        "context menu item clicked - " + action + ": ",
        this.selectedItems
      );
    },
    changePage(pageNum) {
      this.page = pageNum;
    },
    today() {
      this.startDate = new Date()
      this.endDate = new Date()
    },
    aWeek() {
      const today = new Date()

      const aWeekAgo = today.setDate(today.getDate() - 7)

      this.startDate = aWeekAgo;
      this.endDate = new Date();
    },
    aMonth() {
      const today = new Date()

      const aMonthAgo = today.setMonth(today.getMonth() - 1)

      this.startDate = aMonthAgo;
      this.endDate = new Date();
    },
    twoMonth() {
      const today = new Date()

      const twoMonthAgo = today.setMonth(today.getMonth() - 2)

      this.startDate = twoMonthAgo;
      this.endDate = new Date();
    },
    selectStartData(val) {
      this.startDate = val
    },
    selectEndData(val) {
      this.endDate = val
    },
    searchClick() {
      console.log("test")
      if(this.startDate === null || this.endDate === null) {
        alert("날짜를 선택해주세요")
      } else {
        let currentRadio = this.currentProcessingStatus === 0 ? '전체' :
        this.currentProcessingStatus === 1 ? '수술 완료' :
        this.currentProcessingStatus === 2 ? '수술 취소' :
        this.currentProcessingStatus === 3 ? '입원' : '퇴원'

        let searchType = this.currentSearchType === '주치의' ? 'doctor' :
        this.currentSearchType === '수술실' ? 'surgery_name' : 'department'

        let temp = this.items.filter((i) => {
          if(currentRadio === '전체') {
            if(new Date(this.startDate) <= new Date(i.date.split(' ')[0]) && new Date(this.endDate) >= new Date(i.date.split(' ')[0])) {
              return i[searchType].indexOf(this.search) > -1
            }
          }
          else {
            if(currentRadio === i.patient_status){
              if(new Date(this.startDate) <= new Date(i.date.split(' ')[0]) && new Date(this.endDate) >= new Date(i.date.split(' ')[0])) {
                return i[searchType].indexOf(this.search) > -1
              }
            }
          }
        })

        this.filteredItems = temp
      }
    },
    changeRadio(val){
      this.currentProcessingStatus = val
    }

  },
  computed: {
    isSelectedAll() {
      console.log(this.selectedItems.length >= this.filteredItems.length)
      return this.selectedItems.length >= this.filteredItems.length;
    },
    isAnyItemSelected() {
      return (
        this.selectedItems.length > 0 &&
        this.selectedItems.length < this.filteredItems.length
      );
    },
  },
  watch: {
    search() {
      this.page = 1;
    },
  },
  async mounted() {
    this.loadItems();
    this.items = await api.getRecords()
    this.filteredItems = this.items
    console.log(this.filteredItems)
  }
};
</script>
