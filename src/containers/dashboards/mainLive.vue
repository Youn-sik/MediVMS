<template>
  <!-- <b-card> -->
    <div class="main-live" v-if="mainlive">
        <template v-if="currentUser.authority <= 1">
            <WebRtcPlayer
                v-if="parseInt(mainlive.isLives[0])"
                :liveurl="mainlive.live_urls[0]"
                id='main'
            />
            <VideoPlayer
                v-else
                :isHistory="false"
                license-server="https://widevine-proxy.appspot.com/proxy"
                :manifest-url="mainlive.live_urls[0]"
                style="height:460px; background:black;"
            />
        </template>
        <div v-else style="width:100%; height:100%; text-align:center; line-height:441px;">
            시청 권한이 없습니다.
        </div>

        <div class="main-live-info">[ {{mainlive.surgery_name}} ]</div>

        <div class="sub-cameras" v-if="currentUser.authority <= 1">
            <div v-for="(item,index) in mainlive.live_urls.slice(1)" :key="index" class="sub-camera">
                <WebRtcPlayer
                    v-if="parseInt(mainlive.isLives.slice(1)[index])"
                    :liveurl="item"
                    :id='index'
                />
                <VideoPlayer
                    v-else
                    :isHistory="false"
                    license-server="https://widevine-proxy.appspot.com/proxy"
                    :manifest-url="item"
                    style="height:92px; background:black;"
                />
            </div>
        </div>
    </div>

  <!-- </b-card> -->
</template>
<script>
import VideoPlayer from '../../components/Shaka/VideoPlayer.vue'
import WebRtcPlayer from '../../components/WebRTC/WebRTC.vue'
export default {
    props:['mainlive','currentUser'],
    components: {
        VideoPlayer,
        WebRtcPlayer
    },
    data () {
        return {
        }
    },
};
</script>

