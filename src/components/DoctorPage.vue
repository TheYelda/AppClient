<template>
  <el-container>
    <el-header>
        <AppHeader tabs="任务列表,用户设置"/>
    </el-header>

    <el-main></el-main>

    <el-footer></el-footer>
  </el-container>
</template>

<script>
// import config from './AppConfig.vue'
import AppHeader from './AppHeader.vue'

export default {
  name: 'DoctorPage',
  components: {
    AppHeader
  },
  data() {
      return {}
  },
  methods: {}
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
