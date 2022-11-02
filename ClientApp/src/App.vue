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
              <v-switch class="d-flex flex-row-reverse" :label="dark" hide-details width="min" v-model="theme.global.name" true-value="light" false-value="dark"></v-switch>
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
      <v-sheet @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" color="ui3" height="40" width="40">
        <v-container class="fill-height">
          <v-row style="line-height: 2; user-select: none;" class="fill-height">
            lol
          </v-row>
        </v-container>

        <v-menu style="user-select: none;" @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" absolute open-on-hover activator="parent" :close-on-content-click="false">
          {{ hello }}
        </v-menu>
      </v-sheet>
      <!-- <v-sheet v-for="(page, name, i) in pageList" @click="changePage(page)"> -->
        <v-sheet v-for="[name, page] in pageList" @click="currentPage = page.value">
        {{ name }}
      </v-sheet>
    </v-footer>
  </v-app>
  
</template>


<script setup lang="ts">
import { ref, shallowRef, onMounted, defineAsyncComponent, getCurrentInstance } from 'vue'
import { useDisplay, useTheme } from 'vuetify'

import HelloWorld from './components/HelloWorld.vue'
import MainPage from './components/MainPage.vue'

// const pageList = shallowRef<object>({});
// let pageList: { [key: string]: any} = {};
const pageList = new Map();
for (const p in import.meta.glob('./components/*.vue')) {
  const n = p.split('/').pop()!.replace(/\.\w+$/, '');
  pageList.set(n, shallowRef<object>(eval(n)));
  // pageList[n] = shallowRef<object>(eval(n));
}
// const currentPage = shallowRef<object>(pageList['MainPage'].value);
  const currentPage = shallowRef<object>(pageList.get('MainPage').value);
// console.log(pageList['MainPage']);


// const pageList = shallowRef<object>({});
// console.log('Start:');
// console.log(pageList);
// for (const p in import.meta.glob('./components/*.vue')) {
//   console.log('Page:');
//   console.log(p);
//   const n = p.split('/').pop().replace(/\.\w+$/, '');
//   console.log('Name:');
//   console.log(n);
//   pageList.value[n] = eval(n);
//   console.log(pageList);
//   console.log(pageList.value);
//   console.log(pageList.value[n]);
//   console.log(pageList.value['MainPage']);
// }
// const currentPage = shallowRef<object>(pageList.value['MainPage']);
// console.log(pageList.value['MainPage']);
// console.log('cur');
// console.log(currentPage);




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

// function changePage(p: string) {
//   console.log('change');
//   console.log(p);
//   currentPage.value = pageList[p].value;
//   console.log(pageList[p].value);
//   console.log(pageList[p].value.value);
//   console.log(p);
//   console.log('cur');
//   console.log(currentPage);
//   console.log(pageList[p]);
// }



// function changePage(p) {
//   currentPage.value = pageList.value[p];
//   console.log(pageList.value[p]);
//   console.log(pageList.value[p].value);
//   console.log(p);
//   console.log('cur');
//   console.log(currentPage);
//   console.log(pageList.value);
// }


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

</style>