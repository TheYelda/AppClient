<template>
    <el-row>
        <el-table :data="accounts" stripe>
            <el-table-column type="index" width="55"></el-table-column>
            <el-table-column prop="account_id" label="工号"></el-table-column>
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column prop="nickname" label="昵称"></el-table-column>
            <el-table-column prop="auth" label="权限身份"></el-table-column>
            <el-table-column prop="email" label="邮箱"></el-table-column>
        </el-table>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AdminAccountList',
  components: {
    // ...
  },

  data() {
    return {
      accounts: []
    }
  },
  created() {
    // load data
    this.loadAccounts()
  },
  methods: {
    loadAccounts() {
      this.$http.get(config.apiUrl + '/accounts/').then(res => {
        // this.$message.success(res.body.message)
        this.accounts = res.body.data
        var accountAuthorityCode = { '100': '无权限', '101': '管理员', '102': '医生', '103': '客人' }
        for (var i = 0; i < this.accounts.length; i++) {
            this.accounts[i].auth = accountAuthorityCode[this.accounts[i].authority]
        }
      }, res => {
        this.$message.error('请求账户信息错误')
        // eslint-disable-next-line
        console.log(res)
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
