/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.tests;

import java.util.concurrent.TimeUnit;
import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;
import org.apache.commons.math3.stat.descriptive.SummaryStatistics;
import org.openjdk.jmh.annotations.*;
/**
 *
 * @author Victor
 */

@BenchmarkMode(Mode.AverageTime)
@Fork(Params.forks_std)
@Warmup(iterations = Params.warmups_std, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@Measurement(iterations = Params.iterations_std, time = 1, timeUnit = TimeUnit.NANOSECONDS)
@OutputTimeUnit(TimeUnit.SECONDS)
@State(Scope.Benchmark)

public class testStatistics {
    // 4 Hilos 
    // Memoria - con GC o Profiling pero sin Benchmark
    private double[] jdkRandomGenerator;
    private double[] normalDistribution;
    private double[] exponentialDistribution;
    private double[] empiricalDistributionFB;
    private double[] empiricalDistributionLB;
    
    @Setup
    public void setup(){
        jdkRandomGenerator      = new testJDKRandomGenerator().getSet();
        normalDistribution      = new testNormalDistribution().getSet();
        exponentialDistribution = new testExponentialDistribution().getSet();
        empiricalDistributionFB = new testEmpiricalDistributionFB().getSet();
        empiricalDistributionLB = new testEmpiricalDistributionLB().getSet();
    }
    
    // All test in Summary Statistics
    
    @Benchmark
    public void SummaryS_jdkRandomGenerator(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: jdkRandomGenerator)
            ss.addValue(v);
        
        ss.toString();
    }
    
    @Benchmark
    public void SummaryS_normalDistribution(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: normalDistribution)
            ss.addValue(v);
        
        ss.toString();
    }
    
    @Benchmark
    public void SummaryS_exponentialDistribution(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: exponentialDistribution)
            ss.addValue(v);
        
        ss.toString();
    }
    
    @Benchmark
    public void SummaryS_empiricalDistributionFB(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: empiricalDistributionFB)
            ss.addValue(v);
        
        ss.toString();
    }
    
    @Benchmark
    public void SummaryS_empiricalDistributionLB(){
        SummaryStatistics ss = new SummaryStatistics();
        for (double v: empiricalDistributionLB)
            ss.addValue(v);
        
        ss.toString();
    }
    
    // All test in Descriptive Statistics
    
    @Benchmark
    public void DescriptiveS_jdkRandomGenerator(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: jdkRandomGenerator)
            ds.addValue(v);
        
        ds.toString();
    }
    
    @Benchmark
    public void DescriptiveS_normalDistribution(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: normalDistribution)
            ds.addValue(v);
        
        ds.toString();
    }
    
    @Benchmark
    public void DescriptiveS_exponentialDistribution(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: exponentialDistribution)
            ds.addValue(v);
        
        ds.toString();
    }
    
    @Benchmark
    public void DescriptiveS_empiricalDistributionFB(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: empiricalDistributionFB)
            ds.addValue(v);
        
        ds.toString();
    }
    
    @Benchmark
    public void DescriptiveS_empiricalDistributionLB(){
        DescriptiveStatistics ds = new DescriptiveStatistics();
        
        for (double v: empiricalDistributionLB)
            ds.addValue(v);
        
        ds.toString();
    }
}