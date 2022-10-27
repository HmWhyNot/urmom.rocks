<template>
  <v-app>
    <v-app-bar app color="grey-lighten-1" density="compact" :elevation="elevation">
      <v-app-bar-nav-icon @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'"> {{ mom }} </v-app-bar-nav-icon>
      <v-app-bar-title align="center">
        <b>{{ title }}</b>
      </v-app-bar-title>
    </v-app-bar>

    <v-dialog v-model="dialog" :disabled="wow" :fullscreen="mob.mobile.value">
      <v-btn @click="wow = true">
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

const wow = ref<boolean>(true)
const dialog = true;
const elevation = 10;
const title = 'oofgottem';
const mom = ref<string>('MOM');
const { mobile } = useDisplay();
const mob = useDisplay();
console.log(mobile);
mob.mobileBreakpoint = 'sm';
console.log(mob.mobile);
// mob.mobile = true;
console.log(mob.mobile);
console.log(wow.value);


</script>


<style>

</style>