<template>
<div style="position : relative">
    <div
    style="position : absolute; z-index:100; height:17px; width:100%; background:rgba(66, 63, 62, 0.6); color:white"
    >
        {{ time }}
    </div>

    <div
    v-for="(url, index) in manifestUrl"
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
            class=""
            :poster="posterUrl"
        ></video>
    </div>

    <div class="timeline" ref="timeline" @click="clickTimeLine" style="position: relative; top:-6px; z-index:10">
        <!-- <div class="timeline__drag" ref="timeline__drag"></div> -->
        <span class="timeline__progress" ref="timeline__progress"></span>
    </div>
    <!-- <div ref="videoContainer2" class="video2" style="display:none; z-index:99;">
    <video
        style="width:100%; height:100%;"
        id="video2"
        ref="videoPlayer2"
        preload="auto"
        muted
        class=""
        :poster="posterUrl"
    ></video>
    </div> -->
</div>
</template>

<script>
import moment from "moment";
import {base_url} from "../../server.json"
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
// watch: {
//   'manifestUrl': function() {
//     this.player
//       .load(this.manifestUrl)
//       .then(() => {
//         // This runs if the asynchronous load is successful.
//         console.log('The video has now been loaded!');
//       })
//       .catch(this.onError); // onError is executed if the asynchronous load fails
//   },
// },
data() {
    return {
        player: null,
        player2: null,
        currentPlayerNumber:0,
        currentTime: 0,
        date: "",
        urls: [
            "http://172.16.135.17:3000/stream/1.mp4",
            "http://172.16.135.17:3000/stream/2.mp4"
        ],
        timeline:0,
        lastVideoTime:null,// 마지막 영상 길이
        totalVideoTime:null// 총 영상 길이
    };
},
mounted() {
    this.date = this.recordStartDate; // 시작 날짜 초기화

    const shaka = require("shaka-player/dist/shaka-player.ui.js");

    // player 초기화
    this.manifestUrl.forEach((e,i) => {
        let player = new shaka.Player(this.$refs["videoPlayer"+i][0]);
        const ui = new shaka.ui.Overlay(
            player,
            this.$refs['videoContainer'+i][0],
            this.$refs['videoPlayer'+i][0]
        );

        ui.getControls();

        // 첫번째 영상은 무조건 block으로 보이게 하기
        if(i === 0)
            this.$refs['videoContainer'+this.currentPlayerNumber][0].style.display = "block";
        console.log(e)
        player
        .load(`https://${base_url}:3000/stream/${e.replace('.mpd','')}/${e}`)
        .then(() => {
            console.log("The video"+i+" has now been loaded")

            // 마지막 영상 길이, 총 영상 길이 가져오기 이전 영상은 1시간 고정
            // if(this.manifestUrl.length === i+1) {
            //     this.lastVideoTime = player.g.duration
            //     this.totalVideoTime = i * 60 * 60 + this.lastVideoTime
            // }

            this.totalVideoTime += player.g.duration

            // player.g.addEventListener("timeupdate", event => {
            //     this.currentTime = parseInt(event.target.currentTime);
            //     let scala = (this.currentPlayerNumber*60*60 + event.target.currentTime) / this.totalVideoTime
            //     this.$refs.timeline__progress.style.transform = "scaleX("+scala+")"
            // });

            player.g.addEventListener("ended", () => {
                // 날짜 초기화
                this.currentTime++;
                this.date = moment(this.date)
                    .add(this.currentTime, "seconds")
                    .format("YYYY-MM-DD HH:mm:ss");
                this.currentTime = 0;


                if(this.currentPlayerNumber === this.manifestUrl.length-1)
                    return 0;

                // display 변경
                this.$refs['videoContainer'+this.currentPlayerNumber][0].style.display = "none";
                this.$refs['videoContainer'+(++this.currentPlayerNumber)][0].style.display = "block";

                // 영상 재생
                this.$refs['videoPlayer'+this.currentPlayerNumber][0].play()
            });

        }).catch(err => {
            console.log("error : " + err)
        });
    });

    // player1
    // this.player = new shaka.Player(this.$refs.videoPlayer);
    // const ui = new shaka.ui.Overlay(
    //     this.player,
    //     this.$refs.videoContainer,
    //     this.$refs.videoPlayer
    // );

    // ui.getControls();

    // this.player
    // .load(this.urls[0])
    // .then(() => {
    //     // This runs if the asynchronous load is successful.
    //     console.log("The video has now been loaded!");
    //     this.player.g.play();

    //     // 시간 업데이트
    //     this.player.g.addEventListener("timeupdate", event => {
    //         this.currentTime = parseInt(event.target.currentTime);
    //     });

    //     // 첫번째 영상이 끝났을때
    //     this.player.g.addEventListener("ended", () => {
    //         // 날짜 초기화
    //         this.currentTime++;
    //         this.date = moment(this.date)
    //             .add(this.currentTime, "seconds")
    //             .format("YYYY-MM-DD HH:mm:ss");
    //         this.currentTime = 0;

    //         // display 변경
    //         this.$refs.videoContainer.style.display = "none";
    //         this.$refs.videoContainer2.style.display = "block";

    //         // player2 start
    //         this.player2.g.play();
    //     });
    // })
    // .catch(this.onError); // onError is executed if the asynchronous load fails.

    // // player2
    // this.player2 = new shaka.Player(this.$refs.videoPlayer2);
    // const ui2 = new shaka.ui.Overlay(
    //     this.player2,
    //     this.$refs.videoContainer2,
    //     this.$refs.videoPlayer2
    // );
    // ui2.getControls();
    // this.player2
    // .load(this.urls[1])
    // .then(() => {
    //     // This runs if the asynchronous load is successful.
    //     console.log("The video has now been loaded!");

    //     this.player2.g.addEventListener("timeupdate", event => {
    //         this.currentTime = parseInt(event.target.currentTime);
    //     });
    // })
    // .catch(this.onError); // onError is executed if the asynchronous load fails.
},
methods: {
    clickTimeLine(e) {
        let timelineBoundingClientRect = this.$refs.timeline.getBoundingClientRect()

        let timelineWidth = timelineBoundingClientRect.width

        let clickedPosX = e.screenX - timelineBoundingClientRect.x

        let percentage = clickedPosX/timelineWidth;

        console.log(this.totalVideoTime,percentage)

        let time = moment(this.recordStartDate)
        .add(this.totalVideoTime * percentage, "seconds")
        .format("YYYY-MM-DD HH:mm:ss")

        this.moveVideoTime(time)
    },
    onError(error) {
        console.error("Error code", error.code, "object", error);
    },
    moveVideoTime(val) {
        let recordTime = moment(this.recordStartDate)
        let detectedTime = moment(val)

        let diff = moment.duration((detectedTime.diff(recordTime)))
        let videoIndex = diff.hours()
        let seconds = diff.minutes() * 60 + diff.seconds()

        if(videoIndex === this.manifestUrl.length){
            videoIndex--;
            seconds += 60*60
        }

        this.manifestUrl.forEach((e,i) => {
            if( i === videoIndex){
                // this.$refs['videoPlayer'+videoIndex][0].currentTime = seconds;

                this.currentPlayerNumber = videoIndex

                this.currentTime = diff.hours() * 60 * 60 + diff.minutes() * 60;
                this.date = moment(this.recordStartDate)
                    .add(this.currentTime, "seconds")
                    .format("YYYY-MM-DD HH:mm:ss");
                this.currentTime = diff.seconds()

                console.log(  this.$refs['videoPlayer'+videoIndex][0].duration, seconds )

                this.$refs['videoPlayer'+videoIndex][0].currentTime = seconds

                let scala = (this.currentPlayerNumber*60*60 + seconds) / this.totalVideoTime
                this.$refs.timeline__progress.style.transform = "scaleX("+scala+")"

                this.$refs['videoContainer'+videoIndex][0].style.display = "block";
                this.$refs['videoPlayer'+videoIndex][0].play()
            } else {
                this.$refs['videoContainer'+i][0].style.display = "none";
                this.$refs['videoPlayer'+i][0].pause()
            }
        })
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