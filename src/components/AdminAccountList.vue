<template>
    <el-row>
        <div>
            <el-button type="primary" @click="accountAuthChange">修改权限</el-button>
        </div>
        <el-table :data="getAccounts()" stripe @selection-change="changeAccountSelection">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="account_id" label="工号"></el-table-column>
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column prop="nickname" label="昵称"></el-table-column>
            <el-table-column prop="auth" label="权限身份"></el-table-column>
            <el-table-column prop="email" label="邮箱"></el-table-column>
        </el-table>

        <el-row>
            <el-pagination
                @size-change="changeAccountPageSize"
                @current-change="changeAccountPageCurrent"
                :current-page="accountPageCurrent"
                :page-sizes="accountPageSizes"
                :page-size="accountPageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="accounts.length">
            </el-pagination>
        </el-row>
        
        <el-dialog title="修改权限" :visible.sync="accountAuthVisible" center :show-close="false">
            <el-form>
                <el-form-item>
                    <el-row><el-col>
                    <el-select v-model="newAuthCode" placeholder="请选择权限" size="small">
                    <!-- <el-option label="医生" value=102></el-option>
                    <el-option label="客人" value=103></el-option>
                    <el-option label="无权限" value=100></el-option> -->
                    <el-option
                        v-for="item in options"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                    >
                    </el-option>
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
      options: [{
          value: '102',
          label: '医生'
      }, {
          value: '103',
          label: '客人'
      }, {
          value: '100',
          label: '无权限'
      }],
      newAuthCode: '',
      accountPageCurrent: 1,  // 当前任务列表页码数
      accountPageSizes: [5, 10, 30, 50],  // 可选任务列表页面最大项目数列表
      accountPageSize: 10  // 任务列表页面最大项目数
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
    changeAccountPageSize: function (val) {
        this.accountPageSize = val;
    },
    changeAccountPageCurrent: function (val) {
        this.accountPageCurrent = val;
    },
    getAccounts() {
        var len = this.accounts.length;
        if (this.accountPageSize >= len) {
            return this.accounts;
        } else {
            var accountPages = [];
            for (var i = 0; i < len; i += this.accountPageSize) {
                if (i + this.accountPageSize >= len) {
                    accountPages.push(this.accounts.slice(i));
                } else {
                    accountPages.push(this.accounts.slice(i, i + this.accountPageSize));
                }
            }
            return accountPages[this.accountPageCurrent - 1];
        }
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
                data["authority"] = this.newAuthCode
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
