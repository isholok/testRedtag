({
    handleClick : function(component, event, helper) {
        let validity = component.find('datesrange').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validity){
            var isDateError = component.get("v.dateValidationError");
            if(isDateError != true){
                let urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/apex/BirdseyeGroupPrintPage?recordId="+component.get('v.recordId')+'&fromDate='+component.get('v.fromDate')+'&toDate='+component.get('v.toDate'),
                    "isredirect": "true"
                });
                urlEvent.fire();
            }
        }
        },
            dateCheck : function(component, event, helper){
                let firstDate = component.get("v.fromDate");
                let secondDate = component.get("v.toDate");
                if(secondDate < firstDate){
                    component.set("v.dateValidationError" , true);
                }
                else{
                    component.set("v.dateValidationError" , false);
                }
            }
    })