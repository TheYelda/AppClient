<template>
  <el-container>
    <el-header>
        <AppHeader tabs="任务列表,用户设置" @switchTab="whichTab"/>
    </el-header>

    <el-main>
        <el-card>
            <div v-if="inJobList()"><DoctorJobList /></div>
            <div v-if="inInfoSetting()"><AppInfoSetting @pass="passCode"/></div>
        </el-card>
    </el-main>

    <el-footer></el-footer>
  </el-container>
</template>

<script>
// import config from './AppConfig.vue'
import AppHeader from './AppHeader.vue'
import AppInfoSetting from './AppInfoSetting.vue'
import DoctorJobList from './DoctorJobList.vue'

export default {
  name: 'DoctorPage',
  components: {
    AppHeader,
    AppInfoSetting,
    DoctorJobList
  },
  data() {
      return {
          activeTab: 0
      }
  },
  created() {
    var userInfo = window.localStorage.getItem('user')

    if (!userInfo) {
      this.$message.error('对不起，您还未登录，请先登录！')
      setTimeout(() => {
        this.$emit('logout', 0)  // hello world
      }, 1000)
    } else {
        // eslint-disable-next-line
        console.log(userInfo)
    }
  },
  methods: {
      whichTab(index) {
          this.activeTab = index
      },
      inJobList() {
          return this.activeTab == 0
      },
      inInfoSetting() {
          return this.activeTab == 1
      },
      passCode(code) {
          this.$emit('logout', code)
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
