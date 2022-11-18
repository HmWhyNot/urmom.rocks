import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import { useTheme } from 'vuetify'

export const useMainStore = defineStore('mainStore', () => {

  // support variables
  const theme = useTheme();

  // storage variables
  return {
    momText: ref<string>(''),
    momTextList: ref<Array<string>>([]),
    hi: ref<string>('hello'),
    dark: theme.global.name,
    momCount: ref<number>(0),
    ticTacToe: ref({
      field: [0, 0, 0,
              0, 0, 0,
              0, 0, 0,],
      player: 1
    })
  };
});