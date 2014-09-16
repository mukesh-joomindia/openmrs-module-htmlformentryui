<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
    ui.includeJavascript("uicommons", "angular.min.js");
    ui.includeJavascript("uicommons", "angular-resource.min.js");
    ui.includeJavascript("htmlformentryui", "htmlFormSimple.js", Integer.MIN_VALUE)

    def breadcrumbMiddle = breadcrumbOverride ?: """
        [ { label: '${ returnLabel }' , link: '${ returnUrl }'} ]
    """
%>

${ ui.includeFragment("uicommons", "validationMessages")}

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<script type="text/javascript">

    // we expose this as a global variable so that HTML forms can call the API methods associated with the Keyboard Controller
    // TODO expose this some other way than a global variable so we can support multiple navigators (if that will ever be needed)
    var NavigatorController;

    var breadcrumbs = _.flatten([
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        ${ breadcrumbMiddle },
        { label: "${ ui.escapeJs(ui.message("emr.editHtmlForm.breadcrumb", ui.format(htmlForm.form))) }" }
    ]);

    jQuery(function() {
        jq('input.submitButton').hide();
        jq('form#htmlform').append(jq('#confirmation-template').html());
        NavigatorController =  KeyboardController(jq('#htmlform').first());

        jq('input.confirm').click(function(){

            if (!jq(this).attr("disabled")) {
                jq(this).closest("form").submit();
            }

            jq(this).attr('disabled', 'disabled');
            jq(this).addClass("disabled");

        });
    });
</script>

${ ui.includeFragment("htmlformentryui", "htmlform/enterHtmlForm", [
        patient: patient,
        htmlForm: htmlForm,
        visit: encounter.visit,
        encounter: encounter,
        returnUrl: returnUrl,
        automaticValidation: false,
        cssClass: "simple-form-ui"
]) }

<script type="text/template" id="confirmation-template">
<div id="confirmation">
    <span class="title">${ ui.message("emr.simpleFormUi.confirm.title") }</span>

    <div id="confirmationQuestion" class="container">
        <h3>${ ui.message("emr.simpleFormUi.confirm.question") }</h3>

        <div id="confirmation-messages"></div>

        <div class="before-dataCanvas"></div>
        <div id="dataCanvas"></div>
        <div class="after-data-canvas"></div>

        <p style="display: inline">
            <button type="submit" onclick="submitHtmlForm()" class="submitButton confirm right">
                ${ ui.message("emr.save") }
                <i class="icon-spinner icon-spin icon-2x" style="display: none; margin-left: 10px;"></i>
            </button>
        </p>
        <p style="display: inline">
            <input type="button" value="${ ui.message("emr.no") }" class="cancel" />
        </p>
        <p>
            <span class="error field-error">${ ui.message("emr.simpleFormUi.error.emptyForm") }</span>
        </p>
    </div>
</div>
</script>