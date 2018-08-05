<template>
  <div>
    <div v-if="isViewing">
      <img :src="url" id="theImage">
    </div>
    <div v-else>
      <canvas id="theCanvas"></canvas>
    </div>
    <div style="display: block;">
    <el-button @click="initViewer" type="primary" style="margin-bottom: 10px;">自由缩放</el-button>
    <el-button @click="useFilter" style="margin-bottom: 10px;">去除赤光</el-button>
    </div>
    <span>亮度调节</span>
    <el-slider v-model="brightness" @change="changeBrightness" :min="0" :max="200"></el-slider>
    <span>对比度调节</span>
    <el-slider v-model="contrast" @change="changeContrast" :min="0" :max="200"></el-slider>
  </div>
</template>

<script>
// import config from './AppConfig.vue'

export default {
  name: 'AppImage',
  components: {
    // ...
  },
  props: {
      url: String
  },
  data() {
      return {
        brightness: 100,
        contrast: 100,
        hasViewr: false,
        isViewing: true
      }
  },

  methods: {
    initViewer() {
      this.isViewing = true
      this.brightness = 0
      $("#theImage").elevateZoom({
        zoomType: "lens",//类型：透镜效果 
        lensShape: "round", //透镜形状：圆形 
        scrollZoom: true //是否开启鼠标滚动 
      });
      // if (true) {
      //   var i = 0
      //   setTimeout(function() { 
      //     var viewer = new Viewer(document.getElementById('theImage'), {
      //       inline: false,
      //       viewed: function() {
      //         viewer.zoomTo(1);
      //       }
      //     }); 
      //     this.hasViewr = true
      //   }, 1000)
      // }
    },
    changeBrightness() {
      // this.isViewing = false
      var src = this.url
      var value = this.brightness
      var second = this.contrast
      // Caman("#theCanvas", src, function () {
      //   this.revert(false)
      //   this.brightness(value).contrast(second).render()
      //   var theCanvas = document.getElementById("theCanvas")
      //   theCanvas.style.height = 'auto'
      // })
      document.getElementById("theImage").style.filter = "brightness(" + value + "%)";
    },
    changeContrast() {
      // this.isViewing = false
      var src = this.url
      var first = this.brightness
      var value = this.contrast
      // Caman("#theCanvas", src, function () {
      //   this.revert(false)
      //   this.brightness(first).contrast(value).render()
      //   var theCanvas = document.getElementById("theCanvas")
      //   theCanvas.style.height = 'auto'
      // })
      document.getElementById("theImage").style.filter = "contrast(" + value + "%)";
    },
    useFilter() {
      this.isViewing = false
      var src = this.url
      var first = this.brightness
      var second = this.contrast
      Caman("#theCanvas", src, function () {
        this.revert(false)
        this.channels({
          red: -100,
          green: 0,
          blue: -100
        }).greyscale().brightness(first).contrast(second).render()
        var theCanvas = document.getElementById("theCanvas")
        theCanvas.style.height = 'auto'
      })
    }
  }
}


</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
img {
    max-width: 100%;
    max-height: auto;
    margin-top: 10px;
    margin-bottom: 10px;
}
canvas {
    max-width: 100%;
    max-height: auto !important;
    margin-top: 10px;
    margin-bottom: 10px;
}

div {
  overflow: hidden;
}

</style>
