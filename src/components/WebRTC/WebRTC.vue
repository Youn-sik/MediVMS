<template>
    <video
        style="width:100%; height:100%;"
        :id="'video' + id"
        class="webRtc"
        muted
        playsinline
        controls
    ></video>
</template>

<script>
import WebRtcStreamer from "./webrtcstreamer.js";
export default {
    props: ["liveurl", "id"],
    data() {
        return {
            webRtcServer: null
        };
    },
    mounted() {
        // if (location.search.slice(1)) {
        var url = { video: this.liveurl, audio: null };
        var options = "rtptransport=tcp&timeout=60";
        var webrtcConfig = {
            url: "",
            options: "rtptransport=tcp&timeout=60",
            layoutextraoptions: "&width=320&height=0",
            defaultvideostream: "Bunny"
        };

        this.webRtcServer = new WebRtcStreamer(
            "video" + this.id,
            webrtcConfig.url
        );
        // document.getElementById("title").innerHTML=url.video;
        this.webRtcServer.connect(url.video, url.audio, options);
        fetch(webrtcConfig.url + "/api/version")
            .then(r => r.text())
            .then(response => {
                document.getElementById("footer").innerHTML =
                    "<p><a href='https://github.com/mpromonet/webrtc-streamer'>WebRTC-Streamer</a> " +
                    JSON.parse(response).split(" ")[0] +
                    "</p>";
            });
    },
    beforeDestroy() {
        this.webRtcServer.disconnect();
    }
};
</script>
