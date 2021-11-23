<template>
  <div class="icon-cards-row">
    <!-- <glide-component :settings="glideIconsOption"> -->
      <b-col md="12" style="display:flex; justify-content:space-between">
        <icon-card style="width:31%" title="연결된 단말" icon="iconsminds-pulse" :value="`${activatedDevicesCount}/${devices.length}`" />
        <icon-card
          style="width:31%"
          title="수술중인 수술실"
          icon="iconsminds-loading"
          :value="`${activatedSurgeriesCount}/${surgeries.length}`"
        />
        <icon-card
          style="width:31%"
          title="오늘 일정"
          icon="iconsminds-loading-2"
          :value="`${todaySchedules.length}`"
        />
      </b-col>
      <!-- <icon-card title="평균회복시간" icon="iconsminds-first-aid" :value="'1.1hr'" /> -->
    <!-- </glide-component> -->
  </div>
</template>
<script>
import GlideComponent from "../../components/Carousel/GlideComponent";
import IconCard from "../../components/Cards/IconCard";
import api from "../../api"
import moment from 'moment'

export default {
  components: {
    "glide-component": GlideComponent,
    "icon-card": IconCard
  },
  data() {
    return {
      glideIconsOption: {
        gap: 5,
        perView: 4,
        type: "carousel",
        breakpoints: {
          320: {
            perView: 1
          },
          576: {
            perView: 2
          },
          1600: {
            perView: 3
          },
          1800: {
            perView: 4
          }
        },
        hideNav: true
      },
      devices:[],
      activatedDevicesCount:0,
      surgeries:[],
      activatedSurgeriesCount:0,
      todaySchedules:[],
    };
  },
  // methods: {

  // },
  async mounted() {
    this.surgeries = await api.getSurgery()

    let start = moment().format("YYYY-MM-DD")
    let end = moment().format("YYYY-MM-DD 23:59:59")

    this.surgeries.forEach(async (item) => {
      let temp = await api.getDevices(item)
      this.devices = this.devices.concat(temp)


      let _temp = await api.getSchedule({start,end,surgery_id:item.surgery_id,searchType:this.currentSearchType, search:''})
      this.todaySchedules = this.todaySchedules.concat(_temp)

      if(item.record)
        this.activatedSurgeriesCount++;
    })

    let temp = await api.getConnectecDevices()
    temp.data.forEach((item) => {
      if(item.clientid.indexOf('server') === -1)
        this.activatedDevicesCount++;
    })
  }
};
</script>
