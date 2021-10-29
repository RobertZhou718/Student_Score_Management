

$.extend($.fn.validatebox.defaults.rules, {
   
	//Verification account cannot be repeated
	repeat: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "SystemServlet?method=AllAccount&t="+new Date().getTime(),
				success: function(data){//Load the data in the verification function, and judge the input value after it is loaded
					var account = $.parseJSON(data);
		            for(var i=0;i < account.length;i++){
		            	if(value == account[i]){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'User already exists'
	},
	
	//Verification course cannot be repeated
	repeat_course: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "CourseServlet?method=CourseList&t="+new Date().getTime(),
				success: function(data){//Load the data in the verification function, and judge the input value after it is loaded
					var course = $.parseJSON(data);
		            for(var i=0;i < course.length;i++){
		            	if(value == course[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'Course name already exists'
	},
	
	
	//Verification department cannot be repeated
	repeat_clazz: {
		validator: function (value, param) {
			var gradeid = $(param[0]).combobox("getValue");
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				data: {gradeid: gradeid},
				url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
				success: function(data){//Load the data in the verification function, and judge the input value after it is loaded
					var clazz = $.parseJSON(data);
		            for(var i=0;i < clazz.length;i++){
		            	if(value == clazz[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'The department already exists'
	},
	
	//Verify that the two values are the same
	equals: {
        validator: function (value, param) {
        	if($(param[0]).val() != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Passwords are different.'
    },
    
    //Password rules
    password: {
        validator: function (value) {
        	var reg = /^[a-zA-Z0-9]{6,16}$/;
        	return reg.test(value);
            
        }, message: '6-16 digits, characters numbers only!'
    },
    
    //Verify that the entered password is correct
    oldPassword: {
        validator: function (value, param) {
        	if(param != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Wrong password'
    },
    

    //User account verification (can only include _ numbers and letters) 
    account: {//
        validator: function (value, param) {
            if (value.length < param[0] || value.length > param[1]) {
                $.fn.validatebox.defaults.rules.account.message = 'User password length must between' + param[0] + 'to' + param[1] ;
                return false;
            } else {
                if (!/^[\w]+$/.test(value)) {
                    $.fn.validatebox.defaults.rules.account.message = 'The username can only consist of numbers, letters, and underscores.';
                    return false;
                } else {
                    return true;
                }
            }
        }, message: ''
    }
}) 
