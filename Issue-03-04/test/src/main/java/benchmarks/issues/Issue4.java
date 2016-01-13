/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.issues;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;
import org.apache.commons.math3.stat.descriptive.SummaryStatistics;
import org.openjdk.jmh.Main;
import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.runner.RunnerException;
/**
 *
 * @author Victor
 */

@BenchmarkMode(Mode.All)
@Warmup(iterations = 3, time = 1, timeUnit = TimeUnit.SECONDS )
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@Fork(1)
//@Threads( 2 )
@State(Scope.Benchmark)
public class Issue4 {
    // 4 Hilos 
    // Memoria - con GC o Profiling pero sin Benchmark
    private double[] values;
    
    @Setup
    public void setup(){
        Issue3 i = new Issue3();
        values = i.test1();
    }
    
    @Benchmark
    public void SummaryS(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: values)
            ss.addValue(v);
        
        //System.out.println(ss.toString());
    }
    
    public void DescriptiveS(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: values)
            ds.addValue(v);
        
        //System.out.println(ds.toString());
    }
    
    public static void main(String... args) throws RunnerException, IOException {
        Main.main(args);
        //Issue4 i = new Issue4();
        //i.setup();
        //i.SummaryS();
        //i.DescriptiveS();
    }
}
