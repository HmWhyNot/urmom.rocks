<template>
  <v-app>
    <v-app-bar app color="grey-darken-2" density="compact" :elevation="elevation">
      <v-app-bar-nav-icon @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'"> {{ mom }} </v-app-bar-nav-icon>
      <v-app-bar-title align="center">
        <b>{{ title }}</b>
      </v-app-bar-title>
    </v-app-bar>

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
import HelloWorld from './components/HelloWorld.vue'
import MainPage from './components/MainPage.vue'

const elevation = 10;
const title = 'oofgottem';
const mom = ref<string>('MOM');

</script>


<style>

</style>