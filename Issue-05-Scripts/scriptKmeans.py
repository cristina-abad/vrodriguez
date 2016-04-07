#!/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Sun Sep  6 23:14:11 2015

@author: eboza
"""
import sys, getopt, numpy
from sklearn.feature_selection import VarianceThreshold
from sklearn.cluster import KMeans
from sklearn.preprocessing import scale
from sklearn.decomposition import PCA    

def main(argv):
    ### Put the arguments in variables.
    datasetFile = ''
    clusters = 500
    try:
        opts, args = getopt.getopt(argv,"hf:k:",["datasetFile=","clusters="])
    except getopt.GetoptError:
        print 'scriptKmeans.py -f <datasetFile> -k <clusters>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'scriptKmeans.py -f <datasetFile> -k <clusters>'
            sys.exit()
        elif opt in ("-f", "--datasetFile"):
            datasetFile = arg
        elif opt in ("-k", "--clusters"):
            clusters = int(arg)
    if datasetFile == '':
        print 'ERROR: Must specify a trace filename.'
        print 'scriptKmeans.py -f <datasetFile> -k <clusters>'
        sys.exit(1)

    ### Load dataset from file passed as argument. Without the ID column.    
    dataset = numpy.loadtxt(datasetFile, delimiter=" ", skiprows=1, usecols=range(1,12))
    ### X = dataset[:,1:]
    X = dataset
    ###X_scaled = scale(X, axis=0, with_mean=False, with_std=False, copy=True)
    X_scaled = scale(X, axis=0, with_mean=True, with_std=True, copy=True)
    print "========================================\n"
    print 'Scaled Dataset Shape:'
    print(X_scaled.shape)

    ### Set similar variance for all dimensionality reduction methods:
    ### This could be read from arguments
    variance = 0.9
    
    ### Apply Variance Threshold
    selector = VarianceThreshold(threshold=variance)
    X_varianceThreshold = selector.fit_transform(X)
    print "========================================\n"
    print "Variance Threshold:\n"
    print "Shape after VarianceThreshold:" + str(X_varianceThreshold.shape) + "\n"
    print "Variance of each feature:" + str(selector.variances_) + "\n\n"

    ### Apply PCA
    pca = PCA(n_components=variance, copy=True, whiten=False)
    X_scaled_PCA = pca.fit_transform(X_scaled)
    print "========================================\n"
    print "PCA:\n"
    print "Shape after PCA:" + str(X_scaled_PCA.shape) + "\n"
    print "Variance Ratio:" + str(pca.explained_variance_ratio_) + "\n\n"

    ### K-Means with the Scaled Dataset - k=<clusters> 500 by default
    print "========================================\n"
    print "K-means only with Scaled Dataset:\n"
    ###kmeans_allFeatures = KMeans(init='k-means++', n_clusters=500, n_init=10)
    kmeans_allFeatures = KMeans(init='k-means++', n_clusters=clusters, n_init=10)
    Z_allFeatures = kmeans_allFeatures.fit_predict(X_scaled)
    numpy.savetxt(datasetFile + "_clustered-Z_allFeatures.csv", Z_allFeatures, delimiter=",", fmt="%d", header="Cluster_id", comments="")
    numpy.savetxt(datasetFile + "_clusters_centers-Z_allFeatures.csv", kmeans_allFeatures.cluster_centers_, delimiter=",")

    ### K-Means with VarianceThreshold - k=500 per elbow test
    print "========================================\n"
    print "K-means with VarianceThreshold:\n"
    if X_scaled.shape == X_varianceThreshold.shape:
        print "VarianceThreshold didn't remove any feature."
    else:
        ###kmeans_varianceThreshold = KMeans(init='k-means++', n_clusters=500, n_init=10)
        kmeans_varianceThreshold = KMeans(init='k-means++', n_clusters=clusters, n_init=10)
        Z_varianceThreshold = kmeans_varianceThreshold.fit_predict(X_varianceThreshold)
        numpy.savetxt(datasetFile + "_clustered-Z_varianceThreshold.csv", Z_varianceThreshold, delimiter=",", fmt="%d", header="Cluster_id", comments="")
        numpy.savetxt(datasetFile + "_clusters_centers-Z_varianceThreshold.csv", kmeans_varianceThreshold.cluster_centers_, delimiter=",")

    ### K-Means with PCA - k=<clusters> 500 by default
    print "========================================\n"
    print "K-means with PCA:\n"
    ###kmeans_withPCA = KMeans(init='k-means++', n_clusters=500, n_init=10)
    kmeans_withPCA = KMeans(init='k-means++', n_clusters=clusters, n_init=10)
    Z_withPCA = kmeans_withPCA.fit_predict(X_scaled_PCA)
    numpy.savetxt(datasetFile + "_clustered-Z_withPCA.csv", Z_withPCA, delimiter=",", fmt="%d", header="Cluster_id", comments="")
    numpy.savetxt(datasetFile + "_clusters_centers-Z_withPCA.csv", kmeans_withPCA.cluster_centers_, delimiter=",")

    ### K-Means 2 Features Skewness and AverageInterarrival (mean) - k=<clusters> 500 by default
    ### id mean median mid-range gmean std iqr range mad coeficiente_variacion skewness kurtosis
    print "========================================\n"
    print "K-means with 2 Features: Skewness and AverageInterarrival:\n"
    ###kmeans_twoFeatures = KMeans(init='k-means++', n_clusters=500, n_init=10)
    kmeans_twoFeatures = KMeans(init='k-means++', n_clusters=clusters, n_init=10)
    Z_twoFeatures = kmeans_twoFeatures.fit_predict(X_scaled[:,[0,9]])
    numpy.savetxt(datasetFile + "_clustered-Z_twoFeatures.csv", Z_twoFeatures, delimiter=",", fmt="%d", header="Cluster_id", comments="")
    numpy.savetxt(datasetFile + "_clusters_centers-Z_twoFeatures.csv", kmeans_twoFeatures.cluster_centers_, delimiter=",")
 
if __name__ == "__main__":
   main(sys.argv[1:])

