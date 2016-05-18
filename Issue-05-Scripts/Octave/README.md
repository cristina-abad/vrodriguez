#Packages

- [statistics] (http://octave.sourceforge.net/statistics/)
- [control](http://http://octave.sourceforge.net/signal/)
- [tisean](http://octave.sourceforge.net/tisean/)
- [java](http://octave.sourceforge.net/java/) (This packages is included in the Octave versions >= 3.8.0)

## Installation packages

Method 1: Download packages from website and install
```
$ octave --no-gui
>> pkg install namePackage.tar.gz
>> pkg list
```

Method 2: Install packages from Octave Forge repository
```
$ octave --no-gui
>> pkg install -forge namePackage
>> pkg list
```

Ref: https://www.gnu.org/software/octave/doc/v4.0.1/Installing-and-Removing-Packages.html
