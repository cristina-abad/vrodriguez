package benchmarks.tests;


import java.io.*;
import org.apache.commons.math3.random.EmpiricalDistribution;

public class readEmpiricalDistributionFromSerializedFile {

    public EmpiricalDistribution readEDFS(String filename) {
        // EmpiricalDistribution empiricalDistribution = null;
        EmpiricalDistribution empiricalDistribution = null;

        //DeSerializar Objeto:
        try {
            InputStream file = new FileInputStream(filename);
            InputStream buffer = new BufferedInputStream(file);
            ObjectInput input = new ObjectInputStream(buffer);
            try {
                empiricalDistribution = (EmpiricalDistribution) input.readObject();
                //showResults(filename, empiricalDistribution);
            } finally {
                input.close();
            }
        } catch (Exception e) {
            System.out.println("Error, couldn't load the empirical distribution:" + e.getMessage());
        }
        
        return empiricalDistribution;
    }
    
    public void showResults(String filename, EmpiricalDistribution e){
        System.out.println("===========================");
        System.out.println("File: " + filename);
        System.out.println("Empirical Distribution loaded. Bins: " + e.getBinCount());
        System.out.println(e.getSampleStats().toString());
    }
    
}
