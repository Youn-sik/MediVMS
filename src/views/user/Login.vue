<template>
<b-row class="h-100">
    <b-colxx xxs="12" md="5" class="mx-auto my-auto">
        <b-card class="auth-card" no-body title="Login">
            <!-- <div class="position-relative image-side">
                <p class="text-white h2">{{ $t('dashboards.magic-is-in-the-details') }}</p>
                <p class="white mb-0">
                    Please use your credentials to login.
                    <br />If you are not a member, please
                    <router-link to="/user/register" class="white">register</router-link>.
                </p>
            </div> -->
            <div class="form-side">
                <router-link to="/">
                    <span class="logo-single" />
                </router-link>
                <h2 class="mb-4">로그인</h2>

                <b-form @submit.prevent="formSubmit" class="av-tooltip tooltip-label-bottom">
                    <b-form-group label="ID" class="has-float-label mb-4">
                        <b-form-input type="text" v-model="$v.form.email.$model" :state="!$v.form.email.$error" />
                    </b-form-group>

                    <b-form-group :label="$t('user.password')" class="has-float-label mb-4">
                        <b-form-input type="password" v-model="$v.form.password.$model" :state="!$v.form.password.$error" />
                        <b-form-invalid-feedback v-if="!$v.form.password.required">Please enter your password</b-form-invalid-feedback>
                        <b-form-invalid-feedback v-else-if="!$v.form.password.minLength || !$v.form.password.maxLength">Your password must be between 4 and 16 characters</b-form-invalid-feedback>
                    </b-form-group>
                    <div class="d-flex justify-content-between align-items-center">
                        <div></div>
                        <b-button type="submit" variant="primary" size="lg" :disabled="processing" :class="{'btn-multiple-state btn-shadow': true,
                    'show-spinner': processing,
                    'show-success': !processing && loginError===false,
                    'show-fail': !processing && loginError }">
                            <span class="spinner d-inline-block">
                                <span class="bounce1"></span>
                                <span class="bounce2"></span>
                                <span class="bounce3"></span>
                            </span>
                            <span class="icon success">
                                <i class="simple-icon-check"></i>
                            </span>
                            <span class="icon fail">
                                <i class="simple-icon-exclamation"></i>
                            </span>
                            <span class="label">로그인</span>
                        </b-button>
                    </div>
                </b-form>
            </div>
        </b-card>
    </b-colxx>
</b-row>
</template>

<script>
import {
    mapGetters,
    mapActions
} from "vuex";
import {
    validationMixin
} from "vuelidate";
import { adminRoot } from '../../constants/config';
const {
    required,
    maxLength,
    minLength,
    email
} = require("vuelidate/lib/validators");

export default {
    data() {
        return {
            form: {
                email: "",
                password: ""
            },
        };
    },
    mixins: [validationMixin],
    validations: {
        form: {
            password: {
                required,
                maxLength: maxLength(16),
                minLength: minLength(4)
            },
            email: {
                required,
                email,
                minLength: minLength(4)
            }
        }
    },
    computed: {
        ...mapGetters(["currentUser", "processing", "loginError"])
    },
    methods: {
        ...mapActions(["login"]),
        formSubmit() {
            this.$v.$touch();
            // this.form.email = "piaf-vue@coloredstrategies.com";
            // this.form.password = "piaf123";
            this.$v.form.$touch();
           // if (!this.$v.form.$anyError) {
                this.login({
                    email: this.form.email,
                    password: this.form.password
                });
            //}
        }
    },
    watch: {
        currentUser(val) {
            if (val && val.account) {
                // setTimeout(() => {
                    if(parseInt(val.dashboard))
                        this.$router.push('/app/dashboards/default');
                    else if(parseInt(val.surgery))
                        this.$router.push('/app/pages/product/surgeries');
                    else if(parseInt(val.schedule))
                        this.$router.push('/app/pages/product/sergery-reserv');
                    else if(parseInt(val.browse))
                        this.$router.push('/app/data');
                    else if(parseInt(val.admin))
                        this.$router.push('/app/admin');
                    else if(parseInt(val.setting))
                        this.$router.push('/app/settings');
                // }, 0);
            }
        },
        loginError(val) {
            if (val != null) {
                this.$notify("error", "Login Error", val, {
                    duration: 3000,
                    permanent: false
                });

            }
        }
    }
};
</script>
