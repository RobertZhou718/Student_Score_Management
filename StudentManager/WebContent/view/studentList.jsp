<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Student List</title>
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
	        title:'Student List', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible:false, 
	        fit: true, 
	        method: "post",
	        url:"StudentServlet?method=StudentList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false, 
	        pagination:true,
	        rownumbers:true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'sn',title:'Student number',width:200, sortable: true},    
 		        {field:'name',title:'Name',width:200},
 		        {field:'sex',title:'Sex',width:100},
 		        {field:'mobile',title:'Mobile',width:150},
 		        {field:'email',title:'E-mail',width:150},
 		        {field:'clazz_id',title:'Department',width:150, 
 		        	formatter: function(value,row,index){
 						if (row.clazzId){
 							var clazzList = $("#clazzList").combobox("getData");
 							for(var i=0;i<clazzList.length;i++ ){
 								if(row.clazzId == clazzList[i].id)
 									return clazzList[i].name;
 							}
 							return row.clazzId;
 						} else {
 							return 'not found';
 						}
 					}
				},
 		        
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#clazzList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
	    //page 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,
	        pageList: [10,20,30,50,100], 
	        beforePageText: 'Page',
	        afterPageText: '  Total {pages} pages', 
	        displayMsg: 'Current display {from} - {to} records   Total {total} records', 
	    }); 
	    //add
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    //edit
	    $("#edit").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("Notification", "Please select a piece of data to operate!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    //delete
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("Notification", "Please select data to delete!", "warning");
            } else{
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.sn;
            	});
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("Notification", "All data related to the student (including grades) will be deleted. Are you sure to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "StudentServlet?method=DeleteStudent",
							data: {sns: numbers, ids: ids},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Notification","Successfully deleted!","info");
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
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
	    
	  	
	  
	  	$("#clazzList").combobox({
	  		width: "150",
	  		height: "25",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  		url: "DeptServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
	  		onChange: function(newValue, oldValue){
	  			
	  			$('#dataList').datagrid("options").queryParams = {clazzid: newValue};
	  			$('#dataList').datagrid("reload");
	  		}
	  	});
	  	
	  	function preLoadClazz(){
	  		$("#clazzList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, 
		  		editable: false, 
		  		method: "post",
		  		url: "DeptServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  		
		  		}
		  	});
	  	}
	  	
	
	  	$("#add_clazzList, #edit_clazzList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
	  	
	  	
	  	$("#add_clazzList").combobox({
	  		url: "DeptServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				var data = $(this).combobox("getData");;
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	  	
	  	$("#edit_clazzList").combobox({
	  		url: "DeptServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
			onLoadSuccess: function(){
				//default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	//add
	    $("#addDialog").dialog({
	    	title: "Add Student",
	    	width: 650,
	    	height: 460,
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
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							var clazzid = $("#add_clazzList").combobox("getValue");
							$.ajax({
								type: "post",
								url: "StudentServlet?method=AddStudent",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Added successfully!","info");
										//close
										$("#addDialog").dialog("close");
										//clear
										$("#add_number").textbox('setValue', "");
										$("#add_name").textbox('setValue', "");
										$("#add_sex").textbox('setValue', "male");
										$("#add_phone").textbox('setValue', "");
										$("#add_email").textbox('setValue', "");
										
										//reload
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
							  			$('#dataList').datagrid("reload");
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
										
									} else{
										$.messager.alert("Notification","Failed to add!","warning");
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
						$("#add_number").textbox('setValue', "");
						$("#add_name").textbox('setValue', "");
						$("#add_phone").textbox('setValue', "");
						$("#add_email").textbox('setValue', "");
						$("#add_sex").textbox('setValue', "male");
						$("#add_clazzList").combobox("clear");
						
					
			
					}
				},
			]
	    });
	  	
	  	//edit
	    $("#editDialog").dialog({
	    	title: "Edit Student information",
	    	width: 650,
	    	height: 460,
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
						var clazzid = $("#edit_clazzList").combobox("getValue");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "StudentServlet?method=EditStudent&t="+new Date().getTime(),
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Update success!","info");
										//close
										$("#editDialog").dialog("close");
										//reload
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
										$("#dataList").datagrid("reload");
										$("#dataList").datagrid("uncheckAll");
										
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
							  			
									} else{
										$.messager.alert("Notification","Update failed!","warning");
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
						//clear
						$("#edit_name").textbox('setValue', "");
						$("#edit_sex").textbox('setValue', "Male");
						$("#edit_phone").textbox('setValue', "");
						$("#edit_email").textbox('setValue', "");
						$("#edit_clazzList").combobox("clear");
					}
				}
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//edit
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_sex").textbox('setValue', selectRow.sex);
				$("#edit_phone").textbox('setValue', selectRow.mobile);
				$("#edit_email").textbox('setValue', selectRow.email);
				$("#edit-id").val(selectRow.id);
				
				var clazzid = selectRow.clazzId;
				setTimeout(function(){
					$("#edit_clazzList").combobox('setValue', clazzid);
				}, 100);
				
			}
	    });
	  //search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentName: $('#search_student_name').val(),
	  			clazzid: $("#clazzList").combobox('getValue') == '' ? 0 : $("#clazzList").combobox('getValue')
	  		});
	  	});
	  	$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$('#search_student_name').textbox('setValue', "");;
	    	$("#clazzList").combobox('clear');
	    });
	});
	
	
	</script>
</head>
<body>
	<!-- data list -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- tool bar -->
	<div id="toolbar">
		<c:if test="${userType == 1 || userType == 3}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${userType == 1 || userType == 3}">
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		</c:if>
		<div style="float: left;margin-top:4px;" class="datagrid-btn-separator" >&nbsp;&nbsp;Name：<input id="search_student_name" class="easyui-textbox" name="search_student_name" /></div>
		<div style="margin-left: 10px;margin-top:4px;" >Department：<input id="clazzList" class="easyui-textbox" name="clazz" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Clear search</a>
		</div>
	
	</div>
	
	<!-- add dialog -->
	<div id="addDialog" style="padding: 10px">  
		
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		
	    		<tr>
	    			<td>Name:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please fill in your name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Password:</td>
	    			<td>
	    				<input id="add_password"  class="easyui-textbox" style="width: 200px; height: 30px;" type="password" name="password" data-options="required:true, missingMessage:'Please enter your password'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Sex:</td>
	    			<td><select id="add_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="male">Male</option><option value="female">Female</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>Mobile:</td>
	    			<td><input id="add_phone" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="mobile" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>E-mail:</td>
	    			<td><input id="add_email" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="email" validType="number" /></td>
	    		</tr>
	    		<tr>
	    			<td>Department:</td>
	    			<td><input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- edit dialog -->
	<div id="editDialog" style="padding: 10px"> 
    	<form id="editForm" method="post">
	    	<input type="hidden" name="id" id="edit-id">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Sex:</td>
	    			<td><select id="edit_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="male">Male</option><option value="female">Female</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>Mobile:</td>
	    			<td><input id="edit_mobile" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="mobile" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>E-mail:</td>
	    			<td><input id="edit_email" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="email" validType="number" /></td>
	    		</tr>
	    		<tr>
	    			<td>Department:</td>
	    			<td><input id="edit_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>

	
</body>
</html>