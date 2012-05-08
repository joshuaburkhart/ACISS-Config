#USAGE:
#./rq.sh <job name> <node name> <queue name> <name of file to execute with arguments>
#
#EXAMPLE:
#./rq.sh N-Body un8 fatnodes "/home13/jburkhar/N-Body/mpinbody_no -DT 86548 -T 364 -G 6.67E-12 -f /home13/jburkhar/N-Body/galaxy.dat"
#
#Note: the name of the file to execute and the command line argumenst must be surrounded by quotes ("") so they can be accepted as a single parameter to this script

echo "#!/bin/bash -l
#PBS -N ${1:-'jburkhart_default_jobname'}
#PBS -o /home13/jburkhar/research/out/queue_output/
#PBS -e /home13/jburkhar/research/out/queue_output/
#PBS -d /home13/jburkhar/research/out/queue_output/
#PBS -l nodes=${2:-'un8'}
#PBS -q ${3:-'fatnodes'}

# Load any modules needed to run your software
module load stacks
module load velvet

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
$4 " > ~/tmp_pbs.sh
qsub -q ${3:-'fatnodes'} ~/tmp_pbs.sh
rm ~/tmp_pbs.sh
