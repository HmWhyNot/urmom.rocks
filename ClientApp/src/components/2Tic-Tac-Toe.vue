<template>
    <v-container class="fill-height">
        <v-sheet>

            <v-container ref="con" id="con" class="ma-0 pa-0 fill-height">
                <v-row>
                    <v-col align="center">
                <div>{{ configKonva.width }} : {{ configKonva.height }}</div>
                <v-stage ref="stage" :config="configKonva">
                    <v-layer id="layer" ref="layer">
                        <v-line v-for="line in lineGroup" :config="{...configFrame, points: line}"></v-line>
                        <v-group v-for="(square, i) in squareGroup" :key="'square' + i" v-props="state" :config="{...configSquare, ...square}" @click="state.value = 1">
                            <v-circle v-if="state < 0" :config="configNaught"></v-circle>
                            <v-line v-if="state > 0" :config="configCross"></v-line>
                        </v-group>
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
const layer = ref<Konva.Layer>();
const stage = ref<Konva.Stage>();
const canvSize = { width: 600, height: 600 }
const sqSize = {width: canvSize.width / 3, height: canvSize.height / 3}
console.log(sqSize);
const lineGroup = ref<Array<Array<number>>>([
    [sqSize.width, 0, sqSize.width, canvSize.height],
    [sqSize.width * 2, 0, sqSize.width * 2, canvSize.height],
    [0, sqSize.height, canvSize.width, sqSize.height],
    [0, sqSize.height * 2, canvSize.width, sqSize.height * 2],
])
// const squareGroup = ref<Array<Array<number>>>([
//     [0, 0, canvSize.width / 3, canvSize.height / 3],
// ])
const squareGroup = ref<Array<any>>([
    { x: 0, y: 0, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width, y: 0, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width * 2, y: 0, width: sqSize.width, height: sqSize.height },
    { x: 0, y: sqSize.height, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width, y: sqSize.height, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width * 2, y: sqSize.height, width: sqSize.width, height: sqSize.height },
    { x: 0, y: sqSize.height * 2, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width, y: sqSize.height * 2, width: sqSize.width, height: sqSize.height },
    { x: sqSize.width * 2, y: sqSize.height * 2, width: sqSize.width, height: sqSize.height },
])

console.log(Konva);
console.log(VKonva);



const configKonva = {
    width: canvSize.width,
    height: canvSize.height,
}
const configFrame = {
    stroke: 'white',
    strokeWidth: 2
}
const configSquare = {
    fill: 'grey',
    opacity: 0.5
}
const configNaught = {
    stroke: 'white',
    strokeWidth: 2,
    radius: sqSize.width / 3,
    x: sqSize.width / 2,
    y: sqSize.height / 2
}
const configCross = {
    stroke: 'white',
    strokeWidth: 2,
    points: [sqSize.width / 2 - configNaught.radius, sqSize.height / 2 - configNaught.radius,
             sqSize.width / 2 + configNaught.radius, sqSize.height / 2 + configNaught.radius,
             sqSize.width / 2, sqSize.height / 2,
             sqSize.width / 2 - configNaught.radius, sqSize.height / 2 + configNaught.radius,
             sqSize.width / 2 + configNaught.radius, sqSize.height / 2 - configNaught.radius,]
}
// const lineConfig = {
//     points: [100, 0, 100, configKonva.height],
//     stroke: 'white',
//     fill: 'white',
//     strokeWidth: 5,

// }

function squareClick(e: any) {
    console.warn(e)
    console.log(e.target)
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