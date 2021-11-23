<template>
  <div id="app-container" :class="getMenuType">
    <topnav />
    <sidebar />
    <!-- <main style="">
      <div v-if="hrefCheck" class="container-fluid">
        <slot></slot>
      </div>
    </main> -->
    <main>
      <div class="container-fluid">
        <slot></slot>
      </div>
    </main>
    <!-- <footer-component /> -->
  </div>
</template>

<script>
import Sidebar from "../containers/navs/Sidebar";
import Topnav from "../containers/navs/Topnav";
import Footer from "../containers/navs/Footer";
import { mapGetters } from "vuex";

export default {
  components: {
    topnav: Topnav,
    sidebar: Sidebar,
    "footer-component": Footer
  },
  data() {
    return {
      show: false
    };
  },
  computed: {
    ...mapGetters(["getMenuType","currentUser"]),
    // hrefCheck: () => {
    //   return window.location.href.indexOf('grid') > -1
    // }

  },
  mounted() {
    setTimeout(() => {
      document.body.classList.add("default-transition");
    }, 100);
  }
};
</script>
