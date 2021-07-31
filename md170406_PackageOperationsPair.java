/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sab_projekat;
import java.math.BigDecimal;
import rs.etf.sab.operations.PackageOperations;

/**
 *
 * @author mrsic
 */
public class md170406_PackageOperationsPair<Integer,BigDecimal> implements PackageOperations.Pair {
    Integer firstParam;
    BigDecimal secondParam;
    
    public void setFirstParam(Integer f){ firstParam = f; }
    public void setSecondParam(BigDecimal s){ secondParam = s; }
    
    @Override
    public Object getFirstParam() {
        return firstParam;
    }

    @Override
    public Object getSecondParam() {
        return secondParam;
    }
    
}
