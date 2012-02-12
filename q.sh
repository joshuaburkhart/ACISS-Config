#USAGE:
#./q.sh <number of procs> <name of file to execute with arguments>
#
#EXAMPLE:
#./q.sh 10 "/home13/jburkhar/N-Body/mpinbody_no -DT 86548 -T 364 -G 6.67E-12 -f /home13/jburkhar/N-Body/galaxy.dat"
#
#Note: the name of the file to execute and the command line argumenst must be surrounded by quotes ("") so they can be accepted as a single parameter to this script

echo "#!/bin/bash -l
#PBS -N CIS_555_N-Body
#PBS -o /home13/jburkhar/queue_output/
#PBS -e /home13/jburkhar/queue_output/
#PBS -d /home13/jburkhar/queue_output/
#PBS -q student
#PBS -l nodes=8:ppn=12

# Load any modules needed to run your software
module load mpi-tor/openmpi-1.5.4_pgi-11.9

# the following lines are not required, but can be useful 
# for debugging purposes:
#diplays PBS work directory
#echo "PBS_O_WORKDIR:" $PBS_O_WORKDIR
#cd $PBS_O_WORKDIR

#displays nodefile and contents of nodefile, useful for running MPI
#echo "PBS_NODEFILE:" $PBS_NODEFILE
#cat $PBS_NODEFILE > hostfile.tmp

#displays PBS jobname and jobid
#echo "PBS_JOBNAME, PBS_JOBID:" $PBS_JOBNAME $PBS_JOBID

#displays username and hostname, 
#export USER_NAME=`whoami`
#export HOST_NAME=`hostname -s`
#echo "Hello from $USER_NAME at $HOST_NAME"

#make sure we are running the MPI version we want:
#which mpirun

# execute program here:
#  -np = number of cpus to use
mpirun -np $1 $2" > ~/tmp_pbs.sh
qsub -q student ~/tmp_pbs.sh
rm ~/tmp_pbs.sh
