/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sab_projekat;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.VehicleOperations;

/**
 *
 * @author mrsic
 */
public class md170406_VehicleOperations implements VehicleOperations{

    Connection conn = DB.getInstance().getConnection();
    
    @Override
    public boolean insertVehicle(String registracioniBroj, int i, BigDecimal bd) {
        if(i != 0 && i != 1 && i != 2) return false;
        if(registracioniBroj.equals("")) return false;
        try(PreparedStatement ps = conn.prepareStatement("insert into Vozilo values(?, ?, ?)");
            PreparedStatement ps1 = conn.prepareStatement("select * from Vozilo where RegistracioniBroj=?");) {
            ps1.setString(1,registracioniBroj);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()) return false;
            ps.setString(1,registracioniBroj);
            ps.setInt(2,i);
            ps.setBigDecimal(3,bd);
            int num = ps.executeUpdate();
            return num==1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public int deleteVehicles(String... registracioniBrojevi) {
        int broj = 0;
        if(registracioniBrojevi.length == 0) return 0;
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Vozilo where RegistracioniBroj=?");
        ) {
            for(String reg : registracioniBrojevi){
                ps.setString(1, reg);
                broj += ps.executeUpdate();
            }
            return broj;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    @Override
    public List<String> getAllVehichles() {
        List<String> vozila = new ArrayList<String>();
        try(
            PreparedStatement ps = conn.prepareStatement("select RegistracioniBroj from Vozilo");
        ) {
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                vozila.add(rs.getString(1));
            }
            
            return vozila;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vozila;
    }

    @Override
    public boolean changeFuelType(String registracioniBroj, int i) {
        if(i != 0 && i != 1 && i != 2) return false;
        if(registracioniBroj.equals("")) return false;
        try(PreparedStatement ps = conn.prepareStatement("update Vozilo set TipGoriva=? where RegistracioniBroj=?");
            PreparedStatement ps1 = conn.prepareStatement("select * from Vozilo where RegistracioniBroj=?");) {
            ps1.setString(1,registracioniBroj);
            ResultSet rs = ps1.executeQuery();
            if(!rs.next()) return false;
            ps.setInt(1,i);
            ps.setString(2,registracioniBroj);
            int num = ps.executeUpdate();
            if(num==1) return true;
            else return false;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public boolean changeConsumption(String registracioniBroj, BigDecimal bd) {
        if(registracioniBroj.equals("")) return false;
        try(PreparedStatement ps = conn.prepareStatement("update Vozilo set Potrosnja=? where RegistracioniBroj=?");
            PreparedStatement ps1 = conn.prepareStatement("select * from Vozilo where RegistracioniBroj=?");) {
            ps1.setString(1,registracioniBroj);
            ResultSet rs = ps1.executeQuery();
            if(!rs.next()) return false;
            ps.setBigDecimal(1,bd);
            ps.setString(2,registracioniBroj);
            int num = ps.executeUpdate();
            if(num==1) return true;
            else return false;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
}
