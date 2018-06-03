<template>
    <el-row :gutter="20">
        
        <el-col :span="24">
            <el-form :model="accountForm">
                <el-form-item label="工号">
                    <el-input v-model="accountForm.account_id" :disabled="true" :placeholder="accountForm.account_id"></el-input>
                </el-form-item>
                <el-form-item label="用户名">
                    <el-input v-model="accountForm.username" :disabled="true" :placeholder="accountForm.username"></el-input>
                </el-form-item>
                <el-form-item label="昵称">
                    <el-input v-model="accountForm.nickname" :disabled="true" :placeholder="accountForm.nickname"></el-input>
                </el-form-item>
                <el-form-item label="权限">
                    <el-input v-model="accountForm.authority" :disabled="true" :placeholder="accountForm.authority"></el-input>
                </el-form-item>
                <el-form-item label="邮件">
                    <el-input v-model="accountForm.email"></el-input>
                </el-form-item>
                <el-form-item label="密码">
                    <el-input v-model="accountForm.password"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button >修改账户信息</el-button>
                    <el-button type="primary" @click="logout">登出</el-button>
                </el-form-item>
            </el-form>
        </el-col>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AdminInfoSetting',
  components: {
    // ...
  },

  data() {
    return {
      accountForm: {}
    }
  },
  created() {
    this.loadInfo()
  },

  methods: {
    loadInfo() {
      var userInfo = JSON.parse(window.localStorage.getItem('user'))
      var id = userInfo.account_id
        this.$http.get(config.apiUrl + '/accounts/' + id).then(res => {
        //   this.$message.success(res.body.message)
          delete res.body.message
          this.accountForm = res.body
      }, res => {
          this.$message.error(res.body.message)
          // eslint-disable-next-line
          console.log(res)
      });
    },
    logout() {
      this.$http.delete(config.apiUrl + '/authorization/').then(res => {
        this.$message.success(res.body.message)
        window.localStorage.removeItem('user')
        this.$emit('pass', 0)
      }, res => {
        this.$message.error(res.body.message)
        // eslint-disable-next-line
        console.log(res)
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
