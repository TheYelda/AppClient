<template>
  <div id="app">
    <div v-if="!helloWorld">
      <HelloWorld msg="Hello world" @goPage="whichPage"/>
    </div>
    <div v-else-if="isAdmin()"><AdminPage @logout="whichPage"/></div>
    <div v-else-if="isDoctor()"><DoctorPage @logout="whichPage"/></div>
    <div v-else-if="isGuest()"><GuestPage /></div>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import AdminPage from './components/AdminPage.vue'
import DoctorPage from './components/DoctorPage.vue'
import GuestPage from './components/GuestPage.vue'

export default {
  name: 'app',
  components: {
    HelloWorld,
    AdminPage,
    DoctorPage,
    GuestPage
  },
  data() {
    return {
      // isAdmin-1, isDoctor-2, isGuest-3
      helloWorld: 0,
    }
  },
  created() {
    var userInfo = JSON.parse(window.localStorage.getItem('user'))
    if (userInfo) {
      var authorityCode = [ 100, 101, 102, 103, 104 ]
      for (var i = 0; i < authorityCode.length; i++) {
        if (userInfo.authority == authorityCode[i]) {
          this.helloWorld = i;
          if (userInfo.authorityCode == 104) {
            this.helloWorld = 2
          }
        }
      }
    }
  },
  methods: {
    whichPage(code) {
      if (code == 4) code = 2
      this.helloWorld = code
    },
    isAdmin() {
      return this.helloWorld == 1
    },
    isDoctor() {
      return this.helloWorld == 2
    },
    isGuest() {
      return this.helloWorld == 3
    },
  }
}
</script>

<style>
#app {
  /* font-family: 'Avenir', Helvetica, Arial, sans-serif; */
  /* -webkit-font-smoothing: antialiased; */
  /* -moz-osx-font-smoothing: grayscale; */
}
</style>
