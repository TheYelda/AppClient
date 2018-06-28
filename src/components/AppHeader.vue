<template>
  <el-header>
      <el-row>
          <el-col><h1>眼底图像标注系统</h1></el-col>
      </el-row>

      <el-row>
          <el-col>
              <el-tabs @tab-click="clickTab">
                  <el-tab-pane v-for="(tab, index) in items" :key="index" :label="tab.label"></el-tab-pane>
              </el-tabs>
          </el-col>
      </el-row>

  </el-header>
</template>

<script>
export default {
  name: 'AppHeader',
  props: {
    tabs: String
  },
  data() {
      var tabs = this._props.tabs.split(','), items = []
      for (var i =0; i < tabs.length; i++) {
          items.push({
              label: tabs[i]
          })
      }
      return {
          items: items
      }
  },
  methods: {
      clickTab(tab) {
          this.$emit('switchTab', tab.index)
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
