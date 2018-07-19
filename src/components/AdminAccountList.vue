<template>
    <el-row>
        <el-col v-if="accountListVisible">
        <div>
            <el-button type="primary" @click="accountAuthChange">修改权限</el-button>
            <el-button @click="allResultDownload">下载所有</el-button>
        </div>
        <el-table :data="getAccounts()" stripe @selection-change="changeAccountSelection" @row-click="clickAccountRow">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="account_id" label="工号"></el-table-column>
            <el-table-column prop="username" label="用户名"></el-table-column>
            <el-table-column prop="nickname" label="昵称"></el-table-column>
            <el-table-column prop="auth" label="权限身份"
                :filters="authorityFilter"
                :filter-method="filterHandler">
            </el-table-column>
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

        </el-col>
        <el-col v-else>
            <el-row>
                <el-button @click="backToAccountList">返回</el-button>
                <el-button @click="accountResultDownload">下载个人</el-button>
                <el-tree :data="accountPerformance" :props="defaultProps" accordion></el-tree>
            </el-row>
        </el-col>


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
      accountListVisible: true,
      accounts: [],
      accountSelectedId: 0,
      accountPerformance: [
          { label: '进度', children: [{label: '任务总数：'}, {label: '未标注：'}, {label: '标注中：'}, {label: '已完成：'}] },
          { label: '图片质量', children: [{label: '准确率：'}] },
          { label: '糖尿病视网膜病变', children: [{label: '准确率：'}] },
          { label: '糖尿病视网膜病变阶段', children: [{label: '准确率：'}] },
          { label: '黄斑水肿', children: [{label: '准确率：'}] },
          { label: '高血压视网膜病变', children: [{label: '准确率：'}] },
          { label: '年龄相关性黄斑变性', children: [{label: '准确率：'}] },
          { label: '视网膜静脉阻塞', children: [{label: '准确率：'}] },
          { label: '视网膜动脉阻塞', children: [{label: '准确率：'}] },
          { label: '病理性近视', children: [{label: '准确率：'}] },
          { label: '视盘、视神经疾病', children: [{label: '准确率：'}] },
          { label: '疑似青光眼', children: [{label: '准确率：'}] },
          { label: '其他疾病', children: [{label: '准确率：'}] }
      ],
      authorityFilter: [{
          text: '医生',
          value: '医生'
      }, {
          text: '客人',
          value: '客人'
      }, {
          text: '无权限',
          value: '无权限'
      }, {
          text: '专家',
          value: '专家'
      }],
      accountAuthVisible: false,
      accountSelection: [],
      options: [{
          value: 102,
          label: '医生'
      }, {
          value: 103,
          label: '客人'
      }, {
          value: 100,
          label: '无权限'
      }, {
          value: 104,
          label: '专家'
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
        this.accounts = res.body.data
        var accountAuthorityCode = { '100': '无权限', '101': '管理员', '102': '医生', '103': '客人', '104': '专家' }
        for (var i = 0; i < this.accounts.length; i++) {
            this.accounts[i].auth = accountAuthorityCode[this.accounts[i].authority]
        }
      }, res => {
        this.$message.error('请求账户信息错误')
        // eslint-disable-next-line
        console.log(res)
      })
    },
    filterHandler(value, row, column) {
        const property = column['property'];
        return row[property] === value;
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
    },
    clickAccountRow(row) {
        var id = row.account_id
        this.accountSelectedId = id
        // request data
        var data;
        this.$http.get(config.apiUrl + '/accounts/performance/' + id).then(res => {
            this.$message.success(res.body.message)
            data = res.body.data

            for (var item in data) {
                if (item != 'progress') {
                    var dic = ['progress','quality','dr','stage','dme','hr','age_dme','rvo','crao','myopia','od','glaucoma','others']
                    var index = dic.indexOf(item)
                    this.accountPerformance[index].children[0].label = this.accountPerformance[index].children[0].label + data[item].accuracy.toString()
                } else {
                    var dic = ['total_jobs', 'unlabeled_jobs', 'labeling_jobs', 'finished_jobs']
                    for (var i in data.progress) {
                        var index = dic.indexOf(i)
                        this.accountPerformance[0].children[index].label = this.accountPerformance[0].children[index].label + data.progress[i].toString()
                    }
                }
            }
            this.accountListVisible = false
        }, res => {
            // eslint-disable-next-line
            console.log(res)
        })
    },
    backToAccountList() {
        this.accountListVisible = true
        this.accountPerformance[0].children[0].label = '任务总数：'
        this.accountPerformance[0].children[1].label = '未标注：'
        this.accountPerformance[0].children[2].label = '标注中：'
        this.accountPerformance[0].children[3].label = '已完成：'
        for (var i = 1; i <= 12; i++) {
            this.accountPerformance[i].children[0].label = '准确率：'
        }
    },
    allResultDownload() {
        this.$http.get(config.apiUrl + '/download/?').then(res => {
            console.log(res)
            this.download(res.body, 'all.csv')
        }, res => {
            this.$message.error(res.body.message)
            // eslint-disable-next-line
            console.log(res)
        })
    },
    accountResultDownload() {
        this.$http.get(config.apiUrl + '/download/?account_id=' + this.accountSelectedId).then(res => {
            this.download(res.body, this.accountSelectedId + '.csv')
        }, res => {
            this.$message.error(res.body.message)
            // eslint-disable-next-line
            console.log(res)
        })
    },
    download(data, filename) {
        if (!data) return

        var url = window.URL.createObjectURL(new Blob([data]))
        var link = document.createElement('a')
        link.style.display = 'none'
        link.href = url
        link.setAttribute('download', filename)
        document.body.appendChild(link)
        link.click()
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
