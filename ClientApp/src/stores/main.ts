import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useStore = defineStore('main', () => {
  const momText = ref<string>('');
  const hi = ref<string>('hello')

  return { momText, hi }
});