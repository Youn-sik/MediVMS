<template>
    <nav :class="menuType + ' navbar ' + 'fixed-top'">
        <div class="d-flex align-items-center navbar-left">
            <!-- <a
                href="#"
                class="menu-button d-none d-md-block"
                @click.prevent.stop="
                    changeSideMenuStatus({
                        step: menuClickCount + 1,
                        classNames: menuType,
                        selectedMenuHasSubItems
                    })
                "
            >
                <menu-icon />
            </a>
            <a
                href="#"
                class="menu-button-mobile d-xs-block d-sm-block d-md-none"
                @click.prevent.stop="changeSideMenuForMobile(menuType)"
            >
                <mobile-menu-icon />
            </a> -->
            <!-- <div
                class="navbar-koolsign-logo"
                style="cursor:pointer;"
                @click="moveHome"
            >
                <span class="logo d-none d-xs-block"></span>
                <span class="logo-mobile d-block d-xs-none"></span>
            </div> -->
        </div>
        <!-- <div class="navbar-logo" style="cursor:pointer;" @click="moveHome">
            <span class="logo d-none d-xs-block"></span>
            <span class="logo-mobile d-block d-xs-none"></span>
        </div> -->

        <div class="navbar-right">
            <!-- <div class="d-none d-md-inline-block align-middle mr-3">
                <switches
                    id="tool-mode-switch"
                    v-model="isDarkActive"
                    theme="custom"
                    class="vue-switcher-small"
                    color="primary"
                />
                <b-tooltip
                    target="tool-mode-switch"
                    placement="left"
                    title="Dark Mode"
                ></b-tooltip>
            </div> -->
            <a @click="logout" href="#" class="logout"
                ><img src="/assets/img/logout.svg" />로그아웃</a
            >
        </div>
    </nav>
</template>

<script>
import Switches from "vue-switches";
import notifications from "../../data/notifications";

