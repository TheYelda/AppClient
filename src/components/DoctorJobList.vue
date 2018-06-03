<template>
    <el-row>
        <el-table :data="jobs" stripe>
            <el-table-column type="index" width="55"></el-table-column>
            <el-table-column prop="job_id" label="任务编号"></el-table-column>
            <el-table-column prop="image_id" label="图片编号"></el-table-column>
            <el-table-column prop="label_id" label="标注编号"></el-table-column>
            <el-table-column prop="state" label="状态"></el-table-column>
            <el-table-column prop="finished_date" label="完成日期"></el-table-column>
        </el-table>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'DoctorJobList',
  components: {
    // ...
  },

  data() {
    return {
      jobs: []
    }
  },
  created() {
    // load data
    this.loadJobs()
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
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
