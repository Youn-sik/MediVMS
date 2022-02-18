<template>
    <div ref="videoContainer" class="" :style="style">
        <div
            style="position : absolute; z-index:100; height:17px; width:100%; background:rgba(66, 63, 62, 0.6); color:white"
        >
            {{ time }}
        </div>
        <video
            style="width:100%; height:100%;"
            id="video"
            loop
            ref="videoPlayer"
            autoplay
            :src="
                this.manifestUrl.indexOf('assets') > -1
                    ? require(this.manifestUrl)
                    : this.manifestUrl
            "
            muted
            class=""
            :poster="posterUrl"
        ></video>
    </div>
</template>

<script>
import moment from "moment";
export default {
    props: [
        "manifestUrl",
        "posterUrl",
        "style",
        "isHistory",
        "recordStartDate"
    ],
    computed: {
        time() {
            return moment(this.recordStartDate)
                .add(this.currentTime, "seconds")
                .format("YYYY-MM-DD HH:mm:ss");
        }
    },
    watch: {
        manifestUrl: function() {
            this.player
                .load(this.manifestUrl)
                .then(() => {
                    // This runs if the asynchronous load is successful.
                    console.log("The video has now been loaded!");
                })
                .catch(this.onError); // onError is executed if the asynchronous load fails
        }
    },
    data() {
        return {
            player: null,
            currentTime: 0
        };
    },
    mounted() {
        const shaka = require("shaka-player/dist/shaka-player.ui.js");
        this.player = new shaka.Player(this.$refs.videoPlayer);
        const ui = new shaka.ui.Overlay(
            this.player,
            this.$refs.videoContainer,
            this.$refs.videoPlayer
        );
        ui.getControls();
        if (this.isHistory) {
            this.player.configure({
                drm: {
                    clearKeys: {
                        // replace keyid and key  with those used during video encryption
                        // 'keyid': 'key',
                        e90efe76ce02353a8ea327ba4d2dfc37:
                            "c959e6ae2cb17c7116eb4a739ceb505b"
                    }
                }
            });
        }
        if (!this.manifestUrl) return 0;
        this.player
            .load(this.manifestUrl)
            .then(() => {
                this.player.g.addEventListener("timeupdate", e => {
                    this.currentTime = parseInt(e.target.currentTime);
                });
                // This runs if the asynchronous load is successful.
                console.log("The video has now been loaded!");
            })
            .catch(this.onError); // onError is executed if the asynchronous load fails.

        this.player.trickPlay(-2);
    },
    methods: {
        onError(error) {
            console.error("Error code", error.code, "object", error);
        },
        moveVideoTime(val) {
            this.player.g.currentTime = val;
        }
    }
};
</script>

<style>
@import "../../../node_modules/shaka-player/dist/controls.css"; /* Shaka player CSS import */
.size {
    width: 800px;
}
</style>
