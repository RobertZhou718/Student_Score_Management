package Servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Bean.Dept;
import Bean.Page;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import Dao.DeptDao;

public class DeptServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3014055729419973547L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("toClazzListView".equals(method)){
			clazzList(request,response);
		}else if("getClazzList".equals(method)){
			getClazzList(request, response);
		}else if("AddClazz".equals(method)){
			addClazz(request, response);
		}else if("DeleteClazz".equals(method)){
			deleteClazz(request, response);
		}else if("EditClazz".equals(method)){
			editClazz(request, response);
		}
	}
	private void editClazz(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		Integer id = Integer.parseInt(request.getParameter("id"));
		String name = request.getParameter("name"); 
		String info = request.getParameter("info");
		Dept clazz = new Dept();
		clazz.setName(name);
		clazz.setInfo(info);
		clazz.setId(id);
		DeptDao clazzDao = new DeptDao();
		if(clazzDao.editClazz(clazz)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				clazzDao.closeCon();
			}
		}
	}
	private void deleteClazz(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		Integer id = Integer.parseInt(request.getParameter("clazzid"));
		DeptDao clazzDao = new DeptDao();
		if(clazzDao.deleteClazz(id)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				clazzDao.closeCon();
			}
		}
	}
	private void addClazz(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name = request.getParameter("name"); 
		String info = request.getParameter("info");
		Dept clazz = new Dept();
		clazz.setName(name);
		clazz.setInfo(info);
		DeptDao clazzDao = new DeptDao();
		if(clazzDao.addClazz(clazz)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				clazzDao.closeCon();
			}
		}
		
	}
	private void clazzList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		try {
			request.getRequestDispatcher("view/deptList.jsp").forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void getClazzList(HttpServletRequest request,HttpServletResponse response){
		String name = request.getParameter("clazzName");
		Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
		Integer pageSize = request.getParameter("rows") == null ? 999 : Integer.parseInt(request.getParameter("rows"));
		Dept clazz = new Dept();
		clazz.setName(name);
		DeptDao clazzDao = new DeptDao();
		List<Dept> clazzList = clazzDao.getClazzList(clazz, new Page(currentPage, pageSize));
		int total = clazzDao.getClazzListTotal(clazz);
		clazzDao.closeCon();
		response.setCharacterEncoding("UTF-8");
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("total", total);
		ret.put("rows", clazzList);
		try {
			String from = request.getParameter("from");
			if("combox".equals(from)){
				response.getWriter().write(JSONArray.fromObject(clazzList).toString());
			}else{
				response.getWriter().write(JSONObject.fromObject(ret).toString());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
