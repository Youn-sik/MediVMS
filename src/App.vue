<template>
  <v-app>
    <AppBar/>

    <!-- <v-toolbar clipped-left app>
      <span>Toolbar</span>
    </v-toolbar> -->

    <!-- <v-content :style="$vuetify.breakpoint.smAndDown ? 'padding-top: 112px' : 'padding-top: 128px'"> -->
    <v-content>
      <v-container fluid class="pageContainer">
        <router-view></router-view>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import AppBar from './components/AppBar.vue'
export default {
    components: {
        AppBar
    }
}
</script>

<style scoped>
    .pageContainer{
        padding:0px !important
    }
</style>