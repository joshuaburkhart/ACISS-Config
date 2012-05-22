module load mpi-tor/openmpi-1.5.4_gcc-4.5.3
alias q='~/bin/q.sh'
alias r='~/bin/r.sh'
alias rq='~/research/bin/rq.sh'
alias qmon='watch "qstat -n | grep jburkhar"'
alias m='module load jacket/64-bit && module load matlab && matlab -nodisplay'
alias i='qsub -I -X -l nodes=12 -q gpu'
alias pll='git pull origin master'
alias psh='git push origin master'
alias gav='git commit -av'
function csv {
  cat $1 | tr '\n' ' ' | tr -s ' ' | tr ' ' ',' && echo ''
}
