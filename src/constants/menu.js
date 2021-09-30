import { adminRoot } from "./config";
import { UserRole } from "../utils/auth.roles";

const data = {
  "admin":[
//   {
//   id: "dashboards",
//   icon: "iconsminds-shop-4",
//   label: "menu.dashboards",
//   to: `${adminRoot}/dashboards`,
//   // roles: [UserRole.Admin, UserRole.Editor],
//   subs: [{
//     icon: "simple-icon-briefcase",
//     label: "menu.default",
//     to: `${adminRoot}/dashboards/default`,
//     // roles: [UserRole.Admin],
//   },
//   {
//     icon: "simple-icon-pie-chart",
//     label: "menu.analytics",
//     to: `${adminRoot}/dashboards/analytics`,
//     // roles: [UserRole.Admin],
//   },
//   {
//     icon: "simple-icon-basket-loaded",
//     label: "menu.ecommerce",
//     to: `${adminRoot}/dashboards/ecommerce`,
//     // roles: [UserRole.Editor],
//   },
//   {
//     icon: "simple-icon-doc",
//     label: "menu.content",
//     to: `${adminRoot}/dashboards/content`,
//     // roles: [UserRole.Editor],
//   }
//   ]
// },
{
  id: "dashboards",
  icon: "iconsminds-shop-4",
  label: "대시보드",
  to: `${adminRoot}/dashboards`
},
{
  id: "surgries",
  icon: "iconsminds-first-aid",
  label: "수술실",
  to: `${adminRoot}/pages/product/surgeries`
},
{
  id: "sergery-reserv",
  icon: "simple-icon-calendar",
  label: "수술실 예약",
  to: `${adminRoot}/pages/product/sergery-reserv`
},
{
  id: "데이터 열람",
  icon: "iconsminds-digital-drawing",
  label: "데이터 열람",
  to: `${adminRoot}/pages`,
  // subs: [
  // {
  //   id: "pages-grid",
  //   label: "grid",
  //   to: `${adminRoot}/pages/grid`,
  //   subs: [{
  //     icon: "simple-icon-grid",
  //     label: "grid",
  //     to: `${adminRoot}/pages/grid`
  //   },

  //   ]
  // },
  // ]
},
{
  id: "applications",
  icon: "iconsminds-firewall",
  label: "권한관리",
  to: `${adminRoot}/applications`,
  // subs: [{
  //   icon: "simple-icon-check",
  //   label: "menu.todo",
  //   to: `${adminRoot}/applications/todo`
  // },
  // {
  //   icon: "simple-icon-calculator",
  //   label: "menu.survey",
  //   to: `${adminRoot}/applications/survey`
  // },
  // {
  //   icon: "simple-icon-bubbles",
  //   label: "menu.chat",
  //   to: `${adminRoot}/applications/chat`
  // }
  // ]
},
{
  id: "설정",
  icon: "simple-icon-settings",
  label: "설정",
  to: `${adminRoot}/applications`,
  // subs: [{
  //   icon: "simple-icon-check",
  //   label: "menu.todo",
  //   to: `${adminRoot}/applications/todo`
  // },
  // {
  //   icon: "simple-icon-calculator",
  //   label: "menu.survey",
  //   to: `${adminRoot}/applications/survey`
  // },
  // {
  //   icon: "simple-icon-bubbles",
  //   label: "menu.chat",
  //   to: `${adminRoot}/applications/chat`
  // }
  // ]
},
// {
//   id: "ui",
//   icon: "iconsminds-pantone",
//   label: "menu.ui",
//   to: `${adminRoot}/ui`,
//   subs: [
//     {
//       id: "ui-forms",
//       label: "menu.forms",
//       to: `${adminRoot}/ui/forms`,
//       subs: [{
//         icon: "simple-icon-notebook",
//         label: "menu.layouts",
//         to: `${adminRoot}/ui/forms/layouts`
//       },
//       {
//         icon: "simple-icon-puzzle",
//         label: "menu.components",
//         to: `${adminRoot}/ui/forms/components`
//       },
//       {
//         icon: "simple-icon-check",
//         label: "menu.validations",
//         to: `${adminRoot}/ui/forms/validations`
//       },
//       {
//         icon: "simple-icon-magic-wand",
//         label: "menu.wizard",
//         to: `${adminRoot}/ui/forms/wizard`
//       }
//       ]
//     },
//     {
//       id: "ui-datatables",
//       label: "menu.datatables",
//       to: `${adminRoot}/ui/datatables`,
//       subs: [
//         {
//           icon: "simple-icon-screen-desktop",
//           label: "menu.divided-table",
//           to: `${adminRoot}/ui/datatables/divided-table`
//         },
//         {
//           icon: "simple-icon-mouse",
//           label: "menu.scrollable",
//           to: `${adminRoot}/ui/datatables/scrollable`
//         },
//         {
//           icon: "simple-icon-grid",
//           label: "menu.default",
//           to: `${adminRoot}/ui/datatables/default`
//         }
//       ]
//     },
//     {
//       id: "ui-components",
//       label: "menu.components",
//       to: `${adminRoot}/ui/components`,
//       subs: [{
//         icon: "simple-icon-bell",
//         label: "menu.alerts",
//         to: `${adminRoot}/ui/components/alerts`
//       },
//       {
//         icon: "simple-icon-badge",
//         label: "menu.badges",
//         to: `${adminRoot}/ui/components/badges`
//       },
//       {
//         icon: "simple-icon-control-play",
//         label: "menu.buttons",
//         to: `${adminRoot}/ui/components/buttons`
//       },
//       {
//         icon: "simple-icon-layers",
//         label: "menu.cards",
//         to: `${adminRoot}/ui/components/cards`
//       },
//       {
//         icon: "simple-icon-picture",
//         label: "menu.carousel",
//         to: `${adminRoot}/ui/components/carousel`
//       },
//       {
//         icon: "simple-icon-chart",
//         label: "menu.charts",
//         to: `${adminRoot}/ui/components/charts`
//       },
//       {
//         icon: "simple-icon-arrow-up",
//         label: "menu.collapse",
//         to: `${adminRoot}/ui/components/collapse`
//       },
//       {
//         icon: "simple-icon-arrow-down",
//         label: "menu.dropdowns",
//         to: `${adminRoot}/ui/components/dropdowns`
//       },
//       {
//         icon: "simple-icon-book-open",
//         label: "menu.editors",
//         to: `${adminRoot}/ui/components/editors`
//       },

//       {
//         icon: "simple-icon-star",
//         label: "menu.icons",
//         to: `${adminRoot}/ui/components/icons`
//       },
//       {
//         icon: "simple-icon-note",
//         label: "menu.input-groups",
//         to: `${adminRoot}/ui/components/input-groups`
//       },
//       {
//         icon: "simple-icon-screen-desktop",
//         label: "menu.jumbotron",
//         to: `${adminRoot}/ui/components/jumbotron`
//       },
//       {
//         icon: "simple-icon-map",
//         label: "menu.maps",
//         to: `${adminRoot}/ui/components/maps`
//       },
//       {
//         icon: "simple-icon-docs",
//         label: "menu.modal",
//         to: `${adminRoot}/ui/components/modal`
//       },
//       {
//         icon: "simple-icon-cursor",
//         label: "menu.navigation",
//         to: `${adminRoot}/ui/components/navigation`
//       },
//       {
//         icon: "simple-icon-pin",
//         label: "menu.popover-tooltip",
//         to: `${adminRoot}/ui/components/popover-tooltip`
//       },
//       {
//         icon: "simple-icon-shuffle",
//         label: "menu.sortable",
//         to: `${adminRoot}/ui/components/sortable`
//       },
//       {
//         icon: "simple-icon-grid",
//         label: "menu.tables",
//         to: `${adminRoot}/ui/components/tables`
//       }
//       ]
//     }
//   ]
// },
// {
//   id: "menu",
//   icon: "iconsminds-three-arrow-fork",
//   label: "menu.menu",
//   to: `${adminRoot}/menu`,
//   subs: [{
//     icon: "simple-icon-logout",
//     label: "menu.types",
//     to: `${adminRoot}/menu/types`
//   },
//   {
//     icon: "simple-icon-layers",
//     label: "menu.levels",
//     to: `${adminRoot}/menu/levels`,
//     subs: [{
//       icon: "simple-icon-arrow-right",
//       label: "menu.third-level-1",
//       to: `${adminRoot}/menu/levels/third-level-1`
//     },
//     {
//       icon: "simple-icon-arrow-right",
//       label: "menu.third-level-2",
//       to: `${adminRoot}/menu/levels/third-level-2`
//     },
//     {
//       icon: "simple-icon-arrow-right",
//       label: "menu.third-level-3",
//       to: `${adminRoot}/menu/levels/third-level-3`
//     }
//     ]
//   }
//   ]
// },
// {
//   id: "blank-page",
//   icon: "iconsminds-bucket",
//   label: "menu.blank-page",
//   to: `${adminRoot}/blank-page`
// },
// {
//   id: "docs",
//   icon: "iconsminds-library",
//   label: "menu.docs",
//   to: "https://piaf-vue-docs.coloredstrategies.com/",
//   newWindow: true
// }
],
user:[
  {
    id: "surgries",
    icon: "iconsminds-first-aid",
    label: "수술실",
    to: `${adminRoot}/pages/product/surgeries`
  },
  {
    id: "applications",
    icon: "iconsminds-firewall",
    label: "권한관리",
    to: `${adminRoot}/applications`,
    // subs: [{
    //   icon: "simple-icon-check",
    //   label: "menu.todo",
    //   to: `${adminRoot}/applications/todo`
    // },
    // {
    //   icon: "simple-icon-calculator",
    //   label: "menu.survey",
    //   to: `${adminRoot}/applications/survey`
    // },
    // {
    //   icon: "simple-icon-bubbles",
    //   label: "menu.chat",
    //   to: `${adminRoot}/applications/chat`
    // }
    // ]
  },]};
export default data;
