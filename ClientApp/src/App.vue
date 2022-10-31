<template>
  <v-app>
    <v-app-bar app color="ui1" :border="barBorder" density="compact" :elevation="elevation">
      <v-container fluid>
        <v-row>
          <v-col class="justify-left" align="left">
            <v-app-bar-nav-icon @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'"> {{ mom }} </v-app-bar-nav-icon>

            <v-dialog width="50%" class="text-center" v-model="dialog" activator="parent" :scrim="true" :fullscreen="mobile">
              <v-sheet color="background">
                <v-container>
                  <v-card :elevation="elevation">
                    <v-card-text class="text-center">
                      {{ dgMsg }}
                    </v-card-text>
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
          </v-col>
          
          <v-col class="justify-center">
            <v-app-bar-title align="center">
              <b>{{ title }}</b>
            </v-app-bar-title>
          </v-col>

          <v-col class="d-flex justify-right" align="right">
            <v-col/>
            <v-col cols="auto">
              <v-switch :label="dark" hide-details="true" width="min" v-model="theme.global.name" true-value="light" false-value="dark"></v-switch>
            </v-col>
            <v-col cols="auto"></v-col>
            <v-col cols="auto"></v-col>
          </v-col>
          <span @mouseover="dad" @mouseleave="dad" class="dad">dad</span>
        </v-row>
      </v-container>
    </v-app-bar>

    <v-main>
      <MainPage/>
    </v-main>

    <v-footer app color="ui2">
      <v-sheet @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" color="ui3" height="40" width="40">
        <v-container class="fill-height">
          <v-row style="line-height: 2;" class="fill-height">
            lol
          </v-row>
        </v-container>

        <v-menu @mouseover="hello = 'HELLO'" @mouseleave="hello = 'GOODBYE'" absolute open-on-hover activator="parent" :close-on-content-click="false">
          {{ hello }}
        </v-menu>
      </v-sheet>
    </v-footer>
  </v-app>
  
</template>


<script setup lang="ts">
import { ref } from 'vue'
import { useDisplay, useTheme } from 'vuetify'
import HelloWorld from './components/HelloWorld.vue'
import MainPage from './components/MainPage.vue'

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

function dgHi() {
  dgMsg.value = 'How rude!!';
  setTimeout(() => {
    dgMsg.value = 'roflmao';
  }, 2000);
}

function dad(e) {
  console.log(e);
  console.log(e.target.style.opacity);
  e.target.style.opacity = e.target.style.opacity ^ 1;
}


</script>


<style>
.dad {
  position: absolute;
  width: 50px;
  height: 50px;
  z-index: 999;
  text-align: center;
  margin: auto;
  line-height: 50px;
  right: 0;
  display: block;
  opacity: 0;
}

</style>