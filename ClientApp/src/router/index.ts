import * as VueRouter from 'vue-router'
import MainPage from '../components/0MainPage.vue'
import HelloWorld from '../components/HelloWorld.vue'
import Papa from '../components/1Papa.vue'

const routes = [
    { path: '/', name: 'MainPage', component: MainPage },
    { path: '/papa', name: 'Papa', component: Papa },
    { name: 'HelloWorld', component: HelloWorld },
]

const router = VueRouter.createRouter({
    history: VueRouter.createWebHistory(),
    routes,
})

export default router