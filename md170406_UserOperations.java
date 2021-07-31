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
import rs.etf.sab.operations.UserOperations;

/**
 *
 * @author mrsic
 */
public class md170406_UserOperations implements UserOperations {
    
    Connection conn = DB.getInstance().getConnection();
    
    
    @Override
    public boolean insertUser(String korisnickoIme, String ime, String prezime, String sifra){
        if(ime.equals("") || Character.isLowerCase(ime.charAt(0))) return false;
        if(prezime.equals("") || Character.isLowerCase(prezime.charAt(0))) return false;
        if(!sifra.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")) return false;
        try(PreparedStatement ps = conn.prepareStatement("insert into Korisnik values(?,?,?,?,0)");
            PreparedStatement ps1 = conn.prepareStatement("select * from Korisnik where korisnickoIme=?");) {
            
            ps1.setString(1,korisnickoIme);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()){return false;}
            ps.setString(1,korisnickoIme);
            ps.setString(2,ime);
            ps.setString(3,prezime);
            ps.setString(4,sifra);
            ps.executeUpdate();
            return true;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
        
    };
    
    @Override
    public int declareAdmin(String korisnickoIme){
        if(korisnickoIme.equals("")) return 2;
        
        try(PreparedStatement ps = conn.prepareStatement("select * from Administrator where korisnickoIme=?");
            PreparedStatement ps1 = conn.prepareStatement("insert into Administrator values(?)");
            PreparedStatement ps2 = conn.prepareStatement("select * from Korisnik where korisnickoIme=?");   ) {
            
            ps2.setString(1,korisnickoIme);
            ResultSet rs = ps2.executeQuery();
            if(!rs.next()) return 2;
            ps.setString(1,korisnickoIme);
            rs = ps.executeQuery();
            if(rs.next()) return 1;
            ps1.setString(1,korisnickoIme);
            ps1.executeUpdate();
            return 0;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 2;
    };

    @Override
    public Integer getSentPackages(String... korisnickaImena) {
        Integer broj = 0;
        if(korisnickaImena.length == 0) return null;
        try(
            PreparedStatement ps = conn.prepareStatement("select COUNT(*) from Paket P where P.Status=3 and P.ID IN (select Z.Paket from ZahtevZaPrevozom Z where Z.Korisnik=?)");
                PreparedStatement ps1 = conn.prepareStatement("select * from Korisnik where KorisnickoIme=?");
        ) {
            for(String korisnik : korisnickaImena){
                ps1.setString(1, korisnik);
                ResultSet rs1 = ps1.executeQuery();
                if(!rs1.next()) return null;
                ps.setString(1, korisnik);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    broj += rs.getInt(1);
                }
            }
            return broj;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
       
    }

    @Override
    public int deleteUsers(String... korisnickaImena) {
        int broj = 0;
        if(korisnickaImena.length == 0) return 0;
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Korisnik where KorisnickoIme=?");
        ) {
            for(String korisnik : korisnickaImena){
                ps.setString(1, korisnik);
                broj += ps.executeUpdate();
            }
            return broj;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    @Override
    public List<String> getAllUsers() {
        List<String> korisnici = new ArrayList<String>();
        try(
            PreparedStatement ps = conn.prepareStatement("select KorisnickoIme from Korisnik");
        ) {
            
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                korisnici.add(rs.getString(1));
            }
            
            return korisnici;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return korisnici;
    }
    
    
    
}
