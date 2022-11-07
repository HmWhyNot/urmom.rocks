import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import MainPage from '../components/0MainPage.vue'
import Papa from '../components/1Papa.vue'
import NoPage from '../components/NoPage.vue'

const routes: RouteRecordRaw[] = [
    { path: '/', name: 'MainPage', component: MainPage },
    { path: '/papa', name: 'Papa', component: Papa },
    { path: '/:noPage+', name: 'NoPage', component: NoPage },
]

export default createRouter({
    history: createWebHistory(),
    routes,
})