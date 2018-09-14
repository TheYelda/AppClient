<template>
    <el-row>
        <el-col v-if="jobListVisible">
          <div>
            <el-select v-model="stateFilter" placeholder="请选择只显示的任务状态" @change="changeStateFilter" style="float: right;">
              <el-option
                v-for="item in stateFilters"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              >
              </el-option>
            </el-select>
          </div>
            <el-table :data="jobs" stripe @row-click="clickJobRow">
                <el-table-column type="index" width="55"></el-table-column>
                <el-table-column prop="job_id" label="任务编号"></el-table-column>
                <el-table-column prop="image_id" label="图片编号"></el-table-column>
                <el-table-column prop="label_id" label="标注编号"></el-table-column>
                <el-table-column prop="job_state" label="状态"></el-table-column>
                <el-table-column prop="finished_date" label="完成日期"></el-table-column>
            </el-table>
            <el-row style="margin-top: 20px;">
                <el-pagination
                    @size-change="changeJobPageSize"
                    @current-change="changeJobPageCurrent"
                    :page-sizes="jobPageSizes"
                    :page-size="jobPageSize"
                    :current-page="jobPageCurrent"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="total">
                </el-pagination>
            </el-row>
        </el-col>
        <el-col v-else>
            <el-row :gutter="20">
                <el-col :span="20">
                    <el-button @click="backToJobList">返回</el-button>
                    <AppImage :url="imageUrl"/>
                    <el-button-group>
                    <el-button @click="toPreImage" icon="el-icon-arrow-left">上一张</el-button>
                    <el-button>第 {{ jobIndex+1 }} 张</el-button>
                    <el-button @click="toNextImage">下一张<i class="el-icon-arrow-right el-icon--right"></i></el-button>
                    </el-button-group>
                </el-col>
                <el-col :span="4">
                    <AppLabel :label="labelId" :submitId="jobId" @createLabel="setLabelId" @nextImage="toNextImage"/>
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
      accountId: -1,
      jobs: [],
      total: 0,

      stateFilter: '0',
      stateFilters: [
        { value: '0', label: '显示所有' },
        { value: '200', label: '未标注' },
        { value: '201', label: '标注中' },
        { value: '202', label: '已完成' }
      ],

      // info
      jobListVisible: true,
      imageUrl: '',
      jobIndex: -1,
      jobId: -1,
      labelId: -1,  // no label

      // 分页参数
      jobPageCurrent: 1,  // 页码数
      jobPageSizes: [5, 10, 30, 50, 1000, 2000, 5000],  // 可选最大项目数列表
      jobPageSize: 10  // 最大项目数
    }
  },
  created() {
    this.loadJobs()
  },
  methods: {
    loadJobs(needCallback) {
      var offset = (this.jobPageCurrent - 1) * this.jobPageSize

      var id = JSON.parse(window.localStorage.getItem('user')).account_id
      var url = config.apiUrl + '/jobs/?account_id=' + id
      if (this.stateFilter != '0') url = url +  '&job_state=' + this.stateFilter
      url = url + '&offset=' + offset + '&limit=' + this.jobPageSize

      this.$http.get(url).then(res => {
        this.jobs = res.body.data
        this.total = res.body.total
        var jobStateCode = { '200': '未标注', '201': '标注中', '202': '已完成' }
        for (var i = 0; i < this.jobs.length; i++) {
            this.jobs[i].job_state = jobStateCode[this.jobs[i].job_state]
        }
        if (needCallback == 'prev') this.changeImageAndLabel('prev')
        else if (needCallback == 'next') this.changeImageAndLabel('next')
      }, res => {
        this.$message.error('请求任务信息错误')
        // eslint-disable-next-line
        console.log(res)
      });
    },
    changeStateFilter() {
      this.jobPageCurrent = 1
      this.loadJobs()
    },
    clickJobRow(row) {
      if (row.job_state == '已完成') return this.$message.info("已完成无法查看")
      this.jobListVisible = false
      this.queryJobById(row.job_id)  // just update jobIndex

      this.$http.get(config.apiUrl + '/images/' + row.image_id).then(res => {
        this.imageUrl = config.apiUrl + '/uploads/medical-images/' + res.body.url
      }, res => {
        // eslint-disable-next-line
        console.log(res)
      })
      this.jobId = row.job_id
      if (!row.label_id) {
        this.labelId = -1
      } else {
        this.labelId = row.label_id  // set label id
      }
    },
    backToJobList() {
      // eslint-disable-next-line
      $("div").remove(".zoomContainer")
      this.jobListVisible = true
      this.loadJobs()
    },
    setLabelId(id) {
      this.labelId = id
    },
    filterHandler(value, row) {
      return row.job_state == value
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
    },
    toPreImage() {
      if (this.jobIndex == 0) return this.$message.info('当前已经是第一张图像了')
      else {
        this.jobIndex--
        if ((this.jobIndex + 1) <= (this.jobPageCurrent - 1) * this.jobPageSize) {
          this.jobPageCurrent--  // prev page
          this.loadJobs('prev')
        } else {
          this.changeImageAndLabel('prev')
        }
      }
    },
    toNextImage(isAuto) {
      if (isAuto) this.loadJobs()  // a job is done after submit
      if (this.jobIndex == this.total - 1) return this.$message.info('当前已经是最后一张图像了')
      else {
        this.jobIndex++
        if ((this.jobIndex + 1) > this.jobPageCurrent * this.jobPageSize) {
          this.jobPageCurrent++  // next page
          this.loadJobs('next')
        } else {
          this.changeImageAndLabel('next')
        }
      }
    },
    changeImageAndLabel(flag) {
      var index = this.jobIndex % this.jobPageSize  // index in the subset

      if (this.jobs[index].job_state == '已完成') {
        if (flag == 'prev') {
          this.$message.error("上一张已完成无法查看")
          this.jobIndex++
          if (this.index == this.jobPageSize - 1) this.jobPageCurrent++  // had changed page, need to reset
        }
        else if (flag == 'next') {
          this.$message.error("下一张已完成无法查看")
          this.jobIndex--
          if (this.index == 0) this.jobPageCurrent--  // had changed page, need to reset
        }
        this.loadJobs()
      } else {
        this.$http.get(config.apiUrl + '/images/' + this.jobs[index].image_id).then(res => {
          this.imageUrl = config.apiUrl + '/uploads/medical-images/' + res.body.url
        })
        this.jobId = this.jobs[index].job_id
        if (this.jobs[index].label_id) this.labelId = this.jobs[index].label_id  // has label
        else this.labelId = -1
        // eslint-disable-next-line
        $("div").remove(".zoomContainer")
      }
    },
    queryJobById(id) {
      for (var i = 0; i < this.jobs.length; ++i) {
        if (this.jobs[i].job_id == id) {
          this.jobIndex = this.jobPageSize * (this.jobPageCurrent - 1) + i
          return this.jobs[i]
        }
      }
      return null
    }
  }
}
</script>