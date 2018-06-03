<template>
  <el-form :model="labelForm">
        <el-form-item label="QUALITY"><el-switch v-model="labelForm.quality"></el-switch></el-form-item>
        <el-form-item label="DR"><el-switch v-model="labelForm.dr"></el-switch></el-form-item>

        <el-form-item label="STAGE"><el-input v-model="labelForm.stage"></el-input></el-form-item>

        <el-form-item label="DME"><el-switch v-model="labelForm.dme"></el-switch></el-form-item>

        <el-form-item label="HR"><el-input v-model="labelForm.hr"></el-input></el-form-item>
        <el-form-item label="AGE_DME"><el-input v-model="labelForm.age_dme"></el-input></el-form-item>

        <el-form-item label="RVO"><el-switch v-model="labelForm.rvo"></el-switch></el-form-item>
        <el-form-item label="CRAO"><el-switch v-model="labelForm.crao"></el-switch></el-form-item>
        <el-form-item label="MYOPIA"><el-switch v-model="labelForm.myopia"></el-switch></el-form-item>
        <el-form-item label="OD"><el-switch v-model="labelForm.od"></el-switch></el-form-item>
        <el-form-item label="GLAUCOMA"><el-switch v-model="labelForm.glaucoma"></el-switch></el-form-item>
        <el-form-item label="OTHERS"><el-switch v-model="labelForm.others"></el-switch></el-form-item>

        <el-form-item label="COMMENT"><el-input v-model="labelForm.comment"></el-input></el-form-item>
        

        <el-form-item>
            <el-button @click="saveLabelForm" icon="el-icon-edit">保存</el-button>
            <el-button type="primary" @click="submitLabelForm" icon="el-icon-circle-check">提交</el-button>
        </el-form-item>
    </el-form>
</template>

<script>
// import config from './AppConfig.vue'

export default {
  name: 'AppLabel',
  components: {
    // ...
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
          }
      }
  },
  methods: {
      saveLabelForm() {
          // ...
      },
      submitLabelForm() {
          // ...
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
