 <template>
    <div id="app" style="height:100vh" ref="app"
    @mousemove="rotateOnMouse"
    @mouseup="()=>{rotationEnable = false}">
        <div class="grid">
            <div class="temp"
            id="temp"
            :style="{
            'background-size': `${columnWidth}px ${rowHeight}px`,
            height: `200%`,
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
                    <div class="hoverWrap" style="z-index:100">
                        <button
                            @mousedown="()=>{rotationStart(item.i)}"
                        >
                            test
                        </button>
                        <video v-if="item.mode === 'zoom'" style="z-index:1; height:100%; width:100%; transform: scale( 3,3 )" playsinline autoplay muted loop poster="https://i.pinimg.com/originals/28/6c/00/286c004a0cc4a49a5e6985b0e0812923.gif" id="bgvid">
                            <source src="http://media6000.dropshots.com/photos/1381926/20170326/005609.mp4" type="video/mp4">
                        </video>
                        <video v-else-if="item.mode === 'standard'" style="z-index:1; height:100%; width:100%;" playsinline autoplay muted loop poster="https://i.pinimg.com/originals/28/6c/00/286c004a0cc4a49a5e6985b0e0812923.gif" id="bgvid">
                            <source src="http://media6000.dropshots.com/photos/1381926/20170326/005609.mp4" type="video/mp4">
                        </video>
                    </div>
                </grid-item>
            </grid-layout>
        </div>
    </div>
</template>

<script>
import GridItem from '../components/GridItem.vue';
import GridLayout from '../components/GridLayout.vue';
export default {
    components: {
        GridLayout,
        GridItem,
    },
    computed: {
        rowHeight() {
            return window.innerHeight / 12;
        },
        columnWidth() {
            //스크롤이 차지하는 크기를 생각해야함
            return window.innerWidth / 24;
        },
    },
    mounted() {
        this.gridItems = document.getElementsByClassName("vue-grid-item vue-resizable cssTransforms")
    },
    data() {
        return {
            layout: [
                {"x":0,"y":0,"w":1,"h":1,"i":"0", static: false, mode:'standard'},
                {"x":2,"y":0,"w":1,"h":1,"i":"1", static: false, mode:'zoom'},
                {"x":4,"y":0,"w":4,"h":4,"i":"2", static: false, mode:'none'},
                // {"x":6,"y":0,"w":4,"h":6,"i":"3", static: false}, x
                // {"x":8,"y":0,"w":4,"h":6,"i":"4", static: false},
                // {"x":8,"y":0,"w":4,"h":6,"i":"5", static: false},
                // {"x":8,"y":0,"w":4,"h":6,"i":"6", static: false},
                // {"x":8,"y":0,"w":4,"h":6,"i":"7", static: false},
                // {"x":8,"y":0,"w":4,"h":6,"i":"8", static: false},
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
            lastMouseEvent:null
        }
    },
    methods: {
        gridMovedEvent() {
            this.gridLayoutHeight = parseInt(document.getElementById("grid-layout").style.height.replace('px',''))
            this.gridLayoutWidth = parseInt(document.getElementById("grid-layout").style.width.replace('px',''))

            //높이
            if(this.gridLayoutHeight > window.innerHeight / this.transformScale)
                this.ZoomOut()
            else if(window.innerHeight / this.transformScale === window.innerHeight)
                return;
            else if(this.gridLayoutHeight+100 < window.innerHeight / this.transformScale)
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
                console.log(radians,degree)

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
    background: #ccc;
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
</style>