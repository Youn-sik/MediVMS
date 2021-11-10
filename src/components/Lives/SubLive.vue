<template>
    <div v-if="live">
        <p style="text-align:center; margin-bottom:3px;">[{{live.surgery_name}}]&nbsp;&nbsp;&nbsp;</p>
        <WebRtcPlayer
            v-if="parseInt(live.isLives)"
            :liveurl="live.live_urls"
            id='main'
        />
        <VideoPlayer
            v-else
            license-server="https://widevine-proxy.appspot.com/proxy"
            :manifest-url="live.live_urls"
            style="height:221px; background:black;"
            :isHistory="false"
        />
        <b-form-group v-slot="{ ariaDescribedby }" class="mt-3">
            <b-form-radio-group
                id="sub-live-radio-group"
                v-model="currentVideoNumber"
                :aria-describedby="ariaDescribedby"
                :name="`radio-sub-component-${itemClassName}`"
            >
                <template v-for="(item,index) in live.numberOfDevices">
                    <b-form-radio style="margin:0;" :key="index" :value="index"></b-form-radio>
                </template>
            </b-form-radio-group>
        </b-form-group>
    </div>
</template>
<script>
import VideoPlayer from "../../components/Shaka/VideoPlayer.vue";
import WebRtcPlayer from '../../components/WebRTC/WebRTC.vue'

export default {
    props: ['live','itemClassName'],
    components: {
        VideoPlayer,
        WebRtcPlayer
    },
    data() {
        return {
            currentVideoNumber:0,
        };
    }
};
</script>
