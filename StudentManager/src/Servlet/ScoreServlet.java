package Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import Bean.Page;
import Bean.Score;
import Bean.Student;
import Dao.ScoreDao;

public class ScoreServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -153736421631912372L;
	
	

	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("toScoreListView".equals(method)){
			try {
				request.getRequestDispatcher("view/scoreList.jsp").forward(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else if("AddScore".equals(method)){
			addScore(request,response);
		}else if("ScoreList".equals(method)){
			getScoreList(request,response);
		}else if("EditScore".equals(method)){
			editScore(request,response);
		}else if("DeleteScore".equals(method)){
			deleteScore(request,response);
		}else if("toScoreStatsView".equals(method)){
			try {
				request.getRequestDispatcher("view/scoreStats.jsp").forward(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else if("getStatsList".equals(method)){
			getStatsList(request,response);
		}
	}
	private void getStatsList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int courseId = request.getParameter("courseid") == null ? 0 : Integer.parseInt(request.getParameter("courseid").toString());
		String searchType = request.getParameter("searchType");
		response.setCharacterEncoding("UTF-8");
		if(courseId == 0){
			try {
				response.getWriter().write("error");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		ScoreDao scoreDao = new ScoreDao();
		Score score = new Score();
		score.setCourseId(courseId);
		if("avg".equals(searchType)){
			Map<String, Object> avgStats = scoreDao.getAvgStats(score);
			List<Double> scoreList = new ArrayList<Double>();
			scoreList.add(Double.parseDouble(avgStats.get("max_score").toString()));
			scoreList.add(Double.parseDouble(avgStats.get("min_score").toString()));
			scoreList.add(Double.parseDouble(avgStats.get("avg_score").toString()));
			List<String> avgStringList = new ArrayList<String>();
			avgStringList.add("Max Score");
			avgStringList.add("Min Score");
			avgStringList.add("Avg Score");
			Map<String, Object> retMap = new HashMap<String, Object>();
			retMap.put("courseName", avgStats.get("courseName").toString());
			retMap.put("scoreList", scoreList);
			retMap.put("avgList", avgStringList);
			retMap.put("type", "suceess");
			try {
				response.getWriter().write(JSONObject.fromObject(retMap).toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		List<Map<String, Object>> scoreList = scoreDao.getScoreList(score);
		
		List<Integer> numberList = new ArrayList<Integer>();
		numberList.add(0);
		numberList.add(0);
		numberList.add(0);
		numberList.add(0);
		numberList.add(0);
		List<String> rangeStringList = new ArrayList<String>();
		rangeStringList.add("under 60");
		rangeStringList.add("60~70");
		rangeStringList.add("70~80");
		rangeStringList.add("80~90");
		rangeStringList.add("90~100");
		String courseName = "";
		for(Map<String, Object> entry:scoreList){
			courseName = entry.get("courseName").toString();
			double scoreValue = Double.parseDouble(entry.get("score").toString());
			if(scoreValue < 60){
				numberList.set(0, numberList.get(0)+1);
				continue;
			}
			if(scoreValue <= 70 && scoreValue >= 60){
				numberList.set(1, numberList.get(1)+1);
				continue;
			}
			if(scoreValue <= 80 && scoreValue > 70){
				numberList.set(2, numberList.get(2)+1);
				continue;
			}
			if(scoreValue <= 90 && scoreValue > 80){
				numberList.set(3, numberList.get(3)+1);
				continue;
			}
			if(scoreValue <= 100 && scoreValue > 90){
				numberList.set(4, numberList.get(4)+1);
				continue;
			}
		}
		Map<String, Object> retMap = new HashMap<String, Object>();
		retMap.put("courseName", courseName);
		retMap.put("numberList", numberList);
		retMap.put("rangeList", rangeStringList);
		retMap.put("type", "suceess");
		try {
			response.getWriter().write(JSONObject.fromObject(retMap).toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void deleteScore(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		ScoreDao scoreDao = new ScoreDao();
		String msg = "success";
		if(!scoreDao.deleteScore(id)){
			msg = "error";
		}
		scoreDao.closeCon();
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void editScore(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		int studentId = request.getParameter("studentid") == null ? 0 : Integer.parseInt(request.getParameter("studentid").toString());
		int courseId = request.getParameter("courseid") == null ? 0 : Integer.parseInt(request.getParameter("courseid").toString());
		Double scoreNum = Double.parseDouble(request.getParameter("score"));
		String remark = request.getParameter("remark");
		Score score = new Score();
		score.setId(id);
		score.setCourseId(courseId);
		score.setStudentId(studentId);
		score.setScore(scoreNum);
		score.setRemark(remark);
		ScoreDao scoreDao = new ScoreDao();
		String ret = "success";
		if(!scoreDao.editScore(score)){
			ret = "error";
		}
		try {
			response.getWriter().write(ret);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void getScoreList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId = request.getParameter("studentid") == null ? 0 : Integer.parseInt(request.getParameter("studentid").toString());
		int courseId = request.getParameter("courseid") == null ? 0 : Integer.parseInt(request.getParameter("courseid").toString());
		Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
		Integer pageSize = request.getParameter("rows") == null ? 999 : Integer.parseInt(request.getParameter("rows"));
		Score score = new Score();
		
		int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
		if(userType == 2){
			
			Student currentUser = (Student)request.getSession().getAttribute("user");
			studentId = currentUser.getId();
		}
		score.setCourseId(courseId);
		score.setStudentId(studentId);
		ScoreDao scoreDao = new ScoreDao();
		List<Score> courseList = scoreDao.getScoreList(score, new Page(currentPage, pageSize));
		int total = scoreDao.getScoreListTotal(score);
		scoreDao.closeCon();
		response.setCharacterEncoding("UTF-8");
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("total", total);
		ret.put("rows", courseList);
		try {
			String from = request.getParameter("from");
			if("combox".equals(from)){
				response.getWriter().write(JSONArray.fromObject(courseList).toString());
			}else{
				response.getWriter().write(JSONObject.fromObject(ret).toString());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void addScore(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId = request.getParameter("studentid") == null ? 0 : Integer.parseInt(request.getParameter("studentid").toString());
		int courseId = request.getParameter("courseid") == null ? 0 : Integer.parseInt(request.getParameter("courseid").toString());
		Double scoreNum = Double.parseDouble(request.getParameter("score"));
		String remark = request.getParameter("remark");
		Score score = new Score();
		score.setCourseId(courseId);
		score.setStudentId(studentId);
		score.setScore(scoreNum);
		score.setRemark(remark);
		ScoreDao scoreDao = new ScoreDao();
		if(scoreDao.isAdd(studentId, courseId)){
			try {
				response.getWriter().write("added");
				scoreDao.closeCon();
				return;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		String ret = "success";
		if(!scoreDao.addScore(score)){
			ret = "error";
		}
		try {
			response.getWriter().write(ret);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
