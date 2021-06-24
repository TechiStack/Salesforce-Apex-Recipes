({
	doInit : function(component, event, helper) {
        if(component.get("v.pageReference") != undefined && component.get("v.pageReference") != 'undefined') {
        var code = component.get("v.pageReference").state.code;
        if(code != undefined) {
            var action  = component.get("c.getAccessToken");
            action.setParams({
                "code" : code
            });
        	action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var accessToken = response.getReturnValue();
                component.set("v.accessToken", accessToken);
            }
        });
        
        $A.enqueueAction(action);
        }
      }
    },
     doAuth : function(component, event, helper) {

	var action  = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
				//if you want to use standard method use below code. But it will open in new tab.
               /* var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": authUrl
                });
                urlEvent.fire();*/
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleFilesChange : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;
        var code = component.get("v.accessToken");
        alert(attachmentId);
        
        var action  = component.get("c.uploadFile");
        action.setParams({
            "attachmentId": attachmentId,
            "accessToken" : 'ya29.c.ElkLBxAdkAvxwrpJ1xmOCCMpwaciLfloDUk-2wEMNJIxHzaLlbZjCGq7CH8DC41SJhDSvE8VfoFGDXCPzH6s-eVf4owSwjfrE2dzP6M07ZWCJMbMSMb41o5C0w'
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var responseCode = response.getReturnValue();
                if(responseCode != '')
                    alert(responseCode)
                    else
                        alert('There was some error');
            }
        });
        
        $A.enqueueAction(action);
    }
})