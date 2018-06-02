<template>
    <el-row>
        <el-table :data="accounts" stripe>
            <el-table-column type="index" width="55"></el-table-column>
            <el-table-column prop="account_id" label="工号"></el-table-column>
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column prop="nickname" label="昵称"></el-table-column>
            <el-table-column prop="authority" label="权限身份"></el-table-column>
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
    this.$http.get(config.apiUrl + '/accounts/').then(res => {
        this.$message.success(res.body.message)
        this.accounts = res.body.data
    }, res => {
        this.$message.error('请求账户信息错误')
        console.log(res)
    })
  },
  methods: {
    // ...
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
