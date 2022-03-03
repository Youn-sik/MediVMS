<template>
    <div>
        <div class="custom-div-setting">
            <b-row>
                <b-colxx xxs="12">
                    <piaf-breadcrumb heading="설정"/>
                    <div class="separator mb-5"></div>
                    <b-card>
                        <b-form-checkbox v-model="settings.watermark" name="check-button" switch>
                            워터마크
                        </b-form-checkbox>
                        <b-form-checkbox v-model="settings.face" name="check-button" switch>
                            얼굴
                        </b-form-checkbox>
                        <b-form-checkbox v-model="settings.human" name="check-button" switch>
                            사람
                        </b-form-checkbox>
                        <b-form-checkbox v-model="settings.voice" name="check-button" switch>
                            음성녹음
                        </b-form-checkbox>
                        <br/>
                        <b-form-group label="워터마크 등록">
                        <div style="width:40%;">
                            <b-form-file v-model="watermarkFile" id="file-small"></b-form-file>
                        </div>
                        </b-form-group>
                        <div style="text-align:center">
                            <b-button
                                variant=""
                                icon
                                class="ma-2"
                                @click="clickSave"
                            >
                                저장
                            </b-button>
                        </div>
                    </b-card>
                </b-colxx>
            </b-row>
        </div>
    </div>
</template>

<script>
import api from "../../../../api"
export default {
    data() {
        return {
            watermarkFile : null,
            settings:{
                watermark:false,
                face:false,
                human:false,
                voice:false
            },
        }
    },
    methods: {
        async clickSave() {
            this.updateSettings()
        },

        fileToBase64(file) {
            return new Promise((resolve, reject) => {
                const reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = () => resolve(reader.result.toString().substr(reader.result.toString().indexOf(',') + 1));
                reader.onerror = error => reject(error);
            });
        },

        async getSettings() {

            let temp = await api.getSettings()
            this.settings = {
                watermark: temp.watermark ? true : false,
                face: temp.face ? true : false,
                human: temp.human ? true : false,
                voice: temp.voice ? true : false,
                id : temp.id,
            }
        },

        async updateSettings() {
            let base64 = null
            if(this.watermarkFile !== null) {
                base64 = await this.fileToBase64(this.watermarkFile)
            }
            try {
                await api.updateSettings({...this.settings, base64})
                this.makeToast('success','저장 완료','저장이 완료되었습니다.')
            } catch(e) {
                this.makeToast('success','저장 실패','저장이 실패했습니다.')
            }

        },

        makeToast(variant,title,msg) {
            this.$bvToast.toast(msg, {
                title,
                variant,
                solid: true,
                autoHideDelay : 2000
            })
        }
    },
    mounted() {
        this.getSettings()
    }
}
</script>