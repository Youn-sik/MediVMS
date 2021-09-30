<template>
  <div>
    <b-row>
      <b-colxx xxs="12">
        <piaf-breadcrumb :heading="'전체'" />
        <!-- <b-form-checkbox @change="mosaicToggle" style="float:right; margin-top:10px;" v-model="mosaicChecked" name="check-button" switch>
          모자이크
        </b-form-checkbox> -->
        <div class="separator mb-5"></div>
      </b-colxx>
    </b-row>
    <b-row>
      <b-colxx xl="6" lg="12">
        <icon-cards-carousel></icon-cards-carousel>
        <b-row>
          <b-colxx md="12" class="mb-4">
            <main-live :mainlive="main" :current-user="currentUser"></main-live>
          </b-colxx>
        </b-row>
      </b-colxx>
      <b-colxx lg="12" xl="6" class="mb-0">
        <sub-lives :sub="sub" :current-surgery="currentSurgery" :current-user="currentUser"></sub-lives>
      </b-colxx>
    </b-row>
    <b-row>
      <b-colxx xxs="12">
        <div class="move-video-buttons" v-if="main">
          <b-button :disabled="currentSurgery === 0" class="mb-1" @click="prevSurgery" variant="primary"><</b-button>
          <h2 style="display:inline"><b-badge class="mb-1" pill variant="primary">[ {{ main.surgery_name }} ]</b-badge></h2>
          <b-button :disabled="currentSurgery === surgeries.length-1" @click="nextSurgery" class="mb-1" variant="primary">></b-button>
        </div>
      </b-colxx>
    </b-row>
    <!-- <b-row>
      <b-colxx xxs="12">
        <piaf-breadcrumb :heading="'수술실 정보'" />
        <div class="separator mb-5"></div>
      </b-colxx>
    </b-row>
    <b-row>
      <b-colxx lg="12" md="12" class="mb-5">
        <b-card class="mb-5">
          <p>수술실 정보</p>
          <b-table-simple>
            <b-tbody striped>
                <b-tr>
                  <b-th rowspan="1" style="width:20%">수술실</b-th>
                  <b-th rowspan="1" style="width:20%">시작 시간</b-th>
                  <b-th rowspan="1" style="width:20%">온도</b-th>
                  <b-th rowspan="1" style="width:20%">습도</b-th>
                  <b-th rowspan="1" style="width:20%">수술 시간</b-th>
                </b-tr>
                <b-tr>
                  <b-td rowspan="1">수술실 #1</b-td>
                  <b-td rowspan="1">2021-09-13 11:17:55</b-td>
                  <b-td rowspan="1">27℃</b-td>
                  <b-td rowspan="1">40%</b-td>
                  <b-td rowspan="1">04:00</b-td>
                </b-tr>
            </b-tbody>
          </b-table-simple>
        </b-card>

        <b-card>
          <p>환자 정보</p>
          <b-table-simple>
            <b-tbody striped>
                <b-tr>
                  <b-th rowspan="1" style="width:20%">진료 번호</b-th>
                  <b-th rowspan="1" style="width:20%">이름</b-th>
                  <b-th rowspan="1" style="width:20%">성별</b-th>
                  <b-th rowspan="1" style="width:20%">나이</b-th>
                  <b-th rowspan="1" style="width:20%">진단명</b-th>
                </b-tr>
                <b-tr>
                  <b-td rowspan="1">1</b-td>
                  <b-td rowspan="1">유한나</b-td>
                  <b-td rowspan="1">여</b-td>
                  <b-td rowspan="1">42</b-td>
                  <b-td rowspan="1">골절</b-td>
                </b-tr>
            </b-tbody>
          </b-table-simple>
        </b-card>
      </b-colxx>
    </b-row>
    <b-row>
      <b-colxx xl="6" lg="12" class="mb-4">
        <piaf-breadcrumb :heading="'수술 화면'" />
        <div class="separator mb-5"></div>
        <VideoPlayer
          v-if="currentUser.authority <= 1"
          license-server="https://widevine-proxy.appspot.com/proxy"
          :manifest-url="'https://st2.depositphotos.com/8810948/12391/v/600/depositphotos_123919252-stock-video-hands-beautician-makes-procedure-patient.mp4'"
          poster-url=""
        />
        <div v-else style="width:100%; height:100%; text-align:center; line-height:544px;">
            시청 권한이 없습니다.
        </div>
      </b-colxx>
      <b-colxx xl="6" lg="12" class="mb-4">
        <piaf-breadcrumb :heading="'Vital Sign'" />
        <div class="separator mb-5"></div>
        <VideoPlayer
          v-if="currentUser.authority <= 1"
          license-server="https://widevine-proxy.appspot.com/proxy"
          :manifest-url="'https://ak.picdn.net/shutterstock/videos/20286253/preview/stock-footage-monitoring-of-patient-s-condition-vital-signs-on-icu-monitor-in-hospital-medical-icu-monitor-with.webm'"
          poster-url=""
        />
        <div v-else style="width:100%; height:100%; text-align:center; line-height:544px;">
            시청 권한이 없습니다.
        </div>
      </b-colxx>
    </b-row> -->
  </div>
