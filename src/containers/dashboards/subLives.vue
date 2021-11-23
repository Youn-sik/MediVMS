<template>
  <b-row v-if="sub">
    <b-colxx xxs="6" class="mb-5" v-for="(live,index) in sub" :key="index">
        <sub-live v-if="currentSurgery !== index" :live="live" :item-class-name="index" label-prefix="$" :data="smallChartData1" />
        <div v-else class="already-displayed">
            <p>송출중...</p>
        </div>
    </b-colxx>
  </b-row>
</template>
<script>
import SubLive from "../../components/Lives/SubLive.vue";
import {
    smallChartData1,
    smallChartData2,
    smallChartData3,
    smallChartData4
} from "../../data/charts";

export default {
    props:['sub','currentSurgery','currentUser'],
    components: {
        "sub-live": SubLive
    },
    data() {
        return {
            smallChartData1,
            smallChartData2,
            smallChartData3,
            smallChartData4
        };
    },
    mounted() {
        console.log(this.currentUser)
    }
};
</script>
