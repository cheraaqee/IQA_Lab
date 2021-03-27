The most-frequently used script here, will probably be the 'testing_script.m'.
If you have already satisfied the 'readme.txt's within the folders:
'methods'
'datasets'
, you (probably!) will be able to test a bunch of arbitrary methods on your entire
favorite datasets and obtain an .xls file containing the average and comparison of the
methods on the datasets. (Currently, there is a problem with generating excel files
within Linux. Generally, the codes are tested on Widnows, but most of them should work
for Linux too.)

A LaTeX file will be also generated, 'the_result.tex', it will produce the paper-style table for the methods and datasets. It is successfully compiled on https://overleaf.com .

With `timer_2.m' you can plot the execution time VS accuracy for SCI datasets.

There is also another option. You can plott `scatter plot' for SCID, SIQAD, and QACS. For that purpose refer to 'sctr_batch.m'
