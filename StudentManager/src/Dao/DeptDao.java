package Dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Bean.Dept;
import Bean.Page;
import Util.StringUtil;


public class DeptDao extends BaseDao {
	public List<Dept> getClazzList(Dept clazz,Page page){
		List<Dept> ret = new ArrayList<Dept>();
		String sql = "select * from s_clazz ";
		if(!StringUtil.isEmpty(clazz.getName())){
			sql += "where name like '%" + clazz.getName() + "%'";
		}
		sql += " limit " + page.getStart() + "," + page.getPageSize();
		ResultSet resultSet = query(sql);
		try {
			while(resultSet.next()){
				Dept cl = new Dept();
				cl.setId(resultSet.getInt("id"));
				cl.setName(resultSet.getString("name"));
				cl.setInfo(resultSet.getString("info"));
				ret.add(cl);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	public int getClazzListTotal(Dept clazz){
		int total = 0;
		String sql = "select count(*)as total from s_clazz ";
		if(!StringUtil.isEmpty(clazz.getName())){
			sql += "where name like '%" + clazz.getName() + "%'";
		}
		ResultSet resultSet = query(sql);
		try {
			while(resultSet.next()){
				total = resultSet.getInt("total");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}
	public boolean addClazz(Dept clazz){
		String sql = "insert into s_clazz values(null,'"+clazz.getName()+"','"+clazz.getInfo()+"') ";
		return update(sql);
	}
	public boolean deleteClazz(int id){
		String sql = "delete from s_clazz where id = "+id;
		return update(sql);
	}
	public boolean editClazz(Dept clazz) {
		// TODO Auto-generated method stub
		String sql = "update s_clazz set name = '"+clazz.getName()+"',info = '"+clazz.getInfo()+"' where id = " + clazz.getId();
		return update(sql);
	}
	
}
