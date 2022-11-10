<template>
<v-container class="fill-height">
    <v-textarea v-model="store.hi" hide-details class="ta fill-height flex-column d-flex flex-grow-1" label="hi" autocomplete="username" counter auto-grow variant="solo"></v-textarea>
</v-container>
</template>

<script setup lang='ts'>
import { ref } from 'vue'
import { useMainStore } from '../stores/main'

const store = useMainStore();

</script>

<style>

.ta > * {
    flex-grow: 1;
}

</style>