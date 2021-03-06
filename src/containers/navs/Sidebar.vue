<template>
    <div class="sidebar" @click.stop="() => {}">
        <div class="main-menu">
            <div class="navbar-logo" style="cursor:pointer;" @click="moveHome">
                <span class="logo d-none d-xs-block"></span>
                <span class="logo-mobile d-block d-xs-none"></span>
            </div>
            <vue-perfect-scrollbar
                class="scroll"
                :settings="{ suppressScrollX: true, wheelPropagation: false }"
            >
                <ul class="list-unstyled">
                    <li
                        v-for="(item, index) in filteredMenuItems(menuItems)"
                        :class="{
                            active:
                                (selectedParentMenu === item.id &&
                                    viewingParentMenu === '') ||
                                viewingParentMenu === item.id
                        }"
                        :key="`parent_${index}`"
                        :data-flag="item.id"
                        @click="goPage(item.to)"
                    >
                        <span class="navicon">
                            <img
                                class="icon"
                                :src="`/assets/img/${item.icon}.svg`"
                            />
                        </span>
                        <span class="navname">
                            {{ $t(item.label) }}
                        </span>
                    </li>
                </ul>
                <div class="logo2"></div>
            </vue-perfect-scrollbar>
            <a
                href="#"
                :class="menuType + ' menu-button d-none d-md-block hide-button'"
                @click.prevent.stop="
                    changeSideMenuStatus({
                        step: menuClickCount + 1,
                        classNames: menuType,
                        selectedMenuHasSubItems
                    })
                "
            >
                <img src="/assets/img/hide.svg" />
            </a>
            <a
                href="#"
                class="menu-button-mobile d-xs-block d-sm-block d-md-none hide-button"
                @click.prevent.stop="changeSideMenuForMobile(menuType)"
            >
                <img src="/assets/img/hide.svg" />
            </a>
        </div>

        <div class="sub-menu">
            <vue-perfect-scrollbar
                class="scroll"
                :settings="{ suppressScrollX: true, wheelPropagation: false }"
            >
                <ul
                    v-for="(item, itemIndex) in filteredMenuItems(menuItems)"
                    :class="{
                        'list-unstyled': true,
                        'd-block':
                            (selectedParentMenu === item.id &&
                                viewingParentMenu === '') ||
                            viewingParentMenu === item.id
                    }"
                    :data-parent="item.id"
                    :key="`sub_${item.id}`"
                >
                    <li
                        v-for="(sub, subIndex) in filteredMenuItems(item.subs)"
                        :key="`sub_${subIndex}`"
                        :class="{
                            'has-sub-item': sub.subs && sub.subs.length > 0,
                            active: $route.path.indexOf(sub.to) > -1
                        }"
                    >
                        <a
                            v-if="sub.newWindow"
                            :href="sub.to"
                            rel="noopener noreferrer"
                            target="_blank"
                        >
                            <i :class="sub.icon" />
                            <span>{{ $t(sub.label) }}</span>
                        </a>
                        <template v-else-if="sub.subs && sub.subs.length > 0">
                            <b-link
                                v-b-toggle="`menu_${itemIndex}_${subIndex}`"
                                variant="link"
                                class="rotate-arrow-icon opacity-50"
                            >
                                <i class="simple-icon-arrow-down"></i>
                                <span class="d-inline-block">{{
                                    $t(sub.label)
                                }}</span>
                            </b-link>
                            <b-collapse
                                visible
                                :id="`menu_${itemIndex}_${subIndex}`"
                            >
                                <ul class="list-unstyled third-level-menu">
                                    <li
                                        v-for="(thirdLevelSub,
                                        thirdIndex) in filteredMenuItems(
                                            sub.subs
                                        )"
                                        :key="
                                            `third_${itemIndex}_${subIndex}_${thirdIndex}`
                                        "
                                        :class="{
                                            'third-level-menu': true,
                                            active:
                                                $route.path === thirdLevelSub.to
                                        }"
                                    >
                                        <a
                                            v-if="thirdLevelSub.newWindow"
                                            :href="thirdLevelSub.to"
                                            rel="noopener noreferrer"
                                            target="_blank"
                                        >
                                            <i :class="thirdLevelSub.icon" />
                                            <span>{{
                                                $t(thirdLevelSub.label)
                                            }}</span>
                                        </a>
                                        <router-link
                                            v-else
                                            :to="thirdLevelSub.to"
                                        >
                                            <i :class="thirdLevelSub.icon" />
                                            <span>{{
                                                $t(thirdLevelSub.label)
                                            }}</span>
                                        </router-link>
                                    </li>
                                </ul>
                            </b-collapse>
                        </template>
                        <router-link v-else :to="sub.to">
                            <i :class="sub.icon" />
                            <span>{{ $t(sub.label) }}</span>
                        </router-link>
                    </li>
                </ul>
            </vue-perfect-scrollbar>
        </div>
    </div>
