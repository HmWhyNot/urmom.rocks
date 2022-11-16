import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import NoPage from '@/components/NoPage.vue'
import MainPage from '@/components/0MainPage.vue'
import Papa from '@/components/1Papa.vue'
import TicTacToe from '@/components/2Tic-Tac-Toe.vue'
import CircleGame from '@/components/3CircleGame.vue'

const routes: RouteRecordRaw[] = [
    { path: '/:noPage+', name: 'NoPage', component: NoPage },
    { path: '/', name: 'MainPage', component: MainPage },
    { path: '/papa', name: 'Papa', component: Papa },
    { path: '/tic-tac-toe', name: 'TicTacToe', component: TicTacToe },
    { path: '/circle-game', name: 'CircleGame', component: CircleGame },
]

export default createRouter({
    history: createWebHistory(),
    routes,
})