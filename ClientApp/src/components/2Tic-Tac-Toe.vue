<template>
    <v-container>
        <canvas ref="ttt" id="ttt">Tic Tac Toe</canvas>
    </v-container>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'

const root = ref();

onMounted(() => {
    console.log(root.value);
})
</script>

<style>

</style>