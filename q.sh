echo "mpirun -np $1 $2" > ./tmp.sh
chmod +x ./tmp.sh
qsub -q student -I ./tmp.sh
rm ./tmp.sh
