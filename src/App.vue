<template>
    <div class="h-100" v-if="!isLogin">
        <router-view :mqttClient="mqttClient" />
        <!-- <color-switcher></color-switcher> -->
        <!-- <div style="position:fixed; left: 0; z-index:2; right: 0; top:0px">
            <b-alert
                style="width:20%; margin: 0 auto; color:white; background:rgb(255,70,78);"
                :show="dismissCountDown"
                dismissible
                variant="danger"
                @dismissed="dismissCountDown = 0"
                @dismiss-count-down="countDownChanged"
            >
                <p>출입 금지자가 감지 되었습니다.</p>
            </b-alert>
        </div> -->
    </div>
</template>

<script>
import ColorSwitcher from "./components/Common/ColorSwitcher";
import mqtt from "mqtt";
import { getDirection } from "./utils";
import { mqtt_url } from "./server.json";
import moment from "moment";
import { mapGetters } from "vuex";
moment.locale("ko");

export default {
    computed: {
        ...mapGetters(["currentUser"])
    },
    components: {
        "color-switcher": ColorSwitcher
    },
    beforeMount() {
        const direction = getDirection();
        if (direction.isRtl) {
            document.body.classList.add("rtl");
            document.dir = "rtl";
            document.body.classList.remove("ltr");
        } else {
            document.body.classList.add("ltr");
            document.dir = "ltr";
            document.body.classList.remove("rtl");
        }
    },
    methods: {
        countDownChanged(dismissCountDown) {
            this.dismissCountDown = dismissCountDown;
        },
        showAlert() {
            this.dismissCountDown = this.dismissSecs;
        }
    },
    mounted() {
        this.mqttClient = mqtt.connect(mqtt_url, {
            protocol: "wss",
            port: 8084,
            keepalive: 0,
            path: "/mqtt",
            clientId:
                "server_" +
                Math.random()
                    .toString(16)
                    .substr(2, 8),
            clean: true
        });

        this.mqttClient.on("error", function(err) {
            console.log(err);
        });

        this.mqttClient.on("connect", test => {
            console.log("MQTT connected.");
            this.mqttClient.subscribe(
                ["/detect/emergancy/+"],
                (error, result) => {
                    if (error) {
                        console.log("MQTT subscribe error.");
                    } else {
                        console.log("MQTT subscribed.");
                    }
                }
            );
        });
    },
    data() {
        return {
            dismissSecs: 5,
            dismissCountDown: 0,
            showDismissibleAlert: false,
            mqttClient: null,
            isLogin: false
        };
    }
};
</script>

<style>
/* button {
    color: white !important;
} */

.Vue-Toastification__toast--error .Vue-Toastification__toast-body {
    /* color:#ffc107 !important; */
    font-weight: bold !important;
    font-size: 20px;
}

.Vue-Toastification__toast--warning .Vue-Toastification__toast-body {
    /* color:#ff5252 !important; */
    font-weight: bold !important;
    font-size: 20px;
}
</style>
