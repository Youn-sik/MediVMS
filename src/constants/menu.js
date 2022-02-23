import { adminRoot } from "./config";
import { UserRole } from "../utils/auth.roles";

const data = {
    admin: [
        {
            id: "dashboards",
            icon: "icon1",
            label: "대시보드",
            to: `${adminRoot}/dashboards`
        },
        {
            id: "surgries",
            icon: "icon2",
            label: "수술실 모니터링",
            to: `${adminRoot}/pages/product/surgeries`
        },
        {
            id: "sergery-reserv",
            icon: "icon3",
            label: "수술실 예약",
            to: `${adminRoot}/pages/product/sergery-reserv`
        },
        {
            id: "data",
            icon: "icon4",
            label: "데이터 열람",
            to: `${adminRoot}/data/data-list`,
            subs: [
                {
                    id: "surgery-data-lists",
                    label: "열람 목록",
                    to: `${adminRoot}/data/data-list/browse`
                },
                {
                    id: "surgery-data-lists",
                    label: "반출 목록",
                    to: `${adminRoot}/data/data-list/takeout`
                },
                {
                    id: "history",
                    label: "열람 기록",
                    to: `${adminRoot}/data/history-list/browse`
                },
                {
                    id: "history",
                    label: "반출 기록",
                    to: `${adminRoot}/data/history-list/takeout`
                }
            ]
        },
        {
            id: "admin",
            icon: "icon5",
            label: "관리자 메뉴",
            to: `${adminRoot}/admin`,
            subs: [
                {
                    id: "auth-manage",
                    label: "권한 관리",
                    to: `${adminRoot}/admin/auth`
                },
                {
                    id: "browse-permit",
                    label: "열람 허가",
                    to: `${adminRoot}/admin/browse`
                },
                {
                    id: "takeout-permit",
                    label: "반출 허가",
                    to: `${adminRoot}/admin/takeout`
                }
            ]
        },
        {
            id: "settings",
            icon: "icon6",
            label: "설정",
            to: `${adminRoot}/settings/settings`,
            subs: [
                {
                    id: "onoff",
                    icon: "",
                    label: "기타 설정",
                    to: `${adminRoot}/settings/settings`
                },
                {
                    id: "surgries_manage",
                    icon: "",
                    label: "단말 관리",
                    to: `${adminRoot}/settings/devices`
                },
                {
                    id: "sergery-reserv",
                    icon: "",
                    label: "수술실 관리",
                    to: `${adminRoot}/settings/surgery-manage`
                },
                {
                    id: "doctor",
                    icon: "",
                    label: "의사 관리",
                    to: `${adminRoot}/settings/doctor`
                }
            ]
        }
    ],
    user: [
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
            to: `${adminRoot}/applications`
        }
    ]
};
export default data;
