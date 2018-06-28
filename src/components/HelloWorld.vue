<template>
  <el-container>
    <el-header></el-header>

    <el-main>
      <el-row>
        <el-col :span="6" :offset="8">
          <h1>眼底图像标注系统</h1>
          <div v-if="isLogin"><LoginCard @switchToRegister="switchCard" @pass="passCode"/></div>
          <div v-else><RegisterCard @switchToLogin="switchCard"/></div>
        </el-col>
      </el-row>
    </el-main>

    <el-footer></el-footer>
  </el-container>
</template>

<script>
import LoginCard from './LoginCard.vue'
import RegisterCard from './RegisterCard.vue'

export default {
  name: 'HelloWorld',
  components: {
    LoginCard,
    RegisterCard
  },
  data() {
    return {
      isLogin: true
    }
  },
  methods: {
    switchCard(flag) {
      this.isLogin = flag
    },
    passCode(code) {
      this.$emit('goPage', code)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  text-align: center;
}
</style>
