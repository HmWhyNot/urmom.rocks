<template>
    <v-container ref="con" alignment="center" justify="center" class="fill-height">
        <div>{{ canvWidth }} : {{ canvHeight }}</div>
        <!-- <canvas ref="ttt" id="ttt" @mousemove="draw" @mousedown="isDrawing = true" @mouseup="isDrawing = false" :width="canvSize?.width" :height="canvSize?.height">Tic Tac Toe</canvas> -->
        <canvas ref="ttt" id="ttt" @mousemove="draw" @mousedown="isDrawing = true" @mouseup="isDrawing = false" :width="canvWidth" :height="canvHeight">Tic Tac Toe</canvas>
    </v-container>
</template>

<script setup lang="ts">
import { computed, onMounted, onUpdated, reactive, Ref, ref, watch, watchEffect } from 'vue'

const ttt = ref<HTMLCanvasElement>();
const con = ref<HTMLCanvasElement>();
const isDrawing = ref<boolean>(false);
const mousePos = ref<{x: number, y: number}>({x: 0, y: 0});
// const canvSize = ref<{ width: number, height: number }>();
const canvSize = ref<{ width: Ref<number>, height: Ref<number> }>({width: ref<number>(ttt.value?.clientWidth || 0), height: ref<number>(ttt.value?.clientHeight || 0)});
const canvWidth = ref<number>();
const canvHeight = ref<number>();
// const canvWidth = computed(() => ttt.value?.clientWidth);
// const canvHeight = computed(() => ttt.value?.clientHeight);
// watch<number>(ref<number>(ttt.value?.clientWidth || 0), () => {canvWidth.value = 0; console.log('yes')});
// watch<number>(ref<number>(ttt.value?.clientHeight || 0), () => {canvHeight.value = 0; console.log('no')});
watch(ttt, () => {canvWidth.value = ttt.value?.clientWidth}, {immediate: true, deep: true});
watch(ttt, () => {canvHeight.value = ttt.value?.clientHeight}, {immediate: true, deep: true});
const canvHW = computed(() => ttt.value)
console.log(canvSize);
console.log(ttt);
onUpdated(() => {
    canvWidth.value = ttt.value!.clientWidth;
    canvHeight.value = ttt.value!.clientHeight;
});


// watchEffect(() => {
//     // canvSize.value = {width: ttt.value?.clientWidth || 0, height: ttt.value?.clientHeight || 0};
//     canvWidth.value = ttt.value?.clientWidth;
//     canvHeight.value = ttt.value?.clientHeight;
// });

// function draw(canv: HTMLCanvasElement): void {
//     const ctx = canv.getContext('2d')!;
//     ctx.beginPath();
//     ctx.arc(10, 10, 10, 0, 1);
//     ctx.stroke();
// }
function draw(e: MouseEvent): void {
    // canvWidth.value = ttt.value!.clientWidth;
    // canvHeight.value = ttt.value!.clientHeight;
    if (isDrawing.value) {
        const ctx = ttt.value?.getContext('2d')!;
        ctx.beginPath();
        ctx.moveTo(mousePos.value.x, mousePos.value.y);
        ctx.lineTo(e.offsetX, e.offsetY);
        ctx.stroke();
        mousePos.value = {x: e.offsetX, y: e.offsetY};
        console.log(ttt.value?.clientWidth);
        console.log(ttt);
        console.log(canvSize);
        console.warn(ttt.value?.clientWidth);
        console.log(canvWidth);
        console.warn(ttt.value?.clientHeight);
        console.log(canvHeight);
        console.warn(canvHW.value);
        console.log(canvHW.value?.clientWidth);
        console.log(canvHW.value?.clientHeight);
    }
    else {
        mousePos.value = {x: e.offsetX, y: e.offsetY};
    }
}

onMounted(() => {
    const canvas = ttt.value!;
    // canvSize.value = { width: canvas.clientWidth, height: canvas.clientHeight};
    // canvSize.value = { width: ref<number>(canvas.clientWidth).value, height: ref<number>(canvas.clientHeight).value};
    
    // canvSize.value.width = canvas.clientWidth;
    // canvSize.value.height = canvas.clientHeight;
    
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