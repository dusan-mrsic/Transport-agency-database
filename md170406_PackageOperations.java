/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sab_projekat;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import rs.etf.sab.operations.PackageOperations;

/**
 *
 * @author mrsic
 */
public class md170406_PackageOperations implements PackageOperations{

    Connection conn = DB.getInstance().getConnection();
    
    @Override
    public int insertPackage(int IDopstineOD, int IDopstineDO, String korisnickoIme, int tip, BigDecimal tezina) {
        if(tip != 0 && tip != 1 && tip != 2) return -1;
        try(PreparedStatement ps = conn.prepareStatement("insert into Paket values (?,?,?,?,?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps1 = conn.prepareStatement("insert into ZahtevZaPrevozom values(?,?,?,?)");
            PreparedStatement ps2 = conn.prepareStatement("select * from Opstina where ID=?");
            PreparedStatement ps3 = conn.prepareStatement("select * from Korisnik where KorisnickoIme=?");
            PreparedStatement ps4 = conn.prepareStatement("select ID from Korisnik where KorisnickoIme=?");) {
            
            ps3.setString(1,korisnickoIme);
            ResultSet rs = ps3.executeQuery();
            if(!rs.next()) return -1;
            ps2.setInt(1,IDopstineDO);
            rs = ps2.executeQuery();
            if(!rs.next()) return -1;
            ps2.setInt(1,IDopstineOD);
            rs = ps2.executeQuery();
            if(!rs.next()) return -1;
            ps.setInt(1,0);
            ps.setBigDecimal(2, new BigDecimal(0));
            ps.setDate(3,null);
            ps.setInt(4,tip);
            ps.setBigDecimal(5, tezina);
            ps.setString(6,null);
            ps.executeUpdate();
            rs=ps.getGeneratedKeys();
            int id = 0;
            if(rs.next()){
               	id = rs.getInt(1);
            }else return -1;
            /*int idK = 0;
            ps4.setString(1,korisnickoIme);
            rs = ps4.executeQuery();
            if(rs.next()){
                idK = rs.getInt(1);
            }else return -1;*/
            ps1.setString(1, korisnickoIme);
            ps1.setInt(2,id);
            ps1.setInt(3, IDopstineOD);
            ps1.setInt(4, IDopstineDO);
            ps1.executeUpdate();
            return id;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;

    }

    @Override
    public int insertTransportOffer(String kurirKorisnickoIme, int IDpaketa, BigDecimal procenat) {
        if(kurirKorisnickoIme.equals("")) return -1;
        try(PreparedStatement ps = conn.prepareStatement("select * from Kurir where KorisnickoIme=?");
            PreparedStatement ps1 = conn.prepareStatement("select * from ZahtevZaPrevozom where Paket=?");
            PreparedStatement ps2 = conn.prepareStatement("insert into Ponuda values(?,?,?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps3 = conn.prepareStatement("select Korisnik from ZahtevZaPrevozom where Paket=?");) {
            ps.setString(1,kurirKorisnickoIme);
            ResultSet rs = ps.executeQuery();
            if(!rs.next()) return -1;
            if(rs.getInt(5)==1) return -1; // status
            ps1.setInt(1, IDpaketa);
            ResultSet rs1 = ps1.executeQuery();
            if(!rs1.next()) return -1;
            ps3.setInt(1, IDpaketa);
            ResultSet rs2 = ps3.executeQuery();
            if(!rs2.next()) return -1;
            String korinsik = rs2.getString(1);
            // ako je procenat null generisemo RANDOM procenat
            if (procenat==null) {
   		Random broj = new Random();
       		int randomBroj=broj.nextInt(20);
                randomBroj = randomBroj - 10;
       		procenat=new BigDecimal(randomBroj);
            }
            ps2.setBigDecimal(1,procenat);
            ps2.setString(2,kurirKorisnickoIme);
            ps2.setString(3,korinsik);
            ps2.setInt(4,IDpaketa);
            ps2.executeUpdate();
            ResultSet rs3 = ps2.getGeneratedKeys();
            if(rs3.next()) return rs3.getInt(1);
            return -1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }
    
    public BigDecimal cena(int idPaketa, BigDecimal procenat){
        BigDecimal cena = new BigDecimal(0);
        BigDecimal tezina = new BigDecimal(0);
        int OpstinaOD = 0, OpstinaDO = 0, x1 = 0, x2 = 0, y1 = 0, y2 = 0, tip = 0;
        try(PreparedStatement ps = conn.prepareStatement("select OpstinaOD, OpstinaDO from ZahtevZaPrevozom where Paket=?");
            PreparedStatement ps1 = conn.prepareStatement("select X, Y from Opstina where ID=?");
                PreparedStatement ps2 = conn.prepareStatement("select Tezina, Tip from Paket where ID=?");) {
            
            ps.setInt(1, idPaketa);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                OpstinaOD = rs.getInt(1);
                OpstinaDO = rs.getInt(2);
            }
            ps1.setInt(1, OpstinaOD);
            rs = ps1.executeQuery();
            if(rs.next()){
                x1 = rs.getInt(1);
                y1 = rs.getInt(2);
            }
            ps1.setInt(1, OpstinaDO);
            rs = ps1.executeQuery();
            if(rs.next()){
                x2 = rs.getInt(1);
                y2 = rs.getInt(2);
            }
            double euclid_distance = Math.sqrt((double)((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)));
            ps2.setInt(1,idPaketa);
            rs = ps2.executeQuery();
            if(rs.next()){
                tezina = rs.getBigDecimal(1);
                double tezinaA = tezina.doubleValue();
                tip = rs.getInt(2);
            }
            
            procenat = procenat.divide(new BigDecimal(100));
            BigDecimal c = new BigDecimal(0);
            if(tip == 0) c = new BigDecimal(10.0 * euclid_distance).multiply(procenat.add(new BigDecimal(1)));
            if(tip == 1) c = new BigDecimal((25.0 + tezina.doubleValue() * 100.0) * euclid_distance).multiply(procenat.add(new BigDecimal(1)));
            if(tip == 2) c = new BigDecimal((75.0 + tezina.doubleValue() * 300.0) * euclid_distance).multiply(procenat.add(new BigDecimal(1)));
            return c;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return cena;
    }
    
    public double distanca(int OpstinaOD, int OpstinaDO){
        double euclid_distance = 0;
        try(PreparedStatement ps1 = conn.prepareStatement("select X, Y from Opstina where ID=?");) {
            
            int x1 = 0, x2 = 0, y1 = 0, y2 = 0;
            ps1.setInt(1, OpstinaOD);
            ResultSet rs = ps1.executeQuery();
            if (rs.next()) {
                x1 = rs.getInt(1);
                y1 = rs.getInt(2);
            }   
            ps1.setInt(1, OpstinaDO);
            rs = ps1.executeQuery();
            if (rs.next()) {
                x2 = rs.getInt(1);
                y2 = rs.getInt(2);
            }   
            
            euclid_distance = Math.sqrt((double) ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)));
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return euclid_distance;
    }
    @Override
    public boolean acceptAnOffer(int IDPonude) {
        try(PreparedStatement ps = conn.prepareStatement("insert into OdobrenaPonuda values(?,?,?,?)");
            PreparedStatement ps1 = conn.prepareStatement("select ProcenatCeneIsporuke, KorisnickoIme,Korisnik,Paket from Ponuda where ID=?");
            PreparedStatement ps2 = conn.prepareStatement("update Paket set VremePrihvatanja=?, Cena=?, Status=?, Kurir=? where ID=?");) {
            ps1.setInt(1, IDPonude);
            ResultSet rs  = ps1.executeQuery();
            if(!rs.next()) return false;
            BigDecimal procenat = rs.getBigDecimal(1);
            ps.setBigDecimal(1, procenat);
            String kurir = rs.getString(2);
            ps.setString(2, kurir);
            ps.setString(3, rs.getString(3));
            int idPaketa = rs.getInt(4);
            ps.setInt(4, idPaketa);
            int ret = ps.executeUpdate();
            if(ret != 1) return false;
            ps2.setDate(1, Date.valueOf(LocalDate.now()));
            
            ps2.setBigDecimal(2, cena(idPaketa,procenat));
            ps2.setInt(3,1);
            ps2.setString(4, kurir);
            ps2.setInt(5, idPaketa);
            ret = ps2.executeUpdate();
            return ret == 1;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public List<Integer> getAllOffers() {
         List<Integer> ponude = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Ponuda");) {
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                ponude.add(rs.getInt(1));
            }
            return ponude;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return ponude;
    }

    @Override
    public List<Pair<Integer, BigDecimal>> getAllOffersForPackage(int IDPaketa) {
        List<Pair<Integer, BigDecimal>> ponude = new ArrayList<PackageOperations.Pair<Integer, BigDecimal>>();
        try(PreparedStatement ps = conn.prepareStatement("select ProcenatCeneIsporuke, ID from Ponuda where Paket=?");) {
            ps.setInt(1,IDPaketa);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                md170406_PackageOperationsPair<Integer, BigDecimal> pair =new md170406_PackageOperationsPair();
                pair.setFirstParam(rs.getInt(2));
                pair.setSecondParam(rs.getBigDecimal(1));
                ponude.add(pair);
            }
            return ponude;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return ponude;
    }

    @Override
    public boolean deletePackage(int IDpaketa) {
        try(PreparedStatement ps = conn.prepareStatement("delete from Paket where ID=?");) {
            ps.setInt(1,IDpaketa);
            int ret = ps.executeUpdate();
            return ret == 1;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public boolean changeWeight(int IDpaketa, BigDecimal tezina) {
        try(PreparedStatement ps = conn.prepareStatement("update Paket set Tezina=? where ID=?");) {
            ps.setInt(2,IDpaketa);
            ps.setBigDecimal(1, tezina);
            int ret = ps.executeUpdate();
            return ret == 1;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public boolean changeType(int IDpaketa, int tip) {
        if(tip != 0 && tip != 1 && tip != 2 ) return false;
        try(PreparedStatement ps = conn.prepareStatement("update Paket set Tip=? where ID=?");) {
            ps.setInt(2,IDpaketa);
            ps.setInt(1, tip);
            int ret = ps.executeUpdate();
            return ret == 1;
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    @Override
    public Integer getDeliveryStatus(int IDPaketa) {
        try(PreparedStatement ps = conn.prepareStatement("select Status from Paket where ID=?");) {
            ps.setInt(1,IDPaketa);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                //System.out.println("status delivery " + rs.getInt(1) + " " + IDPaketa);
                return rs.getInt(1);
            }else return null;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public BigDecimal getPriceOfDelivery(int IDPaketa) {
        try(PreparedStatement ps = conn.prepareStatement("select Cena from Paket where ID=?");) {
            ps.setInt(1,IDPaketa);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                if(rs.getBigDecimal(1) == null) return null;
                else return rs.getBigDecimal(1);
            }else return null;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public Date getAcceptanceTime(int IDPaketa) {
        try(PreparedStatement ps = conn.prepareStatement("select VremePrihvatanja from Paket where ID=?");) {
            ps.setInt(1,IDPaketa);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                if(rs.getDate(1) == null) return null;
                else return rs.getDate(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public List<Integer> getAllPackagesWithSpecificType(int tip) {
        List<Integer> paketi = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Paket where Tip=?");) {
            ps.setInt(1,tip);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                paketi.add(rs.getInt(1));
            }
            return paketi;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return paketi;
    }

    @Override
    public List<Integer> getAllPackages() {
        List<Integer> paketi = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Paket");) {
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                paketi.add(rs.getInt(1));
            }
            return paketi;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return paketi;
    }

    @Override
    public List<Integer> getDrive(String kurirKorisnickoIme) {
        List<Integer> paketi = new ArrayList<Integer>();
        try(PreparedStatement ps = conn.prepareStatement("select ID from Paket where Kurir=? and Status=2");) {
            ps.setString(2, kurirKorisnickoIme);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                paketi.add(rs.getInt(1));
            }
            return paketi;
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return paketi;
    }

    @Override
    public int driveNextPackage(String kurirKorisnickoIme) {
        int OpstinaOD = 0, OpstinaDO = 0;
        try(PreparedStatement ps = conn.prepareStatement("select Status from Kurir where KorisnickoIme=?");
            PreparedStatement ps1 = conn.prepareStatement("select ID from Paket where Status=2 and VremePrihvatanja = (Select MIN(VremePrihvatanja) from Paket where Kurir=?)");
            PreparedStatement ps2 = conn.prepareStatement("update Paket set Status=? where Status=? and Kurir=? ");
            PreparedStatement ps3 = conn.prepareStatement("update Kurir set Status=? where KorisnickoIme=? ");
            PreparedStatement ps4 = conn.prepareStatement("insert into Voznja values(?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
            PreparedStatement ps5 = conn.prepareStatement("insert into Sadrzi values(?,?,?)");
            PreparedStatement ps6 = conn.prepareStatement("select OpstinaOD, OpstinaDO from ZahtevZaPrevozom where Paket=?");
            PreparedStatement ps7 = conn.prepareStatement("select ID from Voznja where Kurir=?");
            PreparedStatement ps8 = conn.prepareStatement("select Opstina from Voznja where Kurir=?");
            PreparedStatement ps9 = conn.prepareStatement("update Paket set Status=? where ID=? ");
            PreparedStatement ps10 = conn.prepareStatement("update Kurir set BrIsporucenihPaketa=BrIsporucenihPaketa + 1 where KorisnickoIme=? ");
            PreparedStatement ps11 = conn.prepareStatement("update Voznja set Opstina=? where Kurir=?");) {
            
            // da li postoji kurir
            ps.setString(1,kurirKorisnickoIme);
            ResultSet rs = ps.executeQuery();
            if(!rs.next()) return -2;
            int status = rs.getInt(1);
            // ako je status 0 ( ne vozi ), preuzmi sve pakete sa tipom 1
            if(status == 0){
                //ako nema paketa
                ps2.setInt(1, 2);
                ps2.setInt(2,1);
                ps2.setString(3,kurirKorisnickoIme);
                int ret = ps2.executeUpdate();
                if(ret == 0) return -1;
                //update kurir
                ps3.setInt(1,1);
                ps3.setString(2,kurirKorisnickoIme);
                ps3.executeUpdate();
                //dovati paket pa opstine
                ps1.setString(1,kurirKorisnickoIme);
                ResultSet rs2 = ps1.executeQuery();
                int idPaketa = 0;
                if(rs2.next()) idPaketa = rs2.getInt(1);
                ps6.setInt(1, idPaketa);
                ResultSet rs5 = ps6.executeQuery();
                if(rs5.next()){
                    OpstinaOD = rs5.getInt(1);
                    OpstinaDO = rs5.getInt(2);
                }
                //napravi voznju
                ps4.setString(1, kurirKorisnickoIme);
                ps4.setInt(2,OpstinaDO);
                ps4.executeUpdate();
                ResultSet rs1 = ps4.getGeneratedKeys();
                int idVoznje = 0;
                if(rs1.next()) idVoznje = rs1.getInt(1);
                else return -2;
                //napravi da voznja sadrzi paket
                ps1.setString(1,kurirKorisnickoIme);
                rs2 = ps1.executeQuery();
                idPaketa = 0;
                if(rs2.next()) idPaketa = rs2.getInt(1);
                //ako nema paketa
                else{
                    ps3.setInt(1,0);
                    ps3.setString(2,kurirKorisnickoIme);
                    ps3.executeUpdate();
                    return -1;
                };
                //dodaj u Sadrzi
                ps5.setInt(1, idVoznje);
                ps5.setInt(3, idPaketa);
                ps5.setBigDecimal(2,new BigDecimal(distanca(OpstinaOD,OpstinaDO)));
                ps5.executeUpdate();
                ps11.setInt(1,OpstinaDO);
                ps11.setString(2,kurirKorisnickoIme);
                ps11.executeUpdate();
                ps9.setInt(1, 3);
                ps9.setInt(2,idPaketa);
                ps9.executeUpdate();
                ps10.setString(1,kurirKorisnickoIme);
                ps10.executeUpdate();
                return idPaketa;
            }else{
                //ako vec vozi
                //dohvati paket
                
                ps1.setString(1,kurirKorisnickoIme);
                ResultSet rs2 = ps1.executeQuery();
                int idPaketa = 0;
                if(rs2.next()) idPaketa = rs2.getInt(1);
                else{
                    //ako nema paketa - ne vozi vise
                    ps3.setInt(1,0);
                    ps3.setString(2,kurirKorisnickoIme);
                    ps3.executeUpdate();
                    izracunajProfit(kurirKorisnickoIme);
                    return -1;
                };
                ps6.setInt(1, idPaketa);
                ResultSet rs5 = ps6.executeQuery();
                if(rs5.next()){
                    OpstinaOD = rs5.getInt(1);
                    OpstinaDO = rs5.getInt(2);
                }
                //dodaj u sadrzi
                int idVoznje=0;
                ps7.setString(1,kurirKorisnickoIme);
                ResultSet rs7 = ps7.executeQuery();
                if(rs7.next()) idVoznje = rs7.getInt(1);
                int idTrenutneOpstina=0;
                ps8.setString(1,kurirKorisnickoIme);
                ResultSet rs8 = ps8.executeQuery();
                if(rs8.next()) idTrenutneOpstina = rs8.getInt(1);
                ps5.setInt(1, idVoznje);
                ps5.setInt(3, idPaketa);
                ps5.setBigDecimal(2,new BigDecimal(distanca(idTrenutneOpstina,OpstinaOD) + distanca(OpstinaOD,OpstinaDO)));
                ps5.executeUpdate();
                ps11.setInt(1,OpstinaDO);
                ps11.setString(2,kurirKorisnickoIme);
                ps11.executeUpdate();
                ps9.setInt(1, 3);
                ps9.setInt(2,idPaketa);
                ps9.executeUpdate();
                ps1.setString(1,kurirKorisnickoIme);
                rs2 = ps1.executeQuery();
                ps10.setString(1,kurirKorisnickoIme);
                ps10.executeUpdate();
                if(!rs2.next()) {
                    //ako nema paketa - ne vozi vise
                    ps3.setInt(1,0);
                    ps3.setString(2,kurirKorisnickoIme);
                    ps3.executeUpdate();
                    izracunajProfit(kurirKorisnickoIme);
                };
                return idPaketa;
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    public void izracunajProfit(String kurirKorisnickoIme){
        try(PreparedStatement ps = conn.prepareStatement("select ID from Voznja where Kurir=?");
            PreparedStatement ps1 = conn.prepareStatement("select SUM(Cena) from Paket where ID IN (select Paket from Sadrzi where Voznja=?)");
            PreparedStatement ps2 = conn.prepareStatement("select SUM(Kilometraza) from Sadrzi where Voznja=?");
            PreparedStatement ps3 = conn.prepareStatement("select TipGoriva, Potrosnja from Vozilo where RegistracioniBroj IN (select Vozilo from Kurir where KorisnickoIme=?)");
            PreparedStatement ps4 = conn.prepareStatement("update Kurir set OstvarenProfit=? where KorisnickoIme=? ");
            PreparedStatement ps5 = conn.prepareStatement("delete from Sadrzi where Voznja=?");) {
            int idVoznje=0;
            ps.setString(1,kurirKorisnickoIme);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) idVoznje = rs.getInt(1);
            BigDecimal cena = new BigDecimal(0);
            ps1.setInt(1,idVoznje);
            rs = ps1.executeQuery();
            if(rs.next()) cena = rs.getBigDecimal(1);
            BigDecimal kilometraza = new BigDecimal(0);
            ps2.setInt(1,idVoznje);
            rs = ps2.executeQuery();
            if(rs.next()) kilometraza = rs.getBigDecimal(1);
            int tip = 0;
            BigDecimal potrosnja = new BigDecimal(0);
            ps3.setString(1, kurirKorisnickoIme);
            rs = ps3.executeQuery();
            if(rs.next()){
                tip = rs.getInt(1);
                potrosnja = rs.getBigDecimal(2);
            }
            BigDecimal cenaGoriva = new BigDecimal(0);
            if(tip == 0) cenaGoriva = new BigDecimal(15);
            if(tip == 1) cenaGoriva = new BigDecimal(36);
            if(tip == 2) cenaGoriva = new BigDecimal(32);
            BigDecimal profit  = cena.subtract(potrosnja.multiply(cenaGoriva).multiply(kilometraza));
            ps4.setBigDecimal(1, profit);
            ps4.setString(2,kurirKorisnickoIme);
            ps4.executeUpdate();
            ps5.setInt(1,idVoznje);
            ps5.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(md170406_PackageOperations.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
