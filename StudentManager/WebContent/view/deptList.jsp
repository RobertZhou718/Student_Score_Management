<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Department List</title>
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
	        title:'Department List', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible: false,
	        fit: true, 
	        method: "post",
	        url:"DeptServlet?method=getClazzList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true, 
	        pagination: true, 
	        rownumbers: true, 
	        sortName: 'id',
	        sortOrder: 'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'Department name',width:200},
 		        {field:'info',title:'Department introduction',width:100, 
 		        },
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	    //page 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//each page default 10 
	        pageList: [10,20,30,50,100],//set
	        beforePageText: 'Page',//before 
	        afterPageText: '  Total {pages} pages', 
	        displayMsg: 'Current display {from} - {to} records   Total {total} records', 
	    });
	
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    //delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("Notification", "Please select data to delete!", "warning");
            } else{
            	var clazzid = selectRow.id;
            	$.messager.confirm("Notification", "The department information will be deleted (if there are students or teachers in the department, it cannot be deleted), confirm to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "DeptServlet?method=DeleteClazz",
							data: {clazzid: clazzid},
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
	    
	    
	  	
	  	//add
	    $("#addDialog").dialog({
	    	title: "Add Department",
	    	width: 500,
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
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "DeptServlet?method=AddClazz",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Added successfully!","info");
										//close
										$("#addDialog").dialog("close");
										//clear
										$("#add_name").textbox('setValue', "");
										$("#info").val("");
										//reload
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
					iconCls:'icon-reload',
					handler:function(){
						$("#add_name").textbox('setValue', "");
						$("#info").val("");
					}
				},
			]
	    });
	  	
	  	
	  	//search button
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			clazzName: $('#clazzName').val()
	  		});
	  	});
	  	$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$('#clazzName').textbox('setValue', "");
	    });
	  	
	  //edit button
	  	$("#edit-btn").click(function(){
	  		var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("Notification", "Please select the data to modify!", "warning");
            	return;
            }
        	$("#editDialog").dialog("open");
	  	});
	  
	  //edit
	    $("#editDialog").dialog({
	    	title: "Edit Department",
	    	width: 500,
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
					text:'Submit',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("Notification","Please check the data you entered!","warning");
							return;
						} else{
							
							$.ajax({
								type: "post",
								url: "DeptServlet?method=EditClazz",
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Notification","Success!","info");
										//close
										$("#editDialog").dialog("close");
										//clear
										$("#edit_name").textbox('setValue', "");
										$("#edit_info").val("");
										//reload
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("Notification","Failed!","warning");
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
						$("#edit_name").textbox('setValue', "");
						$("#edit_info").val("");
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_info").val(selectRow.info);
				$("#edit-id").val(selectRow.id);
			}
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
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left; margin-right: 10px;"><a id="edit-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="margin-top: 3px;">Department name：<input id="clazzName" class="easyui-textbox" name="clazzName" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Clear search</a>
		</div>
	</div>
	
	<!-- add dialog -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Department name:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name"  data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Department introduction:</td>
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
    	<input type="hidden" id="edit-id" name="id">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Department name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name"  data-options="required:true, missingMessage:'Can not be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Department introduction:</td>
	    			<td>
	    				<textarea id="edit_info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>