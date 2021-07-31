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
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.CourierOperations;
import rs.etf.sab.operations.CourierRequestOperation;

/**
 *
 * @author mrsic
 */
public class md170406_CourierOperations implements CourierOperations{

    Connection conn = DB.getInstance().getConnection();

    @Override
    public boolean insertCourier(String ime, String vozilo) {
        CourierRequestOperation courierRequestOperation=new md170406_CourierRequestOperation();
        courierRequestOperation.insertCourierRequest(ime,vozilo);
        return courierRequestOperation.grantRequest(ime);
    }

    @Override
    public boolean deleteCourier(String ime) {
        try(
            PreparedStatement ps = conn.prepareStatement("delete from Kurir where KorisnickoIme=?");
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
    public List<String> getCouriersWithStatus(int i) {
        List<String> kuriri = new ArrayList<String>();
        if(i != 0 && i != 1) return kuriri;
        try(PreparedStatement ps = conn.prepareStatement("select KorisnickoIme from Kurir where Status=?");) {
            ps.setInt(1, i);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) kuriri.add(rs.getString(1));
            return kuriri;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_CityOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return kuriri;
    }

    @Override
    public List<String> getAllCouriers() {
        List<String> kuriri = new ArrayList<String>();
        try(
            PreparedStatement ps = conn.prepareStatement("select KorisnickoIme from Kurir order by OstvarenProfit DESC");
        ) {
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                kuriri.add(rs.getString(1));
            }
            
            return kuriri;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return kuriri;
    }

    @Override
    public BigDecimal getAverageCourierProfit(int i) {
        BigDecimal ukupanProfit = new BigDecimal(0);
        try(
            PreparedStatement ps = conn.prepareStatement("select AVG(OstvarenProfit) from Kurir where BrIsporucenihPaketa>=?");
        ) {
            
            ps.setInt(1, i);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException ex) {
            Logger.getLogger(md170406_UserOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return ukupanProfit;
    }

}
