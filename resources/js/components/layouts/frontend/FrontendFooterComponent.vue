<template>
    <LoadingComponent :props="loading" />

    <footer id="site-footer" class="site-footer background four-columns" v-show="!isMobile">
        <div class="footer">
            <div class="section-padding">
                <div class="section-container">
                    <div class="block-widget-wrap">
                        <div class="row">
                            <!-- Contact Section -->
                            <div class="col-lg-3 col-md-6 column-1">
                                <div class="block block-menu m-b-20">
                                    <h2 class="block-title">{{ $t('label.contact') }}</h2>
                                    <div class="block-content">
                                        <ul>
                                            <li>
                                                <span>{{ $t('label.address') }}:</span> {{ setting.company_address }}
                                            </li>
                                            <li>
                                                <span>{{ $t('label.email') }}:</span> <a :href="`mailto:${setting.company_email}`">{{ setting.company_email }}</a>
                                            </li>
                                            <li>
                                                <span>{{ $t('label.phone') }}:</span> {{ setting.company_phone }}
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="block block-social">
                                    <ul class="social-link">
                                        <li v-if="setting.social_media_facebook">
                                            <a :href="setting.social_media_facebook" target="_blank">
                                                <i class="fa fa-facebook"></i>
                                            </a>
                                        </li>
                                        <li v-if="setting.social_media_twitter">
                                            <a :href="setting.social_media_twitter" target="_blank">
                                                <i class="fa fa-twitter"></i>
                                            </a>
                                        </li>
                                        <li v-if="setting.social_media_instagram">
                                            <a :href="setting.social_media_instagram" target="_blank">
                                                <i class="fa fa-instagram"></i>
                                            </a>
                                        </li>
                                        <li v-if="setting.social_media_youtube">
                                            <a :href="setting.social_media_youtube" target="_blank">
                                                <i class="fa fa-youtube"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Support Pages -->
                            <div class="col-lg-3 col-md-6 column-2">
                                <div class="block block-menu">
                                    <h2 class="block-title">{{ $t('label.support') }}</h2>
                                    <div class="block-content">
                                        <ul>
                                            <li v-for="supportPage in supportPages" :key="supportPage.id">
                                                <router-link :to="{ name: 'frontend.page', params: { slug: supportPage.slug } }">
                                                    {{ supportPage.title }}
                                                </router-link>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Legal Pages -->
                            <div class="col-lg-3 col-md-6 column-3">
                                <div class="block block-menu">
                                    <h2 class="block-title">{{ $t('label.legal') }}</h2>
                                    <div class="block-content">
                                        <ul>
                                            <li v-for="legalPage in legalPages" :key="legalPage.id">
                                                <router-link :to="{ name: 'frontend.page', params: { slug: legalPage.slug } }">
                                                    {{ legalPage.title }}
                                                </router-link>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Newsletter & Apps -->
                            <div class="col-lg-3 col-md-6 column-4">
                                <router-link :to="{ name: 'frontend.home' }">
                                    <img class="footer-logo" :src="setting.theme_footer_logo" :alt="setting.company_name" />
                                </router-link>

                                <form @submit.prevent="saveSubscription" class="mt-5 mb-6 block">
                                    <label class="mb-3 font-medium text-white">
                                        {{ $t('message.subscribe_to_our_newsletter') }}
                                    </label>
                                    <div class="flex w-full h-10 rounded-3xl p-1 bg-white">
                                        <input type="email" v-model="subscriptionProps.post.email"
                                            :placeholder="$t('label.your_email_address')" class="w-full h-full pl-3 pr-2">
                                        <button type="submit"
                                            class="text-xs font-semibold capitalize flex-shrink-0 px-3 h-full rounded-3xl bg-primary text-white">
                                            {{ $t('button.subscribe') }}
                                        </button>
                                    </div>
                                </form>

                                <div class="app-store-links">
                                    <a target="_blank" class="app-store-link"
                                        v-if="setting.site_android_app_link" :href="setting.site_android_app_link">
                                        <img :src="setting.image_play_store" :alt="$t('label.android_app')">
                                    </a>
                                    <a target="_blank" class="app-store-link"
                                        v-if="setting.site_ios_app_link" :href="setting.site_ios_app_link">
                                        <img :src="setting.image_app_store" :alt="$t('label.ios_app')">
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer Bottom -->
        <div class="footer-bottom">
            <div class="section-padding">
                <div class="section-container">
                    <div class="block-widget-wrap">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="footer-left">
                                    <p class="copyright">{{ setting.site_copyright }}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="footer-right">
                                    <div class="block block-image" v-if="setting.payment_methods_image">
                                        <img :src="setting.payment_methods_image" :alt="$t('label.payment_methods')">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
</template>


<script>
import statusEnum from "../../../enums/modules/statusEnum";
import axios from "axios";
import alertService from "../../../services/alertService";
import LoadingComponent from "../../frontend/components/LoadingComponent";
import menuSectionEnum from "../../../enums/modules/menuSectionEnum";
import _ from "lodash";

export default {
    name: "FrontendFooterComponent",
    components: { LoadingComponent },
    data() {
        return {
            loading: {
                isActive: false,
            },
            legalPages: [],
            supportPages: [],
            isMobile: false,
            enums: {
                statusEnum: statusEnum,
                menuSectionEnum: menuSectionEnum
            },
            subscriptionProps: {
                post: {
                    email: ""
                }
            },
            errors: {},
        }
    },
    computed: {
        setting: function () {
            return this.$store.getters['frontendSetting/lists'];
        }
    },
    mounted() {
        this.checkMobile();
        window.addEventListener('resize', this.checkMobile);

        this.loading.isActive = true;
        this.$store.dispatch("frontendPage/lists", {
            paginate: 0,
            order_column: "id",
            order_type: "asc",
            status: this.enums.statusEnum.ACTIVE
        }).then(res => {
            if (res.data.data.length > 0) {
                _.forEach(res.data.data, (page) => {
                    if (page.menu_section_id === this.enums.menuSectionEnum.LEGAL) {
                        this.legalPages.push(page);
                    } else {
                        this.supportPages.push(page);
                    }
                });
            }
            this.loading.isActive = false;
        }).catch((err) => {
            this.loading.isActive = false;
        });
    },
    beforeUnmount() {
        window.removeEventListener('resize', this.checkMobile);
    },
    methods: {
        checkMobile() {
            this.isMobile = window.innerWidth < 768;
        },
        saveSubscription: function () {
            try {
                const url = '/frontend/subscriber';
                this.loading.isActive = true;
                axios.post(url, this.subscriptionProps.post).then(res => {
                    this.loading.isActive = false;
                    this.subscriptionProps.post.email = "";
                    this.errors = {};
                    alertService.success(this.$t("message.subscribe"));
                }).catch((err) => {
                    this.loading.isActive = false;
                    if (err.response && err.response.data && err.response.data.errors) {
                        alertService.error(err.response.data.errors.email[0]);
                    } else {
                        alertService.error(err.message);
                    }
                });
            } catch (err) {
                this.loading.isActive = false;
                alertService.error(err);
            }
        }
    }
}
</script>

<style scoped>
.footer-logo {
    height: auto;
    max-width: 200px;
}

.app-store-links {
    display: flex;
    gap: 10px;
    margin-top: 10px;
}

.app-store-link {
    display: inline-block;
}

.app-store-link img {
    height: 40px;
    border-radius: 8px;
}
</style>