import { mapGetters, mapMutations, mapActions } from "vuex";
import { MenuIcon, MobileMenuIcon } from "../../components/Svg";
import {
    searchPath,
    menuHiddenBreakpoint,
    localeOptions,
    buyUrl,
    adminRoot
} from "../../constants/config";
import {
    getDirection,
    setDirection,
    getThemeColor,
    setThemeColor
} from "../../utils";
export default {
    components: {
        "menu-icon": MenuIcon,
        "mobile-menu-icon": MobileMenuIcon,
        switches: Switches
    },
    data() {
        return {
            searchKeyword: "",
            isMobileSearch: false,
            isSearchOver: false,
            fullScreen: false,
            menuHiddenBreakpoint,
            searchPath,
            adminRoot,
            localeOptions,
            buyUrl,
            notifications,
            isDarkActive: false,
            navCount: 0
        };
    },
    mounted() {
        if (parseInt(this.currentUser.dashboard) === 1) this.navCount++;

        if (parseInt(this.currentUser.surgery) === 1) this.navCount++;

        if (parseInt(this.currentUser.schedule) === 1) this.navCount++;

        if (parseInt(this.currentUser.history) === 1) this.navCount++;

        if (parseInt(this.currentUser.admin) === 1) this.navCount++;

        if (parseInt(this.currentUser.setting) === 1) this.navCount++;

        if (this.navCount === 1)
            this.changeSideMenuStatus({
                step: 1,
                classNames: "menu-hidden",
                selectedMenuHasSubItems: false
            });
        else
            this.changeSideMenuStatus({
                step: 1,
                classNames: "menu-default",
                selectedMenuHasSubItems: false
            });

        // if(this.currentUser.authority > 0){
        //   setTimeout(() => {
        //     this.changeSideMenuStatus({classNames: "menu-sub-hidden",
        //     selectedMenuHasSubItems: false,
        //     step: 1})
        //   },0)
        // }
    },
    methods: {
        ...mapMutations(["changeSideMenuStatus", "changeSideMenuForMobile"]),
        ...mapActions(["setLang", "signOut"]),
        moveHome() {
            if (parseInt(this.currentUser.dashboard))
                this.$router.push("/app/dashboards/default");
            else if (parseInt(this.currentUser.surgery))
                this.$router.push("/app/pages/product/surgeries");
            else if (parseInt(this.currentUser.schedule))
                this.$router.push("/app/pages/product/sergery-reserv");
            else if (parseInt(this.currentUser.browse))
                this.$router.push("/app/data");
            else if (parseInt(this.currentUser.admin))
                this.$router.push("/app/admin");
            else if (parseInt(this.currentUser.setting))
                this.$router.push("/app/settings");
        },
        search() {
            this.$router.push(
                `${this.searchPath}?search=${this.searchKeyword}`
            );
            this.searchKeyword = "";
        },
        searchClick() {
            if (window.innerWidth < this.menuHiddenBreakpoint) {
                if (!this.isMobileSearch) {
                    this.isMobileSearch = true;
                } else {
                    this.search();
                    this.isMobileSearch = false;
                }
            } else {
                this.search();
            }
        },
        handleDocumentforMobileSearch() {
            if (!this.isSearchOver) {
                this.isMobileSearch = false;
                this.searchKeyword = "";
            }
        },

        changeLocale(locale, direction) {
            const currentDirection = getDirection().direction;
            if (direction !== currentDirection) {
                setDirection(direction);
            }

            this.setLang(locale);
        },
        logout() {
            console.log("test");
            this.signOut().then(() => {
                this.$router.push("/user/login");
            });
        },

        toggleFullScreen() {
            const isInFullScreen = this.isInFullScreen();

            var docElm = document.documentElement;
            if (!isInFullScreen) {
                if (docElm.requestFullscreen) {
                    docElm.requestFullscreen();
                } else if (docElm.mozRequestFullScreen) {
                    docElm.mozRequestFullScreen();
                } else if (docElm.webkitRequestFullScreen) {
                    docElm.webkitRequestFullScreen();
                } else if (docElm.msRequestFullscreen) {
                    docElm.msRequestFullscreen();
                }
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.webkitExitFullscreen) {
                    document.webkitExitFullscreen();
                } else if (document.mozCancelFullScreen) {
                    document.mozCancelFullScreen();
                } else if (document.msExitFullscreen) {
                    document.msExitFullscreen();
                }
            }
            this.fullScreen = !isInFullScreen;
        },
        isInFullScreen() {
            return (
                (document.fullscreenElement &&
                    document.fullscreenElement !== null) ||
                (document.webkitFullscreenElement &&
                    document.webkitFullscreenElement !== null) ||
                (document.mozFullScreenElement &&
                    document.mozFullScreenElement !== null) ||
                (document.msFullscreenElement &&
                    document.msFullscreenElement !== null)
            );
        }
    },
    computed: {
        ...mapGetters({
            currentUser: "currentUser",
            menuType: "getMenuType",
            menuClickCount: "getMenuClickCount",
            selectedMenuHasSubItems: "getSelectedMenuHasSubItems"
        })
    },
    beforeDestroy() {
        document.removeEventListener(
            "click",
            this.handleDocumentforMobileSearch
        );
    },
    created() {
        const color = getThemeColor();
        this.isDarkActive = color.indexOf("dark") > -1;
    },
    watch: {
        "$i18n.locale"(to, from) {
            if (from !== to) {
                this.$router.go(this.$route.path);
            }
        },
        isDarkActive(val) {
            let color = getThemeColor();
            let isChange = false;
            if (val && color.indexOf("light") > -1) {
                isChange = true;
                color = color.replace("light", "dark");
            } else if (!val && color.indexOf("dark") > -1) {
                isChange = true;
                color = color.replace("dark", "light");
            }
            if (isChange) {
                setThemeColor(color);
                setTimeout(() => {
                    window.location.reload();
                }, 500);
            }
        },
        isMobileSearch(val) {
            if (val) {
                document.addEventListener(
                    "click",
                    this.handleDocumentforMobileSearch
                );
            } else {
                document.removeEventListener(
                    "click",
                    this.handleDocumentforMobileSearch
                );
            }
        }
    }
};
</script>
