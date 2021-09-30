 <template>
    <div id="app"
    style="position:relative; left:-60px; top:-45px;"
    ref="app"
    @mousemove="rotateOnMouse"
    @mouseup="()=>{rotationEnable = false}">
        <div class="grid">
            <div class="temp"
            id="temp"
            :style="{
            'background-size': `${columnWidth}px ${rowHeight}px`,
            height: `400%`,
            }"></div>
            <grid-layout
                id="grid-layout"
                :layout.sync="layout"
                :col-num="24*3"
                :row-height="rowHeight - 26.0 / 24"
                :col-width="30"
                :is-draggable="draggable"
                :responsive="false"
                :vertical-compact="false"
                :prevent-collision="true"
                :margin="[1, 1]"
                :use-css-transforms="true"
                :transformScale="transformScale"
            >
                <grid-item v-for="(item,index) in layout"
                    :class="item.i"
                    :key="index"
                    :static="item.static"
                    :preserveAspectRatio="true"
                    :x="item.x"
                    :y="item.y"
                    :w="item.w"
                    :h="item.h"
                    :i="item.i"
                    @moved="gridMovedEvent"
                >
                    <div class="hoverWrap" style="z-index:100" @mouseover="(e)=>{girdMouseOverEvent(e,index)}" @mouseleave="(e)=>{girdMouseLeaveEvent(e,index)}">
                        <div class="icons" v-if="item.mouseover" style="color:white; width:100%; height:25px; background:rgba(0,0,0,0.5); position:absolute; top:0px; z-index:1000; display:inline-block">
                            <div
                            :style="{
                            'background-color': item.live ?
                            '#A7CF5D' : '#9D9D9D',
                            'width':'15px',
                            'height':'15px',
                            'border-radius':'75px',
                            'text-align':'center',
                            'font-size':'12px',
                            'vertical-align':'middle',
                            'float':'left',
                            'line-height':'15px',
                            'margin-left':'7px',
                            'display':'inline-block',
                            'margin-top':'4px'}
                            "
                            ></div>
                            <p style="display:inline-block; float:left; margin-left:4px; font-size:15px; line-height:23px;">{{item.deviceName}}</p>
                            <button id="close" style="float:right; font-size:15.5px;" @click="removeItem(item,index)"><i class="simple-icon-close"></i></button>
                            <b-tooltip target="close"
                                placement="bottom"
                                title="닫기">
                            </b-tooltip>

                            <button v-if="item.mode !== 'zoom'" @click="createZoomBox(item,index)" id="createZoom" :style="{
                                'float':'right',
                                'font-size':'15.5px',
                                'background': item.mode === 'zoomParent' ? 'rgb(64,158,255,0.5)' : null
                                }"><i class="simple-icon-frame"></i></button>
                            <b-tooltip target="createZoom"
                                placement="bottom"
                                title="줌영역 생성">
                            </b-tooltip>
                        </div>

                         <div v-if="item.mode === 'zoom'" :ref="'zoomVideo '+ item.parent" style="z-index:1; width:100%; height:100%; transform:scale(2.1,2.1); transform-origin:0px 0px" playsinline autoplay muted loop id="bgvid">
                            <VideoPlayer
                                license-server="https://widevine-proxy.appspot.com/proxy"
                                manifest-url="https://dash.akamaized.net/dash264/TestCases/1c/qualcomm/2/MultiRate.mpd"
                                poster-url="https://upload.wikimedia.org/wikipedia/commons/a/a7/Big_Buck_Bunny_thumbnail_vlc.png"
                            />
                        </div>
                        <div v-else-if="item.mode === 'zoomParent'" ref="original" class="original video" style="z-index:1; width:100%; height:100%;" playsinline autoplay muted loop id="bgvid">
                            <VideoPlayer
                                license-server="https://widevine-proxy.appspot.com/proxy"
                                manifest-url="https://dash.akamaized.net/dash264/TestCases/1c/qualcomm/2/MultiRate.mpd"
                                poster-url="https://upload.wikimedia.org/wikipedia/commons/a/a7/Big_Buck_Bunny_thumbnail_vlc.png"
                            />
                        </div>
                        <div v-else ref="original" class="original video" style="z-index:1; width:100%; height:100%;" playsinline autoplay muted loop id="bgvid">
                            <VideoPlayer
                                license-server="https://widevine-proxy.appspot.com/proxy"
                                manifest-url="https://dash.akamaized.net/dash264/TestCases/1c/qualcomm/2/MultiRate.mpd"
                                poster-url="https://upload.wikimedia.org/wikipedia/commons/a/a7/Big_Buck_Bunny_thumbnail_vlc.png"
                            />
                        </div>

                        <!-- zoom 박스 -->
                        <button v-if="item.mode === 'zoomParent'"
                        :ref="'zoom ' + index"
                        class="zoombox"
                        @mousedown="(e)=>{zoomBoxMouseDown(e,item)}"
                        @mouseup="zoomBoxMouseUp"
                        @mousemove="(e)=>{zoomBoxMouseMove(e,index,item)}"
                        style="
                        width: 158.5px;
                        height: 92px;
                        color: white;
                        z-index: 1;
                        position: absolute;
                        top: 0px;
                        left: 0px;
                        box-shadow: 0 0 0 3px #409eff inset;
                        cursor:pointer"></button>
                    </div>
                </grid-item>
            </grid-layout>
        </div>
    </div>