</template>

<script>
import GradientCard from "../../../components/Cards/GradientCard";
import GradientWithRadialProgressCard from "../../../components/Cards/GradientWithRadialProgressCard";
import AdvancedSearch from "../../../containers/dashboards/AdvancedSearch";
import BestSellers from "../../../containers/dashboards/BestSellers";
import Cakes from "../../../containers/dashboards/Cakes";
import Calendar from "../../../containers/dashboards/Calendar";
import ConversionRatesChartCard from "../../../containers/dashboards/ConversionRatesChartCard";
import IconCardsCarousel from "../../../containers/dashboards/IconCardsCarousel";
import Logs from "../../../containers/dashboards/Logs";
import Tickets from "../../../containers/dashboards/Tickets";
import ProductCategoriesPolarArea from "../../../containers/dashboards/ProductCategoriesPolarArea";
import ProfileStatuses from "../../../containers/dashboards/ProfileStatuses";
import subLives from "../../../containers/dashboards/subLives";
import SalesChartCard from "../../../containers/dashboards/SalesChartCard";
import SmallLineCharts from "../../../containers/dashboards/SmallLineCharts";
import SortableStaticticsRow from "../../../containers/dashboards/SortableStaticticsRow";
import TopRatedItems from "../../../containers/dashboards/TopRatedItems";
import WebsiteVisitsChartCard from "../../../containers/dashboards/WebsiteVisitsChartCard";
import mainLive from "../../../containers/dashboards/mainLive";
import api from "../../../api"
import VideoPlayer from '../../../components/Shaka/VideoPlayer.vue'
import {
    mapGetters
} from "vuex";
export default {
  components: {
    VideoPlayer,
    "advanced-search": AdvancedSearch,
    "best-sellers": BestSellers,
    cakes: Cakes,
    calendar: Calendar,
    "converconversion-rates-chart-card": ConversionRatesChartCard,
    "icon-cards-carousel": IconCardsCarousel,
    logs: Logs,
    tickets: Tickets,
    "product-categories-polar-area": ProductCategoriesPolarArea,
    "profile-statuses": ProfileStatuses,
    "sub-lives": subLives,
    "sales-chart-card": SalesChartCard,
    "small-line-charts": SmallLineCharts,
    "sortable-statictics-row": SortableStaticticsRow,
    "top-rated-items": TopRatedItems,
    "website-visit-chart-card": WebsiteVisitsChartCard,
    "gradient-card": GradientCard,
    "gradient-with-radial-progress-card": GradientWithRadialProgressCard,
    "main-live":mainLive
  },
  computed: {
    ...mapGetters(["currentUser", "processing", "loginError"])
  },
  data () {
    return {
      surgeries : [],
      main : null,
      sub : null,
      currentSurgery:0,
      mosaicChecked:true
    }
  },

  async beforeCreate () {
    let result = await api.getSurgery()
    this.surgeries = result
    let temp = JSON.parse(JSON.stringify(result[0]))
    temp.device_names = temp.device_names.split(',')
    temp.live_urls = temp.live_urls.split(',')
    temp.devices = temp.devices.split(',')
    temp.isLives = temp.isLives.split(',')

    this.main = temp

    this.sub = result;
  },

  methods: {
    nextSurgery() {
      this.currentSurgery++
      this.changeVideo()
    },
    prevSurgery() {
      this.currentSurgery--
      this.changeVideo()
    },
    changeVideo() {
      let temp = JSON.parse(JSON.stringify(this.surgeries[this.currentSurgery]))
      temp.device_names = temp.device_names.split(',')
      temp.live_urls = temp.live_urls.split(',')
      temp.devices = temp.devices.split(',')
      temp.isLives = temp.isLives.split(',')
      this.main = temp
    },
    mosaicToggle(val) {
      console.log(val);
    }
  }
};
</script>
