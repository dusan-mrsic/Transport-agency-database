package sab_projekat;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.GeneralOperations;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author mrsic
 */
public class md170406_GeneralOperations implements GeneralOperations {

    
            
    Connection conn = DB.getInstance().getConnection();
    @Override
    public void eraseAll() {
        try(PreparedStatement ps1 = conn.prepareStatement("delete from Grad");
            PreparedStatement ps2 = conn.prepareStatement("delete from Korisnik");
                PreparedStatement ps3 = conn.prepareStatement("delete from Administrator");
                PreparedStatement ps4 = conn.prepareStatement("delete from Kurir");
                PreparedStatement ps5 = conn.prepareStatement("delete from OdobrenaPonuda");
                PreparedStatement ps6 = conn.prepareStatement("delete from Opstina");
                PreparedStatement ps7 = conn.prepareStatement("delete from Paket");
                PreparedStatement ps8 = conn.prepareStatement("delete from Ponuda");
                PreparedStatement ps9 = conn.prepareStatement("delete from Sadrzi");
                PreparedStatement ps10 = conn.prepareStatement("delete from Vozilo");
                PreparedStatement ps11 = conn.prepareStatement("delete from Voznja");
                PreparedStatement ps12 = conn.prepareStatement("delete from ZahtevVozilo");
                PreparedStatement ps13 = conn.prepareStatement("delete from ZahtevZaPrevozom");) {
            
            ps9.execute();
            ps11.execute();
            ps5.execute();
            
            ps8.execute();
            ps13.execute();
            ps7.execute();
            ps6.execute();
            
            ps1.execute();
            ps12.execute();
            
            ps4.execute();
            ps10.execute();
            
            ps2.execute();
            ps3.execute();
            
           
            
            
            
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_GeneralOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
