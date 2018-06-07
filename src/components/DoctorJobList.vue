<template>
    <el-row>
        <el-col v-if="jobListVisible">
            
            <el-table :data="curPage" stripe @row-click="clickJobRow">
                <el-table-column type="index" width="55"></el-table-column>
                <el-table-column prop="job_id" label="任务编号"></el-table-column>
                <el-table-column prop="image_id" label="图片编号"></el-table-column>
                <el-table-column prop="label_id" label="标注编号"></el-table-column>
                <el-table-column 
                    prop="job_state" 
                    label="状态"
                    :filters="[{text:'未标注', value:'未标注'}, {text:'标注中', value:'标注中'}, {text:'已完成', value:'已完成'}]"
                    :filter-method="filterHandler"
                ></el-table-column>
                <el-table-column prop="finished_date" label="完成日期"></el-table-column>
            </el-table>
            <el-col :span="10">
                <el-pagination
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    :page-sizes="[5, 10, 15, 20]"
                    :page-size="pageSize"
                    :current-page="curPageNum"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="jobs.length">
                </el-pagination>
            </el-col>
        </el-col>
        <el-col v-else>
            <el-row :gutter="20">
                <el-col :span="20">
                    <el-button @click="backToJobList">返回</el-button>
                    <AppImage :url="imageUrl"/>
                </el-col>
                <el-col :span="4">
                    <AppLabel :label="labelId" :submitId="jobId" @createLabel="setLabelId"/>
                </el-col>
            </el-row>
        </el-col>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'
import AppImage from './AppImage.vue'
import AppLabel from './AppLabel.vue'

export default {
  name: 'DoctorJobList',
  components: {
    AppImage,
    AppLabel
  },

  data() {
    return {
      jobs: [],
      jobListVisible: true,
      jobIndex: 0,
      imageUrl: '',
      labelId: -1,
      jobId: -1,
      pageSize: 5,
      curPage: [],
      curPageNum: 1,
      firstIndex: 0,
      lastIndex: 0
    }
  },
  created() {
    // load data
    this.loadJobs()
    this.firstIndex = 0
    this.lastIndex = (this.jobs.length < this.firstIndex + this.pageSize ? this.jobs.length - 1 : this.firstIndex + this.pageSize - 1 )
    this.refreshCurPage()
  },
  methods: {
    loadJobs() {
      var userInfo = JSON.parse(window.localStorage.getItem('user'))
      this.$http.get(config.apiUrl + '/jobs/?account_id=' + userInfo.account_id).then(res => {  // NEED
        // this.$message.success(res.body.message)
        this.jobs = res.body.data;
        var jobStateCode = { '200': '未标注', '201': '标注中', '202': '已完成' }
        for (var i = 0; i < this.jobs.length; i++) {
            this.jobs[i].state = jobStateCode[this.jobs[i].job_state]
        }
      }, res => {
        this.$message.error('请求任务信息错误')
        // eslint-disable-next-line
        console.log(res)
      });
    },
    clickJobRow(row) {
        this.jobListVisible = false
        this.$http.get(config.apiUrl + '/images/' + row.image_id).then(res => {
            this.imageUrl = config.apiUrl + '/uploads/medical-images/' + res.body.filename
        }, res => {
            // eslint-disable-next-line
            console.log(res)
        })
        if (!row.label_id) {
            this.labelId = -1
        }
        this.jobId = row.job_id
    },
    backToJobList() {
        this.jobListVisible = true
        this.loadJobs()
    },
    setLabelId(id) {
        this.labelId = id
        this.loadJobs()
    },
    filterHandler(value, row) {
        return row.job_state == value
    },
    handleSizeChange(size) {
        this.pageSize = size
        this.handleCurrentChange(1)
    },
    handleCurrentChange(curPageNum) {
        this.curPageNum = curPageNum
        this.firstIndex = (this.curPageNum - 1) * this.pageSize
        this.lastIndex = (this.jobs.length < this.firstIndex + this.pageSize ? this.jobs.length - 1 : this.firstIndex + this.pageSize - 1 )
        this.refreshCurPage()
    },
    refreshCurPage() {
        this.curPage = []
        for (var i = this.firstIndex; i <= this.lastIndex; ++i) {
            this.curPage.push(this.jobs[i])
        } 
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
