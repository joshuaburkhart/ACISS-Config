export VIMRUNTIME='~/.vim/'

module load mpi-tor/openmpi-1.5.4_gcc-4.5.3 Quake samtools bowtie

alias q='~/bin/q.sh'
alias r='~/bin/r.sh'
alias rq='~/research/bin/rq.sh'
alias rsh='/home13/jburkhar/tmp/netkit-rsh-0.17/rsh'
alias m='module load jacket/64-bit && module load matlab && matlab -nodisplay'
alias i='qsub -I -X -l nodes=1:ppn=6 -q generic'
alias pll='git pull origin master'
alias psh='git push origin master'
alias gav='git commit -av'
alias wy='cd /home11/mmiller/Wyeomyia'
alias qmon='watch "qstat -n | grep jburkhar | tr -s [:blank:] | sort -r -k10"'
alias qlog='qlog.sh'
ls --color=auto > /dev/null

R=/home13/jburkhar/research
Y=/home11/mmiller/Wyeomyia

function csv {
  cat $1 | tr '\n' ' ' | tr -s ' ' | tr ' ' ',' && echo ''
}
