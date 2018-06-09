<template>
    <el-row :gutter="20">
        <el-col :span="6">
            <el-upload
                class="avatar-uploader"
                :action="photoUploadUrl"
                :show-file-list="false"
                :auto-upload="true"
                :on-success="handlePhotoSuccess"
                :before-upload="beforePhotoUpload">
                <img v-if="photoUrl" :src="photoUrl" class="avatar">
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>    
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
        //   this.$message.success(res.body.message)
          delete res.body.message
          this.accountForm = res.body
          this.photoUrl = config.apiUrl + '/uploads/photos/' + res.body.photo
      }, res => {
          this.$message.error(res.body.message)
          // eslint-disable-next-line
          console.log(res)
      });
    },
    postAccountForm() {
        var data = this.accountForm, id = this.accountForm.account_id
        delete data.account_id
        this.$http.post(config.apiUrl + '/accounts/' + id, data).then(res => {
            this.$message.success(res.body.message)
            this.loadInfo()
        }, res => {
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
.avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 20vw;
    height: 20vw;
    line-height: 20vw;
    text-align: center;
  }
  .avatar {
    width: 20vw;
    height: 20vw;
    display: block;
  }
</style>
