<template>
    <div>
        <b-row>
            <b-colxx xxs="12">
                <piaf-breadcrumb heading="설정"/>
                <div class="separator mb-5"></div>
                <b-card>
                    <b-form-checkbox v-model="checked" name="check-button" switch>
                        워터마크
                    </b-form-checkbox>
                    <b-form-checkbox v-model="checked" name="check-button" switch>
                        얼굴
                    </b-form-checkbox>
                    <b-form-checkbox v-model="checked" name="check-button" switch>
                        사람
                    </b-form-checkbox>
                    <b-form-checkbox v-model="checked" name="check-button" switch>
                        음성녹음
                    </b-form-checkbox>
                </b-card>
            </b-colxx>
        </b-row>
    </div>
</template>

<script>
export default {
}
</script>