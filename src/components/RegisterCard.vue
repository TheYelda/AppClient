<template>
  <el-card>
    <el-form :model="registerForm">
        <el-form-item><el-input placeholder="用户名" v-model="registerForm.username"></el-input></el-form-item>
        <el-form-item><el-input placeholder="昵称" v-model="registerForm.nickname"></el-input></el-form-item>
        <el-form-item><el-input placeholder="邮箱" v-model="registerForm.email"></el-input></el-form-item>
        <el-form-item><el-input type="password" placeholder="密码" v-model="registerForm.password"></el-input></el-form-item>
        <el-form-item><el-input type="password" placeholder="确认密码" v-model="passwordShadow"></el-input></el-form-item>
        <el-form-item><el-button type="primary" @click="register">注册</el-button></el-form-item>
        <el-form-item><el-button type="text" @click="switchToLogin">已有账号？返回登录</el-button></el-form-item>
    </el-form>
  </el-card>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'LoginCard',
  http() {
      return {
        headers: { 'Content-Type': 'application/json' }
      }
  },
  data() {
      return {
        registerForm: {
            username: '',
            nickname: '',
            email: '',
            password: ''
        },
        passwordShadow: ''
      }
  },
  methods: {
      register() {
          if (this.checkRegisterForm()) {
              return this.postRegisterForm()
          }
      },
      checkRegisterForm() {
          return true
      },
      postRegisterForm() {
          this.$http.post(config.apiUrl + '/accounts/', this.registerForm).then(res => {
            // eslint-disable-next-line
            console.log(res)
          }, res => {
            // eslint-disable-next-line
            console.log(res)
          })
      },
      switchToLogin() {
          this.$emit('switchToLogin', true)
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.el-button {
    /* display: block; */
    width: 100%;
}
</style>
