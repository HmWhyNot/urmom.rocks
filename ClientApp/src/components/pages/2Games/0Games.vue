<template>
  <v-container class="fill-height">
    <v-sheet>

      <transition appear name="pageTran" mode="out-in">
        <router-view v-slot="{ Component, route }">
          
          <v-container v-if="route.matched[0].name == route.name" ref="con" id="con" class="ma-0 pa-0 fill-height">
            <v-row justify="center" class="fill-height">
              Implement list of games here
            </v-row>
          </v-container>

          <component v-else :is="Component"></component>

        </router-view>
      </transition>
      
    </v-sheet>
  </v-container>
</template>