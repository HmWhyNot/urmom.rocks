// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Vuetify
import { createVuetify } from 'vuetify'
import { md2 } from 'vuetify/blueprints'

export default createVuetify({
  blueprint: md2,
  theme: {
    defaultTheme: 'dark',
    themes: {
      dark: {
        dark: true,
        colors: {
          ui1: '#263238',
          ui2: '#455a64',
          ui3: '#78909c',
        },
      },
      light: {
        dark: false,
        colors: {
          ui1: '#cfd8dc',
          ui2: '#b0bec5',
          ui3: '#78909c',
        },
      },
    },
  },
  defaults: {
    global: {
      align: 'center',
    },
    VSheet: {
      border: true,
      rounded: true,
      elevation: 2,
      height: '100%',
    },
    VContainer: {
      justify: 'center',
      align: 'center',
      height: '100%',
      fluid: true,
    },
    VRow: {
      justify: 'center',
      align: 'center',
      height: '100%',
    },
  },
})
