<template>
    <div style="position : relative">
        <div
            style="position : absolute; z-index:100; height:17px; width:100%; background:rgba(66, 63, 62, 0.6); color:white"
        >
            {{ time }}
        </div>

        <div
            v-for="(url, index) in [0, 1]"
            :key="index"
            :ref="'videoContainer' + index"
            :class="'video' + index"
            style="z-index:99; display:none; z-index:1"
        >
            <video
                style="width:100%; height:100%;"
                :id="'video' + index"
                :ref="'videoPlayer' + index"
                preload="auto"
                muted
                autoplay
                class=""
            ></video>
        </div>

        <div
            :ref="'videoContainerlast'"
            :class="'videolast'"
            style="z-index:99; display:none; z-index:1"
        >
            <video
                style="width:100%; height:100%;"
                :id="'videolast'"
                :ref="'videoPlayerlast'"
                preload="auto"
                muted
                class=""
            ></video>
        </div>

        <div
            class="timeline"
            ref="timeline"
            @click="clickTimeLine"
            style="position: relative; top:-6px; z-index:10"
        >
            <span class="timeline__progress" ref="timeline__progress"></span>
        </div>
    </div>
</template>

<script>
import moment from "moment";
import { base_url } from "../../server.json";
export default {
    props: {
        manifestUrl: {
            type: Array,
            required: true
        },
        posterUrl: {
            type: String,
            required: false,
            default: ""
        },
        style: {
            type: String,
            required: false,
            default: ""
        },
        recordStartDate: {
            type: String,
            required: false,
            default: ""
        }
    },
    computed: {
        time() {
            return moment(this.date)
                .add(this.currentTime, "seconds")
                .format("YYYY-MM-DD HH:mm:ss");
        }
    },
    data() {
        return {
            preload: true,
            player: null,
            player2: null,
            ui: null,
            ui2: null,
            lastPlayer: null,
            lastUi: null,
            currentPlayerNumber: 0,
            currentTime: 0,
            date: "",
            urls: [
                "http://172.16.135.17:3000/stream/1.mp4",
                "http://172.16.135.17:3000/stream/2.mp4"
            ],
            timeline: 0,
            lastVideoTime: null, // 마지막 영상 길이
            totalVideoTime: null // 총 영상 길이
        };
    },
    mounted() {
        this.date = this.recordStartDate; // 시작 날짜 초기화

        const shaka = require("shaka-player/dist/shaka-player.ui.js");

        this.player = new shaka.Player(
            this.$refs["videoPlayer" + this.currentPlayerNumber][0]
        );

        this.ui = new shaka.ui.Overlay(
            this.player,
            this.$refs["videoContainer" + this.currentPlayerNumber][0],
            this.$refs["videoPlayer" + this.currentPlayerNumber][0]
        );

        this.ui.getControls();

        // 첫번째 영상은 무조건 block으로 보이게 하기
        if (this.currentPlayerNumber === 0)
            this.$refs[
                "videoContainer" + this.currentPlayerNumber
            ][0].style.display = "block";

        this.playerLoad("player");

        this.player2 = new shaka.Player(this.$refs["videoPlayer" + 1][0]);
        this.ui2 = new shaka.ui.Overlay(
            this.player2,
            this.$refs["videoContainer" + 1][0],
            this.$refs["videoPlayer" + 1][0]
        );

        this.ui2.getControls();

        //마지막 영상 플레이어
        this.lastPlayer = new shaka.Player(this.$refs["videoPlayerlast"]);
        this.lastUi = new shaka.ui.Overlay(
            this.lastPlayer,
            this.$refs["videoContainerlast"],
            this.$refs["videoPlayerlast"]
        );

        this.lastUi.getControls();

        this.lastPlayer
            .load(
                `http://${base_url}:3000/stream/` +
                    this.manifestUrl[this.manifestUrl.length - 1]
            )
            .then(() => {
                this.lastVideoTime = this.lastPlayer.g.duration;
                this.totalVideoTime =
                    60 * 60 * (this.manifestUrl.length - 1) +
                    this.lastVideoTime;
                this.lastPlayer.unload();
            });
    },
    methods: {
        playerLoad(val, seconds = null) {
            //player load 함수
            this[val]
                .load(
                    `http://${base_url}:3000/stream/` +
                        this.manifestUrl[this.currentPlayerNumber]
                )
                .then(() => {
                    if (seconds) {
                        //초가 지정되면 해당 위치로 이동
                        this[val].g.currentTime = seconds;
                    }

                    this[val].g.addEventListener("timeupdate", e => {
                        if (parseInt(e.target.currentTime) !== 0) {
                            this.currentTime = parseInt(e.target.currentTime);
                            let scala =
                                ((this.preload
                                    ? this.currentPlayerNumber
                                    : this.currentPlayerNumber - 1) *
                                    60 *
                                    60 +
                                    this.currentTime) /
                                this.totalVideoTime;
                            this.$refs.timeline__progress.style.transform = `scaleX(${scala})`;
                        }
                    });

                    this[val].g.addEventListener("play", () => {
                        //play 할시 다음 영상 로딩 하는 로직
                        if (this.preload) {
                            this.currentPlayerNumber++;
                            this.preload = false; //play될때 마다 실행 되는걸 막기위해 처음 한번만 실행 후 현재 영상이 end될때 까지 실행 X
                            if (val === "player") {
                                this.playerLoad("player2");
                            } else {
                                this.playerLoad("player");
                            }
                        }
                    });

                    // this[val].g.addEventListener("canplay", () => { //play 할시 다음 영상 로딩 하는 로직
                    //     if(this.preload){
                    //         this.currentPlayerNumber++;
                    //         this.preload = false //play될때 마다 실행 되는걸 막기위해 처음 한번만 실행 후 현재 영상이 end될때 까지 실행 X
                    //         if(val === 'player') {
                    //             this.playerLoad('player2')
                    //         } else {
                    //             this.playerLoad('player')
                    //         }
                    //     }
                    // });

                    this[val].g.addEventListener("ended", () => {
                        //현재 영상 끝나면 다음 영상 재생후 현재 player unload
                        this.preload = true; //현재 영상의 다다음 영상을 로딩할수 있도록 false로 변경
                        if (val === "player") {
                            this.$refs["videoContainer" + 0][0].style.display =
                                "none";
                            this.$refs["videoContainer" + 1][0].style.display =
                                "block";
                            // this.player2.g.play()
                        } else {
                            this.$refs["videoContainer" + 1][0].style.display =
                                "none";
                            this.$refs["videoContainer" + 0][0].style.display =
                                "block";
                            // this.player.g.play()
                        }

                        this.currentTime++;
                        this.date = moment(this.date)
                            .add(this.currentTime, "seconds")
                            .format("YYYY-MM-DD HH:mm:ss");

                        // this.playerUnload(val)
                    });
                })
                .catch(err => {
                    console.log("error : " + err);
                });
        },
        playerUnload(val) {
            this[val].unload();
        },
        clickTimeLine(e) {
            let timelineBoundingClientRect = this.$refs.timeline.getBoundingClientRect();

            let timelineWidth = timelineBoundingClientRect.width;

            let clickedPosX = e.clientX - timelineBoundingClientRect.x;

            let percentage = clickedPosX / timelineWidth;

            let time = moment(this.recordStartDate)
                .add(this.totalVideoTime * percentage, "seconds")
                .format("YYYY-MM-DD HH:mm:ss");

            this.moveVideoTime(time);
        },
        onError(error) {
            console.error("Error code", error.code, "object", error);
        },
        moveVideoTime(val) {
            this.preload = true;

            let recordTime = moment(this.recordStartDate);
            let detectedTime = moment(val);

            let diff_minutes = detectedTime.diff(recordTime, "minutes");
            let diff_seconds = detectedTime.diff(recordTime, "seconds");

            let videoIndex = parseInt(diff_minutes / 60);
            let seconds = diff_seconds - videoIndex * 60 * 60;

            this.currentPlayerNumber = videoIndex;

            let scala =
                (this.currentPlayerNumber * 60 * 60 + seconds) /
                this.totalVideoTime;
            this.$refs.timeline__progress.style.transform = `scaleX(${scala})`;

            this.date = moment(this.recordStartDate)
                .add(diff_seconds - seconds, "seconds")
                .format("YYYY-MM-DD HH:mm:ss");

            if (videoIndex / 2 === 0) {
                //짝수면 1번 플레이어
                this.playerUnload("player2");
                this.playerLoad("player", seconds);
                this.$refs["videoContainer" + 0][0].style.display = "block";
                this.$refs["videoContainer" + 1][0].style.display = "none";
            } else {
                //홀수면 2번 플레이어
                this.playerUnload("player");
                this.playerLoad("player2", seconds);
                this.$refs["videoContainer" + 1][0].style.display = "block";
                this.$refs["videoContainer" + 0][0].style.display = "none";
            }
        }
    }
};
</script>

<style>
@import "../../../node_modules/shaka-player/dist/controls.css"; /* Shaka player CSS import */
.size {
    width: 800px;
}

.timeline {
    width: 100%;
    height: 10px;
    background-color: black;
    cursor: pointer;
    position: relative;
}

/* Here is the dragger that I will use to move the video
* current time forward or backward.
* I have added a background color for you to see it
* but just remove it in production.
*/

.timeline__drag {
    width: 1px;
    height: 20px;
    top: -10px;
    background-color: yellow;
    position: absolute;
    z-index: 2;
    transform-origin: 0 0;
}

.timeline__progress {
    display: block;
    width: 100%;
    height: 100%;
    background-color: green;
    transform: scaleX(0);
    transform-origin: 0 0;
    /* position: relative; */
    /* z-index: 1; */
}

/* .shaka-controls-container {
    display: none !important;
} */
</style>