</template>

<script>
import { mapGetters, mapMutations } from "vuex";
import {
    menuHiddenBreakpoint,
    subHiddenBreakpoint
} from "../../constants/config";
import menuItems from "../../constants/menu";
import { UserRole } from "../../utils/auth.roles";

export default {
    data() {
        return {
            selectedParentMenu: "",
            menuItems: null,
            viewingParentMenu: ""
        };
    },
    created() {
        this.menuItems = menuItems.admin;
        let navs = [
            parseInt(this.currentUser.dashboard),
            parseInt(this.currentUser.surgery),
            parseInt(this.currentUser.schedule),
            parseInt(this.currentUser.browse),
            parseInt(this.currentUser.admin),
            parseInt(this.currentUser.setting)
        ];

        this.menuItems = menuItems.admin.filter((item, index) => {
            if (navs[index]) return item;
        });
    },
    mounted() {
        this.selectMenu();
        window.addEventListener("resize", this.handleWindowResize);
        document.addEventListener("click", this.handleDocumentClick);
        this.handleWindowResize();
    },
    beforeDestroy() {
        document.removeEventListener("click", this.handleDocumentClick);
        window.removeEventListener("resize", this.handleWindowResize);
    },

    methods: {
        ...mapMutations([
            "changeSideMenuStatus",
            "changeSideMenuForMobile",
            "addMenuClassname",
            "changeSelectedMenuHasSubItems"
        ]),
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
        goPage(to) {
            console.log(to);
            this.$router.push(to);
        },
        selectMenu() {
            const currentParentUrl = this.$route.path
                .split("/")
                .filter(x => x !== "")[1];
            if (currentParentUrl !== undefined || currentParentUrl !== null) {
                this.selectedParentMenu = currentParentUrl.toLowerCase();
            } else {
                this.selectedParentMenu = "dashboards";
            }
            this.isCurrentMenuHasSubItem();
        },
        isCurrentMenuHasSubItem() {
            const menuItem = this.menuItems.find(
                x => x.id === this.selectedParentMenu
            );
            const isCurrentMenuHasSubItem =
                menuItem && menuItem.subs && menuItem.subs.length > 0
                    ? true
                    : false;
            if (isCurrentMenuHasSubItem != this.selectedMenuHasSubItems) {
                if (!isCurrentMenuHasSubItem) {
                    this.changeSideMenuStatus({
                        step: 0,
                        classNames: this.menuType,
                        selectedMenuHasSubItems: false
                    });
                } else {
                    this.changeSideMenuStatus({
                        step: 0,
                        classNames: this.menuType,
                        selectedMenuHasSubItems: true
                    });
                }
            }

            return isCurrentMenuHasSubItem;
        },

        changeSelectedParentHasNoSubmenu(parentMenu) {
            this.selectedParentMenu = parentMenu;
            this.viewingParentMenu = parentMenu;
            this.changeSelectedMenuHasSubItems(false);
            this.changeSideMenuStatus({
                step: 0,
                classNames: this.menuType,
                selectedMenuHasSubItems: false
            });
        },

        openSubMenu(e, menuItem) {
            const selectedParent = menuItem.id;
            const hasSubMenu = menuItem.subs && menuItem.subs.length > 0;
            this.changeSelectedMenuHasSubItems(hasSubMenu);
            if (!hasSubMenu) {
                this.viewingParentMenu = selectedParent;
                this.selectedParentMenu = selectedParent;
                this.toggle();
            } else {
                const currentClasses = this.menuType
                    ? this.menuType.split(" ").filter(x => x !== "")
                    : "";

                if (!currentClasses.includes("menu-mobile")) {
                    if (
                        currentClasses.includes("menu-sub-hidden") &&
                        (this.menuClickCount === 2 || this.menuClickCount === 0)
                    ) {
                        this.changeSideMenuStatus({
                            step: 3,
                            classNames: this.menuType,
                            selectedMenuHasSubItems: hasSubMenu
                        });
                    } else if (
                        currentClasses.includes("menu-hidden") &&
                        (this.menuClickCount === 1 || this.menuClickCount === 3)
                    ) {
                        this.changeSideMenuStatus({
                            step: 2,
                            classNames: this.menuType,
                            selectedMenuHasSubItems: hasSubMenu
                        });
                    } else if (
                        currentClasses.includes("menu-default") &&
                        !currentClasses.includes("menu-sub-hidden") &&
                        (this.menuClickCount === 1 || this.menuClickCount === 3)
                    ) {
                        this.changeSideMenuStatus({
                            step: 0,
                            classNames: this.menuType,
                            selectedMenuHasSubItems: hasSubMenu
                        });
                    }
                } else {
                    this.addMenuClassname({
                        classname: "sub-show-temporary",
                        currentClasses: this.menuType
                    });
                }
                this.viewingParentMenu = selectedParent;
            }
        },
        handleDocumentClick(e) {
            this.viewingParentMenu = "";
            this.selectMenu();
            this.toggle();
        },
        toggle() {
            const currentClasses = this.menuType
                .split(" ")
                .filter(x => x !== "");
            if (
                currentClasses.includes("menu-sub-hidden") &&
                this.menuClickCount === 3
            ) {
                this.changeSideMenuStatus({
                    step: 2,
                    classNames: this.menuType,
                    selectedMenuHasSubItems: this.selectedMenuHasSubItems
                });
            } else if (
                currentClasses.includes("menu-hidden") ||
                currentClasses.includes("menu-mobile")
            ) {
                if (
                    !(
                        this.menuClickCount === 1 &&
                        !this.selectedMenuHasSubItems
                    )
                ) {
                    this.changeSideMenuStatus({
                        step: 0,
                        classNames: this.menuType,
                        selectedMenuHasSubItems: this.selectedMenuHasSubItems
                    });
                }
            }
        },

        // Resize
        handleWindowResize(event) {
            if (event && !event.isTrusted) {
                return;
            }
            let nextClasses = this.getMenuClassesForResize(this.menuType);
            this.changeSideMenuStatus({
                step: 0,
                classNames: nextClasses.join(" "),
                selectedMenuHasSubItems: this.selectedMenuHasSubItems
            });
        },
        getMenuClassesForResize(classes) {
            let nextClasses = classes.split(" ").filter(x => x !== "");
            const windowWidth = window.innerWidth;

            if (windowWidth < menuHiddenBreakpoint) {
                nextClasses.push("menu-mobile");
            } else if (windowWidth < subHiddenBreakpoint) {
                nextClasses = nextClasses.filter(x => x !== "menu-mobile");
                if (
                    nextClasses.includes("menu-default") &&
                    !nextClasses.includes("menu-sub-hidden")
                ) {
                    nextClasses.push("menu-sub-hidden");
                }
            } else {
                nextClasses = nextClasses.filter(x => x !== "menu-mobile");
                if (
                    nextClasses.includes("menu-default") &&
                    nextClasses.includes("menu-sub-hidden")
                ) {
                    nextClasses = nextClasses.filter(
                        x => x !== "menu-sub-hidden"
                    );
                }
            }
            return nextClasses;
        },

        //For UserRole
        filteredMenuItems(menuItems) {
            return menuItems
                ? menuItems.filter(
                      x =>
                          !x.roles ||
                          (x.roles && x.roles.includes(this.currentUser.role))
                  )
                : [];
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
    watch: {
        $route(to, from) {
            if (to.path !== from.path) {
                const toParentUrl = to.path.split("/").filter(x => x !== "")[1];
                if (toParentUrl !== undefined || toParentUrl !== null) {
                    this.selectedParentMenu = toParentUrl.toLowerCase();
                } else {
                    this.selectedParentMenu = "dashboards";
                }
                this.selectMenu();
                this.toggle();
                this.changeSideMenuStatus({
                    step: 0,
                    classNames: this.menuType,
                    selectedMenuHasSubItems: this.selectedMenuHasSubItems
                });

                window.scrollTo(0, top);
            }
        }
    }
};
</script>
