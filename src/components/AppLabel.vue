<template>
  <el-form :model="labelForm">
        <el-form-item label="图片质量">
            <el-select :disabled="readonly" v-model="labelForm.quality" multiple placeholder="请选择">
                <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="糖尿病视网膜病变"><el-switch :disabled="readonly" v-model="labelForm.dr"></el-switch></el-form-item>

        <el-form-item label="糖尿病视网膜病变阶段">
            <el-select :disabled="readonly" v-model="labelForm.stage" placeholder="请选择">
                <el-option label="无" value="700"></el-option>
                <el-option label="I" value="701"></el-option>
                <el-option label="II" value="702"></el-option>
                <el-option label="III" value="703"></el-option>
                <el-option label="IV" value="704"></el-option>
                <el-option label="V" value="705"></el-option>
                <el-option label="VI" value="706"></el-option>
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
        
        <el-form-item label="视网膜静脉阻塞">
            <el-select :disabled="readonly" v-model="labelForm.rvo" placeholder="请选择">
                <el-option label="无" value="900"></el-option>
                <el-option label="中央静脉阻塞" value="901"></el-option>
                <el-option label="半侧中央静脉阻塞" value="902"></el-option>
                <el-option label="分支静脉阻塞" value="903"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="视网膜动脉阻塞">
            <el-select :disabled="readonly" v-model="labelForm.crao" placeholder="请选择">
                <el-option label="无" value="1000"></el-option>
                <el-option label="中央动脉阻塞" value="1001"></el-option>
                <el-option label="分支动脉阻塞" value="1002"></el-option>
                <el-option label="睫状动脉阻塞" value="1003"></el-option>
            </el-select>
        </el-form-item>

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
        quality: ['800'],
        dr: false,
        stage: '700',
        dme: '400',
        hr: '500',
        age_dme: '600',
        rvo: '900',
        crao: '1000',
        myopia: false,
        od: false,
        glaucoma: false,
        others: false,
        comment: ''
      },
      hasLabel: false,
      canSubmit: false,
      isDone: false,
      options: [
        { value: '800', label: '可接受' },
        { value: '801', label: '曝光问题'},
        { value: '802', label: '镜头污迹'},
        { value: '803', label: '视野偏差'},
        { value: '804', label: '图像失焦'},
        { value: '805', label: '其他问题'}
      ]
    }
  },
  watch: {
    label: function(val) {
      if (val < 0) {
        this.isDone = false
        this.hasLabel = false
        this.resetLabelForm()
      } else {
        this.hasLabel = true
        this.loadLabel()
      }
    }
  },
  created() {
    if (this.label < 0) {
      this.isDone = false
      this.hasLabel = false
      this.resetLabelForm()
    } else {
      this.hasLabel = true
      this.loadLabel()
    }
  },
  methods: {
    loadLabel() {
      if (this.label > 0) {
        this.hasLabel = true
        this.$http.get(config.apiUrl + '/labels/' + this.label).then(res => {
          if (res.body.quality[0] == 0) res.body.quality = ''
          else for (var i = 0; i < res.body.quality.length; i++) res.body.quality[i] = res.body.quality[i].toString()
          res.body.stage = res.body.stage == 0 ? '' : res.body.stage.toString()
          res.body.dme = res.body.dme == 0 ? '' : res.body.dme.toString()
          res.body.hr = res.body.hr == 0 ? '' : res.body.hr.toString()
          res.body.age_dme = res.body.age_dme == 0 ? '' : res.body.age_dme.toString()
          res.body.rvo = res.body.rvo == 0 ? '' : res.body.rvo.toString()  // 静脉
          res.body.crao = res.body.crao == 0 ? '' : res.body.crao.toString()  // 动脉

          delete res.body.message
          this.labelForm = res.body
        }, res => {
          // eslint-disable-next-line
          console.log(res)
        })
        
        this.$http.get(config.apiUrl + '/jobs/' + this.submitId).then(res => {
          if (res.body.job_state == 202) {
            this.isDone = true
          }
        }, res => {
          // eslint-disable-next-line
          console.log(res)
        })
      }
    },
    saveLabelForm() {
      if (this.isDone) return this.$message.info('已完成的标注无法操作')
      var data = this.labelForm

      if (data.quality == []) data.quality = ['0']
      for (var i = 0; i < data.quality.length; i++) data.quality[i] = parseInt(data.quality[i])
      data.stage  = data.stage == '' ? 0 : parseInt(data.stage)
      data.dme = data.dme == '' ? 0 : parseInt(data.dme)
      data.hr = data.hr == '' ? 0 : parseInt(data.hr)
      data.age_dme = data.age_dme == '' ? 0 : parseInt(data.age_dme)
      data.rvo = data.rvo == '' ? 0 : parseInt(data.rvo)
      data.crao = data.crao == '' ? 0 : parseInt(data.crao)

      if (!this.hasLabel) {
        // step 1: create the label of job
        this.$http.post(config.apiUrl + '/labels/', data).then(res => {
          this.hasLabel = true
          this.$emit('createLabel', res.body.label_id)

          // step 2: change the job state
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
        // just update the label
        this.$http.put(config.apiUrl + '/labels/' + this.label, data).then(res => {
          this.$message.success(res.body.message)
        }, res => {
          // eslint-disable-next-line
          console.log(res)
        })
      }
      this.canSubmit = true  // after save
    },
    submitLabelForm() {
      if (this.isDone) return this.$message.info('已完成的标注无法操作')

      if (!this.hasLabel || !this.canSubmit) {
          this.$message.info('请先保存再提交')
      } else if (this.canSubmit) {
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
        this.$emit('nextImage', true)  // auto
        this.canSubmit = false
      }
    },
    resetLabelForm() {
      this.labelForm = {
        quality: ['800'],
        dr: false,
        stage: '700',
        dme: '400',
        hr: '500',
        age_dme: '600',
        rvo: '900',
        crao: '1000',
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
