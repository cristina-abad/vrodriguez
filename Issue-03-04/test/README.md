# Microbenchmark Tests

The application were created used the [JMH framework](http://openjdk.java.net/projects/code-tools/jmh/), these tests is composed of two parts which are testing *Data Distributions* and Testing *Data Statistics* classes.

- **Data Distributions**
  - [JDKRandomGenerator](https://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/random/JDKRandomGenerator.html)
  - [NormalDistribution](http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/distribution/NormalDistribution.html)
  - [ExponentialDistribution](http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/distribution/ExponentialDistribution.html)
  - [EmpiricalDistribution](http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/random/EmpiricalDistribution.html) with few bins (ex:1000)
  - EmpiricalDistribution with large bins (ex:2'000.000)

- **Statistics classes**
  - [SummaryStatistics](http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/stat/descriptive/SummaryStatistics.html)
  - [DescriptiveStatistics](http://commons.apache.org/proper/commons-math/apidocs/org/apache/commons/math3/stat/descriptive/DescriptiveStatistics.html)

For a correct run, this application need two files of empirical distributions: 

1. twoFeatures.321.interarrivals-LargeBinCount
2. twoFeatures.321.interarrivals-SmallBinCount

Or failing that, replace them equivalent to these 2 files and modify those names in  **testEmpiricalDistributionLB** and **testEmpiricalDistributionFB** classes. These files must be in the folder **benchmarks/distributions**.

The units of the results for test *data distributions* this operations / seconds.
The units of the results for test *statistics classes* this seconds / operations.

## Makefile

The Makefile contains 3 tags for the application:
- **clean**: Remove all generated files in a compilation by Maven.
- **compile**: Compile all files and redefined new targets for benchmarks
- **run**: Re-compile all files and run benchmarks

The results of each method will be tested and 2 shown CSV files are generated:
**results.csv** and **statistics_ <time>.csv** where *time* is the total time to run all tests, this last contains the max, min, average and standard desviation of each method evaluated.

## Parameters

The parameters are define in the file [Params.java](https://github.com/cristina-abad/vrodriguez/blob/master/Issue-03-04/test/src/main/java/benchmarks/tests/Params.java) which are described below:

### Data distributions

- **n:** The amount of values of the five data distributions.
- **forks:** The amount of forks of five data distributions in the benchmark
- **warmups:** The amount of warmups for each forks in the five distributions.
- **iterations:** The amount of iterations for each forks of the five data distributions in the benchmark. This operations begin after the warmups.

### Statistics classes

- **forks_std:** The amount of forks of five data distributions in the benchmark
- **warmups_std:** The amount of warmups for each forks in the five distributions.
- **iterations_std:** The amount of iterations for each forks of the five data distributions in the benchmark. This operations begin after the warmups.

**References**
- [Code Tools:JMH](http://openjdk.java.net/projects/code-tools/jmh/)
- [Introction to JMH](http://java-performance.info/jmh/)
- [Java Performance Tuning Guide](http://java-performance.info/introduction-jmh-profilers/)
- [Writing Java Micro Benchmarks with JMH: Juicy](http://psy-lob-saw.blogspot.com/2013/04/writing-java-micro-benchmarks-with-jmh.html)
- [Java Code Examples for org.openjdk.jmh.results.RunResult](http://www.programcreek.com/java-api-examples/index.php?api=org.openjdk.jmh.results.RunResult)

