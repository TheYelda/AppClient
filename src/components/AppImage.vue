<template>
  <div>
    <div>
      <img :src="url" id="theImage">
    </div>
    <div style="display: block;">
    <el-button @click="initViewer" type="primary" style="margin-bottom: 10px;">放大镜</el-button>
    <el-button @click="checkOrigin" style="margin-bottom: 10px;">查看原图</el-button>
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
        base: '',
        brightness: 100,
        contrast: 100,
        hasViewr: false,
        isViewing: true
      }
  },

  methods: {
    initViewer() {
      $("#theImage").elevateZoom({
        zoomType: "lens",//类型：透镜效果 
        lensShape: "round", //透镜形状：圆形 
        scrollZoom: true //是否开启鼠标滚动 
      });
    },
    changeBrightness() {
      var value = this.brightness
      document.getElementById("theImage").style.filter = "brightness(" + value + "%)";
    },
    changeContrast() {
      var value = this.contrast
      document.getElementById("theImage").style.filter = "contrast(" + value + "%)";
    },
    useFilter() {
      if (!this.base) this.base = this.url
      this.url = this.base + '?green_channel=true'
    },
    checkOrigin() {
      if (!this.base) this.base = this.url
      this.url = this.base
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
