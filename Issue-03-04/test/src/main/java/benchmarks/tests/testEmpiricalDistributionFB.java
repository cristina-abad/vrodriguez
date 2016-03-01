/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.tests;

import java.util.concurrent.TimeUnit;
import org.apache.commons.math3.random.EmpiricalDistribution;
import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Warmup;

/**
 *
 * @author victor
 */
@BenchmarkMode(Mode.Throughput)
@Fork(Params.forks)
@Warmup(iterations = Params.warmups, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@Measurement(iterations = Params.iterations, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@OutputTimeUnit(TimeUnit.SECONDS)
@State(Scope.Benchmark)

public class testEmpiricalDistributionFB {
    private static int TAM = Params.n;
    private EmpiricalDistribution e;
    private String filename = "twoFeatures.321.interarrivals-SmallBinCount";
    
    public testEmpiricalDistributionFB(){
        readEmpiricalDistributionFromSerializedFile r = new readEmpiricalDistributionFromSerializedFile();
        e = r.readEDFS(Params.rute + filename);
    }
    
    @Setup
    public void setup(){
        readEmpiricalDistributionFromSerializedFile r = new readEmpiricalDistributionFromSerializedFile();
        e = r.readEDFS(Params.rute + filename);
    }
    
    @Benchmark
    public void testSample(){
        e.sample();
    }
    
    public double[] getSet(){
        double[] A = new double[TAM];
        for (int i = 0; i < TAM; i++)
            A[i] = e.sample();
        return A;
    }
}
