<template>
    <v-container ref="con" id="con" alignment="center" justify="center" class="fill-height ma-0 pa-0">
        <div>{{  }} : {{  }}</div>

        <v-stage @click="createCircle" :config="configKonva">
            <v-layer>
                <v-circle :config="configCircle"></v-circle>
            </v-layer> 
        </v-stage>
        
    </v-container>
</template>

<script setup lang="ts">
import { computed, onMounted, onUpdated, reactive, Ref, ref, watch, watchEffect, nextTick } from 'vue'
import { VContainer } from 'vuetify/lib/components/index';
import Konva from 'konva'
import VKonva from 'vue-konva'


const con = ref<VContainer>();

console.log(Konva);
console.log(VKonva);



const configKonva = {
    width: 500,
    height: 500,
}
const configCircle = {
    radius: 70,
    x: configKonva.width / 2,
    y: configKonva.height / 2,
    fill: "red",
    stroke: "black",
    strokeWidth: 4,
}

function createCircle(e) {
    const x = ref<number>(e.evt.offsetX)
    const y = ref<number>(e.evt.offsetY)

}

onMounted(() => {
    //
})
</script>

<style>
#ttt {
    width: 100%;
    height: auto;
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid grey;
}

</style>