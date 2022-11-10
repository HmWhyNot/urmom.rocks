import { defineStore } from 'pinia'
import { ref } from 'vue'
import { useTheme } from 'vuetify'

export const useMainStore = defineStore('main', () => {

  // support variables
  const theme = useTheme();

  // storage variables
  const ret = {
    momText: ref<string>(''),
    momTextList: ref<Array<string>>([]),
    hi: ref<string>('hello'),
    dark: theme.global.name,
    momCount: ref<number>(0),
  };

  return ret
});