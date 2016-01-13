package benchmarks.issues;

import java.io.IOException;
import org.apache.commons.math3.distribution.ExponentialDistribution;
import org.apache.commons.math3.distribution.NormalDistribution;
import org.apache.commons.math3.random.EmpiricalDistribution;
import org.apache.commons.math3.random.JDKRandomGenerator;
import org.openjdk.jmh.Main;
import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.runner.RunnerException;

/**
 *
 * @author Victor
 */

public class Issue3 {
    
    private static int TAM = 1000000;
    private static String rute = "src/main/java/benchmarks/distributions/";
    
//    public static void main(String... args) throws RunnerException, IOException {
//        Main.main(args);
//    }
    
    //@Benchmark
    public double[] test1(){
        double[] A = new double[TAM];
        JDKRandomGenerator rg = new JDKRandomGenerator();
        
        for (int i = 0; i < TAM; i++)
            A[i] = rg.nextInt();
        
        return A;
    }

    //@Benchmark
    public void test2(){
        // Mean = 0
        // Desviation = 1
        double[] A = new double[TAM];
        NormalDistribution nd = new NormalDistribution(0, 1);
        
        for (int i = 0; i < TAM; i++)
            A[i] = nd.sample();
    }
    
    //@Benchmark
    public void test3(){
        // http://wiki.stat.ucla.edu/socr/index.php/AP_Statistics_Curriculum_2007_Exponential
        double[] A = new double[TAM];
        
        ExponentialDistribution ed = new ExponentialDistribution(2);
        for (int i = 0; i < TAM; i++)
            A[i] = ed.sample();
    }
    
    //@Benchmark
    public void test4(){
        double[] A = new double[TAM];
        readEmpiricalDistributionFromSerializedFile r = new readEmpiricalDistributionFromSerializedFile();
        EmpiricalDistribution e = r.readEDFS(rute + "twoFeatures.321.interarrivals-SmallBinCount");
        for (int i = 0; i < TAM; i++)
            A[i] = e.sample();
    }
    
    //@Benchmark
    public void test5(){
        double[] A = new double[TAM];
        readEmpiricalDistributionFromSerializedFile r = new readEmpiricalDistributionFromSerializedFile();
        EmpiricalDistribution e = r.readEDFS(rute + "twoFeatures.321.interarrivals-LargeBinCount");
        for (int i = 0; i < TAM; i++)
            A[i] = e.sample();
    }
}
