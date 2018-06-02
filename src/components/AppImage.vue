<template>
  <img :src="url">
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
      return {}
  },
  methods: {}
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
img {
    max-width: 100%;
    max-height: auto;
}
</style>
