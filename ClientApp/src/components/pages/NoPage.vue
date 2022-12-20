<template>
  <v-container class="lol fill-height">
    <v-row no-gutters justify="center" class="lol">
      <v-col align="center" align-self="center">
        <p>lol this page not exist lol</p>
        <p>"{{ href }}"</p>
        u dum
      </v-col>
    </v-row>
  </v-container>
</template>


<script setup lang="ts">
import { onMounted, ref } from 'vue'
import * as VRoute from 'vue-router'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter();
const route = useRoute();
const noPage = route.params.noPage;
const href = window.location.href;
router.options.history.replace('/');

</script>


<style>
.lol {
  font-size: 3vw;
  align-self: center;
  justify-self: center;
  user-select: none;
  height: 100%;
}

</style>