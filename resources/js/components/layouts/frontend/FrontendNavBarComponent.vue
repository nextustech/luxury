<template>
    <header id="site-header" class="site-header header-v1 color-white" :class="isSticky === true ? 'fixed top-0 left-0 z-40 w-full bg-white border-b border-gray-100 shadow-sm' : 'sticky top-0 z-40 w-full bg-white border-b border-gray-100 shadow-sm'">
        <!-- Mobile Header -->
        <div class="header-mobile lg:hidden">
            <div class="section-padding py-3 sm:py-4">
                <div class="section-container">
                    <div class="row">
                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-3 col-3 header-left flex items-center">
                            <div class="navbar-header">
                                <button type="button" id="show-megamenu" class="navbar-toggle p-2 hover:bg-gray-100 rounded-lg transition-colors" @click.prevent="showTarget('mobile-sidebar-canvas', 'canvas-active')">
                                    <i class="lab-line-humburger text-xl text-gray-800"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6 header-center flex items-center justify-center">
                            <div class="site-logo">
                                <router-link :to="{ name: 'frontend.home' }">
                                    <img :src="setting.theme_logo" :alt="setting.company_name" height="50" class="object-contain" />
                                </router-link>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-3 col-3 header-right flex items-center justify-end">
                            <div class="mojuri-topcart dropdown">
                                <div class="dropdown mini-cart top-cart">
                                    <a class="dropdown-toggle cart-icon p-2 relative inline-flex hover:bg-gray-100 rounded-lg transition-colors" @click.prevent="openCanvas('cart-canvas')" href="#" role="button">
                                        <div class="icons-cart">
                                            <i class="icon-large-paper-bag text-xl text-gray-800"></i>
                                            <span v-if="carts.length > 0" class="cart-count absolute -top-1 -right-1 bg-primary text-white text-xs font-bold w-5 h-5 rounded-full flex items-center justify-center">{{ carts.length }}</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="header-mobile-fixed fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 flex items-center justify-around py-2 px-1 safe-area-bottom">
                <!-- Shop -->
                <div class="shop-page flex-1">
                    <router-link :to="{ name: 'frontend.product' }" class="flex flex-col items-center gap-0.5 p-2 hover:text-primary transition-colors rounded-lg group">
                        <i class="wpb-icon-shop text-xl text-gray-700 group-hover:text-primary"></i>
                        <span class="text-xs font-medium text-gray-600 group-hover:text-primary hidden sm:inline">{{ $t('label.shop') }}</span>
                    </router-link>
                </div>

                <!-- Login -->
                <div class="my-account flex-1">
                    <div class="login-header">
                        <router-link :to="logged ? { name: 'frontend.account.orderHistory' } : { name: 'auth.login' }" class="flex flex-col items-center gap-0.5 p-2 hover:text-primary transition-colors rounded-lg group">
                            <i class="wpb-icon-user text-xl text-gray-700 group-hover:text-primary"></i>
                            <span class="text-xs font-medium text-gray-600 group-hover:text-primary hidden sm:inline">{{ logged ? $t('label.account') : $t('label.login') }}</span>
                        </router-link>
                    </div>
                </div>

                <!-- Search -->
                <div class="search-box flex-1">
                    <div class="search-toggle flex flex-col items-center gap-0.5 p-2 hover:bg-gray-100 rounded-lg transition-colors cursor-pointer group" @click.prevent="showTarget('search', 'search-active')">
                        <i class="wpb-icon-magnifying-glass text-xl text-gray-700 group-hover:text-primary"></i>
                        <span class="text-xs font-medium text-gray-600 group-hover:text-primary hidden sm:inline">{{ $t('label.search') }}</span>
                    </div>
                </div>

                <!-- Wishlist -->
                <div class="wishlist-box flex-1">
                    <router-link :to="{ name: 'frontend.wishlist' }" class="flex flex-col items-center gap-0.5 p-2 relative hover:text-red-600 transition-colors rounded-lg group">
                        <i class="wpb-icon-heart text-xl text-gray-700 group-hover:text-red-600"></i>
                        <span v-if="wishlists.length > 0" class="absolute -top-0.5 -right-0.5 bg-red-600 text-white text-xs font-bold w-5 h-5 rounded-full flex items-center justify-center">{{ wishlists.length }}</span>
                        <span class="text-xs font-medium text-gray-600 group-hover:text-red-600 hidden sm:inline">{{ $t('label.wishlist') }}</span>
                    </router-link>
                </div>
            </div>
        </div>

        <!-- Desktop Header -->
        <div class="header-desktop">
            <div class="header-wrapper">
                <div class="section-padding">
                    <div class="section-container large p-l-r">
                        <div class="row">
                            <!-- Logo -->
                            <div class="col-xl-3 col-lg-3 col-md-12 col-sm-12 col-12 header-left">
                                <div class="site-logo">
                                    <router-link :to="{ name: 'frontend.home' }">
                                        <img :src="setting.theme_logo" :alt="setting.company_name" height="140" />
                                    </router-link>
                                </div>
                            </div>

                            <!-- Navigation Menu -->
                            <div class="col-xl-6 col-lg-6 col-md-12 col-sm-12 col-12 text-center header-center">
                                <div class="site-navigation">
                                    <nav id="main-navigation">
                                        <ul id="menu-main-menu" class="menu">
                                            <li class="level-0 menu-item" :class="{ 'current-menu-item': checkIsPathAndRoutePathSame('/home') }">
                                                <router-link :to="{ name: 'frontend.home' }" class="font-medium text-gray-700 hover:text-primary transition-colors py-2 inline-block">
                                                    <span class="menu-item-text">{{ $t("label.home") }}</span>
                                                </router-link>
                                            </li>
                                            <li class="level-0 menu-item menu-item-has-children group relative">
                                                <a href="#" @click.prevent="" class="font-medium text-gray-700 hover:text-primary transition-colors flex items-center gap-1.5 py-2">
                                                    <span class="menu-item-text">{{ $t('label.categories') }}</span>
                                                    <i class="fa-solid fa-chevron-down text-xs group-hover:rotate-180 transition-transform duration-300"></i>
                                                </a>
                                                <ul class="sub-menu absolute left-0 mt-0 w-56 bg-white border border-gray-100 rounded-lg shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 top-full pt-2 z-50" v-if="categories.length > 0">
                                                    <li v-for="category in categories" :key="category.id" class="border-b border-gray-100 last:border-0">
                                                        <router-link :to="{ name: 'frontend.product', query: { category: category.slug } }" class="block px-4 py-3 text-sm text-gray-700 hover:text-primary hover:bg-primary/5 transition-all">
                                                            <span class="menu-item-text font-medium">{{ category.name }}</span>
                                                        </router-link>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li class="level-0 menu-item" :class="{ 'current-menu-item': checkIsPathAndRoutePathSame('/offers') }">
                                                <router-link :to="{ name: 'frontend.offers' }" class="font-medium text-gray-700 hover:text-primary transition-colors py-2 inline-block">
                                                    <span class="menu-item-text">{{ $t("label.offers") }}</span>
                                                </router-link>
                                            </li>
                                            <li class="level-0 menu-item">
                                                <a href="#" @click.prevent="" class="font-medium text-gray-700 hover:text-primary transition-colors py-2 inline-block">
                                                    <span class="menu-item-text">{{ $t('label.pages') }}</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>

                            <!-- Header Right Icons -->
                            <div class="col-xl-3 col-lg-3 col-md-12 col-sm-12 col-12 header-right">
                                <div class="header-page-link">
                                    <!-- Search -->
                                    <div class="search-box">
                                        <div class="search-toggle" @click.prevent="showTarget('search-desktop', 'search-active')">
                                            <i class="icon-search"></i>
                                        </div>
                                    </div>

                                    <!-- Login -->
                                    <div class="login-header icon">
                                        <a class="active-login" href="#" @click.prevent="">
                                            <i class="icon-user"></i>
                                        </a>
                                        <div class="form-login-register" v-if="!logged">
                                            <div class="box-form-login">
                                                <div class="active-login"></div>
                                                <div class="box-content">
                                                    <div class="form-login active">
                                                        <form @submit.prevent="" method="post" class="login">
                                                            <h2>{{ $t('button.login_to_your_account') }}</h2>
                                                            <router-link :to="{ name: 'auth.login' }" class="button">
                                                                {{ $t('button.login_to_your_account') }}
                                                            </router-link>
                                                        </form>
                                                    </div>
                                                    <div class="form-register">
                                                        <form @submit.prevent="" method="post" class="register">
                                                            <h2>{{ $t('button.register_your_account') }}</h2>
                                                            <router-link :to="{ name: 'auth.signup' }" class="button">
                                                                {{ $t('button.register_your_account') }}
                                                            </router-link>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-login-register" v-else>
                                            <div class="box-form-login">
                                                <div class="box-content">
                                                    <nav class="flex flex-col py-2">
                                                        <router-link v-if="profile.role_id !== enums.roleEnum.CUSTOMER"
                                                            :to="{ path: '/admin/' + defaultMenu?.url }"
                                                            class="flex items-center gap-3 px-4 py-2">
                                                            {{ $t('menu.' + defaultMenu?.language) }}
                                                        </router-link>
                                                        <router-link :to="{ name: 'frontend.account.orderHistory' }"
                                                            class="flex items-center gap-3 px-4 py-2">
                                                            {{ $t('menu.order_history') }}
                                                        </router-link>
                                                        <router-link :to="{ name: 'frontend.account.accountInfo' }"
                                                            class="flex items-center gap-3 px-4 py-2">
                                                            {{ $t('menu.account_info') }}
                                                        </router-link>
                                                        <button @click.prevent="logout()"
                                                            class="flex items-center gap-3 px-4 py-2">
                                                            {{ $t('button.logout') }}
                                                        </button>
                                                    </nav>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Wishlist -->
                                    <div class="wishlist-box">
                                        <router-link :to="{ name: 'frontend.wishlist' }">
                                            <i class="icon-heart"></i>
                                        </router-link>
                                        <span class="count-wishlist">{{ wishlists.length }}</span>
                                    </div>

                                    <!-- Cart -->
                                    <div class="mojuri-topcart dropdown light">
                                        <div class="dropdown mini-cart top-cart">
                                            <a class="dropdown-toggle cart-icon" @click.prevent="openCanvas('cart-canvas')" href="#" role="button">
                                                <div class="icons-cart">
                                                    <i class="icon-large-paper-bag"></i>
                                                    <span class="cart-count">{{ carts.length }}</span>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Desktop Search -->
    <form @submit.prevent="search" id="search-desktop"
        class="hidden w-full lg:w-auto fixed inset-0 z-30 py-5 px-4 bg-white transition-all duration-500 origin-top scale-y-0">
        <div class="flex items-center justify-between mb-4">
            <router-link :to="{ name: 'frontend.home' }">
                <img class="w-28 sm:w-32" :src="setting.theme_logo" :alt="setting.company_name">
            </router-link>
            <button type="button" @click.prevent="hideTarget('search-desktop', 'search-active')">
                <i class="lab-line-circle-cross text-xl text-danger"></i>
            </button>
        </div>
        <div class="w-full h-10 rounded-3xl flex items-center gap-2 px-4 mb-4 border border-gray-100 bg-gray-100 transition-all duration-300 focus-within:border-primary focus-within:bg-white">
            <button type="button" class="lab-line-search text-lg flex-shrink-0"></button>
            <input id="searchSomething" v-model="searchProduct" @keyup="searchElement" class="w-full h-full" type="search" :placeholder="$t('label.search') + '...'">
        </div>
        <div class="lg:hidden h-[calc(100vh_-_140px)] rounded-xl overflow-y-auto p-4 bg-gray-100">
            <ul v-if="searchProductLists.length > 0" id="searchProductLists">
                <li v-for="searchProductList in searchProductLists" :key="searchProductList.name"
                    @click.prevent="goSearchProduct(searchProductList.slug)"
                    class="py-1 hover:px-2 whitespace-nowrap overflow-hidden text-ellipsis rounded-lg transition-all duration-300 hover:bg-white hover:text-primary">
                    {{ searchProductList.name }}
                </li>
            </ul>
        </div>
    </form>

    <!-- Mobile Search -->
    <form @submit.prevent="search" id="search"
        class="w-full fixed inset-0 z-30 py-5 px-4 bg-white transition-all duration-500 origin-top scale-y-0">
        <div class="flex items-center justify-between mb-4">
            <router-link :to="{ name: 'frontend.home' }">
                <img class="w-28 sm:w-32" :src="setting.theme_logo" :alt="setting.company_name">
            </router-link>
            <button type="button" @click.prevent="hideTarget('search', 'search-active')">
                <i class="lab-line-circle-cross text-xl text-danger"></i>
            </button>
        </div>
        <div class="w-full h-10 rounded-3xl flex items-center gap-2 px-4 mb-4 border border-gray-100 bg-gray-100 transition-all duration-300 focus-within:border-primary focus-within:bg-white">
            <button type="button" class="lab-line-search text-lg flex-shrink-0"></button>
            <input id="searchSomething2" v-model="searchProduct" @keyup="searchElement" class="w-full h-full" type="search" :placeholder="$t('label.search') + '...'">
        </div>
        <div class="lg:hidden h-[calc(100vh_-_140px)] rounded-xl overflow-y-auto p-4 bg-gray-100">
            <ul v-if="searchProductLists.length > 0" id="searchProductLists2">
                <li v-for="searchProductList in searchProductLists" :key="searchProductList.name"
                    @click.prevent="goSearchProduct(searchProductList.slug)"
                    class="py-1 hover:px-2 whitespace-nowrap overflow-hidden text-ellipsis rounded-lg transition-all duration-300 hover:bg-white hover:text-primary">
                    {{ searchProductList.name }}
                </li>
            </ul>
        </div>
    </form>

    <!-- Notification -->
    <div id="order-modal" v-if="orderNotificationStatus" ref="orderNotificationModal" class="modal active ff-modal">
        <div class="modal-dialog max-w-[360px] p-6 text-center relative">
            <button @click.prevent="closeOrderNotificationModal('order-modal', 'modal-active')"
                class="modal-close absolute top-4 right-4">
                <i class="fa-regular fa-circle-xmark"></i>
            </button>
            <h3 class="text-[18px] font-semibold leading-8 mb-6">
                {{ orderNotificationMessage }}
                <span class="block">{{ $t('message.please_check_your_order_list') }}</span>
            </h3>
            <router-link :to="{ path: '/admin/' + orderNotification.url }"
                class="db-btn h-[38px] shadow-[0px_6px_10px_rgba(255,_0,_107,_0.24)] bg-primary text-white">
                {{ $t('button.let_me_check') }}
            </router-link>
        </div>
    </div>

