<template>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant.sync="mini"
      clipped permanent app
    >
      <v-list-item class="px-2">
            <v-btn
                v-if="!mini"
                icon
                @click.stop="mini = !mini"
            >
                <v-icon>mdi-chevron-left</v-icon>
            </v-btn>
      </v-list-item>

      <v-divider></v-divider>

      <v-list dense>
        <!-- <v-list-item
          v-for="item in items"
          :key="item.title"
          link
        > -->
            <v-list-group
                v-for="item in items"
                :key="item.title"
                :value="true"
                :prepend-icon="item.icon"
            >
                <template v-slot:activator>
                    <v-list-item-title>{{ item.title }}</v-list-item-title>
                </template>

                <v-list-item
                    v-for="child in item.child"
                    :key="child.title"
                    link
                >
                    <v-list-item-icon :class="mini ? 'ml-0' : 'ml-5'">
                        <v-icon>{{ child.icon }}</v-icon>
                    </v-list-item-icon>
                    <v-list-item-content>
                        <v-list-item-title>{{ child.title }}</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
            </v-list-group>
      </v-list>
    </v-navigation-drawer>
</template>

<script>
  export default {
    data () {
      return {
        drawer: true,
        items: [
          { title: '단말기 목록', icon: 'mdi-server', child:[
              {
                  title:'NADA-J',
                  icon:'mdi-cctv'
              }
          ]},
        ],
        mini: true,
      }
    },
  }
</script>