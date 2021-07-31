
import rs.etf.sab.operations.CityOperations;
import rs.etf.sab.operations.CourierOperations;
import rs.etf.sab.operations.CourierRequestOperation;
import rs.etf.sab.operations.DistrictOperations;
import rs.etf.sab.operations.GeneralOperations;
import rs.etf.sab.operations.PackageOperations;
import rs.etf.sab.operations.UserOperations;
import rs.etf.sab.operations.VehicleOperations;
import rs.etf.sab.tests.TestHandler;
import rs.etf.sab.tests.TestRunner;
import sab_projekat.md170406_CityOperations;
import sab_projekat.md170406_CourierOperations;
import sab_projekat.md170406_CourierRequestOperation;
import sab_projekat.md170406_DistrictOperations;
import sab_projekat.md170406_GeneralOperations;
import sab_projekat.md170406_PackageOperations;
import sab_projekat.md170406_UserOperations;
import sab_projekat.md170406_VehicleOperations;


public class StudentMain {

    public static void main(String[] args) {
        CityOperations cityOperations = new md170406_CityOperations(); // Change this to your implementation.
        DistrictOperations districtOperations = new md170406_DistrictOperations(); // Do it for all classes.
        CourierOperations courierOperations = new md170406_CourierOperations(); // e.g. = new MyDistrictOperations();
        CourierRequestOperation courierRequestOperation = new md170406_CourierRequestOperation();
        GeneralOperations generalOperations = new md170406_GeneralOperations();
        UserOperations userOperations = new md170406_UserOperations();
        VehicleOperations vehicleOperations = new md170406_VehicleOperations();
        PackageOperations packageOperations = new md170406_PackageOperations();

        TestHandler.createInstance(
                cityOperations,
                courierOperations,
                courierRequestOperation,
                districtOperations,
                generalOperations,
                userOperations,
                vehicleOperations,
                packageOperations);
        
       

        TestRunner.runTests();
    }
}
