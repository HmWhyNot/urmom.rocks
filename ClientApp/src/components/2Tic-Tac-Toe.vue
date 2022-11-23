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
                <v-line ref="winLine" :config="{ ...configWinLine, ...winLineGroup[winLinePos] }"/>
                <v-arc ref="catsArc" :config="{ ...configCatsArc }"/>
                <v-group v-for="(square, i) in squareGroup" :key="'square' + i" :config="{ ...configSquare, ...square }" @click="squareClick(i)">
                  <v-circle v-if="gameState.field[i] < 0" :config="configNaught" />
                  <v-line v-if="gameState.field[i] > 0" :config="configCross" />
                  <v-rect :config="{...configSquare, opacity: 0}"/>
                </v-group>
                <v-group ref="msgBox" v-if="winLinePos != ''">
                  <v-rect :config="configMsgBox"/>
                  <v-text :config="{ ...configMsgText, text: winMessages[gameState.player + 1] }"/>
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
const msgBox = ref<Konva.Group>();
const winLine = ref<Konva.Line>();
const catsArc = ref<Konva.Arc>();

// sizing constants
const canvSize = { width: 600, height: 600 };
const sqSize = { width: canvSize.width / 3, height: canvSize.height / 3 };

////////////////
// game logic //
////////////////

const gameState: {[key: string]: any} = store.ticTacToe
const winLinePos = ref<'top' | 'h-mid' | 'bottom' |
                    'left' | 'v-mid' | 'right' |
                    'left-right-diag' | 'right-left-diag' | 'draw' | ''>('')
const winMessages = ref<string[]>(['Naughts wins!', "Cat's game", 'Crosses wins!']);


// object configs
const configKonva = {
  width: canvSize.width,
  height: canvSize.height,
}
const configFrame = {
  stroke: colors.ui3,
  strokeWidth: 2
}
const configSquare = {
  fill: 'grey',
  opacity: 0.5,
  width: sqSize.width,
  height: sqSize.height,
  // draggable: true
}
const configNaught = {
  stroke: colors.ui3,
  strokeWidth: 2,
  radius: sqSize.width / 3,
  x: sqSize.width / 2,
  y: sqSize.height / 2
}
const configCross = {
  stroke: colors.ui3,
  strokeWidth: 2,
  points: [sqSize.width / 2 - configNaught.radius, sqSize.height / 2 - configNaught.radius,
  sqSize.width / 2 + configNaught.radius, sqSize.height / 2 + configNaught.radius,
  sqSize.width / 2, sqSize.height / 2,
  sqSize.width / 2 - configNaught.radius, sqSize.height / 2 + configNaught.radius,
  sqSize.width / 2 + configNaught.radius, sqSize.height / 2 - configNaught.radius,]
}
const configMsgText = {
  // stroke: colors.ui3,
  fill: colors.ui3,
  fontSize: canvSize.width / 12,
  align: 'center',
  verticalAlign: 'middle',
  width: canvSize.width,
  height: canvSize.height,
}
const configMsgBox = {
  // stroke: colors.ui2,
  fill: colors.ui2,
  width: canvSize.width / 1.5,
  height: canvSize.height / 3,
  x: canvSize.width / 6,
  y: canvSize.height / 3,
  opacity: .8,
  shadowOffsetX: canvSize.width / 25,
  shadowOffsetY: canvSize.height / 25,
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
const configWinLine = {
  stroke: colors.ui3,
  strokeWidth: 2,
  points: [0, 0, canvSize.width * 1.4, 0],
  x: 0,
  y: 0,
  scaleX: 0,
  scaleY: 0,
  rotation: 0,
}
const winLineGroup = ref<{ [key: string]: object }>({
  '': {strokeWidth: 0},
  'draw': {strokeWidth: 0},
  'top': {x: 0, y: canvSize.height * 1/6},
  'h-mid': {x: 0, y: canvSize.height * 3/6},
  'bottom': {x: 0, y: canvSize.height * 5/6},
  'left': {x: canvSize.width * 1/6, y: 0, rotation: 90},
  'v-mid': {x: canvSize.width * 3/6, y: 0, rotation: 90},
  'right': {x: canvSize.width * 5/6, y: 0, rotation: 90},
  'left-right-diag': {x: 0, y: 0, rotation: 45},
  'right-left-diag': {x: canvSize.width, y: 0, rotation: 135},
})
const configCatsArc = {
  angle: 0,
  stroke: colors.ui3,
  strokeWidth: 2,
  x: canvSize.width / 2,
  y: canvSize.height / 2,
  innerRadius: 176,
  outerRadius: 176,
  rotation: 90,
}


function squareClick(i: number) {
  console.log('click');
  // place mark for current player
  if (gameState.field[i] == 0) {
    gameState.field[i] = gameState.player;
    gameState.player = gameState.player * -1;
  }

  winLinePos.value = checkWin(gameState.field);

  // clear field if full or win
if (winLinePos.value != '') {
    gameState.player = gameState.player * -1; // this is to keep the wiining player active
    // msgBox appear animation
    let msgBoxScale = 0;
    let winLineScale = 0;
    nextTick(() => {
      const msgBoxNode = msgBox.value?.getNode();
      const winLineNode = winLine.value?.getNode();
      msgBoxNode.scale({ x: 0, y: 0 });
      winLineNode.scale({ x: 0, y: 0 });
      const msgBoxAnim = new Konva.Animation((f) => {
        msgBoxScale += 3 / 16;
        winLineScale += 1 / 16;
        if (msgBoxScale >= 1) {
          msgBoxScale = 1;
        }
        if (winLineScale >= 1) {
          winLineScale = 1;
          msgBoxAnim.stop()
        }
        msgBoxNode.scale({ x: msgBoxScale, y: msgBoxScale })
        winLineNode.scale({ x: winLineScale, y: winLineScale })
      }, msgBoxNode.getLayer());
      msgBoxAnim.start();
    })
  if (winLinePos.value == 'draw') {
    let catsArcAngle = 0;
    nextTick(() => {
      const catsArcNode = catsArc.value?.getNode();
      const catsArcAnim = new Konva.Animation((f) => {
        catsArcAngle -= 15
        if (catsArcAngle <= -180) {
          catsArcAngle = -180;
          catsArcAnim.stop();
        }
        catsArcNode.angle(catsArcAngle);
      }, catsArcNode.getLayer())
      catsArcAnim.start();
    });
  }
    
    setTimeout(() => {
      gameState.field.fill(0);
      gameState.player = 1;
      winLinePos.value = '';
      console.warn('clear')
    }, 3000)
    return
  }
}

function checkWin(s: number[]) {
  // don't hate me. this works. get over it
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
  }
  if (s.reduce((p: number, c: number) => { return p * c }) != 0) {
    gameState.player = 0;
    return 'draw';
  }
  return '';
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