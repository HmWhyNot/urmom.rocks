import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import NoPage from '@/components/pages/NoPage.vue'
import MainPage from '@/components/pages/0MainPage.vue'
import Papa from '@/components/pages/1Papa.vue'
import TicTacToe from '@/components/pages/2Games/1Tic-Tac-Toe.vue'
import CircleGame from '@/components/pages/2Games/2CircleGame.vue'

// const routes: RouteRecordRaw[] = [
//     { path: '/:noPage+', name: 'NoPage', component: NoPage },
//     { path: '/', name: 'MainPage', component: MainPage },
//     { path: '/papa', name: 'Papa', component: Papa },
//     { path: '/tic-tac-toe', name: 'TicTacToe', component: TicTacToe },
//     { path: '/circle-game', name: 'CircleGame', component: CircleGame },
// ]

let routes: RouteRecordRaw[] = [
    { path: '/:noPage+', name: 'NoPage', component: NoPage },
    { path: '/', name: 'MainPage', component: MainPage },
]

const basePageDir: string = '../components/pages/';
const mainPageName: string = 'MainPage';
// const pageList: Record<string, () => Promise<unknown>> = import.meta.glob('../components/pages/**/**.vue');
const pageList: Record<string, () => Promise<unknown>> = import.meta.glob('../components/pages/**/**.vue');
let pages: { [key: string]: () => Promise<unknown> }[][] = [];
for (const k in pageList) {
    const p = pageList[k];
    const m = k.replace(basePageDir, '').match(/(\d)(\w*)(?:\/(\d)([\w-]*))?\.vue/) ?? [''];
    if (m[0] != '') {
        const i1 = parseInt(m[1]);
        const i2 = parseInt(m[3]) || 0;
        const n = m[4] || m[2];
        if (!pages[i1]) { pages[i1] = [] };
        pages[i1][i2] = { [n]: p };
    }
}
console.log('glob');
console.log(pageList);
console.warn(pages);

for (const p of pages) {
    console.log('h');
    console.log(p);
    const name: string = Object.keys(p[0])[0].toString().replace(/(^-[A-Z])/g, ' $1').trim();
    const path: string = '/' + name.replace(mainPageName, '').toLowerCase();
    const component: unknown = p[0][name];
    let children: object[] = [];
    for (const c of p.slice(1)) {
        const n = Object.keys(c)[0];
        children.push({ path: n.toLowerCase(), name: n.toString().replace(/(^-[A-Z])/g, ' $1').trim(), component: Object.values(c)[0]});
    }
    console.log(name);
    console.log(path);
    console.log(component);
    console.log(children);
}

export default createRouter({
    history: createWebHistory(),
    routes,
})