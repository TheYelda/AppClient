<template>
    <el-row>
        <el-col v-if="imageListVisible">
        <div>
            <el-button @click="imageUpload">导入图像</el-button>
            <el-button type="primary" @click="imageAssign">分配任务</el-button>
            <el-button type="danger" @click="imageDelete" icon="el-icon-delete">删除图像</el-button>
        </div>
        <el-table ref="imageTable" :data="images" stripe @selection-change="changeImageSelection" @row-click="clickImageRow">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="image_id" label="图片编号"></el-table-column>
            <el-table-column prop="name" label="图片名称"></el-table-column>
            <el-table-column prop="source" label="来源"></el-table-column>
            <el-table-column prop="state" label="状态">
            </el-table-column>
        </el-table>

        <el-dialog title="导入图像" :visible.sync="imageUploadVisible" center :show-close="false">
            <el-upload
                ref="upload"
                :action="imageUploadUrl"
                :multiple="true"
                :file-list="fileList"
                :auto-upload="false"
                :before-upload="beforeImageUpload"
                :on-success="successImageUpload">
                <el-button slot="trigger" size="small" type="primary">选取文件</el-button>
                <el-button style="margin-left: 10px;" size="small" type="success" @click="submitImageUpload">上传到服务器</el-button>
                <el-tooltip effect="dark" content="上传中的图像将被中止" placement="right">
                    <el-button @click="cancelImageUpload" size="small">关闭</el-button>
                </el-tooltip>
                <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过5MB</div>
            </el-upload>
        </el-dialog>

        <el-dialog title="分配任务" :visible.sync="imageAssignVisible" center :show-close="false">
            <el-button type="primary" size="small" @click="confirmImageAssign">确定分配</el-button>
            <el-button size="small" @click="cancelImageAssign">关闭</el-button>
            <el-table ref="doctorTable" :data="doctors" @selection-change="changeDoctorSelection">
                <el-table-column type="selection" width="55"></el-table-column>        
                <el-table-column prop="account_id" label="工号"></el-table-column>
                <el-table-column prop="username" label="账号"></el-table-column>
            </el-table>
        </el-dialog>

        <el-dialog title="删除图像" :visible.sync="imageDeleteVisible" center :show-close="false">
            <el-button size="small" @click="confirmImageDelete">确定</el-button>
            <el-button type="success" size="small" @click="cancelImageDelete">取消</el-button>
        </el-dialog>

        </el-col>
        <el-col v-else>
            <el-row :gutter="20">
                <el-col :span="20">
                    <el-button @click="backToImageList">返回</el-button>
                    <AppImage :url="imageUrl"/>
                    <el-button-group>
                    <el-button @click="imagePrevious" icon="el-icon-arrow-left">上一张</el-button>
                    <el-button>第 {{ imageIndex+1 }} 张</el-button>
                    <el-button @click="imageNext">下一张<i class="el-icon-arrow-right el-icon--right"></i></el-button>
                    </el-button-group>
                </el-col>
                <el-col :span="4">
                    <AppLabel :label="labelId" :submitId="imageId" @createLabel="setLabelId"/>
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
  name: 'AdminImageList',
  components: {
    AppImage,
    AppLabel
  },

  data() {
    return {
      images: [],

      // upload
      imageUploadUrl: config.apiUrl+'/uploads/medical-images/',
      imageUploadVisible: false,
      fileList: [],

      // assign
      imageAssignVisible: false,
      imageSelection: [],  // also for delete
      doctors: [],
      doctorSelection: [],

      // delete
      imageDeleteVisible: false,

      // info
      imageListVisible: true,
      imageUrl: '',
      imageIndex: 0,
      labelId: -1,
      imageId: -1
    }
  },
  created() {
    this.loadImages()
  },
  methods: {
    loadImages() {
        this.$http.get(config.apiUrl + '/images/').then(res => {
            // this.$message.success(res.body.message)
            this.images = res.body.data
            var imagesStateCode = { '300': '未分配', '301': '进行中', '302': '有分歧', '303': '已完成'}
            for (var i = 0; i < this.images.length; i++) {
                this.images[i].name = this.images[i].filename.split('.')[0]
                this.images[i].state = imagesStateCode[this.images[i].image_state]
            }
        }, res => {
            if (res.status == 401) {
                // this.$message.error(res.body.message)
                // window.localStorage.removeItem('user')
                this.$emit('pass', 0)
            }
            // eslint-disable-next-line
            console.log(res)
        })
    },

    imageUpload() {
        this.imageUploadVisible = true;
    },
    beforeImageUpload(file) {
        var isJPGorPNG = (file.type === 'image/jpeg' || file.type === 'image/png');
        var isSizeFit = file.size / 1024 / 1024 < 5;

        if (!isJPGorPNG) {
            this.$message.error('图片只能是 JPG 或 PNG 格式!');
        }
        if (!isSizeFit) {
            this.$message.error('图片大小不能超过 5MB!');
        }
        return isJPGorPNG && isSizeFit;
    },
    successImageUpload(res, file) {
        this.$message.success(file.name + ' 上传成功')
        this.loadImages()
    },
    cancelImageUpload() {
        this.imageUploadVisible = false
        this.$refs.upload.abort()
        this.$refs.upload.clearFiles()
    },
    submitImageUpload() {
        this.$refs.upload.submit();
    },

    imageAssign() {
        if (!this.imageSelection.length) {
            this.$message.error('请选择图像再分配任务')
        } else {
            for (var i = 0; i < this.imageSelection.length; i++) {
                if (this.imageSelection[i].state != '未分配') {
                    return this.$message.error('请选择未分配的图像')
                }
            }
            this.imageAssignVisible = true;
            this.loadDoctors()
        }
    },
    changeImageSelection(val) {
        this.imageSelection = val
    },
    loadDoctors() {
      this.doctors = []
      this.$http.get(config.apiUrl + '/accounts/').then(res => {
        // this.$message.success(res.body.message)
        var accounts = res.body.data
        for (var i = 0; i < accounts.length; i++) {
            if (accounts[i].authority == 102) {
                this.doctors.push(accounts[i])
            }
        }
      }, res => {
        this.$message.error('请求账户信息错误')
        // eslint-disable-next-line
        console.log(res)
      })
    },
    changeDoctorSelection(val) {
        this.doctorSelection = val
    },
    confirmImageAssign() {
        if (this.doctorSelection.length < 2) {
            this.$message.error('必须选择至少两个医生');
        } else {
            for (var i = 0; i < this.imageSelection.length; ++i) {
                for (var j = 0; j < this.doctorSelection.length; ++j) {
                    var data = {
                        "image_id": this.imageSelection[i].image_id,
                        "account_id": this.doctorSelection[j].account_id
                    }
                    this.$http.post(config.apiUrl + '/jobs/', data).then(res => {
                        this.$message.success(res.body.message);
                        this.loadImages();
                    }, res => {
                        // eslint-disable-next-line
                        console.log(res);
                    });
                }
            }
            this.$refs.doctorTable.clearSelection();
            this.$refs.imageTable.clearSelection();
            this.selectDoctorDialogVisible = false;
        }
    },
    cancelImageAssign() {
        this.$refs.doctorTable.clearSelection();
        this.imageAssignVisible = false
    },

    clickImageRow(row) {
        // if (row.state == '未分配') {
        //     return this.$message.error('请先分配任务')
        // }
        this.imageListVisible = false
        var image = this.queryImageById(row.image_id)
        if (image) {
            this.imageUrl = config.apiUrl + '/uploads/medical-images/' + image.filename
        }
        this.imageId = row.image_id  // trick name
    },
    queryImageById(id) {
        for (var i = 0; i < this.images.length; ++i) {
            if (this.images[i].image_id === id) {
                this.imageIndex = i
                return this.images[i]
            }
        }
        return null
    },

    imageDelete() {
        if (!this.imageSelection.length) {
            this.$message.error('请选择需要删除的图像')
        } else {
            for (var i = 0; i < this.imageSelection.length; i++) {
                if (this.imageSelection[i].state != '未分配') {
                    return this.$message.error('只能删除未分配的图像')
                }
            }
            this.imageDeleteVisible = true
        }
    },
    confirmImageDelete() {
        this.imageDeleteVisible = false
        for (var i = 0; i < this.imageSelection.length; i++) {
            this.$http.delete(config.apiUrl + '/images/' + this.imageSelection[i].image_id).then(res => {
                this.$message.success(res.body.message)
                this.loadImages();
            }, res => {
                // eslint-disable-next-line
                console.log(res);
            })
        }
    },
    cancelImageDelete() {
        this.imageDeleteVisible = false
    },

    backToImageList() {
        this.imageListVisible = true
    },
    imagePrevious() {
        if (this.imageIndex == 0) {
            return this.$message.info('当前已经是第一张图像了')
        } else {
            this.imageIndex = this.imageIndex-1
            this.imageUrl = config.apiUrl + '/uploads/medical-images/' + this.images[this.imageIndex].filename
        }
    },
    imageNext() {
        if (this.imageIndex == this.images.length-1) {
            return this.$message.info('当前已经是最后一张图像了')
        } else {
            this.imageIndex = this.imageIndex+1
            this.imageUrl = config.apiUrl + '/uploads/medical-images/' + this.images[this.imageIndex].filename
        }
    },
    setLabelId(id) {
        this.labelId = id
        this.loadJobs()
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
