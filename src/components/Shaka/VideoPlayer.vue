
<template>
  <div ref="videoContainer" class="" :style="style">
    <video
        style="width:98.5%; height:100%;"
        id="video"
        loop
        ref="videoPlayer"
        autoplay
        :src="this.manifestUrl.indexOf('assets') > -1 ? require(this.manifestUrl) : this.manifestUrl"
        muted
        class=""
        :poster="posterUrl"
    ></video>
  </div>
</template>

<script>
export default {
  props: {
    manifestUrl: {
      type: String,
      required: true
    },
    posterUrl: {
      type: String,
      required: false,
      default: ''
    },
    style: {
      type: String,
      required: false,
      default: ''
    }
  },
  watch: {
    'manifestUrl': function() {
      this.player
        .load(this.manifestUrl)
        .then(() => {
          // This runs if the asynchronous load is successful.
          console.log('The video has now been loaded!');
        })
        .catch(this.onError); // onError is executed if the asynchronous load fails
    }
  },
  data () {
    return {
      player:null
    }
  },
  mounted() {
    const shaka = require('shaka-player/dist/shaka-player.ui.js');
    this.player = new shaka.Player(this.$refs.videoPlayer);
    const ui = new shaka.ui.Overlay(
      this.player,
      this.$refs.videoContainer,
      this.$refs.videoPlayer
    );
    ui.getControls();
    this.player
      .load(this.manifestUrl)
      .then(() => {
        // This runs if the asynchronous load is successful.
        console.log('The video has now been loaded!');
      })
      .catch(this.onError); // onError is executed if the asynchronous load fails.
  },
  methods: {
    onError(error) {
      console.error('Error code', error.code, 'object', error);
    }
  }
};
</script>

<style>
@import '../../../node_modules/shaka-player/dist/controls.css'; /* Shaka player CSS import */
.size {
  width: 800px;
}
</style>