</template>

<script>
import statusEnum from "../../../enums/modules/statusEnum";
import { onMounted, ref } from "vue";
import targetService from "../../../services/targetService";
import appService from "../../../services/appService";
import activityEnum from "../../../enums/modules/activityEnum";
import roleEnum from "../../../enums/modules/roleEnum";
import orderTypeEnum from "../../../enums/modules/orderTypeEnum";
import { initializeApp } from "firebase/app";
import { getMessaging, getToken, onMessage } from "firebase/messaging";
import _ from "lodash";
import axios from 'axios';
import { useCanvas } from "../../../composables/canvas";


export default {
    name: "FrontendNavbarComponent",
    setup() {
        const isSticky = ref();
        const { openCanvas } = useCanvas();
        onMounted(() => {
            window.addEventListener('scroll', function () {
                let windowScroll = this.scrollY;
                if (windowScroll > 0) {
                    isSticky.value = true;
                } else {
                    isSticky.value = false;
                }
            })
        })
        return {
            isSticky,
            openCanvas
        }
    },
    data() {
        return {
            loading: {
                isActive: false,
            },
            searchProductLists: [],
            currentRoute: "",
            defaultLanguage: null,
            enums: {
                activityEnum: activityEnum,
                roleEnum: roleEnum
            },
            languageProps: {
                paginate: 0,
                order_column: "id",
                order_type: "asc",
                status: statusEnum.ACTIVE
            },
            categoryTabStatus: false,
            activeTab: null,
            searchProduct: "",
            orderNotificationStatus: false,
            orderNotificationMessage: "",
            orderNotification: {
                permission: false,
                url: ""
            },
        }
    },
    computed: {
        logged: function () {
            return this.$store.getters.authStatus;
        },
        authDefaultPermission: function () {
            return this.$store.getters.authDefaultPermission;
        },
        profile: function () {
            return this.$store.getters.authInfo;
        },
        setting: function () {
            return this.$store.getters['frontendSetting/lists'];
        },
        language: function () {
            return this.$store.getters['frontendLanguage/show'];
        },
        languages: function () {
            return this.$store.getters['frontendLanguage/lists'];
        },
        categories: function () {
            return this.$store.getters['frontendProductCategory/trees'];
        },
        wishlists: function () {
            return this.$store.getters['frontendWishlist/lists'];
        },
        carts: function () {
            return this.$store.getters['frontendCart/lists'];
        },
        defaultMenu: function () {
            return this.$store.getters.authDefaultMenu;
        },
    },
    mounted() {
        this.loadThemeStylesheets();
        this.currentRoute = this.$route.path;
        this.loading.isActive = true;
        this.orderPermissionCheck();
        this.$store.dispatch('frontendSetting/lists').then(res => {
            this.defaultLanguage = res.data.data.site_default_language;
            const globalState = this.$store.getters['globalState/lists'];
            if (globalState.language_id > 0) {
                this.defaultLanguage = globalState.language_id;
            }

            this.loading.isActive = false;
            this.$store.dispatch('frontendLanguage/lists', this.languageProps).then().catch();
            this.$store.dispatch('frontendLanguage/show', this.defaultLanguage).then(res => {
                this.$i18n.locale = res.data.data.code;
                this.$store.dispatch("globalState/init", {
                    language_code: res.data.data.code,
                    display_mode: res.data.data.display_mode
                });
            }).catch();

            window.setTimeout(() => {
                this.$store.dispatch('frontendCart/initOrderType', { order_type: orderTypeEnum.DELIVERY });

                if (this.$store.getters.authStatus && res.data.data.notification_fcm_api_key && res.data.data.notification_fcm_auth_domain && res.data.data.notification_fcm_project_id && res.data.data.notification_fcm_storage_bucket && res.data.data.notification_fcm_messaging_sender_id && res.data.data.notification_fcm_app_id && res.data.data.notification_fcm_measurement_id) {
                    initializeApp({
                        apiKey: res.data.data.notification_fcm_api_key,
                        authDomain: res.data.data.notification_fcm_auth_domain,
                        projectId: res.data.data.notification_fcm_project_id,
                        storageBucket: res.data.data.notification_fcm_storage_bucket,
                        messagingSenderId: res.data.data.notification_fcm_messaging_sender_id,
                        appId: res.data.data.notification_fcm_app_id,
                        measurementId: res.data.data.notification_fcm_measurement_id
                    });
                    const messaging = getMessaging();

                    Notification.requestPermission().then((permission) => {
                        if (permission === 'granted') {
                            getToken(messaging, { vapidKey: res.data.data.notification_fcm_public_vapid_key }).then((currentToken) => {
                                if (currentToken) {
                                    axios.post('/frontend/device-token/web', { token: currentToken }).then().catch((error) => {
                                        if (error.response.data.message === 'Unauthenticated.') {
                                            this.$store.dispatch('loginDataReset');
                                        }
                                    });
                                }
                            }).catch();
                        }
                    });

                    onMessage(messaging, (payload) => {
                        const notificationTitle = payload.notification.title;
                        const notificationOptions = {
                            body: payload.notification.body,
                            icon: '/images/required/firebase-logo.png'
                        };
                        new Notification(notificationTitle, notificationOptions);

                        if (payload.data.topicName === 'new-order-found' && this.orderNotification.permission) {
                            this.orderNotificationStatus = true;
                            this.orderNotificationMessage = payload.notification.body;
                            const audio = new Audio(res.data.data.notification_audio);
                            audio.play();
                        }
                    });
                }
            }, 3000);

            this.loading.isActive = false;
        }).catch((err) => {
            this.loading.isActive = false;
        });

        this.loading.isActive = true;
        this.$store.dispatch('frontendProductCategory/trees').then(res => {
            this.loading.isActive = false;
        }).catch((err) => {
            this.loading.isActive = false;
        });

        if (this.logged) {
            this.loading.isActive = true;
            this.$store.dispatch("frontendWishlist/lists").then((res) => {
                this.loading.isActive = false;
            }).catch((err) => {
                this.loading.isActive = false;
            });
        }

    },
    methods: {
        showTarget: function (id, cClass) {
            targetService.showTarget(id, cClass);
        },
        hideTarget: function (id, cClass) {
            targetService.hideTarget(id, cClass);
        },
        textShortener: function (text, number = 30) {
            return appService.textShortener(text, number);
        },
        checkIsPathAndRoutePathSame(path) {
            if (this.currentRoute === path) {
                return true;
            }
        },
        changeLanguage: function (id, code, mode) {
            this.defaultLanguage = id;
            this.$store.dispatch("globalState/set", {
                language_id: id,
                language_code: code,
                display_mode: mode
            }).then(res => {
                this.$store.dispatch('frontendLanguage/show', id).then(res => {
                    this.$i18n.locale = res.data.data.code;
                }).catch();
            }).catch();
        },
        logout: function () {
            this.$store.dispatch("logout").then(res => {
                this.$store.dispatch("frontendWishlist/reset");
                this.$router.push({ name: "frontend.home" });
            }).catch();
        },
        search: function () {
            if (typeof this.searchProduct !== "undefined" && this.searchProduct !== "") {
                this.$router.push({ name: "frontend.product", query: { name: this.searchProduct } });
                this.searchProduct = "";
                this.hideTarget('search', 'search-active')
            }
        },
        orderPermissionCheck: function () {
            const permissions = this.$store.getters.authPermission;
            if (permissions.length > 0) {
                _.forEach(permissions, (permission) => {
                    if (permission.name === 'online-orders') {
                        if (permission.access === true) {
                            this.orderNotification.permission = true;
                            this.orderNotification.url = permission.url;
                        }
                    }
                });
            }
        },
        closeOrderNotificationModal: function (id, cClass) {
            targetService.hideTarget(id, cClass);
            this.orderNotificationStatus = false;
        },
        searchElement: function () {
            if (this.searchProduct && this.searchProduct.length > 2) {
                let url = `frontend/product`;
                url = url + appService.requestHandler({ name: this.searchProduct });
                axios.get(url).then((res) => {
                    this.searchProductLists = res.data.data;
                }).catch();
            } else {
                this.searchProductLists = [];
            }
        },
        goSearchProduct: function (slug) {
            targetService.hideTarget('search', 'search-active');
            this.$router.push({ name: 'frontend.product.details', params: { slug: slug } })
        },
        resetSearch: function(){
            this.searchProduct = "";
        },
        loadThemeStylesheets: function() {
            // Load theme LB stylesheets only for frontend
            const stylesheets = [
                '/themes/lb/libs/bootstrap/css/bootstrap.min.css',
                '/themes/lb/libs/feather-font/css/iconfont.css',
                '/themes/lb/libs/icomoon-font/css/icomoon.css',
                '/themes/lb/libs/font-awesome/css/font-awesome.css',
                '/themes/lb/libs/wpbingofont/css/wpbingofont.css',
                '/themes/lb/libs/elegant-icons/css/elegant.css',
                '/themes/lb/libs/slick/css/slick.css',
                '/themes/lb/libs/slick/css/slick-theme.css',
                '/themes/lb/libs/mmenu/css/mmenu.min.css',
                '/themes/lb/assets/css/app.css',
                '/themes/lb/assets/css/responsive.css'
            ];

            stylesheets.forEach(href => {
                // Check if stylesheet is already loaded
                if (!document.querySelector(`link[href="${href}"]`)) {
                    const link = document.createElement('link');
                    link.rel = 'stylesheet';
                    link.href = href;
                    document.head.appendChild(link);
                }
            });

            // Load Google Fonts for theme
            const googleFontLinks = [
                'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap',
                'https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&display=swap'
            ];

            googleFontLinks.forEach(href => {
                if (!document.querySelector(`link[href="${href}"]`)) {
                    const link = document.createElement('link');
                    link.rel = 'stylesheet';
                    link.href = href;
                    document.head.appendChild(link);
                }
            });
        }
    },
    watch: {
        $route(to, from) {
            this.currentRoute = to.path;
        },
    }
}
</script>
