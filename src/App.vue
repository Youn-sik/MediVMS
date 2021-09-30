<template>
  <div class="h-100" v-if="!isLogin">
    <router-view />
  <!-- <color-switcher /> -->
  </div>
</template>

<script>
import ColorSwitcher from "./components/Common/ColorSwitcher";

import { getDirection } from "./utils";

export default {
  components: {
    "color-switcher": ColorSwitcher
  },
  beforeMount() {
    const direction = getDirection();
    if (direction.isRtl) {
      document.body.classList.add("rtl");
      document.dir = "rtl";
      document.body.classList.remove("ltr");
    } else {
      document.body.classList.add("ltr");
      document.dir = "ltr";
      document.body.classList.remove("rtl");
    }
  },
  data() {
    return {
      isLogin : false,
    }
  }
};
</script>
