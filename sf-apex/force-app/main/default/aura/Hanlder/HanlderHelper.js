({
    ToastMethod : function(title,message) {
        // Display the total in a "toast" status message
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "mode": 'sticky',
            "type":"success"
        });
        resultsToast.fire();
    },
    upload_data: function(component, event, helper,data_form){
        var action = component.get("c.Add_Ammount");
        action.setParams({ "Name" :component.get("v.uiPkg__Bank_Name__c")});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               this.ToastMethod("From server:",response.getReturnValue());
            }
            else{
                console.log(state);
            }
            
        });
        
        $A.enqueueAction(action);
    }
    
})