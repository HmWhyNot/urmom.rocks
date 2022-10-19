<template>
  <v-app>
    <v-main>
      <HelloWorld/>
    </v-main>
    <div>Result: {{ result.test }}</div>
  </v-app>
  
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue'
import HelloWorld from './components/HelloWorld.vue'

export default defineComponent({
  name: 'App',

  components: {
    HelloWorld,
  },
  setup() {
    const result = ref<TestData>({test: ''});
    onMounted(async () => {
      result.value = await (await fetch("/api/test")).json()
      });
    return {
      result,
    }
  },

  data () {
    return {
      //
    }
  },
})

interface TestData {
  test: string;
}

</script>
