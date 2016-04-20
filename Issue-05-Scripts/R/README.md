## Packages
It requires packages:
- [data.table](https://cran.r-project.org/web/packages/data.table/index.html)
- [getopt](https://cran.r-project.org/web/packages/getopt/index.html) 
- [hash](https://cran.r-project.org/web/packages/hash/index.html)
- [moments](https://cran.r-project.org/web/packages/moments/index.html)

If the packages not found in the CRAN repository, you can read the [steps instructions](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Installing-packages).

Use the following statement in R once downloaded the package.

```
install.packages(<path package.tar.gz>, repos = NULL, type = "source")
```

## Run

```
chmod +x run.sh
./run.sh <tracefile> <clusters>
```
I recommend creating a folder and within that housed the tracefile
