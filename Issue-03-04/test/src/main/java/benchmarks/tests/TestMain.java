/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package benchmarks.tests;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Collection;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.results.RunResult;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;
import org.openjdk.jmh.util.Statistics;

/**
 *
 * @author victor
 */

public class TestMain {
    
    private static final String DELIMITER = ",";
    private static final String NEW_LINE = "\n";
    
    public static void main(String... args) throws RunnerException, IOException {
        Date d1 = new Date();
        Options opt = new OptionsBuilder()
                    .result("results.csv")
                    .resultFormat(ResultFormatType.CSV)
                    .build();
        Collection<RunResult> runResult = new Runner(opt).run();
        
        String time = getTime(d1, new Date());
        System.out.println("All benchmarks time: " + time);
        generateCSV_results(runResult, time);
    }
        
    private static void generateCSV_results(Collection<RunResult> runResult, String time){
        FileWriter fileWriter = null;
        try {
            String filename = "statistics_"+time+".csv";
            fileWriter = new FileWriter(filename);
            fileWriter.append("method,avg,min,max,sd,units" + NEW_LINE);
            String line = "";
            for (RunResult r : runResult) {
                line = "";
                System.out.println(r.getPrimaryResult().getLabel());
                System.out.println(r.getPrimaryResult().extendedInfo());
                Statistics s = r.getPrimaryResult().getStatistics();
                
                //Add in the CSV file
                line += r.getParams().getBenchmark() + DELIMITER;
                line += s.getMean() + DELIMITER;
                line += s.getMin() + DELIMITER;
                line += s.getMax() + DELIMITER;
                line += s.getStandardDeviation() + DELIMITER;
		line += r.getPrimaryResult().getScoreUnit() + NEW_LINE;
                fileWriter.append(line);
            }
            System.out.println("Generate results.csv successfully");
            System.out.println("Generate "+filename+" successfully");
        } catch (IOException ex) {
            Logger.getLogger(TestMain.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            try {
                fileWriter.flush();
                fileWriter.close();
            } catch (IOException ex) {
                Logger.getLogger(TestMain.class.getName()).log(Level.SEVERE, null, ex);
            }
        }       
    }
     
    private static String getTime(Date start, Date end){
        long millis = end.getTime() - start.getTime();
        long second = (millis / 1000) % 60;
        long minute = (millis / (1000 * 60)) % 60;
        long hour = (millis / (1000 * 60 * 60)) % 24;

        return String.format("%d:%02d:%02d:%03d", hour, minute, second, millis);
    }
            
}