</template>

<script>
import { GridLayout, GridItem } from "vue-grid-layout"
import VideoPlayer from '../../../../components/Shaka/VideoPlayer.vue'
export default {
    components: {
        GridLayout,
        GridItem,
        VideoPlayer
    },
    computed: {
        rowHeight() {
            return window.innerHeight / 20;
        },
        columnWidth() {
            //스크롤이 차지하는 크기를 생각해야함
            return window.innerWidth / 24;
        },
        videoHeight() {
            return this.originalVideoHeight
        }
    },
    mounted() {
        this.gridItems = document.getElementsByClassName("vue-grid-item vue-resizable cssTransforms")
        setTimeout(() => {
            this.originalVideoHeight = this.$refs.original[0].offsetHeight
        },100)
    },
    data() {
        return {
            layout: [
                {"x":0,"y":0,"w":4,"h":4,"i":"0", static: false, mouseover:false, mode:'zoomParent', live:true, deviceName:'NADA-J1'},
                {"x":2,"y":0,"w":4,"h":4,"i":"1", static: false, mouseover:false, mode:'zoom', parent:"0", live:true, deviceName:'NADA-J1'},
                {"x":4,"y":0,"w":4,"h":4,"i":"2", static: false, mouseover:false, mode:'standard', live:false, deviceName:'NADA-J2'},
                {"x":6,"y":0,"w":4,"h":4,"i":"3", static: false, mouseover:false, mode:'standard', live:false, deviceName:'NADA-J3'},
                {"x":8,"y":0,"w":4,"h":4,"i":"4", static: false, mouseover:false, mode:'standard', live:false, deviceName:'NADA-J4'},

            ],
            hlsUrls: [

            ],
            draggable: true,
            resizable: true,
            transformScale:1,
            gridLayoutHeight:0,
            gridLayoutWidth:0,
            gridItems:[],
            rotationEnable:false,
            targetedGrid:null,
            preTransform:null,
            lastMouseEvent:null,
            originalVideoHeight:0,
            zoomBoxGrab:false,
            gapX:null,
            gapY:null,

        }
    },
    methods: {
        createZoomBox(item,index) {
            if(item.mode === 'standard') {
                this.$set(this.layout[index],'mode','zoomParent')
                this.layout.push({
                    "x":item.x+2,
                    "y":item.y+2,
                    "w":4,
                    "h":4,
                    "i":this.layout.length-1,
                    "parent":item.i,
                    static: false,
                    mouseover:false,
                    mode:'zoom',
                    live:true,
                    deviceName:item.deviceName
                })
            } else if(item.mode === 'zoomParent') {
                const parentIndex = this.layout.map(_item => _item.parent).indexOf(item.i);
                this.$set(this.layout[index],'mode','standard')
                this.layout.splice(parentIndex, 1);
            }
        },
        removeItem(item,index) {
            if(item.mode === 'zoom') {
                const parentIndex = this.layout.map(_item => _item.i).indexOf(item.parent);
                this.$set(this.layout[parentIndex],'mode','standard')
            } else if(item.mode === 'zoomParent') {
                const childIndexes = this.layout.map(_item => _item.parent).indexOf(item.i);
                this.layout.splice(childIndexes, 1);
            }

            this.layout.splice(index, 1);
        },
        girdMouseOverEvent(e,index) {
            // this.$set(this.layout,index,{...this.layout[index],mouseover:true});
            this.$set(this.layout[index],'mouseover',true)
        },
        girdMouseLeaveEvent(e,index) {
            this.$set(this.layout[index],'mouseover',false)
        },
        zoomBoxMouseDown(e,gridItem) {
            this.zoomBoxGrab = true

            const el = e.target;

            const mouseX = e.clientX;
            const mouseY = e.clientY;

            const ballPos = el.getBoundingClientRect();
            console.log(ballPos)

            const appPos = document.getElementById("app").getBoundingClientRect()

            const ballX = ballPos.x - appPos.x - (gridItem.x * this.columnWidth);
            const ballY = ballPos.y - appPos.y - (gridItem.y * this.rowHeight);

            this.gapX = mouseX - ballX;
            this.gapY = mouseY - ballY;
        },
        zoomBoxMouseMove(e,index,gridItem) {
            if(this.zoomBoxGrab){
                const el = e.target;
                const zoomVideo = this.$refs['zoomVideo ' + index]
                const mouseX = e.clientX
                const mouseY = e.clientY

                const videoW = gridItem.w * this.columnWidth
                const videoH = gridItem.h * this.rowHeight

                // 선택한 공 안에 있는 마우스 커서의 XY좌표
                const gapX = this.gapX
                const gapY = this.gapY

                // 마우스 커서의 위치에 따른 공의 XY좌표
                const ballX = mouseX - gapX
                const ballY = mouseY - gapY

                let transformOriginX = ballX;
                let transformOriginY = ballY;

                el.style.left = ballX+"px"
                el.style.top = ballY+"px"

                if(ballX < 0) {
                    el.style.left = "0px"
                    transformOriginX = 0
                }

                if(ballY < 0) {
                    el.style.top = "0px"
                    transformOriginY = 0
                }

                if(ballX+el.clientWidth > videoW) {
                    let X = videoW - el.clientWidth
                    el.style.left = X-3 + "px"
                    transformOriginX = X-3
                }

                if(ballY+el.clientHeight > videoH) {
                    let Y = videoH - el.clientHeight
                    el.style.top = Y-3 + "px"
                    transformOriginY = Y-3
                }

                zoomVideo[0].style.transformOrigin = `${transformOriginX*2}px ${transformOriginY*2}px`

            }
        },
        zoomBoxMouseUp() {
            this.zoomBoxGrab = false
            this.gapX = null
            this.gapY = null
        },
        gridMovedEvent() {
            this.gridLayoutHeight = parseInt(document.getElementById("grid-layout").style.height.replace('px',''))
            this.gridLayoutWidth = parseInt(document.getElementById("grid-layout").style.width.replace('px',''))

            //높이
            if(this.gridLayoutHeight+145 > window.innerHeight / this.transformScale)
                this.ZoomOut()
            else if(window.innerHeight / this.transformScale === window.innerHeight)
                return;
            else if(this.gridLayoutHeight+145 < window.innerHeight / this.transformScale)
                this.ZoomIn()

        },
        scaleHalf: function() {
            this.transformScale = 0.5
            document.getElementById("grid-layout").style.transform = "scale(0.5)";
            document.getElementById("temp").style.transform = "scale(0.5)";
        },
        scaleThreeQuarters: function() {
            this.transformScale = 0.75
            document.getElementById("grid-layout").style.transform = "scale(0.75)";
            document.getElementById("temp").style.transform = "scale(0.75)";
        },
        scaleIdentity: function() {
            this.transformScale = 1
            document.getElementById("grid-layout").style.transform = "scale(1)";
            document.getElementById("temp").style.transform = "scale(1)";
        },

        ZoomIn: function() {
            this.transformScale = Math.round((this.transformScale + 0.1) * 10) / 10
            // this.transformScale = this.transformScale.toFixed(1)
            document.getElementById("grid-layout").style.transform = "scale("+this.transformScale+")";
            document.getElementById("temp").style.transform = "scale("+this.transformScale+")";

            if(this.gridLayoutHeight+100 < window.innerHeight / this.transformScale && this.transformScale != 1.0)
                this.ZoomIn()
        },
        ZoomOut: function() {
            this.transformScale =Math.round((this.transformScale - 0.1) * 10) / 10
            // this.transformScale = this.transformScale.toFixed(1)
            document.getElementById("grid-layout").style.transform = "scale("+this.transformScale+")";
            document.getElementById("temp").style.transform = "scale("+this.transformScale+")";

            if(this.gridLayoutHeight > window.innerHeight / this.transformScale)
                this.ZoomOut()
        },
        rotateOnMouse(e) {
            if(this.rotationEnable) {
                let grid = document.getElementsByClassName("vue-grid-item vue-resizable cssTransforms "+this.targetedGrid)[0]
                // var offset = grid.offset();
                var center_x = (grid.offsetLeft) + (grid.clientWidth / 2);
                var center_y = (grid.offsetTop) + (grid.clientHeight / 2);

                var mouse_x = e.pageX;
                var mouse_y = e.pageY;
                var radians = Math.atan2(mouse_x - center_x, mouse_y - center_y);
                var degree = (radians * (180 / Math.PI) * -1) + 100;

                if(this.rotationEnable){
                    grid.style.transform = this.preTransform
                    grid.style.MozTransform += ' rotate(' + degree + 'deg)';
                    grid.style.WebkitTransform += ' rotate(' + degree + 'deg)';
                    grid.style.OTransform += ' rotate(' + degree + 'deg)';
                    grid.style.msTransform += ' rotate(' + degree + 'deg)';
                } else {
                    this.preTransform = grid.style.transform;
                    grid.style.MozTransform += ' rotate(' + degree + 'deg)';
                    grid.style.WebkitTransform += ' rotate(' + degree + 'deg)';
                    grid.style.OTransform += ' rotate(' + degree + 'deg)';
                    grid.style.msTransform += ' rotate(' + degree + 'deg)';
                }


            }
        },
        rotationStart(gridId) {
            this.rotationEnable = true;
            this.targetedGrid = gridId
        },
        rotationStop() {
            this.rotationEnable = false;
        },
        // rotation(e) {
        //     if(this.rotationEnable) {
        //         this.lastMouseEvent = {
        //             x: e.clientX,
        //             y: e.clientY
        //         }
        //     }
        // },
        // updateAngleToMouse(newPoint,element) {
        //     let
        // }

    }
}
</script>

