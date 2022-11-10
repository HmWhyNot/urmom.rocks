<template>
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

                      <v-row dense class="flex-column">
                        <v-col v-for="m in store.momTextList">
                          <v-sheet color="ui1">{{ m }}</v-sheet>
                        </v-col>
                      </v-row>
                      
                      <v-textarea label="Ur mom is a" variant="solo" :elevation="0" v-model="store.momText"></v-textarea>
                      
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
              <v-switch class="d-flex flex-row-reverse" :label="store.dark" hide-details width="min" v-model="store.dark" true-value="light" false-value="dark"/>
              <v-hover v-slot="{ isHovering, props }">
                <v-card v-bind="props" :style="isHovering ? { opacity: 1 } : { opacity: 0 }" class="dad">
                  <div @click="emit('dad')" v-if="isHovering">dad</div>
                </v-card>
              </v-hover>
            </v-row>
          </v-col>

        </v-row>
      </v-container>
    </v-app-bar>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useDisplay } from 'vuetify'
import { useMainStore } from '../stores/main'

// const props = defineProps({});
const emit = defineEmits<{
  (e: 'dad'): void
}>();
const store = useMainStore();

const dialog = ref<boolean>(false);
const barBorder = ref<number>(300);
const elevation = ref<number>(10);
const title = ref<string>('oofgottem');
const mom = ref<string>('MOM');
const { mobile } = useDisplay();
const dgMsg = ref<string>('roflmao');


function dgHi() {
  dgMsg.value = 'How rude!!';
  store.momCount++;
  store.momTextList.push(store.momText);
  store.momText = '';
  setTimeout(() => {
    dgMsg.value = 'roflmao';
  }, 2000);
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

</style>