import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import colors from 'vuetify/lib/util/colors'
import ko from './ko.ts'
Vue.use(Vuetify)

const opts = {
    lang: {
        locales: { ko },
        current: 'ko',
    },
}

export default new Vuetify(opts)