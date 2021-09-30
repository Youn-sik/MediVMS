<template>
  <div class="icon-cards-row">
    <glide-component :settings="glideIconsOption">
      <icon-card title="사용현황" icon="iconsminds-pulse" :value="'10/15'" />
      <icon-card
        title="수술진행율"
        icon="iconsminds-loading"
        :value="'45%'"
      />
      <icon-card
        title="평균수술시간"
        icon="iconsminds-loading-2"
        :value="'2.1hr'"
      />
      <icon-card title="평균회복시간" icon="iconsminds-first-aid" :value="'1.1hr'" />
    </glide-component>
  </div>
</template>
<script>
import GlideComponent from "../../components/Carousel/GlideComponent";
import IconCard from "../../components/Cards/IconCard";

export default {
  components: {
    "glide-component": GlideComponent,
    "icon-card": IconCard
  },
  data() {
    return {
      glideIconsOption: {
        gap: 5,
        perView: 4,
        type: "carousel",
        breakpoints: {
          320: {
            perView: 1
          },
          576: {
            perView: 2
          },
          1600: {
            perView: 3
          },
          1800: {
            perView: 4
          }
        },
        hideNav: true
      }
    };
  }
};
</script>
