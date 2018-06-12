<template>
  <el-form :model="labelForm">
        <el-form-item label="图片质量"><el-switch :disabled="readonly" v-model="labelForm.quality"></el-switch></el-form-item>
        <el-form-item label="糖尿病视网膜病变"><el-switch :disabled="readonly" v-model="labelForm.dr"></el-switch></el-form-item>

        <el-form-item label="糖尿病视网膜病变阶段">
            <el-select :disabled="readonly" v-model="labelForm.stage" placeholder="请选择">
                <el-option label="无" value="700"></el-option>
                <el-option label="1期" value="701"></el-option>
                <el-option label="2期" value="702"></el-option>
                <el-option label="3期" value="703"></el-option>
                <el-option label="4期" value="704"></el-option>
                <el-option label="5期" value="705"></el-option>
                <el-option label="6期" value="706"></el-option>
                <el-option label="7期" value="707"></el-option>
            </el-select>
        </el-form-item>

        <el-form-item label="黄斑水肿">
            <el-select :disabled="readonly" v-model="labelForm.dme" placeholder="请选择">
                <el-option label="没有黄斑水肿" value="400"></el-option>
                <el-option label="糖尿病黄斑水肿" value="401"></el-option>
                <el-option label="非糖尿病黄斑水肿" value="402"></el-option>
            </el-select>
        </el-form-item>

        <el-form-item label="高血压视网膜病变">
            <el-select :disabled="readonly" v-model="labelForm.hr" placeholder="请选择">
                <el-option label="不患有高血压视网膜病变" value="500"></el-option>
                <el-option label="轻度高血压视网膜病变" value="501"></el-option>
                <el-option label="中度高血压视网膜病变" value="502"></el-option>
                <el-option label="重度高血压视网膜病变" value="503"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="年龄相关性黄斑变性">
            <el-select :disabled="readonly" v-model="labelForm.age_dme" placeholder="请选择">
                <el-option label="不患有年龄相关性黄斑变性" value="600"></el-option>
                <el-option label="早期年龄相关性黄斑变性" value="601"></el-option>
                <el-option label="中期年龄相关性黄斑变性" value="602"></el-option>
                <el-option label="晚期年龄相关性黄斑变性" value="603"></el-option>
            </el-select>
        </el-form-item>

        <el-form-item label="视网膜静脉阻塞"><el-switch :disabled="readonly" v-model="labelForm.rvo"></el-switch></el-form-item>
        <el-form-item label="视网膜动脉阻塞"><el-switch :disabled="readonly" v-model="labelForm.crao"></el-switch></el-form-item>
        <el-form-item label="病理性近视"><el-switch :disabled="readonly" v-model="labelForm.myopia"></el-switch></el-form-item>
        <el-form-item label="视盘、视神经疾病"><el-switch :disabled="readonly" v-model="labelForm.od"></el-switch></el-form-item>
        <el-form-item label="疑似青光眼"><el-switch :disabled="readonly" v-model="labelForm.glaucoma"></el-switch></el-form-item>
        <el-form-item label="其他疾病"><el-switch :disabled="readonly" v-model="labelForm.others"></el-switch></el-form-item>

        <el-form-item label="备注"><el-input :disabled="readonly" v-model="labelForm.comment"></el-input></el-form-item>
        

        <el-form-item>
            <el-button @click="saveLabelForm" icon="el-icon-edit">保存</el-button>
            <el-button type="primary" @click="submitLabelForm" icon="el-icon-circle-check">提交</el-button>
        </el-form-item>
    </el-form>
</template>

<script>
import config from './AppConfig.vue'

