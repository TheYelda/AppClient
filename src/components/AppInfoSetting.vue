<template>
    <el-row :gutter="20">
        <el-col :span="6">
            <img :src="photoUrl" class="avatar">
            <el-upload
                :action="photoUploadUrl"
                :show-file-list="false"
                :auto-upload="true"
                :limit="1"
                :on-success="handlePhotoSuccess"
                :before-upload="beforePhotoUpload">
            <el-button><i class="el-icon-upload"></i>上传照片</el-button>
            </el-upload>
        </el-col>

        <el-col :span="14">
            <el-form :model="accountForm">
                <el-form-item label="工号">
                    <el-input v-model="accountForm.account_id" :disabled="true" :placeholder="accountForm.account_id"></el-input>
                </el-form-item>
                <el-form-item label="用户名">
                    <el-input v-model="accountForm.username" :disabled="true" :placeholder="accountForm.username"></el-input>
                </el-form-item>
                <el-form-item label="昵称">
                    <el-input v-model="accountForm.nickname" :disabled="true" :placeholder="accountForm.nickname"></el-input>
                </el-form-item>
                <el-form-item label="权限">
                    <el-input v-model="accountForm.authority" :disabled="true" :placeholder="accountForm.authority"></el-input>
                </el-form-item>
                <el-form-item label="邮件">
                    <el-input v-model="accountForm.email"></el-input>
                </el-form-item>
                <el-form-item label="密码">
                    <el-input v-model="accountForm.password"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button @click="postAccountForm">修改账户信息</el-button>
                    <el-button type="primary" @click="logout">登出</el-button>
                </el-form-item>
            </el-form>
        </el-col>
    </el-row>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AppInfoSetting',
  components: {
    // ...
  },

  data() {
    return {
      accountForm: {},
      photoUrl: '',
      photoUploadUrl: config.apiUrl + '/uploads/photos/'
    }
  },
  created() {
    this.loadInfo()
  },

  methods: {
    loadInfo() {
      var userInfo = JSON.parse(window.localStorage.getItem('user'))
      var id = userInfo.account_id
        this.$http.get(config.apiUrl + '/accounts/' + id).then(res => {
          delete res.body.message
          this.accountForm = res.body
          this.photoUrl = config.apiUrl + '/uploads/photos/' + res.body.photo + '/?timestamp=' + new Date().getTime()
      }, res => {
          this.$message.error(res.body.message)
          // eslint-disable-next-line
          console.log(res)
      });
    },
    postAccountForm() {
        var data = this.accountForm, id = this.accountForm.account_id
        delete data.account_id
        this.$http.put(config.apiUrl + '/accounts/' + id, data).then(res => {
            this.$message.success(res.body.message)
            this.loadInfo()
        }, res => {
            this.$message.error(res.body.message)
            // eslint-disable-next-line
            console.log(res)
        })
    },
    logout() {
      this.$http.delete(config.apiUrl + '/authorization/').then(res => {
        this.$message.success(res.body.message)
        window.localStorage.removeItem('user')
        this.$emit('pass', 0)
      }, res => {
        this.$message.error(res.body.message)
        // eslint-disable-next-line
        console.log(res)
      });
    },
    beforePhotoUpload: function(file) {
        const isJPGorPNG = (file.type === 'image/jpeg' || file.type === 'image/png');
        const isSizeLimit = file.size / 1024 / 1024 < 2;

        if (!isJPGorPNG) {
            this.$message.error('上传头像图片只能是 JPG 或 PNG 格式!');
        }
        if (!isSizeLimit) {
            this.$message.error('上传头像图片大小不能超过 2MB!');
        }
        return isJPGorPNG && isSizeLimit;
    },
    handlePhotoSuccess: function(response) {
        if (response.message == '头像上传成功') {
            this.$message.success(response.message);
            this.loadInfo();
        }
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .avatar {
    width: 20vw;
    height: 20vw;
    display: block;
    border: 1px dashed #409EFF;
    border-radius: 6px;
    cursor: pointer;
  }
</style>
