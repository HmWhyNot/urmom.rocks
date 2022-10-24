<script setup lang="ts">
import { onMounted, onUpdated, ref } from 'vue'

interface TestData {
  test: string;
}

defineProps<{ msg: string }>()
const result = ref<TestData>({test:''})
const count = ref(0)

onMounted(async () => {
  result.value = await (await fetch("/api/test")).json();

})

onUpdated(async () => {
  if (count.value == 5) {
    result.value.test = 'no u';
    console.log('no u');
  }
  else if (count.value == 10) {
    result.value.test = 'oofgottem';
  }
})




</script>

<template>
  <h1>{{ msg }}</h1>

  <div class="card">
    <button type="button" @click="count++">count is {{ count }}</button>
    <p>
      Edit
      <code>components/HelloWorld.vue</code> to test HMR
    </p>
  </div>

  <p>
    Check out
    <a href="https://vuejs.org/guide/quick-start.html#local" target="_blank"
      >create-vue</a
    >, the official Vue + Vite starter
  </p>
  <p>
    Install
    <a href="https://github.com/johnsoncodehk/volar" target="_blank">Volar</a>
    in your IDE for a better DX
  </p>
  <p class="read-the-docs">Click on the Vite and Vue logos to learn more</p>
  <div>Result: {{ result.test }}</div>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
