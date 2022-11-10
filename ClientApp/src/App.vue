<template>
  <v-app>

    <AppBar @dad="dad = !dad"/>

    <v-main>
      <v-sheet color="background">
        <v-container class="fill-height">
          <v-sheet>
            <router-view v-slot="{ Component }">
              <transition appear name="pageTran" mode="out-in">
                <component :is="dad ? HelloWorld : Component"/>
              </transition>
            </router-view>
          </v-sheet>
        </v-container>
      </v-sheet>
    </v-main>

    <NavBar/>

  </v-app>
  
</template>


<script setup lang="ts">
import * as Vue from 'vue'
import { ref, shallowRef, onMounted, defineAsyncComponent, getCurrentInstance, watch } from 'vue'
import * as Vuetify from 'vuetify'
import { useDisplay, useTheme } from 'vuetify'
import * as VRoute from 'vue-router'
import { useRouter } from 'vue-router'
import { useMainStore } from './stores/main'

// Components
import HelloWorld from './components/HelloWorld.vue'
import AppBar from './components/AppBar.vue'
import NavBar from './components/NavBar.vue'


const router = useRouter()
const dad = ref<boolean>(false);
// mobileBreakpoint.value = 'sm';

router.afterEach(() => dad.value = false);

console.log(useMainStore());


</script>


<style>

.pageTran-enter-to,
.pageTran-leave-from,
.pageTran-enter-active,
.pageTran-leave-active {
  transition: all 0.15s ease;
}
.pageTran-enter-from {
  opacity: 0;
  scale: 50% 75%;
  rotate: 5deg;
  /* rotate: x 90deg; */
  translate: 0 5rem;
}
.pageTran-leave-to {
  opacity: 0;
  scale: 50% 75%;
  rotate: 5deg;
  /* rotate: x 90deg; */
  translate: 0 -5rem;
}

</style>