<template>
  <v-app>
    <v-app-bar app color="ui1" border="barBorder" density="compact" :elevation="elevation">
      <v-container>
        <v-row>
          <v-col cols="1">
            <v-app-bar-nav-icon @mouseover="mom = 'WOW'" @mouseleave="mom = 'MOM'"> {{ mom }} </v-app-bar-nav-icon>

            <v-dialog width="50%" class="text-center" v-model="dialog" activator="parent" :scrim="true" :fullscreen="mobile">
              <v-sheet color="background">
              <v-container>
              <v-card>
                <v-card-text class="text-center">
                  roflmao
                </v-card-text>
                <v-card-actiona>
                  <v-btn color="ui1" @click="dialog = false">
                    Hi
                  </v-btn>
                </v-card-actiona>
              </v-card>
              </v-container>
              </v-sheet>
            </v-dialog>

          </v-col>
          <v-col cols="10">
            <v-app-bar-title align="center">
              <b>{{ title }}</b>
            </v-app-bar-title>
          </v-col>
          <v-col justify="right" cols="1">
            <v-switch :label="dark" hide-details="true" width="min" v-model="theme.global.name" true-value="light" false-value="dark"></v-switch>
          </v-col>
        </v-row>
      </v-container>
    </v-app-bar>

    <!-- <v-dialog class="text-center" v-model="dialog" :fullscreen="mobile">
      <v-card>
        <v-card-text class="text-center">
          roflmao
        </v-card-text>
        <v-card-actiona>
          <v-btn color="ui1" @click="dialog = false">
            Hi
          </v-btn>
        </v-card-actiona>
      </v-card>
    </v-dialog> -->

    <v-main>
      <MainPage/>
    </v-main>

    <v-footer app color="ui2">
      <v-sheet color="ui3" height="50" width="50">
        <v-container class="fill-height">
          <v-row class="fill-height">
            lol
          </v-row>
        </v-container>
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
const barBorder = ref<number>(3);
const elevation = ref<number>(10);
const title = ref<string>('oofgottem');
const mom = ref<string>('MOM');
const { mobile, mobileBreakpoint } = useDisplay();
const theme = useTheme();
const dark = theme.global.name;
mobileBreakpoint.value = 'sm';
console.log(useDisplay());
console.log(theme);
console.log(dark);


</script>


<style>

</style>