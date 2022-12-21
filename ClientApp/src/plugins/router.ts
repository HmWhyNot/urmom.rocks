import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import NoPage from '@/components/pages/NoPage.vue'
import MainPage from '@/components/pages/0/0MainPage.vue'
import Papa from '@/components/pages/0/1Papa.vue'
import TicTacToe from '@/components/pages/2/1Tic-Tac-Toe.vue'
import CircleGame from '@/components/pages/2/2CircleGame.vue'

const basePageDir: string = '../components/pages/';
const pages: Record<string, () => Promise<unknown>> = import.meta.glob('../components/pages/*/**.vue');
const pageList: string[] = Object.keys(pages).map(a => a.replace(basePageDir, ''));
let pageObj: {[key: string]: object[]} = {};
for (const k in pages) {
    const p = pages[k];
    const m = k.replace(basePageDir, '').match(/(\d)\/(\d)(.*)\.vue/) ?? [''];
    if (!(m[1] in pageObj)) { pageObj[m[1]] = [] };
    pageObj[m[1]][Number(m[2])] = { [m[3]]: p};
}
console.log('glob');
console.log(pages);
console.log(pageList);
console.warn(pageObj);

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