<template>
<b-card v-if="videoData" :class="{'d-flex flex-row':true,'active' : selectedItems.includes(data.id)}" no-body>
    <!-- 열람 modal -->
    <b-modal v-if="!videoData.head" size="lg" v-model="modalShow" title="데이터 열람">
         <b-table-simple>
            <b-tbody striped>
                <b-tr>
                    <b-th rowspan="1">일시</b-th>
                    <b-th rowspan="1">수술실</b-th>
                    <b-th rowspan="1">진료과</b-th>
                    <b-th rowspan="1">주치의</b-th>
                    <b-th rowspan="1">수술 내용</b-th>
                    <b-th rowspan="1">환자 상태</b-th>
                </b-tr>
                <b-tr>
                    <b-td rowspan="1">{{videoData.date}}</b-td>
                    <b-td rowspan="1">{{videoData.sergery_name}}</b-td>
                    <b-td rowspan="1">{{videoData.department}}</b-td>
                    <b-td rowspan="1">{{videoData.doctor}}</b-td>
                    <b-td rowspan="1">{{videoData.surgery_desc}}</b-td>
                    <b-td rowspan="1">{{videoData.patient_status}}</b-td>
                </b-tr>
            </b-tbody>
        </b-table-simple>
        <div style="width:744px; height:415px;">
            <VideoPlayer
                :isHistory="true"
                :manifest-url="videoLink"
            ></VideoPlayer>
        </div>
        <div class="move-video-buttons">
          <b-button :disabled="currentSurgery === 0" class="mb-1" @click="prevSurgery" variant="primary"><</b-button>
          <h2 style="display:inline"><b-badge class="mb-1" pill variant="primary">[ {{ currentSurgery+1 }}번 카메라 ]</b-badge></h2>
          <b-button :disabled="currentSurgery === 3" @click="nextSurgery" class="mb-1" variant="primary">></b-button>
        </div>
    </b-modal>

    <div class="pl-2 d-flex flex-grow-1 min-width-zero">
        <div class="custom-control custom-checkbox pl-1 align-self-center pr-4">
            <b-form-checkbox v-if="videoData.head" :checked="isSelectedAll" @change="selectAll(true)" class="itemCheck mb-0" />
            <b-form-checkbox v-else :checked="selectedItems.includes(videoData.id)" @change="toggleItem(videoData.id)" class="itemCheck mb-0" />
        </div>
        <div class="card-body align-self-center d-flex flex-column flex-lg-row justify-content-between min-width-zero align-items-lg-center">
            <p class="mb-0 w-15 w-sm-100">{{videoData.date}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.sergery_name}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.department}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.doctor}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.surgery_desc}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.patient_status}}</p>
            <p v-if="videoData.date === '일시'" class="mb-0 w-15 w-sm-100">{{'열람 가능 여부'}}</p>
            <p v-else class="mb-0 w-15 w-sm-100">{{currentUser.authority &lt; 2 ? '열람 가능' : '열람 불가'}}</p>
            <p v-if="videoData.date === '일시'" class="mb-0 w-15 w-sm-100">{{'열람'}}</p>
            <p v-else class="mb-0 w-15 w-sm-100">
                <b-button :disabled="currentUser.authority >= 2" @click="openModal(videoData)" variant="primary">열람</b-button>
            </p>
        </div>
    </div>
</b-card>
</template>

<script>
import VideoPlayer from '../../components/Shaka/VideoPlayer.vue'
import {base_url} from "../../server.json"
import api from "../../api"
import {
    mapGetters
} from "vuex";
import moment from 'moment'
moment.locale("ko");
export default {
    props: ['data',
    'selectedItems',
    "selectAll",
    "toggleItem",
    "isSelectedAll",],
    components: {
        VideoPlayer
    },
    data() {
        return {
            modalShow:false,
            videoData:null,
            videoLink:null,
            currentSurgery:0,
            date:null,
        }
    },
    computed: {
        ...mapGetters(["currentUser"])
    },
    methods: {
        saveRecord(data) {
            api.saveHistory({
                record_id:data.id,
                account_id:this.currentUser.id,
                created_at:moment().format('YYYY-MM-DD HH:mm:ss')
            })

            console.log(data)
        },
        openModal(data) {
            this.modalShow = true;

            this.saveRecord(data)
        },
        prevSurgery() {
            this.currentSurgery--

            this.videoLink = `https://${base_url}:3000/stream/${this.devices[this.currentSurgery]}_${this.date}`
        },
        nextSurgery() {
            this.currentSurgery++

            // if(this.currentSurgery === 3) {
            //     this.videoLink = 'https://${base_url}:3000/stream/vital.webm'
            // } else {
                this.videoLink = `https://${base_url}:3000/stream/${this.devices[this.currentSurgery]}_${this.date}`
            // }
        },
        currentVideo() {
            this.videoLink = `https://${base_url}:3000/stream/${this.devices[0]}_${this.date}`
        }
    },
    mounted() {
        this.videoData = this.data

        this.date = moment(this.videoData.date).format('YYYYMMDDHHmmss')

        this.devices = this.videoData.devices.split(',')

        if(this.data.video_link) {
            this.videoLink=this.data.video_link
            this.date = this.videoLink.split('_')[1]
        }
        this.currentVideo()
    }
}
</script>
