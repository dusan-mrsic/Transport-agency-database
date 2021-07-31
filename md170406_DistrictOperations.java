/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sab_projekat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.DistrictOperations;

/**
 *
 * @author mrsic
 */
public class md170406_DistrictOperations implements DistrictOperations{
    
    Connection conn = DB.getInstance().getConnection();
    
    @Override
    public int insertDistrict(String ime, int idGrada, int x, int y) {
        //System.out.println("insert opstina");
        if(ime.equals("")) return -1;
        try(PreparedStatement ps = conn.prepareStatement("insert into Opstina values(?, ?, ?, ?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps1 = conn.prepareStatement("select * from Grad where ID=?");
                PreparedStatement ps2 = conn.prepareStatement("select * from Opstina where Naziv=? and X=? and Y=? and Grad=?")) {
            ps1.setInt(1,idGrada);
            ResultSet rs = ps1.executeQuery();
            if(!rs.next()) return -1;
            ps2.setString(1, ime);
            ps2.setInt(2, x);
            ps2.setInt(3, y);
            ps2.setInt(4, idGrada);
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) return -1;
            ps.setString(1, ime);
            ps.setInt(2, x);
            ps.setInt(3, y);
             ps.setInt(4, idGrada);
            ps.executeUpdate();
            ResultSet rs1=ps.getGeneratedKeys();
	    if(rs1.next()){
                return rs1.getInt(1);
            }else return -1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    @Override
    public int deleteDistricts(String... imenaOpstina) {
       // System.out.println("delete opstine");
        int broj = 0;
        if(imenaOpstina.length == 0) return 0;
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Opstina where Naziv=?");
        ) {
            for(String ime : imenaOpstina){
                ps.setString(1, ime);
                broj += ps.executeUpdate();
                
            }
            return broj;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    @Override
    public boolean deleteDistrict(int i) {
       // System.out.println("delete opstina");
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Opstina where ID=?");
        ) {
           ps.setInt(1, i);
           int num = ps.executeUpdate();
           return num == 1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public int deleteAllDistrictsFromCity(String naziv) {
       // System.out.println("delete all opstinagrad");
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Opstina where Grad=?");
                PreparedStatement ps1 = conn.prepareStatement("select ID from Grad where Naziv=?");
        ) {
           ps1.setString(1,naziv);
           ResultSet rs = ps1.executeQuery();
           if(!rs.next()) return 0;
           ps.setInt(1, rs.getInt(1));
           int num = 0;
           num = ps.executeUpdate();
           return num;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    @Override
    public List<Integer> getAllDistrictsFromCity(int i) {
       // System.out.println("getall opstinagrad");
        List<Integer> opstine = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Opstina where Grad=?");
            PreparedStatement ps1 = conn.prepareStatement("select * from Grad where ID=?")) {
            ps1.setInt(1, i);
            ResultSet rs1 = ps1.executeQuery();
            if(!rs1.next()) return null;
            ps.setInt(1, i);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) opstine.add(rs.getInt(1));
            return opstine;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_CityOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return opstine;
    }

    @Override
    public List<Integer> getAllDistricts() {
        //System.out.println("getall opstina");
        List<Integer> opstine = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Opstina");) {
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()) opstine.add(rs.getInt(1));
            
            return opstine;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_CityOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return opstine;
    }
    
}