<style scoped>
.temp {
    /* opacity: .75; */
    position: absolute;
    width: 300vw;
    background-repeat: repeat;
    background-image: linear-gradient(
90deg
,rgba(0, 0, 0, 0.15) 2px,transparent 0),linear-gradient(
180deg
,rgba(0, 0, 0, 0.15) 2px,transparent 0);
}
.vue-grid-layout {
    transition:0.5s all;
    background: rgba(0, 0, 0, 0);
    transform-origin:top left;
    width: 300vw;
    height:100%;
}
.temp{
    transform-origin:top left;
    transition:0.5s all;
    transform: scale( 1,1 )
}

.vue-grid-item {
    overflow:hidden;
}

.vue-grid-item:not(.vue-grid-placeholder) {
    background: black;
    border: 1px solid;
}
.vue-grid-item .resizing {
    opacity: 0.9;
}
.vue-grid-item .static {
    background: #cce;
}
.vue-grid-item .text {
    font-size: 24px;
    text-align: center;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
    height: 100%;
    width: 100%;
}
.vue-grid-item .no-drag {
    height: 100%;
    width: 100%;
}
.vue-grid-item .minMax {
    font-size: 12px;
}
.vue-grid-item .add {
    cursor: pointer;
}
.vue-draggable-handle {
    position: absolute;
    width: 20px;
    height: 20px;
    top: 0;
    left: 0;
    background: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='10'><circle cx='5' cy='5' r='5' fill='#999999'/></svg>") no-repeat;
    background-position: bottom right;
    padding: 0 8px 8px 0;
    background-repeat: no-repeat;
    background-origin: content-box;
    box-sizing: border-box;
    cursor: pointer;
}
.hoverWrap:hover {
    background: linear-gradient(rgba(0,0,0,0.3) 8%, rgba(0,0,0,0) 8%);
}
.hoverWrap {
    height: 100%;;
    /* background: linear-gradient(#3498db 50%, #ffffff 50%); */
}

#grid-layout button {
    color:white;
    background: rgba(0,0,0,0);
    cursor:pointer;
    border:0;
    outline: 0;
}

#grid-layout .icons button:hover {
    background: rgb(64,158,255,0.5)
}
</style>