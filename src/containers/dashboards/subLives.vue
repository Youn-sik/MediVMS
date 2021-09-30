<template>
  <b-row v-if="sub">
    <b-colxx xxs="6" class="mb-5" v-for="(live,index) in sub" :key="index">
        <div v-if="currentUser.authority > 1" class="already-displayed mb-5 pb-5">
            <p class="mb-5 pb-5">시청 권한이 없습니다.</p>
        </div>
        <sub-live v-else-if="currentSurgery !== index" :live="live" :item-class-name="index" label-prefix="$" :data="smallChartData1" />
        <div v-else class="already-displayed">
            <p>송출중...</p>
        </div>
    </b-colxx>
    <!-- <b-colxx xxs="6" class="mb-5">
        <sub-live :class="itemClass" label-prefix="$" :data="smallChartData2" />
    </b-colxx>
    <b-colxx xxs="6" class="mb-5">
        <sub-live :class="itemClass" label-prefix="$" :data="smallChartData3" />
    </b-colxx>
    <b-colxx xxs="6" class="mb-5">
        <sub-live :class="itemClass" label-prefix="$" :data="smallChartData4" />
    </b-colxx> -->
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
