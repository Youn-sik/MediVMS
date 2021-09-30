<template>
<b-card :class="{'d-flex flex-row':true,'active' : selectedItems.includes(data.id)}" no-body>
    <!-- 열람 modal -->
    <b-modal size="lg" v-model="modalShow" title="데이터 열람">
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
                    <b-td rowspan="1">{{videoData.surgery_name}}</b-td>
                    <b-td rowspan="1">{{videoData.department}}</b-td>
                    <b-td rowspan="1">{{videoData.doctor}}</b-td>
                    <b-td rowspan="1">{{videoData.surgery_desc}}</b-td>
                    <b-td rowspan="1">{{videoData.patient_status}}</b-td>
                </b-tr>
            </b-tbody>
        </b-table-simple>
        <div style="width:744px; height:415px;">
            <VideoPlayer
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
            <b-form-checkbox :checked="selectedItems.includes(videoData.id)" class="itemCheck mb-0" />
        </div>
        <div class="card-body align-self-center d-flex flex-column flex-lg-row justify-content-between min-width-zero align-items-lg-center">
            <p class="mb-0 w-15 w-sm-100">{{videoData.date}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.surgery_name}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.department}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.doctor}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.surgery_desc}}</p>
            <p class="mb-0 w-15 w-sm-100">{{videoData.patient_status}}</p>
            <p v-if="videoData.date === '일시'" class="mb-0 w-15 w-sm-100">{{'열람 가능 여부'}}</p>
            <p v-else class="mb-0 w-15 w-sm-100">{{currentUser.authority &lt; 2 ? '열람 가능' : '열람 불가'}}</p>
            <p v-if="videoData.date === '일시'" class="mb-0 w-15 w-sm-100">{{'열람'}}</p>
            <p v-else class="mb-0 w-15 w-sm-100">
                <b-button :disabled="currentUser.authority >= 2" @click="openModal" variant="primary">열람</b-button>
            </p>
            <!-- <p v-else class="mb-0 w-15 w-sm-100">{{data.browseAuth}}</p> -->
            <!-- <div class="w-15 w-sm-100">
                <b-badge pill :variant="data.statusColor">{{ data.status }}</b-badge>
            </div> -->
        </div>
    </div>
</b-card>
</template>

<script>
import VideoPlayer from '../../components/Shaka/VideoPlayer.vue'
import {
    mapGetters
} from "vuex";
export default {
    props: ['data', 'selectedItems'],
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
        ...mapGetters(["currentUser", "processing", "loginError"])
    },
    methods: {
        toggleItem(event, itemId) {
            this.$emit('toggle-item', event, itemId)
        },
        openModal() {
            this.modalShow = true;
        },
        prevSurgery() {
            this.currentSurgery--

            this.videoLink = `http://172.16.41.105:3000/stream/${this.currentSurgery}_${this.date}`
        },
        nextSurgery() {
            this.currentSurgery++

            if(this.currentSurgery === 3) {
                this.videoLink = 'http://172.16.41.105:3000/stream/vital.webm'
            } else {
                this.videoLink = `http://172.16.41.105:3000/stream/${this.currentSurgery}_${this.date}`
            }
        },
        currentVideo() {
            this.videoLink = `http://172.16.41.105:3000/stream/${0}_${this.date}`
        }
    },
    mounted() {
        this.videoData = this.data
        // this.videoData[3].videoLink = 'http://172.16.41.105:3000/stream/vital.webm'
        this.videoLink=this.data.video_link
        this.date = this.videoLink.split('_')[1]
        this.currentVideo()
    }
}
</script>
