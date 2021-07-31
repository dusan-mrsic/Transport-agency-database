/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sab_projekat;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.CourierOperations;
import rs.etf.sab.operations.CourierRequestOperation;

/**
 *
 * @author mrsic
 */
public class md170406_CourierRequestOperation implements CourierRequestOperation{

    Connection conn = DB.getInstance().getConnection();
    
    
    @Override
    public boolean insertCourierRequest(String ime, String vozilo) {
        if(ime.equals("") || vozilo.equals("")) return false;
        try(PreparedStatement ps = conn.prepareStatement("select * from Korisnik where KorisnickoIme=?");
            PreparedStatement ps1 = conn.prepareStatement("select * from Vozilo where RegistracioniBroj=?");
            PreparedStatement ps2 = conn.prepareStatement("select * from Kurir where KorisnickoIme=?");
            PreparedStatement ps3 = conn.prepareStatement("select * from ZahtevVozilo where KorisnickoIme=? and RegistracioniBroj=?");
            PreparedStatement ps4 = conn.prepareStatement("insert into ZahtevVozilo values (?,?)");) {
            ps.setString(1,ime);
            ResultSet rs = ps.executeQuery();
            if(!rs.next()) return false;
            ps1.setString(1,vozilo);
            ResultSet rs1 = ps1.executeQuery();
            if(!rs1.next()) return false;
            ps2.setString(1,vozilo);
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) return false;
            ps3.setString(1,ime);
            ps3.setString(2, vozilo);
            ResultSet rs3 = ps3.executeQuery();
            if(rs3.next()) return false;
            ps4.setString(1,ime);
            ps4.setString(2,vozilo);
            ps4.executeUpdate();
            
	    return true;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public boolean deleteCourierRequest(String ime) {
       try(
            PreparedStatement ps = conn.prepareStatement("delete from ZahtevVozilo where KorisnickoIme=?");
        ) {
           ps.setString(1, ime);
           int num = ps.executeUpdate();
           return num == 1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public boolean changeVehicleInCourierRequest(String ime, String novoVozilo) {
        if(ime.equals("") || novoVozilo.equals("")) return false;
        try(
            PreparedStatement ps = conn.prepareStatement("select * from ZahtevVozilo where KorisnickoIme=?");
            PreparedStatement ps2 = conn.prepareStatement("select * from Vozilo where RegistracioniBroj=?");
            PreparedStatement ps1 = conn.prepareStatement("update ZahtevVozilo set RegistracioniBroj=? where KorisnickoIme=?");
        ) {
           ps.setString(1, ime);
           ResultSet rs = ps.executeQuery();
           if(!rs.next()) return false;
           ps2.setString(1, novoVozilo);
           ResultSet rs2 = ps2.executeQuery();
           if(!rs2.next()) return false;
           ps1.setString(1, novoVozilo);
           ps1.setString(2, ime);
           int num = ps1.executeUpdate();
           return num==1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public List<String> getAllCourierRequests() {
        List<String> zahtevi = new ArrayList<String>();
        try(
            PreparedStatement ps = conn.prepareStatement("select KorisnickoIme from ZahtevVozilo");
        ) {
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                zahtevi.add(rs.getString(1));
            }
            return zahtevi;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return zahtevi;
    }

    @Override
    public boolean grantRequest(String korisnickoIme) {
        try(CallableStatement cs = conn.prepareCall("{ call dbo.spPrihvatiZahtevZaKurira (?,?) }");) {
            cs.setString(1,korisnickoIme);
            cs.registerOutParameter(2, java.sql.Types.INTEGER);
            cs.execute();
            if(cs.getInt(2)==0)return false;
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_CourierRequestOperation.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
}
