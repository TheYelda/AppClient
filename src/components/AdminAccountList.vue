<template>
    <el-row>
        <div>
            <el-button type="primary" @click="accountAuthChange">修改权限</el-button>
        </div>
        <el-table :data="accounts" stripe @selection-change="changeAccountSelection">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="account_id" label="工号"></el-table-column>
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column prop="nickname" label="昵称"></el-table-column>
            <el-table-column prop="auth" label="权限身份"></el-table-column>
            <el-table-column prop="email" label="邮箱"></el-table-column>
        </el-table>

        <el-dialog title="修改权限" :visible.sync="accountAuthVisible" center :show-close="false">
            <el-form>
                <el-form-item>
                    <el-row><el-col>
                    <el-select v-model="newAuthCode" placeholder="请选择权限" size="small">
                    <el-option label="医生" value=102></el-option>
                    <el-option label="客人" value=103></el-option>
                    <el-option label="无权限" value=100></el-option>
                    </el-select>
                    <el-button type="primary" @click="confirmAuthChange" style="margin-left: 10px;" size="small">确 定</el-button>
                    </el-col></el-row>
                </el-form-item>
            </el-form>
        </el-dialog>
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
      accounts: [],
      accountAuthVisible: false,
      accountSelection: [],
      newAuthCode: ''
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
    },
    changeAccountSelection(val) {
        this.accountSelection = val
    },
    accountAuthChange() {
        if (!this.accountSelection.length) {
            this.$message.error('请选择需要修改权限的账户')
        } else {
            this.accountAuthVisible = true
        }
    },
    confirmAuthChange() {
        if (this.newAuthCode) {
            for (var i = 0; i < this.accountSelection.length; i++) {
                var data = this.accountSelection[i]
                var id = data.account_id
                delete data.auth
                delete data.account_id
                this.$http.put(config.apiUrl + '/accounts/' + id, data).then(res => {
                    this.$message.success(res.body.message)
                    this.loadAccounts()
                }, res => {
                    // eslint-disable-next-line
                console.log(res)
                })
            }
        }
        this.newAuthCode = ''
        this.accountAuthVisible = false
        this.accountSelection = []
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
