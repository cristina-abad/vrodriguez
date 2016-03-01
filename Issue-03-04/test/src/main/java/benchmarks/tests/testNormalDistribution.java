/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.tests;

import java.util.concurrent.TimeUnit;
import org.apache.commons.math3.distribution.NormalDistribution;
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

public class testNormalDistribution {
    private static int TAM = Params.n;
    private NormalDistribution nd;
    
    public testNormalDistribution(){
        // Mean = 0
        // Desviation = 1
        nd = new NormalDistribution(0, 1);
    }
    
    @Setup
    public void setup(){
        // Mean = 0
        // Desviation = 1
        nd = new NormalDistribution(0, 1);
    }
    
    @Benchmark
    public void testSample(){
        nd.sample();
    }
    
    public double[] getSet(){
        double[] A = new double[TAM];
        for (int i = 0; i < TAM; i++) 
            A[i] = nd.sample();
        return A;
    }
}
