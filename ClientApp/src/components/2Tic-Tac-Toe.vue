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
                        <v-group v-for="(square, i) in squareGroup" :key="'square' + i" :config="{...configSquare, ...square}" @click="squareClick(i)">
                            <v-circle v-if="gameState[i] > 0" :config="configNaught"></v-circle>
                            <v-line v-if="gameState[i] < 0" :config="configCross"></v-line>
                            <v-rect :config="{...configSquare}"></v-rect>
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
import { useMainStore } from '@/stores/mainStore'

const store = useMainStore();

interface KEvent {
    currentTarget: Konva.Node,
    evt: MouseEvent,
    pointerId: number,
    target: Konva.Node,
    type: string
}
interface squarePos {
    x: number,
    y: number
}

const con = ref<VContainer>();
const layer = ref<Konva.Layer>();
const stage = ref<Konva.Stage>();
const canvSize = { width: 600, height: 600 };
const sqSize = { width: canvSize.width / 3, height: canvSize.height / 3 };

// game logic
const gameState = ref<number[]>(store.ticTacToe.gameState);
const currentPlayer = ref<number>(1); // 1 = naughts, -1 = crosses


const lineGroup = ref<number[][]>([
    [sqSize.width, 0, sqSize.width, canvSize.height],
    [sqSize.width * 2, 0, sqSize.width * 2, canvSize.height],
    [0, sqSize.height, canvSize.width, sqSize.height],
    [0, sqSize.height * 2, canvSize.width, sqSize.height * 2],
])
const squareGroup = ref<squarePos[]>([
    { x: 0, y: 0 },
    { x: sqSize.width, y: 0 },
    { x: sqSize.width * 2, y: 0 },
    { x: 0, y: sqSize.height },
    { x: sqSize.width, y: sqSize.height },
    { x: sqSize.width * 2, y: sqSize.height },
    { x: 0, y: sqSize.height * 2 },
    { x: sqSize.width, y: sqSize.height * 2 },
    { x: sqSize.width * 2, y: sqSize.height * 2 },
])

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
    opacity: 0.5,
    width: sqSize.width,
    height: sqSize.height,
    state: 0
    // draggable: true
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



function squareClick(i: number) {
    if (gameState.value[i] == 0) {
        gameState.value[i] = currentPlayer.value;
        currentPlayer.value = currentPlayer.value * -1
    }
    if (gameState.value.reduce((p, c) => { return p * c }) != 0) {
        setTimeout(() => {
            gameState.value = gameState.value.map(() => { return 0 })
            currentPlayer.value = 1;
            console.warn('clear')
        },3000)
    }
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