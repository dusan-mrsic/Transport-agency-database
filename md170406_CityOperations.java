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
import rs.etf.sab.operations.CityOperations;

/**
 *
 * @author mrsic
 */
public class md170406_CityOperations  implements CityOperations{

    
    Connection conn = DB.getInstance().getConnection();
    @Override
    public int insertCity(String ime, String postanskiBroj) {
        //System.out.println("insert");
        if(ime.equals("")) return -1;
        try(PreparedStatement ps = conn.prepareStatement("insert into Grad values(?, ?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps1 = conn.prepareStatement("select * from Grad where Naziv=? or PostanskiBroj=?");) {
            ps.setString(1,ime);
            ps.setString(2,postanskiBroj);
            ps1.setString(1,ime);
            ps1.setString(2,postanskiBroj);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()) return -1;
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
    public int deleteCity(String... imenaGradova) {
        //System.out.println("delete");

        int broj = 0;
        if(imenaGradova.length == 0) return 0;
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Grad where Naziv=?");
        ) {
            for(String ime : imenaGradova){
                //System.out.println(ime);
                ps.setString(1, ime);
                broj += ps.executeUpdate();
                //System.out.println("delete for");
                
            }
            //System.out.println(broj);
            return broj;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    @Override
    public boolean deleteCity(int i) {
        //System.out.println("delete 1");
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Grad where ID=?");
        ) {
           ps.setInt(1, i);
           int num = ps.executeUpdate();
           if(num == 1) return true;
           else return false;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public List<Integer> getAllCities() {
        //System.out.println("getall");
        List<Integer> gradovi = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Grad");) {
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()) gradovi.add(rs.getInt(1));
            
            return gradovi;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_CityOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return gradovi;
    }
    
}
