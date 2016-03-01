/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.tests;

import java.util.concurrent.TimeUnit;
import org.apache.commons.math3.random.JDKRandomGenerator;
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


@BenchmarkMode(Mode.Throughput)
@Fork(Params.forks)
@Warmup(iterations = Params.warmups, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@Measurement(iterations = Params.iterations, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@OutputTimeUnit(TimeUnit.SECONDS)
@State(Scope.Benchmark)

public class testJDKRandomGenerator {
    
    private static int TAM = Params.n;
    private JDKRandomGenerator rg;
    
    public testJDKRandomGenerator(){
        rg = new JDKRandomGenerator();
    }
    
    @Setup
    public void setup(){
        rg = new JDKRandomGenerator();
    }
    
    @Benchmark
    public void testSample(){
        rg.nextDouble();
    }
    
    public double[] getSet(){
        double[] A = new double[TAM];
        for (int i = 0; i < TAM; i++) 
            A[i] = rg.nextDouble();
        return A;
    }
}