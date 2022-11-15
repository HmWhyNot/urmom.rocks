import { createApp } from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import { loadFonts } from './plugins/webfontloader'
import router from './plugins/router'
import { createPinia } from 'pinia'
import VueKonva from 'vue-konva'

loadFonts()

createApp(App)
  .use(vuetify)
  .use(router)
  .use(createPinia())
  .use(VueKonva)
  .mount('#app')
