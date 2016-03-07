import sys
import os

if __name__ == '__main__':
    args = sys.argv
    if len(args) not in [2,3]:
        print 'amount of parameters: 2'
        print 'usage: generate_sdf.py <inputfile> <delimiter>'
        exit(0)
    else:
        if len(args) == 2:
            args.append(' ')
        FNAME = sys.argv[1]
        delimiter = args[2]
        f = open(FNAME, 'r')
        if os.path.isfile(FNAME):
            s = 0
            for line in f:
                s += int(line.split(delimiter)[1])
            c = 0
            f.close()
            f = open(FNAME, 'r')
            for line in f:
                line = line.replace('\n','')
                p = int(line.split(delimiter)[1]) / (s * 1.0)
                c += p
                print '%s %f %f' %(line, p, c)

        else:
            print 'No such file or directory'