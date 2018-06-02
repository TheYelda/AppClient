<template>
    <el-row>
        <el-table :data="images" stripe>
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="image_id" label="图片编号"></el-table-column>
            <el-table-column prop="filename" label="图片名称"></el-table-column>
            <el-table-column prop="source" label="来源"></el-table-column>
            <el-table-column prop="image_state" label="状态">
            </el-table-column>
        </el-table>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AdminImageList',
  components: {
    // ...
  },

  data() {
    return {
      images: []
    }
  },
  created() {
    // load data
    this.$http.get(config.apiUrl + '/images/').then(res => {
        this.$message.success(res.body.message)
        this.images = res.body.data
    }, res => {
        this.$message.error('请求图像信息错误')
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
