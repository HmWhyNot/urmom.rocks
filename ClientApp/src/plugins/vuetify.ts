// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Vuetify
import { createVuetify } from 'vuetify'
import { md3 } from 'vuetify/blueprints'
import colors from 'vuetify/lib/util/colors'

export default createVuetify({
  blueprint: md3,
  theme: {
    defaultTheme: 'dark',
    themes: {
      dark: {
        dark: true,
        colors: {
          ui1: colors.blueGrey.darken4,
          ui2: colors.blueGrey.darken2,
          ui3: colors.blueGrey.lighten1,
        },
      },
      light: {
        dark: false,
        colors: {
          ui1: colors.blueGrey.lighten4,
          ui2: colors.blueGrey.lighten3,
          ui3: colors.blueGrey.lighten1,
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
      userSelect: 'none',
    },
  },
})
