# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$HOME/software_projects/RadiQual:$HOME/software_projects/BoreKit:$HOME/software_projects/bio

export PATH
. ~/.profile
