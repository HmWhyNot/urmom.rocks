<template>
    <v-footer app color="ui2">
      <v-sheet @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" color="ui3" height="40" width="45">
        <v-container class="fill-height">
          <v-row style="line-height: 2; user-select: none;" class="fill-height">
            lol
          </v-row>
        </v-container>
        <v-menu style="user-select: none;" @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" absolute open-on-hover activator="parent" :close-on-content-click="false">
          {{ hello }}
        </v-menu>
      </v-sheet>

      <v-container padding="0px">
        <v-row padding="0px" no-gutters justify="start">
          <div v-for="page in pageList" class="my-n16 py-n17 pe-6 ms-0 me-n4" cols="1">
            <v-hover v-if="page.children.length > 0" v-slot="{ isHovering, props }">
              <div v-if="isHovering">poo</div>
            </v-hover>
            <router-link class="nav-link" tag="div" :to="page" replace>
              <v-sheet @click="dad = false" tabindex="0" class="nav" :style="{opacity: route.name == page.name ? 1 : 0.65}">
                {{ page.name!.toString() }}
              </v-sheet>
            </router-link>
          </div>
          <v-spacer cols="2"/>
        </v-row>
      </v-container>

      <v-sheet @mouseover="hello = 'GOODBYE'" @mouseleave="hello = 'HELLO'" color="ui3" height="40" width="45">
        <v-container class="fill-height">
          <v-row style="line-height: 2; user-select: none;" class="fill-height">
            {{ store.momCount }}
          </v-row>
        </v-container>
        <v-menu style="user-select: none;" @mouseover="hello = 'GOODBYE'" @mouseleave="hello = 'HELLO'" absolute open-on-hover activator="parent" :close-on-content-click="false">
          {{ hello }}
        </v-menu>
      </v-sheet>
    </v-footer>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter, useRoute, RouteRecord } from 'vue-router'
import { useMainStore } from '@/stores/mainStore'

const props = defineProps({ dad: Boolean });
const store = useMainStore();


const router = useRouter();
const route = useRoute();
const pageList: RouteRecord[] = router.getRoutes().filter(r => { return (r.path.includes('/', 0)) && (!r.path.includes('/', 1)) && (!r.path.includes(':noPage')) });
const hello = ref<string>('HELLO');
const dad = ref<Boolean>(props.dad);
console.log(router);
console.log(route);
console.warn(pageList[0].name);

</script>

<style>
.nav {
  margin: 0px;
  padding: 0px 10px;
  text-align: center;
  line-height: 40px;
  user-select: none;
  opacity: 0.5;
  /* width: 7vi; */
  text-decoration: none;
  /* font-size: 1vi; */
}
.nav:hover {
  opacity: 1;
  background-color: rgb(var(--v-theme-ui1));
  color: rgb(var(--v-theme-ui3));
}

.nav-link {
  text-decoration: none;
  cursor: pointer;
}

</style>