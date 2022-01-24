import Vue from "vue";
import VueRouter from "vue-router";
import AuthGuard from "./utils/auth.guard";
import { adminRoot } from "./constants/config";
import { UserRole } from "./utils/auth.roles";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    component: () => import(/* webpackChunkName: "home" */ "./views/home"),
  },
  {
    path: adminRoot,
    component: () => import(/* webpackChunkName: "app" */ "./views/app"),
    redirect: `${adminRoot}/dashboards`,
    meta: { loginRequired: true },
    /*
    define with Authorization :
    meta: { loginRequired: true, roles: [UserRole.Admin, UserRole.Editor] },
    */
    children: [
      {
        path: "dashboards",
        component: () =>
          import(/* webpackChunkName: "dashboards" */ "./views/app/dashboards"),
        redirect: `${adminRoot}/dashboards/default`,
        // meta: { roles: [UserRole.Admin, UserRole.Editor] },
        children: [
          {
            path: "default",
            component: () =>
              import(/* webpackChunkName: "dashboards" */ "./views/app/dashboards/Default"),
            // meta: { roles: [UserRole.Admin] },
          },
        ]
      },
      {
        path: "pages",
        component: () =>
          import(/* webpackChunkName: "pages" */ "./views/app/pages"),
        redirect: `${adminRoot}/pages`,
        children: [
          {
            path: "product",
            component: () =>
              import(/* webpackChunkName : "product" */ "./views/app/pages/product"),
            redirect: `${adminRoot}/pages/product/surgeries`,
            children: [
              {
                path: "surgeries",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/surgery/Surgery")
              },
              {
                path: "sergery-reserv",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/surgery/SergerReserv")
              },
            ]
          },

          {
            path: "grid",
            component: () =>
              import(/* webpackChunkName : "blog" */ "./views/app/pages/grid/Grid"),
          },
        ]
      },


      {
        path: "settings",
        component: () =>
          import(/* webpackChunkName : "product" */ "./views/app/pages/product"),
        redirect: `${adminRoot}/settings/settings`,
        children: [
          {
            path: "devices",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/devices/Devices")
          },
          {
            path: "surgery-manage",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/surgery/Surgery_manage")
          },
          {
            path: "settings",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/settings/Settings")
          },
          {
            path: "doctor",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/settings/Doctor")
          },
        ]
      },

      {
        path: "data",
        component: () =>
          import(/* webpackChunkName : "product" */ "./views/app/pages/product"),
        redirect: `${adminRoot}/data/data-list`,
        children: [
          {
            path: "data-list",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/product/DataList"),
            redirect: `${adminRoot}/data/data-list/browse`,
            children: [
              {
                path: "browse",
                name: "browse",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/product/DataList")
              },
              {
                path: "takeout",
                name: "takeout",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/product/DataList")
              },
            ]
          },
          {
            path: "history-list",
            component: () =>
              import(/* webpackChunkName: "product" */ "./views/app/pages/product/Histories"),
            redirect: `${adminRoot}/data/history-list/browse`,
            children: [
              {
                path: "browse",
                name: "browse",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/product/Histories")
              },
              {
                path: "takeout",
                name: "takeout",
                component: () =>
                  import(/* webpackChunkName: "product" */ "./views/app/pages/product/Histories")
              },
            ]
          },
        ]
      },
      {
        path: "admin",
        component: () =>
          import(/* webpackChunkName: "applications" */ "./views/app/applications"),
        redirect: `${adminRoot}/admin/auth`,
        children: [
          {
            path: "auth",
            component: () =>
              import(/* webpackChunkName: "applications" */ "./views/app/applications/Todo")
          },
          {
            path: "browse",
            component: () =>
              import(/* webpackChunkName: "applications" */ "./views/app/pages/permit/BrowsePermit")
          },
          {
            path: "takeout",
            component: () =>
              import(/* webpackChunkName: "applications" */ "./views/app/pages/permit/TakeoutPermit")
          },
        ]
      },
    ]
  },
  {
    path: "/error",
    component: () => import(/* webpackChunkName: "error" */ "./views/Error")
  },
  {
    path: "/unauthorized",
    component: () => import(/* webpackChunkName: "error" */ "./views/Unauthorized")
  },
  {
    path: "/user",
    component: () => import(/* webpackChunkName: "user" */ "./views/user"),
    redirect: "/user/login",
    children: [
      {
        path: "login",
        component: () =>
          import(/* webpackChunkName: "user" */ "./views/user/Login")
      },
    ]
  },
  {
    path: "*",
    component: () => import(/* webpackChunkName: "error" */ "./views/Error")
  }
];

const router = new VueRouter({
  linkActiveClass: "active",
  routes,
  mode: "history",
});
router.beforeEach(AuthGuard);
export default router;
