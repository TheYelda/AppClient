<template>
    <el-row>
        <el-table :data="jobs" stripe>
            <el-table-column type="index" width="55"></el-table-column>
            <el-table-column prop="job_id" label="任务编号"></el-table-column>
            <el-table-column prop="image_id" label="图片编号"></el-table-column>
            <el-table-column prop="label_id" label="标注编号"></el-table-column>
            <el-table-column prop="job_state" label="状态"></el-table-column>
            <el-table-column prop="finished_date" label="完成日期"></el-table-column>
        </el-table>
    </el-row>
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
      jobs: []
    }
  },
  created() {
    // load data
    this.$http.get(config.apiUrl + '/jobs').then(res => {  // NEED
        this.$message.success(res.body.message)
        this.jobs = res.body.data;
    }, res => {
        this.$message.error('请求任务信息错误')
        console.log(res)
    });
  },
  methods: {
    // ...
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
