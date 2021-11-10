<template>
  <div>
    <b-row key="list">
      <b-colxx xxs="12" class="mb-3">
        <data-list-item
          :data="{
            head: true,
            date: '일시',
            sergery_name: '수술실 번호',
            department: '진료과',
            doctor: '주치의',
            surgery_desc: '수술 내용',
            patient_status: '환자 상태',
            browseAuth: '열람 가능 여부',
            browse:'열람'
          }"
          :selectAll="selectAll"
          :isSelectedAll="isSelectedAll"
          :selected-items="selectedItems"
          :toggleItem="toggleItem"
        />
      </b-colxx>
      <b-colxx xxs="12" class="mb-3" v-for="(item,index) in items" :key="index" :id="item.id">
        <data-list-item
          :key="item.id"
          :data="{...item, head:false}"
          :selected-items="selectedItems"
          :toggleItem="toggleItem"
        />
      </b-colxx>
    </b-row>
    <b-row v-if="lastPage>1">
      <b-colxx xxs="12">
        <b-pagination-nav
          :number-of-pages="lastPage"
          :link-gen="linkGen"
          :value="page"
          @change="(a)=>changePage(a)"
          :per-page="perPage"
          align="center"
        >
          <template v-slot:next-text>
            <i class="simple-icon-arrow-right" />
          </template>
          <template v-slot:prev-text>
            <i class="simple-icon-arrow-left" />
          </template>
          <template v-slot:first-text>
            <i class="simple-icon-control-start" />
          </template>
          <template v-slot:last-text>
            <i class="simple-icon-control-end" />
          </template>
        </b-pagination-nav>
      </b-colxx>
    </b-row>
  </div>
</template>
<script>
import ImageListItem from "../../components/Listing/ImageListItem";
import ThumbListItem from "../../components/Listing/ThumbListItem";
import DataListItem from "../../components/Listing/DataListItem";
export default {
  components: {
    "image-list-item": ImageListItem,
    "thumb-list-item": ThumbListItem,
    "data-list-item": DataListItem
  },
  props: [
    "displayMode",
    "items",
    "selectedItems",
    "selectAll",
    "isSelectedAll",
    "toggleItem",
    "lastPage",
    "perPage",
    "page",
    "changePage",
    "handleContextMenu",
    "onContextMenuAction"
  ],
  methods: {
    linkGen(pageNum) {
      return "#page-" + pageNum;
    }
  }
};
</script>
