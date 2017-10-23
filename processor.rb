require "uri"
puts "loading procesor"
module Processor
  def Processor.preprocess str
    while str.include? "<rb>"
      beginOccurance=str.index /<rb>/i
      puts "b"+beginOccurance.to_s
      endOccurance=str.index /<\/rb>/i
      puts "e"+endOccurance.to_s
      occurance=str[beginOccurance+4..endOccurance-1]
      puts occurance
      str.sub! /<rb>.+?<\/rb>/im, (eval occurance).to_s
    end
  end

  def Processor.scrub str
    str.gsub! /\#{.+?}/m, ""
    str.gsub! "+", " "
  end

  def Processor.parseGet str
    tmp=Hash.new
    #if more values
    if str[0]=="?"
      str=str[1..str.length]
    end
    if str.include? "&"
      #chop off the ? when beginning
      keyEnd=str.index "="
      key=str[0..keyEnd-1]
      valEnd=str.index "&"
      val=str[keyEnd+1..valEnd-1]
      val=URI.unescape val
      tmp[key.to_sym]=val
      str=str[valEnd+1..str.length]
      puts str
      tmp.merge! parseGet str
    else#last case
      keyEnd=str.index "="
      key=str[0..keyEnd-1]
      val=str[keyEnd+1..str.length]
      val=URI.unescape val
      tmp[key.to_sym]=val
    end
    tmp
  end
end
