<template>
    <v-container class="fill-height">
        <v-sheet>

            <v-container ref="con" id="con" alignment="center" justify="center" class="fill-height ma-0 pa-0">
                <div>{{ configKonva.width }} : {{ configKonva.height }}</div>
                <v-stage ref="stage" :config="configKonva" @click="createCircle">
                    <v-layer id="layer" ref="layer">
                        <v-circle :config="configCircle"></v-circle>
                    </v-layer> 
                </v-stage>
            </v-container>

        </v-sheet>
    </v-container>
</template>

<script setup lang="ts">
import { computed, onMounted, onUpdated, reactive, Ref, ref, watch, watchEffect, nextTick } from 'vue'
import { VContainer } from 'vuetify/lib/components/index';
import Konva from 'konva'
import VKonva from 'vue-konva'
import { isGloballyWhitelisted } from '@vue/shared';


const con = ref<VContainer>();
const KWidth = ref<number>(500);
const KHeight = ref<number>(500);
const layer = ref<Konva.Layer>();

console.log(Konva);
console.log(VKonva);



const configKonva = {
    width: KWidth.value,
    height: KHeight.value,
}
const configCircle: Konva.CircleConfig = {
    radius: 70,
    x: configKonva.width / 2,
    y: configKonva.height / 2,
    fill: "red",
    stroke: "black",
    strokeWidth: 4,
}

function createCircle(e: any) {
    const x = ref<unknown>(e.evt.offsetX)
    const y = ref<number>(e.evt.offsetY)
    console.log(x);
    console.log(y);
    console.log(e);
    console.log(e.evt);
    console.log(e.evt.target);

}

onMounted(() => {
    console.warn('Layer');
    console.log(layer);
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