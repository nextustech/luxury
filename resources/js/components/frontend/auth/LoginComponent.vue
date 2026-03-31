<template>
    <LoadingComponent :props="loading" />
    <div class="w-full max-w-4xl mx-auto px-4 sm:px-6 rounded-2xl flex flex-col sm:flex-row overflow-hidden gap-y-0 bg-white shadow-card mb-20 sm:mb-24 mt-8 sm:mt-16">
        <img :src="APP_URL + '/images/required/auth.jpg'" alt="banners"
            class="w-full hidden sm:block sm:max-w-xs lg:max-w-sm flex-shrink-0 object-cover">
        <form class="w-full p-6 sm:p-8 flex flex-col justify-center" @submit.prevent="login">
            <div class="text-center mb-8">
                <h3 class="text-2xl sm:text-3xl mb-3 font-bold text-primary">{{ $t('label.sign_in') }}</h3>
                <p class="text-sm sm:text-base font-medium text-gray-600">{{ $t('message.continue_shopping') }}</p>
                <div v-if="errors.validation"
                    class="bg-red-50 border border-red-300 text-red-700 px-4 py-3 mt-4 rounded-lg relative flex items-start gap-3" role="alert">
                    <i class="lab-line-close-circle-line text-lg flex-shrink-0 mt-0.5"></i>
                    <span class="block text-sm flex-1">{{ errors.validation }}</span>
                    <span class="cursor-pointer flex-shrink-0 text-lg" @click="close">
                        <i class="lab-line-close-circle text-lg"></i>
                    </span>
                </div>
            </div>

            <div :class="!toggleValue ? 'mb-6' : 'mb-6'">
                <div class="flex items-center justify-between mb-2">
                    <label :for="!toggleValue ? 'formEmail' : 'phone'"
                        class="text-sm font-semibold text-gray-700 capitalize">
                        {{ inputLabel }}
                    </label>
                    <button type="button" class="text-xs sm:text-sm font-medium capitalize text-primary hover:underline transition-all"
                        @click="handleField()">
                        {{ inputButton }}
                    </button>
                </div>
                <div v-if="toggleValue" :class="errors.phone ? 'ring-2 ring-red-500' : ''"
                    class="flex items-center gap-2 px-4 h-12 rounded-lg border border-gray-200 hover:border-primary/50 focus-within:border-primary focus-within:ring-1 focus-within:ring-primary/20 transition-all duration-300 bg-white">
                    <div class="w-fit flex-shrink-0 dropdown-group">
                        <button type="button" class="flex items-center gap-1 dropdown-btn whitespace-nowrap">
                            <span class="text-base">{{ flag }}</span>
                            <span class="text-xs font-medium">{{ form.country_code }}</span>
                            <i class="fa-solid fa-caret-down text-xs text-gray-500"></i>
                        </button>
                        <ul
                            class="p-1.5 w-28 rounded-lg shadow-lg absolute top-12 -left-4 z-50 border border-gray-200 bg-white scale-y-0 origin-top dropdown-list !h-52 !overflow-x-hidden !overflow-y-auto thin-scrolling">
                            <li v-for="countryCode in countryCodes" :key="countryCode.id" @click="countryCodeChange(countryCode)"
                                class="flex items-center gap-2 p-2 rounded cursor-pointer hover:bg-primary/10 transition-colors">
                                <span class="text-base">{{ countryCode.flag_emoji }}</span>
                                <span class="text-xs font-medium">{{ countryCode.calling_code }}</span>
                            </li>
                        </ul>
                    </div>
                    <input v-model="form.phone" v-on:keypress="phoneNumber($event)" :class="errors.phone ? 'text-red-600' : ''" type="text" id="phone"
                        class="flex-1 text-sm h-full outline-none bg-transparent placeholder-gray-400"
                        :placeholder="$t('label.phone')" />
                </div>
                <input v-if="!toggleValue" v-model="form.email" :class="errors.email ? 'ring-2 ring-red-500' : ''" id="formEmail"
                    type="email"
                    class="w-full h-12 px-4 rounded-lg text-sm font-normal border border-gray-200 hover:border-primary/50 focus:border-primary focus:ring-1 focus:ring-primary/20 transition-all duration-300 outline-none bg-white placeholder-gray-400"
                    :placeholder="$t('label.email')" />
                <div v-if="errors.email_or_phone" class="mt-2 text-xs text-red-600 font-medium">
                    {{ errors.email_or_phone }}
                </div>
                <div v-else>
                    <small class="text-xs text-red-600 font-medium" v-if="errors.phone && toggleValue">{{ errors.phone[0] }}</small>
                    <small class="text-xs text-red-600 font-medium" v-if="errors.email && !toggleValue">{{ errors.email[0] }}</small>
                </div>
            </div>

            <div class="mb-6">
                <label for="formPassword" class="block text-sm font-semibold text-gray-700 capitalize mb-2">
                    {{ $t('label.password') }}
                </label>
                <input v-model="form.password" :class="errors.password ? 'ring-2 ring-red-500' : ''" id="formPassword"
                    type="password"
                    class="w-full h-12 px-4 rounded-lg text-sm font-normal border border-gray-200 hover:border-primary/50 focus:border-primary focus:ring-1 focus:ring-primary/20 transition-all duration-300 outline-none bg-white placeholder-gray-400"
                    :placeholder="$t('label.password')" />
                <small class="block mt-2 text-xs text-red-600 font-medium" v-if="errors.password">{{ errors.password[0] }}</small>
            </div>
            <div class="flex items-center justify-between mb-8">
                <div class="flex items-center gap-2.5">
                    <input type="checkbox" id="formRemember" class="w-4 h-4 accent-primary cursor-pointer">
                    <label for="formRemember" class="text-sm font-medium text-gray-700 cursor-pointer whitespace-nowrap">
                        {{ $t('label.remember_me') }}
                    </label>
                </div>
                <router-link :to="{ name: 'auth.forgotPassword' }" class="text-sm font-medium text-primary hover:underline transition-all">
                    {{ $t('label.forgot_password') }}
                </router-link>
            </div>
            <button type="submit"
                class="w-full h-12 px-6 rounded-full bg-primary hover:bg-primary/90 text-white font-bold capitalize transition-all duration-300 shadow-md hover:shadow-lg mb-6">
                {{ $t('label.sign_in') }}
            </button>
            <div class="text-center">
                <span class="text-sm text-gray-600">{{ $t('message.dont_have_account') }}</span>
                <router-link class="text-sm font-bold text-primary hover:underline transition-all ml-1" :to="{ name: 'auth.signup' }">
                    {{ $t('label.sign_up') }}
                </router-link>
            </div>

            <div v-if="demo === 'true' || demo === 'TRUE' || demo === 'True' || demo === '1' || demo === 1"
                class="mt-10 pt-8 border-t border-gray-200">
                <h4 class="text-center text-sm font-semibold text-gray-700 mb-4">{{ $t('message.for_quick_demo') }}</h4>
                <div class="grid grid-cols-2 gap-3">
                    <button type="button" @click.prevent="setupCredit('admin')"
                        class="h-11 rounded-lg text-center text-xs sm:text-sm font-medium capitalize text-white bg-orange-500 hover:bg-orange-600 transition-colors"
                        id="adminClick">
                        {{ $t('label.admin') }}
                    </button>
                    <button type="button" @click.prevent="setupCredit('customer')"
                        class="h-11 rounded-lg text-center text-xs sm:text-sm font-medium capitalize text-white bg-emerald-500 hover:bg-emerald-600 transition-colors"
                        id="customerClick">
                        {{ $t('label.customer') }}
                    </button>
                    <button type="button" @click.prevent="setupCredit('manager')"
                        class="h-11 rounded-lg text-center text-xs sm:text-sm font-medium capitalize text-white bg-sky-600 hover:bg-sky-700 transition-colors"
                        id="branchManagerClick">
                        {{ $t('label.manager') }}
                    </button>
                    <button type="button" @click.prevent="setupCredit('posOperator')"
                        class="h-11 rounded-lg text-center text-xs sm:text-sm font-medium capitalize text-white bg-purple-500 hover:bg-purple-600 transition-colors"
                        id="posOperatorClick">
                        {{ $t('label.pos_operator') }}
                    </button>
                </div>
            </div>
        </form>
    </div>
