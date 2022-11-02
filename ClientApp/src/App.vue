<template>
  <v-app>
    <v-app-bar app color="ui1" :border="barBorder" density="compact" :elevation="elevation">
      <v-container fluid>
        <v-row>

          <v-col class="justify-left" align="left">
            <v-app-bar-nav-icon @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'">
              <v-dialog label="woo" width="50%" class="text-center" v-model="dialog" activator="parent" :scrim="true" :fullscreen="mobile">
                <v-sheet color="background">
                  <v-container>
                    <v-card :elevation="elevation">
                      <v-card-text class="text-center">
                        {{ dgMsg }}
                      </v-card-text>
                      <v-textarea label="Ur mom is a" variant="solo" :elevation="0"></v-textarea>
                      <v-card-actions>
                        <v-card class="mx-1" color="ui1">
                          <v-btn color="ui3" @click="dgHi">
                            Hi
                          </v-btn>
                        </v-card>
                        <v-card class="mx-1" color="ui1">
                          <v-btn color="ui3" @click="dialog = false">
                            Bye
                          </v-btn>
                        </v-card>
                      </v-card-actions>
                    </v-card>
                  </v-container>
                </v-sheet>
              </v-dialog>
              {{ mom }}
            </v-app-bar-nav-icon>
          </v-col>

          <v-col class="justify-center">
            <v-app-bar-title align="center" style="user-select: none;">
              <b>{{ title }}</b>
            </v-app-bar-title>
          </v-col>

          <v-col class="d-flex justify-right" align="right">
            <v-row>
              <v-switch class="d-flex flex-row-reverse" :label="dark" hide-details width="min" v-model="theme.global.name" true-value="light" false-value="dark"/>
              <v-hover v-slot="{ isHovering, props }">
                <v-card v-bind="props" :style="isHovering ? { opacity: 1 } : { opacity: 0 }" class="dad">
                  <div @click="pageSwitch" v-if="isHovering">dad</div>
                </v-card>
              </v-hover>
            </v-row>
          </v-col>
          <!-- <div @mouseover="dad" @mouseleave="dad" @click="pageSwitch" class="d-flex dad">dad</div> -->
        </v-row>
      </v-container>
    </v-app-bar>

    <v-main>
      <component :is="currentPage"/>
    </v-main>

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
          <v-col v-for="page in pageList" class="my-n16 py-n16 pe-5 ms-0 me-n4" cols="1">
            <v-sheet class="nav" :style="{opacity: currentPage == page ? 1 : 0.65}" @click="currentPage = page">
              {{ page.name || page.__name.replace(/\d/, '') }}
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>

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
    </v-footer>
  </v-app>
  
</template>


<script setup lang="ts">
import { ref, shallowRef, onMounted, defineAsyncComponent, getCurrentInstance } from 'vue'
import { useDisplay, useTheme } from 'vuetify'

import MainPage from './components/0MainPage.vue'
import HelloWorld from './components/1HelloWorld.vue'
const pageList = Object.entries(import.meta.glob('./components/[0-9]+*.vue')).map(e => {return eval(e[0].split('/').pop()!.replace(/\.\w+$|\d/g, ''))});
const currentPage = shallowRef<object>(MainPage);


const dialog = ref<boolean>(false);
const barBorder = ref<number>(300);
const elevation = ref<number>(10);
const title = ref<string>('oofgottem');
const mom = ref<string>('MOM');
const { mobile, mobileBreakpoint } = useDisplay();
const theme = useTheme();
const dark = theme.global.name;
const hello = ref<string>('HELLO');
const dgMsg = ref<string>('roflmao');
mobileBreakpoint.value = 'sm';

function pageSwitch() {
  currentPage.value = currentPage.value == MainPage ? HelloWorld : MainPage;
}

function dgHi() {
  dgMsg.value = 'How rude!!';
  console.log(currentPage);
  setTimeout(() => {
    dgMsg.value = 'roflmao';
  }, 2000);
}

function changePage(p) {
  console.log('change');
  console.log(p);
  currentPage.value = p.value;
  console.log(p);
  console.log('cur');
  console.log(currentPage);
}


</script>


<style>
.dad {
  width: 50px;
  height: 50px;
  z-index: 999;
  text-align: center;
  margin: auto;
  line-height: 50px;
  right: 0;
  display: block;
  opacity: 1;
  user-select: none;
}

.nav {
  margin: 0px;
  text-align: center;
  line-height: 50px;
  user-select: none;
  opacity: 0.5;
}
.nav:hover {
  opacity: 1;
  background-color: rgb(var(--v-theme-ui1));
  color: rgb(var(--v-theme-ui3));
}

</style>