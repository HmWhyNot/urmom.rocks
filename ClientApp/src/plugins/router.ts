import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import MainPage from '../components/0MainPage.vue'
import HelloWorld from '../components/HelloWorld.vue'
import Papa from '../components/1Papa.vue'

const routes: RouteRecordRaw[] = [
    { path: '/', name: 'MainPage', component: MainPage, },
    { path: '/papa', name: 'Papa', component: Papa },
    // { path: '/:(*)', name: 'HelloWorld', component: HelloWorld },
    // { path: '/:noPage(*)', name: 'NoPage', component: NoPage },
]

export default createRouter({
    history: createWebHistory(),
    routes,
})