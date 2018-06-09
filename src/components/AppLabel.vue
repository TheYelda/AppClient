<template>
  <el-form :model="labelForm">
        <el-form-item label="QUALITY"><el-switch :disabled="readonly" v-model="labelForm.quality"></el-switch></el-form-item>
        <el-form-item label="DR"><el-switch :disabled="readonly" v-model="labelForm.dr"></el-switch></el-form-item>

        <el-form-item label="STAGE"><el-input :disabled="readonly" v-model="labelForm.stage"></el-input></el-form-item>

        <el-form-item label="DME"><el-switch :disabled="readonly" v-model="labelForm.dme"></el-switch></el-form-item>

        <el-form-item label="HR"><el-input :disabled="readonly" v-model="labelForm.hr"></el-input></el-form-item>
        <el-form-item label="AGE_DME"><el-input :disabled="readonly" v-model="labelForm.age_dme"></el-input></el-form-item>

        <el-form-item label="RVO"><el-switch :disabled="readonly" v-model="labelForm.rvo"></el-switch></el-form-item>
        <el-form-item label="CRAO"><el-switch :disabled="readonly" v-model="labelForm.crao"></el-switch></el-form-item>
        <el-form-item label="MYOPIA"><el-switch :disabled="readonly" v-model="labelForm.myopia"></el-switch></el-form-item>
        <el-form-item label="OD"><el-switch :disabled="readonly" v-model="labelForm.od"></el-switch></el-form-item>
        <el-form-item label="GLAUCOMA"><el-switch :disabled="readonly" v-model="labelForm.glaucoma"></el-switch></el-form-item>
        <el-form-item label="OTHERS"><el-switch :disabled="readonly" v-model="labelForm.others"></el-switch></el-form-item>

        <el-form-item label="COMMENT"><el-input :disabled="readonly" v-model="labelForm.comment"></el-input></el-form-item>
        

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
              dme: false,
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
          canSubmit: false
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
                this.labelForm = res.body
            }, res => {
                // eslint-disable-next-line
                console.log(res)
            })
            if (this.submitId == -1) {
                this.readonly = true;
            }
        }
      },
      saveLabelForm() {
          if (!this.hasLabel) {
              this.$http.post(config.apiUrl + '/labels/', this.labelForm).then(res => {
                  this.$message.success(res.body.message)
                  this.hasLabel = true
                  this.$emit('createLabel', res.body.label_id)
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
              this.$http.put(config.apiUrl + '/labels/' + this.label, this.labelForm).then(res => {
                  this.$message.success(res.body.message)
              }, res => {
                  // eslint-disable-next-line
                  console.log(res)
              })
          }
          this.canSubmit = true
      },
      submitLabelForm() {
          if (!this.hasLabel || !this.canSubmit) {
              this.$message.info('请先保存再提交')
          } else if (this.canSubmit) {
              var userInfo = JSON.parse(window.localStorage.getItem('user'))
              if (userInfo.authority == 101) {
                 this.$http.put(config.apiUrl + '/images/' + this.submitId, {
                     label_id: this.label,
                     image_state: 303  // 已完成
                 }).then(res => {
                     this.$message.success(res.body.message)
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
              dme: false,
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
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
