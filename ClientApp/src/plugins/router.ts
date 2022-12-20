import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import NoPage from '@/components/pages/NoPage.vue'
import MainPage from '@/components/pages/0/0MainPage.vue'
import Papa from '@/components/pages/0/1Papa.vue'
import TicTacToe from '@/components/pages/2/21Tic-Tac-Toe.vue'
import CircleGame from '@/components/pages/2/22CircleGame.vue'

const routes: RouteRecordRaw[] = [
    { path: '/:noPage+', name: 'NoPage', component: NoPage },
    { path: '/', name: 'MainPage', component: MainPage },
    { path: '/papa', name: 'Papa', component: Papa },
    { path: '/tic-tac-toe', name: 'TicTacToe', component: TicTacToe },
    { path: '/circle-game', name: 'CircleGame', component: CircleGame },
]
const pages = import.meta.glob('../components/pages/**').map();
console.log(pages);
// function loadRoutes() {
//     const pages = import.meta.glob('../components/pages/**');
//     // const pageList = pages.
//     for (const path in pages) {
//         console.log(path);
//     }
//     console.log('glob');
//     console.log(pages);
// }
// loadRoutes();

export default createRouter({
    history: createWebHistory(),
    routes,
})