#/bin/sh

Usage="./run_covar.sh <output file>"

if [ $# -ne 1 ]; then
    echo $Usage
    exit 1
fi   

bn="../datamining/covariance/covariance_time"

BENCH="
    ../datamining/covariance/covariance_time_data
    ../datamining/covariance/covariance_time_symmat
    ../datamining/covariance/covariance_time_mean
"
### Run all fast ###
echo "All fast" >> $1
numactl --cpunodebind=0 --membind=0 ../utilities/time_benchmark.sh $bn 2>>$1

### Run placement ###
for b in $BENCH
do
    echo $b >> $1
    numactl --cpunodebind=0 --membind=0 ../utilities/time_benchmark.sh $b 2>>$1
done

### Run all slow ###
echo "All slow" >> $1
numactl --cpunodebind=0 --membind=1 ../utilities/time_benchmark.sh $bn 2>>$1
