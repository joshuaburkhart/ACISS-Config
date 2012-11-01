#

require 'optparse'
options = {}

DEFAULT_OUT_DIR = '.'
MILLION = 1000000
G = 850 * MILLION
CK_TEST_VALS = [20,25,30,35,40]
ID = @unbarcoded

optparse = OptionParser.new { |opts|
    opts.banner = <<-EOS
Usage: ruby param_ests.rb -1 </path/to/input/file/1> -2 </path/to/input/file/2> -o </path/to/output/dir>

Example: ruby param_ests.rb -1 /home13/jburkhar/research/out/kmer_filter_output/sample1.fq -2 /home13/jburkhar/research/out/kmer_filter/output/sample2.fq -o /home13/jburkhar/research/output/stats/
    EOS

    opts.on('-h','--help','Display this screen'){
        puts opts
        exit
    }
    options[:in_file1] = nil
    opts.on('-1','--in_file1','Input File 1'){ |file_name|
        options[:in_file1] = file_name.strip
    }
    options[:in_file2] = nil
    opts.on('-2','--in_file2','Input File 2'){ |file_name|
        options[:in_file2] = file_name.strip
    }
    options[:out_dir] = DEFAULT_OUT_DIR
    opts.on('-o','--out_dir','Output Directory'){ |dir_name|
        options[:out_dir] = dir_name.strip
    }
}
optparse.parse!

file_stats = []

if (!options[:in_file1].nil?)
    file_stats[0] = Thread.new {
        fh1 = File.open(options[:in_file1])
        Thread.current["nbp"] = 0
        Thread.current["n"] = 0
        f1_cached_line = ""
        while f1_cur_line = fh1.gets
            if f1_cached_line.match(/^#{ID}/)
                Thread.current["nbp"] += f1_cur_line.size
                Thread.current["n"] += 1
            end
            f1_cached_line = f1_cur_line
        end
        fh1.close
    }
    if(!options[:in_file2].nil?)
        file_stats[1] = Thread.new {
            fh2 = File.open(options[:in_file2])
            Thread.current["nbp"] = 0
            Thread.current["n"] = 0
            f2_cached_line = ""
            while f2_cur_line = fh2.gets
                if f2_cached_line.match(/^#{ID}/)
                    Thread.current["nbp"] += f2_cur_line.size
                    Thread.current["n"] += 1
                end
                f2_cached_line = f2_cur_line
            end
            fh2.close
        }
    end
    nbp = 0
    n = 0
    file_stats.each { |t|
        t.join
        nbp += t["nbp"]
        n += t["n"]
    }
    l = nbp / n #avg read length
    c = nbp / G #nucleotide coverage
    outh = File.open("estimated_parameters.txt",'w')
    outh.puts "ESTIMATED PARAMETERS FOR:"
    outh.puts "FILE 1: #{options[:in_file1]}"
    outh.puts "FILE 2: #{options[:in_file2]}"
    outh.puts "========================="
    outh.puts
    outh.puts "genome size = #{G}"
    outh.puts "number of reads = #{n}"
    outh.puts "number of base pairs = #{nbp}"
    outh.puts "average read length = #{l}"
    outh.puts "nucleotide coverage = #{c}"
    outh.puts
    CK_TEST_VALS.each { |ck|
        outh.puts "Kmer Coverage #{ck}:"
        k = l + 1 − ((ck * G) / n)
        outh.print "hash length = #{k}"
        if (k < (l / 2))
            outh.print " (smaller than recommended)"
        end
        outh.print "\n"
        #velvet ram use estimation
        outh.print "Estimated RAM = #{(-109635 + 18977 * l + 86326 * (G / MILLION) + 233353 * (n / MILLION) - 51092 * k) / 1048576}"
        outh.puts 
    }
    outh.close
else
    puts "No input file specified. Exiting..."
end
