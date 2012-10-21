#!/usr/bin/ruby

#Usage: ruby rad_aligner.rb </path/to/fasta/file/with/rad/tags> </path/to/fasta/file/with/contigs/1> [ ... </path/to/fasta/file/with/contigs/n>]

#Example: ruby rad_aligner.rb /home13/jburkhar/tmp/mock_rad_tags.fasta /home13/jburkhar/tmp/mock_contigs.fasta

require 'time'

class AssemblyScore
	attr_accessor :name
	attr_accessor :aligned_cut_sites
	attr_accessor :aligned_rad_tags
	attr_accessor :cut_output
	attr_accessor :rad_output
	attr_accessor :rad_mismatches
	def initialize(name)
		@name = name
	end
	def setCutResult(cut_output)
		@cut_output = cut_output
		@cut_output.match(/d (\d+) a/)
		@aligned_cut_sites = Integer($1)
	end
	def setRadResult(rad_output)
		@rad_output = rad_output
		@rad_output.match(/t:\s+(\d+)\s+\(/)
		@aligned_rad_tags = Integer($1)
		@rad_mismatches = @rad_output.count(MISMATCH_CHAR)
	end
	def getActOvrExpAlignments
		if (@aligned_rad_tags != 0)
			return (1000.0 * @aligned_rad_tags) / (2000.0 * @aligned_cut_sites)
		else
			return "NO CUT SITES ALIGNED TO REFERENCE"
		end
	end
	def to_s
		"FILE NAME: #{@name}\nNUMBER OF CUT SITES ALIGNED: #{@aligned_cut_sites}\nNUMBER OF RAD TAGS ALIGNED: #{@aligned_rad_tags}\nRAD SNP MISMATCHES: #{@rad_mismatches}\nACTUAL / EXPECTED: #{getActOvrExpAlignments}\n"
	end
	def to_f
		self.to_s +
			"BOWTIE CUT SITE OUTPUT:\n--\n#{@cut_output}--\nBOWTIE RAD TAG OUTPUT:\n--\n#{@rad_output}--\n"
	end
end

##########
# DRIVER #
##########

rad_fasta_file = ARGV[0]
assembly_scores = Array.new
MISMATCH_CHAR = ">"
BEST = "--best"
ROUT = "--refout"

for i in 1..(ARGV.length - 1)
	assembly_scores << AssemblyScore.new(ARGV[i])
end

#bowtie args
n = 3
l = 5

rad_tags = File.open(rad_fasta_file)
rad_fasta_line = rad_tags.gets
cut_seq = ""
while(rad_fasta_line)
	if(!rad_fasta_line.match(/^>/))
		if(cut_seq == "")
			cut_seq = rad_fasta_line[0,5]
		else
			tmp_seq = rad_fasta_line[0,5]
			if(tmp_seq != "" && tmp_seq != cut_seq)
				rad_tags.close
				puts "RAD TAGS DO NOT HAVE MATCHING CUT SITE SEQUENCES: #{tmp_seq} != #{cut_seq}"
				exit 1
			end
		end
	end
	rad_fasta_line = rad_tags.gets
end

rad_tags.close

assembly_scores.each { |a|
	contigs_fa_file = a.name
	bowtie_idx_name = Time.new.to_f.to_s.sub('.','_')
	sleep(1)
	%x(bowtie-build #{contigs_fa_file} #{bowtie_idx_name})
	a.setCutResult(%x(bowtie -a -n0 -l#{l} -c #{bowtie_idx_name} #{cut_seq} 2>&1))
	a.setRadResult(%x(bowtie #{bowtie_idx_name} -n#{n} -l#{l} #{BEST} -f #{rad_fasta_file} 2>&1))
}

assembly_scores.sort { |i,j| i.getActOvrExpAlignments <=> j.getActOvrExpAlignments }

summary_file = File.open('assembly_score_summaries.txt','w')
summary_file.print "ASSEMBLY SCORE SUMMARIES\n"
summary_file.print "========================\n\n"
summary_file.puts
assembly_scores.each { |a|
	puts
	puts a.to_s
	puts
	summary_file.print a.to_f
	summary_file.puts
}
summary_file.close
