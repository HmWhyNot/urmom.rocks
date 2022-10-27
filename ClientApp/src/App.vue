<template>
  <v-app>
    <v-app-bar app color="grey-lighten-1" border="barBorder" density="compact" :elevation="elevation">
      <v-app-bar-nav-icon @click="dialog = true" @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'"> {{ mom }} </v-app-bar-nav-icon>
      <v-app-bar-title align="center">
        <b>{{ title }}</b>
      </v-app-bar-title>
    </v-app-bar>

    <v-dialog v-model="dialog" :fullscreen="mobile">
      <v-btn @click="dialog = false">
        Hi
      </v-btn>
    </v-dialog>

    <v-main>
      <MainPage/>
    </v-main>

    <v-footer app>
      lol
    </v-footer>
  </v-app>
  
</template>


<script setup lang="ts">
import { ref } from 'vue'
import { useDisplay } from 'vuetify'
import HelloWorld from './components/HelloWorld.vue'
import MainPage from './components/MainPage.vue'

const dialog = ref<boolean>(false);
const barBorder = ref<number>(3);
const elevation = ref<number>(10);
const title = ref<string>('oofgottem');
const mom = ref<string>('MOM');
const { mobile } = useDisplay();
console.log(useDisplay());


</script>


<style>

</style>