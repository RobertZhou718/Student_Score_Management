<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Course List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		//datagrid initialization 
	    $('#dataList').datagrid({ 
	        title:'Course List', 
	        iconCls:'icon-more',//icon 
	        border: true, 
	        collapsible: false,//Foldable
	        fit: true, 
	        method: "post",
	        url:"CourseServlet?method=CourseList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: false,
	        pagination: true,//page 
	        rownumbers: true,//row 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'Course name',width:200},
 		       	{field:'teacherId',title:'Teacher',width:200,
 		        	formatter: function(value,row,index){
 						if (row.teacherId){
 							var teacherList = $("#teacherList").combobox("getData");
 							for(var i=0;i<teacherList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.teacherId == teacherList[i].id)return teacherList[i].name;
 							}
 							return row.clazzId;
 						} else {
 							return 'not found';
 						}
 					}	
 		       	},
 		       	{field:'courseDate',title:'Schedule',width:200},
 		        {field:'selectedNum',title:'Number of people selected',width:200},
 		        {field:'maxNum',title:'Maximum number of people available',width:200},
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#teacherList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
		//preload
	    function preLoadClazz(){
	  		$("#teacherList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, 
		  		editable: false, 
		  		method: "post",
		  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  		
		  		}
		  	});
	  	}
		
	  //page
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//每页显示的记录条数，默认为10 
	        pageList: [10,20,30,50,100],//可以设置每页记录条数的列表 
	        beforePageText: 'Page',//页数文本框前显示的汉字 
	        afterPageText: '  Total {pages} pages', 
	        displayMsg: 'Current display {from} - {to} records   Total {total} records', 
	    });
	   	
	    //add button
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	  //edit button
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("Notification", "Please select a piece of data to operate!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    
	  //edit dialog
	  	$("#editDialog").dialog({
	  		title: "Modify course information",
	    	width: 450,
	    	height: 400,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Submit',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							var teacherid = $("#edit_teacherList").combobox("getValue");
							var id = $("#dataList").datagrid("getSelected").id;
							var name = $("#edit_name").textbox("getText");
							var courseDate = $("#edit_course_date").textbox("getText");
							var maxNum = $("#edit_max_num").numberbox("getValue");
							var info = $("#edit_info").val();
							var data = {id:id, teacherid:teacherid, name:name,courseDate:courseDate,info:info,maxnum:maxNum};
							
							$.ajax({
								type: "post",
								url: "CourseServlet?method=EditCourse",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Successfully modified!","info");
										//close
										$("#editDialog").dialog("close");
										//clear
										$("#edit_name").textbox('setValue', "");
										$("#edit_course_date").textbox('setValue', "");
										$("#edit_info").val("");
										
										//reload
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("Notification","Failed to edit!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						 $("#edit_teacherList").combobox("clear");
						 $("#edit_name").textbox('setValue', "");
						 $("#edit_course_date").textbox('setValue', "");
						 $("#edit_max_num").numberbox('setValue', "");
						 $("#edit_info").val("");				
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_course_date").textbox('setValue', selectRow.courseDate);
				$("#edit_max_num").numberbox('setValue', selectRow.maxNum);
				$("#edit_info").val(selectRow.info);
				var teacherId = selectRow.teacherId;
				setTimeout(function(){
					$("#edit_teacherList").combobox('setValue', teacherId);
				}, 100);
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_course_date").textbox('setValue', "");
				$("#edit_info").val("");
			}
	    });
	    
	    //delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelections");
        	if(selectRow == null){
            	$.messager.alert("Notification", "Please select data to delete!", "warning");
            } else{
            	var ids = [];
            	$(selectRow).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("Notification", "All data related to the course will be deleted. Are you sure to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "CourseServlet?method=DeleteCourse",
							data: {ids: ids},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Notification","Successfully deleted!","info");
									//reload
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("Notification","Failed to delete!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	
	  	//add dialog
	    $("#addDialog").dialog({
	    	title: "Add course",
	    	width: 450,
	    	height: 400,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Add',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "CourseServlet?method=AddCourse",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Added successfully!","info");									
										$("#addDialog").dialog("close");										
										$("#add_name").textbox('setValue', "");							
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("Notification","Add failed!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-book-reset',
					handler:function(){
						$("#add_name").textbox('setValue', "");
						$("#add_course_date").textbox('setValue', "");
						$("#add_max_num").numberbox('setValue', "");
						$("#info").val("");
						
						 $("#add_teacherList").combobox("clear")
					}
				},
			]
	    });
	  	
	  //General properties of the drop-down box
	  	$("#add_teacherList, #edit_teacherList,#teacherList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
	  	//add teacher list
	    $("#add_teacherList").combobox({
	  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  //edit teacher list
	    $("#edit_teacherList").combobox({
	  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	    //search button
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			name: $('#courseName').val(),
	  			teacherid: $("#teacherList").combobox('getValue') == '' ? 0 : $("#teacherList").combobox('getValue')
	  		});
	  	});
		$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$("#teacherList").combobox('clear');
	    });
	});
	</script>
</head>
<body>
	<!-- data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- tool bar -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="margin-top: 3px;">
			Course：<input id="courseName" class="easyui-textbox" name="clazzName" />
			Teacher：<input id="teacherList" class="easyui-textbox" name="clazz" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Clear search</a>
		</div>
	</div>
	
	<!-- add dialog -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Course:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Teacher:</td>
	    			<td colspan="3">
	    				<input id="add_teacherList" style="width: 200px; height: 30px;" class="easyui-textbox" name="teacherid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Schedule:</td>
	    			<td><input id="add_course_date" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="course_date" data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Maximum number of people available:</td>
	    			<td><input id="add_max_num" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="maxnum" data-options="min:0,precision:0,required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Course information</td>
	    			<td>
	    				<textarea id="info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- edit dialog -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
    		<!-- <input type="hidden" name="id" id="edit-id"> -->
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Course:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Teacher:</td>
	    			<td colspan="3">
	    				<input id="edit_teacherList" style="width: 200px; height: 30px;" class="easyui-textbox" name="teacherid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Schedule:</td>
	    			<td><input id="edit_course_date" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="course_date" data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Maximum number of people available:</td>
	    			<td><input id="edit_max_num" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="max_num" data-options="min:0,precision:0,required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Course information:</td>
	    			<td>
	    				<textarea id="edit_info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
</body>
</html>