</template>

<script>
import router from "../../../router";
import LoadingComponent from "../components/LoadingComponent";
import alertService from "../../../services/alertService";
import appService from "../../../services/appService";
import ENV from "../../../config/env";
import roleEnum from "../../../enums/modules/roleEnum";

export default {
    name: "LoginComponent",
    components: { LoadingComponent },
    data() {
        return {
            loading: {
                isActive: false,
            },
            form: {
                email: "",
                phone: "",
                country_code: "",
                password: ""
            },
            flag: "",
            errors: {},
            permissions: {},
            firstMenu: null,
            demo: ENV.DEMO,
            APP_URL: ENV.API_URL,
            toggleValue: false,
            inputLabel: this.$t('label.email'),
            inputButton: this.$t('label.use_phone_instead'),
            enums: {
                roleEnum: roleEnum
            }
        }
    },
    computed: {
        carts: function () {
            return this.$store.getters['frontendCart/lists'];
        },
        countryCodes: function () {
            return this.$store.getters['frontendCountryCode/lists'];
        },
    },
    mounted() {
        this.loading.isActive = true;
        this.$store.dispatch('frontendCountryCode/lists');
        this.$store.dispatch('frontendSetting/lists').then(res => {
            this.$store.dispatch('frontendCountryCode/show', res.data.data.company_country_code).then(res => {
                this.form.country_code = res.data.data.calling_code;
                this.flag = res.data.data.flag_emoji;

                this.loading.isActive = false;
            }).catch((err) => {
                this.loading.isActive = false;
            });
        }).catch((err) => {
            this.loading.isActive = false;
        });
    },
    methods: {
        phoneNumber(e) {
            return appService.phoneNumber(e);
        },
        login: function () {
            try {
                this.loading.isActive = true;
                this.$store.dispatch('login', this.form).then((res) => {
                    this.loading.isActive = false;
                    alertService.success(res.data.message);
                    this.$store.dispatch("frontendWishlist/lists").then().catch();

                    // Get user info and check role
                    const userInfo = this.$store.getters.authInfo;

                    // If user is not a customer (admin, manager, etc.), redirect to admin dashboard
                    if (userInfo.role_id !== roleEnum.CUSTOMER) {
                        router.push({ name: "admin.dashboard" });
                    } else {
                        // For customers, redirect to checkout if cart exists, otherwise home
                        if (this.carts.length > 0) {
                            router.push({ name: "frontend.checkout" });
                        } else {
                            router.push({ name: "frontend.home" });
                        }
                    }

                    setTimeout(() => {
                        appService.recursiveRouter(router.options.routes, this.$store.getters.authPermission);
                    }, 1000);
                }).catch((err) => {
                    this.loading.isActive = false;
                    this.errors = err.response.data.errors;
                })
            } catch (err) {
                this.loading.isActive = false;
            }
        },
        handleField: function () {
            this.toggleValue = !this.toggleValue

            if (this.toggleValue) {
                this.form.email = "";
                this.inputLabel = this.$t('label.phone');
                this.inputButton = this.$t('label.use_email_instead');
            } else {
                this.form.phone = "";
                this.inputLabel = this.$t('label.email');
                this.inputButton = this.$t('label.use_phone_instead');
            }
        },
        countryCodeChange: function (e) {
            this.flag = e.flag_emoji;
            this.form.country_code = e.calling_code;
        },
        close: function () {
            this.errors = {}
        },
        setupCredit: function (e) {
            if (e === 'admin') {
                this.form.email = 'admin@example.com';
                this.form.password = '123456';
            } else if (e === 'customer') {
                this.form.email = 'customer@example.com';
                this.form.password = '123456';
            } else if (e === 'manager') {
                this.form.email = 'manager@example.com';
                this.form.password = '123456';
            } else if (e === 'posOperator') {
                this.form.email = 'posoperator@example.com';
                this.form.password = '123456';
            }
        }
    }
}
</script>
