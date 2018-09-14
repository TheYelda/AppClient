<template>
    <div>
        <el-row>
            <el-table :data="jobs" stripe>
                <el-table-column prop="job_id" label="任务编号"></el-table-column>
                <el-table-column prop="image_id" label="图片编号"></el-table-column>
                <el-table-column prop="label_id" label="标注编号"></el-table-column>
                <el-table-column prop="nickname" label="医生昵称"></el-table-column>
                <el-table-column prop="state" label="状态"></el-table-column>
                <el-table-column prop="finished_date" label="完成日期"></el-table-column>
            </el-table>
        </el-row>

        <el-row style="margin-top: 20px;">
            <el-pagination
                @size-change="changeJobPageSize"
                @current-change="changeJobPageCurrent"
                :current-page="jobPageCurrent"
                :page-sizes="jobPageSizes"
                :page-size="jobPageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total">
            </el-pagination>
        </el-row>
    </div>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AdminJobList',
  components: {
    // ...
  },

  data() {
    return {
      jobs: [],
      total: 0,
      jobPageCurrent: 1,  // 当前任务列表页码数
      jobPageSizes: [5, 10, 30, 50, 1000, 2000, 5000],  // 可选任务列表页面最大项目数列表
      jobPageSize: 10  // 任务列表页面最大项目数
    }
  },
  created() {
    this.loadJobs()
  },
  methods: {
    loadJobs() {
      var offset = (this.jobPageCurrent - 1) * this.jobPageSize
      this.$http.get(config.apiUrl + '/jobs/' + '?offset=' + offset + '&limit=' + this.jobPageSize).then(res => {
        this.jobs = res.body.data
        this.total = res.body.total
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
    changeJobPageSize(val) {
      this.jobPageSize = val
      if (this.total <= this.jobPageSize * (this.jobPageCurrent - 1)) {  // 容量溢出
        this.jobPageCurrent = Math.ceil(this.total / this.jobPageSize)
      }
      this.loadJobs()
    },
    changeJobPageCurrent(val) {
      this.jobPageCurrent = val
      this.loadJobs()
    }
  }
}
</script>