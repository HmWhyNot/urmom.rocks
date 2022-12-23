import { createRouter, createWebHistory, RouteRecordRaw, RouteComponent } from 'vue-router'
import NoPage from '@/components/pages/NoPage.vue'
// import MainPage from '@/components/pages/0MainPage.vue'
// import Papa from '@/components/pages/1Papa.vue'
// import TicTacToe from '@/components/pages/2Games/1Tic-Tac-Toe.vue'
// import CircleGame from '@/components/pages/2Games/2CircleGame.vue'

// const routes: RouteRecordRaw[] = [
//     { path: '/:noPage+', name: 'NoPage', component: NoPage },
//     { path: '/', name: 'MainPage', component: MainPage },
//     { path: '/papa', name: 'Papa', component: Papa },
//     { path: '/tic-tac-toe', name: 'TicTacToe', component: TicTacToe },
//     { path: '/circle-game', name: 'CircleGame', component: CircleGame },
// ]

const routes: RouteRecordRaw[] = createRoutes(import.meta.glob('../components/pages/**/**.vue'), { path: '/:noPage+', name: 'NoPage', component: NoPage });

function createRoutes(inputPages: Record<string, () => Promise<unknown>>, ...staticRoutes: RouteRecordRaw[]) {
    let r: RouteRecordRaw[] = [];
    const basePageDir: string = '../components/pages/';
    const mainPageName: string = 'MainPage';

    for (const k in inputPages) {
        const p = inputPages[k];
        const m = k.replace(basePageDir, '').match(/(\d)(\w*)(?:\/(\d)([\w-]*))?\.vue/) ?? [''];
        if (m[0] != '') {
            const i1 = parseInt(m[1]);
            const i2 = parseInt(m[3]) || 0;
            const n = m[4] || m[2];
    
            const name: string = n.replace(/(?<!-)([A-Z])/g, ' $1').trim();
            const path: string = n.replace(mainPageName, '').toLowerCase();
            const component: RouteComponent = p;
    
            if (i2 == 0) {
                r[i1] = {path: '/' + path, name: name, component: component};
            }
            else {
                r[i1].children = r[i1].children || [];
                r[i1].children![i2 - 1] = {path: path, name: name, component: component};
            }
        }
    }
    r.push(...staticRoutes);

    return r;
}

export default createRouter({
    history: createWebHistory(),
    routes,
})