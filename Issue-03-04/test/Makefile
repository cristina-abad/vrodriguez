clean:
	mvn clean

compile:
	$(MAKE) clean
	mvn install

run:
	$(MAKE) compile
	java -cp target/benchmarks.jar benchmarks/tests/TestMain