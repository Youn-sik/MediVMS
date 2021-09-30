<template>
  <b-card>
    <b-card-title>
      최근 열람 현황
      <b-dropdown id="statusDropdown" :text="currentMonth + '개월 이내'" variant="outline-secondary">
        <b-dropdown-item @click="changeMonth(item)" v-for="(item,index) in month" :key="index">{{item}}개월 이내</b-dropdown-item>
      </b-dropdown>
    </b-card-title>
    <div v-for="(s,index) in profileStatuses[getCurrentMonth]" :key="index" class="mb-5">
      <p class="mb-3">
        {{ s.title }}
        <span class="float-right text-muted">{{s.status}}/{{s.total}}</span>
      </p>
      <b-progress :value="(s.status / s.total) * 100"></b-progress>
    </div>
  </b-card>
</template>
<script>
import profileStatuses from "../../data/profileStatuses";

export default {
  data() {
    return {
      profileStatuses,
      currentMonth:1,
      month:[
        1,
        3,
        6
      ]
    };
  },
  computed:{
    getCurrentMonth: function() {
      return this.currentMonth
    }
  },
  methods:{
    changeMonth(val) {
      this.currentMonth = val
    },
  }
};
</script>
