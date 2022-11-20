<template>
  <v-container class="fill-height">
    <v-sheet>

      <v-container ref="con" id="con" class="ma-0 pa-0 fill-height">
        <v-row>
          <v-col align="center">
            <div>Current Player: {{ (gameState.player < 0) ? 'Naughts' : 'Crosses' }}</div>
            <v-stage ref="stage" :config="configKonva">
              <v-layer id="layer" ref="layer">
                <v-line v-for="line in frameGroup" :config="{ ...configFrame, points: line }" />
                <v-line :config="{ ...configFrame, points: winLineGroup[winLine] }"/>
                <v-group v-for="(square, i) in squareGroup" :key="'square' + i" :config="{ ...configSquare, ...square }" @click="squareClick(i)">
                  <v-circle v-if="gameState.field[i] < 0" :config="configNaught" />
                  <v-line v-if="gameState.field[i] > 0" :config="configCross" />
                  <v-rect :config="{...configSquare, opacity: 0}"/>
                </v-group>
                <v-group v-if="winLine != 'none' || gameState.player == 0">
                  <v-rect/>
                  <v-text :config="{ ...configEndText, text: winMessages[gameState.player + 1] }"/>
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
import { useMainStore } from '@/stores/mainStore'
import vuetify from '@/plugins/vuetify';

const store = useMainStore();
const colors = vuetify.theme.current.value.colors;


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

// sizing constants
const canvSize = { width: 600, height: 600 };
const sqSize = { width: canvSize.width / 3, height: canvSize.height / 3 };

////////////////
// game logic //
////////////////

const gameState: {[key: string]: any} = store.ticTacToe
const winLine = ref<'top' | 'h-mid' | 'bottom' |
                    'left' | 'v-mid' | 'right' |
                    'left-right-diag' | 'right-left-diag' | 'none' | ''>('')
const winMessages = ref<string[]>(['Naughts wins!', "Cat's game", 'Crosses wins!']);


// object configs
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
const configEndText = {
  // stroke: colors.ui3,
  fill: colors.ui3,
  fontSize: 48,
  align: 'center',
  verticalAlign: 'middle',
  width: canvSize.width,
  height: canvSize.height,
}


// arrays for object positioning
const frameGroup = ref<number[][]>([
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
const winLineGroup = ref<{[key: string]: number[]}>({
  'none': [],
  'top': [0, sqSize.height * 0.5, canvSize.width, sqSize.height * 0.5],
  'h-mid': [0, sqSize.height * 1.5, canvSize.width, sqSize.height * 1.5],
  'bottom': [0, sqSize.height * 2.5, canvSize.width, sqSize.height * 2.5],
  'left': [sqSize.width * 0.5, 0, sqSize.width * 0.5, canvSize.height],
  'v-mid': [sqSize.width * 1.5, 0, sqSize.width * 1.5, canvSize.height],
  'right': [sqSize.width * 2.5, 0, sqSize.width * 2.5, canvSize.height],
  'left-right-diag': [0, 0, canvSize.width, canvSize.height],
  'right-left-diag': [canvSize.width, 0, 0, canvSize.height],
})


function squareClick(i: number) {
  console.log('click');
  // place mark for current player
  if (gameState.field[i] == 0) {
    gameState.field[i] = gameState.player;
  }

  winLine.value = checkWin(gameState.field);
  console.log(winLine.value)

  // clear field if full or win
  if (winLine.value != '' ) {
    console.log('here')
    setTimeout(() => {
      gameState.field.fill(0);
      gameState.player = 1;
      console.log(gameState.player)
      winLine.value = '';
      console.log(gameState.player)
      console.warn('clear')
    }, 3000)
    return
  }
  //switches player
  gameState.player = gameState.player * -1;
}

function checkWin(s: number[]) {
  // don't hate me. this works. get over it
  if (s.reduce((p: number, c: number) => { return p * c }) != 0) {
    return 'none'
  }
  switch (9) {
    case ((s[0] + s[1] + s[2]) ** 2):
      return 'top';
    case ((s[3] + s[4] + s[5]) ** 2):
      return 'h-mid';
    case ((s[6] + s[7] + s[8]) ** 2):
      return 'bottom';
    case ((s[0] + s[3] + s[6]) ** 2):
      return 'left';
    case ((s[1] + s[4] + s[7]) ** 2):
      return 'v-mid';
    case ((s[2] + s[5] + s[8]) ** 2):
      return 'right';
    case ((s[0] + s[4] + s[8]) ** 2):
      return 'left-right-diag';
    case ((s[2] + s[4] + s[6]) ** 2):
      return 'right-left-diag';
    default:
        return ''      
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