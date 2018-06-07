<template>
  <el-card>
    <el-form :model="loginForm">
        <el-form-item><el-input placeholder="用户名" v-model="loginForm.username"></el-input></el-form-item>
        <el-form-item><el-input type="password" placeholder="密码" v-model="loginForm.password"></el-input></el-form-item>
        <el-form-item><el-button type="primary" @click="login">登录</el-button></el-form-item>
        <el-form-item><el-button type="text" @click="switchToRegister">没有账号？前往注册</el-button></el-form-item>
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
        loginForm: {
            username: '',
            password: ''
        }
      }
  },
  methods: {
      login() {
        if (!window.localStorage) {
            this.$message.error('浏览器不支持本地缓存，请升级！')
        } else if (this.checkLoginForm()) {
            this.postLoginForm();
        }
      },

      checkLoginForm() {
        if (this.loginForm.username == '') {
            this.$message.error('请输入用户名');
            return false;
        } 
        if (this.loginForm.password == '') {
            this.$message.error('请输入密码');
            return false;
        }
        return true;
      },

      postLoginForm() {
          this.$http.post(config.apiUrl + '/authorization/', this.loginForm).then(res => {
            // eslint-disable-next-line
            console.log(res)

            window.localStorage.setItem('user', JSON.stringify(res.body))

            var authority = res.body.authority
            var authorityCode = [ 100, 101, 102, 103 ]

            for (var code = 0; code < authorityCode.length; code++) {
                if (authority == authorityCode[code]) {
                    if (code == 0) {
                        this.$message.info('请联系管理员获取权限')
                    } else {
                        this.$message.success(res.body.message)
                        this.$emit('pass', code)
                    }
                }
            }
          }, res => {
            this.$message.error(res.body.message)
            // eslint-disable-next-line
            console.log(res)
          })
          
      },

      switchToRegister() {
          this.$emit('switchToRegister', false)
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