export default {
  name: 'AppLabel',
  components: {
    // ...
  },
  props: {
      label: Number,
      submitId: Number
  },
  data() {
      return {
          labelForm: {
              quality: false,
              dr: false,
              stage: '',
              dme: '',
              hr: '',
              age_dme: '',
              rvo: false,
              crao: false,
              myopia: false,
              od: false,
              glaucoma: false,
              others: false,
              comment: ''
          },
          readonly: false,
          hasLabel: false,
          canSubmit: false,
          isDone: false
      }
  },
  watch: {
    label: function(val) {
        if (val < 0) {
            this.hasLabel = false
            this.resetLabelForm()
            return
        }

       this.hasLabel = true
       this.loadLabel()
    }
  },
  created() {
      if (this.label < 0) {
          this.hasLabel = false
          this.resetLabelForm()
          return
      }

      this.hasLabel = true
      this.loadLabel()
  },
  methods: {
      loadLabel() {
        if (this.label > 0) {
            this.hasLabel = true
            this.$http.get(config.apiUrl + '/labels/' + this.label).then(res => {
                this.$message.success(res.body.message)
                delete res.body.message
                if (res.body.stage == 0) {
                    res.body.stage = ''
                } else {
                    res.body.stage = res.body.stage.toString()
                }
                if (res.body.dme == 0) {
                    res.body.dme = ''
                } else {
                    res.body.dme = res.body.dme.toString()
                }
                if (res.body.hr == 0) {
                    res.body.hr = ''
                } else {
                    res.body.hr = res.body.hr.toString()
                }
                if (res.body.age_dme == 0) {
                    res.body.age_dme = ''
                } else {
                    res.body.age_dme = res.body.age_dme.toString()
                }
                console.log(res.body)
                this.labelForm = res.body
                // eslint-disable-next-line
                console.log(this.labelForm)
            }, res => {
                // eslint-disable-next-line
                console.log(res)
            })
            if (this.submitId == -1) {
                this.readonly = true;
            }

            var userInfo = JSON.parse(window.localStorage.getItem('user'))
            if (userInfo.authority == 101) {
            this.$http.get(config.apiUrl + '/images/' + this.submitId).then(res => {
                if (res.body.job_state == 303) {
                    this.isDone = true
                }
                }, res => {
                    // eslint-disable-next-line
                    console.log(res)
                })
            } else if (userInfo.authority == 102) {
            this.$http.get(config.apiUrl + '/jobs/' + this.submitId).then(res => {
                    if (res.body.job_state == 202) {
                        this.isDone = true
                    }
                }, res => {
                    // eslint-disable-next-line
                    console.log(res)
                })
            }
        }
      },
      saveLabelForm() {
          if (this.isDone) return this.$message.info('已完成的标注无法操作')

          // eslint-disable-next-line
          console.log(this.labelForm)
          var data = this.labelForm
          if (data.stage == '') { data.stage = '0' }
          if (data.dme == '') { data.dme = '0' }
          if (data.hr == '') { data.hr = '0' }
          if (data.age_dme == '') { data.age_dme = '0' }
          data.stage = parseInt(data.stage)
          data.dme = parseInt(data.dme)
          data.hr = parseInt(data.hr)
          data.age_dme = parseInt(data.age_dme)
          // eslint-disable-next-line
          console.log(data)
          if (!this.hasLabel) {
              this.$http.post(config.apiUrl + '/labels/', data).then(res => {
                  this.$message.success(res.body.message)
                  this.hasLabel = true
                  this.$emit('createLabel', res.body.label_id)

                  // admin
                  var userInfo = JSON.parse(window.localStorage.getItem('user'))
                  if (userInfo.authority == 101) {
                      this.$http.put(config.apiUrl + '/images/' + this.submitId, {
                     label_id: res.body.label_id,
                    }).then(res => {
                        this.$message.success(res.body.message)
                    }, res => {
                        // eslint-disable-next-line
                        console.log(res)
                    })
                    return
                  }

                  this.$http.put(config.apiUrl + '/jobs/' + this.submitId, {
                     label_id: res.body.label_id,
                     job_state: 201  // 标注中
                  }).then(res => {
                    this.$message.success(res.body.message)
                  }, res => {
                    // eslint-disable-next-line
                    console.log(res)
                  })
              }, res => {
                  // eslint-disable-next-line
                  console.log(res)
              })
          } else {
              this.$http.put(config.apiUrl + '/labels/' + this.label, data).then(res => {
                  this.$message.success(res.body.message)
                  this.loadLabel()
              }, res => {
                  // eslint-disable-next-line
                  console.log(res)
              })
          }
          this.canSubmit = true
      },
      submitLabelForm() {
          if (this.isDone) return this.$message.info('已完成的标注无法操作')


          if (!this.hasLabel || !this.canSubmit) {
              this.$message.info('请先保存再提交')
          } else if (this.canSubmit) {
              this.$message.info('系统自动保存')
              this.saveLabelForm()  // auto save

              var userInfo = JSON.parse(window.localStorage.getItem('user'))
              if (userInfo.authority == 101) {
                 this.$http.put(config.apiUrl + '/images/' + this.submitId, {
                     label_id: this.label,
                     image_state: 303  // 已完成
                 }).then(res => {
                     this.$message.success(res.body.message)
                     this.loadLabel()
                 }, res => {
                    // eslint-disable-next-line
                    console.log(res)
                 })
              } else if (userInfo.authority == 102) {
                 this.$http.put(config.apiUrl + '/jobs/' + this.submitId, {
                     label_id: this.label,
                     job_state: 202  // 已完成
                 }).then(res => {
                     this.$message.success(res.body.message)
                     this.loadLabel()
                 }, res => {
                    // eslint-disable-next-line
                    console.log(res)
                 })
              }
              this.canSubmit = false
          }
      },
      resetLabelForm() {
          this.labelForm = {
              quality: false,
              dr: false,
              stage: '',
              dme: '',
              hr: '',
              age_dme: '',
              rvo: false,
              crao: false,
              myopia: false,
              od: false,
              glaucoma: false,
              others: false,
              comment: ''
          }
      },
      str2code() {
        //   var dict = [
        //       { code: 700, text: '无' },
        //       { code: 701, text: '1期'},
        //       { code: 702, text: '2期'},
        //       { code: 703, text: '3期'},
        //       { code: 704, text: '4期'},
        //       { code: 705, text: '5期'},
        //       { code: 706, text: '6期'},
        //       { code: 707, text: '7期'},
        //       { code: 400, text: '没有黄斑水肿'},
        //       { code: 401, text: '糖尿病黄斑水肿'},
        //       { code: 402, text: '非糖尿病黄斑水肿'},
        //       { code: 500, text: '不患有高血压视网膜病变'},
        //       { code: 501, text: '轻度高血压视网膜病变'},
        //       { code: 502, text: '中度高血压视网膜病变'},
        //       { code: 503, text: '重度高血压视网膜病变'},
        //       { code: 600, text: '不患有年龄相关性黄斑变性'},
        //       { code: 601, text: '早期年龄相关性黄斑变性'},
        //       { code: 602, text: '中期年龄相关性黄斑变性'},
        //       { code: 603, text: '晚期年龄相关性黄斑变性'}
        //   ]
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
