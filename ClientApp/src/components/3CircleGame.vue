<template>
    <v-container class="fill-height">
        <v-sheet>

            <v-container ref="con" id="con" class="ma-0 pa-0 fill-height">
                <v-row>
                    <v-col align="center">
                <div>{{ configKonva.width }} : {{ configKonva.height }}</div>
                <v-stage ref="stage" :config="configKonva">
                    <v-layer id="layer" ref="layer">
                        <v-circle ref="cir" id="cir" @click="moveCircle" :config="configCircle"></v-circle>
                    </v-layer> 
                </v-stage>
            </v-col>
            </v-row>
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
import { Vue } from 'vue-demi';


const con = ref<VContainer>();
const KWidth = ref<number>(500);
const KHeight = ref<number>(500);
const layer = ref<Konva.Layer>();
const cir = ref<Konva.Circle>();
const stage = ref<Konva.Stage>();

console.log(Konva);
console.log(VKonva);



const configKonva = {
    width: KWidth.value,
    height: KHeight.value,
}
const configCircle = {
    radius: 70,
    x: Math.random() * configKonva.width,
    y: Math.random() * configKonva.height,
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

function moveCircle(e: any) {
    e.target.position({x: Math.random() * configKonva.width, y: Math.random() * configKonva.height});

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
#con {
    align-items: center;
    justify-items: center;
    align-content: center;
    justify-content: center;
}

</style>