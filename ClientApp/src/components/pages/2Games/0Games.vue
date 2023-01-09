<template>
  <v-container class="fill-height">
    <v-sheet>

      <transition appear name="pageTran" mode="out-in">
        <router-view v-slot="{ Component, route }">
          
          <v-container v-if="route.matched[0].name == route.name" ref="con" id="con" class="ma-0 pa-0 fill-height">
            <v-row justify="center" no-gutters class="fill-height">
              <v-col v-for="game in route.matched[0].children" :key="game.name" cols="4" class="pa-16">
                <router-link class="nav-link" tag="div" :to="game" replace>
                  <v-sheet>
                    <v-container>
                      <PagePreviewCard>{{ game.name }}</PagePreviewCard>
                    </v-container>
                  </v-sheet>
                </router-link>
              </v-col>
            </v-row>
          </v-container>

          <component v-else :is="Component"/>

        </router-view>
      </transition>
      
    </v-sheet>
  </v-container>
</template>

<script setup lang="ts">
import PagePreviewCard from '@/components/PagePreviewCard.vue';


</script>

<style>
</style>