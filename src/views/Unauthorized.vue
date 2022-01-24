<template>
  <div id="root">
    <div class="fixed-background">
      <main>
        <div class="container">
          <b-row class="h-100">
            <b-colxx xxs="12" md="10" class="mx-auto my-auto">
              <b-card class="auth-card" no-body>
                <div class="position-relative image-side">
                  <p class="text-white h2">MAGIC IS IN THE DETAILS</p>
                  <p class="white mb-0">Yes, it is indeed!</p>
                </div>
                <div class="form-side">
                  <router-link to="/">
                    <span class="logo-single" />
                  </router-link>
                  <h6 class="mb-4">허가 되지 않은 접근 감지</h6>
                  <p class="mb-0 text-muted text-small mb-0">접근 권한이 없어 해당 페이지에 접근 할 수 없습니다.</p>
                  <p class="display-1 font-weight-bold mb-5">503</p>
                  <b-button
                    type="submit"
                    variant="primary"
                    size="lg"
                    class="btn-shadow"
                    @click="goBack"
                  >뒤로가기</b-button>
                </div>
              </b-card>
            </b-colxx>
          </b-row>
        </div>
      </main>
    </div>
  </div>
</template>
<script>
import {
    mapGetters,
} from "vuex";

export default {
  computed: {
    ...mapGetters(["currentUser", "processing", "loginError"])
  },
  methods: {
    goBack() {
      // this.$router.go(-1);
      if(parseInt(this.currentUser.dashboard))
          this.$router.push('/dashboard');
      else if(parseInt(this.currentUser.surgery))
          this.$router.push('/app/pages/product/surgeries');
      else if(parseInt(this.currentUser.schedule))
          this.$router.push('/app/pages/product/sergery-reserv');
      else if(parseInt(this.currentUser.browse))
          this.$router.push('/app/data');
      else if(parseInt(this.currentUser.admin))
          this.$router.push('/app/admin');
      else if(parseInt(this.currentUser.setting))
          this.$router.push('/app/settings');
    },
  },
  mounted: function () {
    document.body.classList.add("background");
  },
  beforeDestroy() {
    document.body.classList.remove("background");
  },
};
</script>
