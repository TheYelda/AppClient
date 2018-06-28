<template>
  <el-container>
    <el-header>
        <AppHeader tabs="图像列表,任务列表,账户列表,用户设置" @switchTab="whichTab"/>
    </el-header>

    <el-main>
        <el-card>
            <div v-if="inImageList()"><AdminImageList @pass="passCode"/></div>
            <div v-if="inJobList()"><AdminJobList/></div>
            <div v-if="inAccountList()"><AdminAccountList/></div>
            <div v-if="inInfoSetting()"><AppInfoSetting @pass="passCode"/></div>
        </el-card>
    </el-main>

    <el-footer></el-footer>
  </el-container>
</template>

<script>
// import config from './AppConfig.vue'
import AppHeader from './AppHeader.vue'
import AdminImageList from './AdminImageList.vue'
import AdminJobList from './AdminJobList.vue'
import AdminAccountList from './AdminAccountList.vue'
import AppInfoSetting from './AppInfoSetting.vue'

export default {
  name: 'AdminPage',
  components: {
    AppHeader,
    AdminImageList,
    AdminJobList,
    AdminAccountList,
    AppInfoSetting,
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
      inImageList() {
          return this.activeTab == 0
      },
      inJobList() {
          return this.activeTab == 1
      },
      inAccountList() {
          return this.activeTab == 2
      },
      inInfoSetting() {
          return this.activeTab == 3
      },
      passCode(code) {
          this.$emit('logout', code)
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.el-main {
    margin-top: 64px;
}
</style>
