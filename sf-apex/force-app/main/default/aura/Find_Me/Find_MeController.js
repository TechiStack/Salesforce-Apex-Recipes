({
    init: function (cmp, event, helper) {
        
        
        var cmpTarget = cmp.find('menu');
        $A.util.addClass(cmpTarget, '');
        
        var cmpTarget = cmp.find('lgMenu');
        $A.util.addClass(cmpTarget,'menu1');
        
        
        
        
        
        
        
        
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: '1600 Pennsylvania Ave NW',
                    City: 'Washington',
                    State: 'DC'
                },

                title: 'The White House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    },
    
    find_me : function(cmp,event,helper){
         console.log('>>>>>');
        var address = cmp.get('v.Address');
        console.log(address);
        cmp.set('v.mapMarkers', [
            {
                location: {
                     Street: address,
                    City: address,
                    State: address
                },

                title: 'The White House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    },
    slider : function (component,event,helper){
       component.set('v.showPop',true);
        var elements = document.getElementsByClassName("showPenel");
        elements[0].style.display = 'none';

    
    },
    exit: function (component,event,helper){
	   
        var elements = document.getElementsByClassName("showPenel");
        elements[0].style.display = 'block';
        component.set('v.showPop',false);
    }
})