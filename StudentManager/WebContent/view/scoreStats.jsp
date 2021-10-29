<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>成绩统计</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		
		//preload
	    $("#courseList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, 
		  		editable: false, 
		  		method: "post",
		  		url: "CourseServlet?method=CourseList&t="+new Date().getTime()+"&from=combox",
		  		
		  	});
		
	  
	  	$("#courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
	  	
	    //search
	  	$(".search-score-btn").click(function(){
	  		var searchKey = $(this).attr('key');
	  		var courseId = $("#courseList").combobox('getValue');
	  		if(courseId == null || courseId == ''){
	  			$.messager.alert("Notification","Please select a course!","info");
	  			return;
	  		}
	  		$.ajax({
	  			url:'ScoreServlet?method=getStatsList&courseid='+courseId+"&searchType="+searchKey,
	  			dataType:'json',
	  			success:function(rst){
	  				if(rst.type == "suceess"){
	  					var option;
	  					if(searchKey == 'range'){
	  						option = {
		  			  	            title: {
		  			  	                text: 'Course：'+rst.courseName
		  			  	            },
		  			  	            tooltip: {
		  			  	                trigger: 'axis',
		  			  	                axisPointer: {
		  			  	                    type: 'cross',
		  			  	                    crossStyle: {
		  			  	                        color: '#999'
		  			  	                    }
		  			  	                }
		  			  	            },
		  			  	        legend: {
		  			  	        		data:['Score interval distribution']
		  			  	    		},
		  			  	            xAxis: {
		  			  	                data: rst.rangeList
		  			  	            },
		  			  	            yAxis: {type: 'value'},
		  			  	            series: [{
		  			  	                name: 'Score interval distribution',
		  			  	                type: 'bar',
		  			  	                data: rst.numberList
		  			  	            }]
		  			  	        };
	  					}else{
	  						option = {
		  			  	            title: {
		  			  	                text: 'Course：'+rst.courseName
		  			  	            },
		  			  	            tooltip: {
		  			  	                trigger: 'axis',
		  			  	                axisPointer: {
		  			  	                    type: 'cross',
		  			  	                    crossStyle: {
		  			  	                        color: '#999'
		  			  	                    }
		  			  	                }
		  			  	            },
		  			  	        legend: {
		  			  	        		data:['Score distribution']
		  			  	    		},
		  			  	            xAxis: {
		  			  	                data: rst.avgList
		  			  	            },
		  			  	            yAxis: {type: 'value'},
		  			  	            series: [{
		  			  	                name: 'Score distribution',
		  			  	                type: 'bar',
		  			  	                data: rst.scoreList
		  			  	            }]
		  			  	        };
	  					}
	  					showCharts(option);
	  				}else{
	  					$.messager.alert("Notification","Error getting data!","info");
	  				}
	  			}
	  		})
	  		
	  	});
	    
	});
	</script>
</head>
<body style="padding:0px;">
	<div class="panel-header"><div class="panel-title panel-with-icon">Score information statistics</div><div class="panel-icon icon-more"></div><div class="panel-tool"></div></div>
	<!-- tool bar -->
	<div id="toolbar" class="datagrid-toolbar">
		<div style="margin-top: 3px;">
			Course：<input id="courseList" class="easyui-textbox" name="courseList" />
			<a href="javascript:;" class="easyui-linkbutton search-score-btn" key="range" data-options="iconCls:'icon-sum',plain:true">Interval chart</a>
			<a href="javascript:;" class="easyui-linkbutton search-score-btn" key="avg" data-options="iconCls:'icon-sum',plain:true">Average chart</a>
		</div>
	</div>
	<div id="charts-div" style="width:100%;height:500px;"></div>
</body>
<script type="text/javascript" src="easyui/js/echarts.common.min.js"></script>
<script type="text/javascript">
        var myChart = echarts.init(document.getElementById('charts-div'));
        function showCharts(option){
            myChart.setOption(option);
        }
    </script>
</html>