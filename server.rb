require "socket"
require "yaml"

def loadyaml filename
  yaml=File.read filename
  YAML.load yaml
end

$config=loadyaml "config.yaml"

if $config[:dbtype]=="silly"
  load "db.rb"
elsif $config[:dbtype]=="mongo"
  load "mdb.rb"
end

load "processor.rb"
load "js.rb"

webserver=TCPServer.new($config[:ip], $config[:port])



serverThread=Thread.new do
  while ($session = webserver.accept)
    puts "connection"
    $session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

    #get filename
    request=$session.gets
    #if filename=="favicon.ico"
      #$session.close
    #end
    begin
      puts "request"+request
    rescue
      puts "request"+request
      puts "no request"
      $session.close
    end
    trimmedrequest=request.gsub(/GET\ \//, "").gsub(/\ HTTP.*/, "")
    filename=trimmedrequest.chomp
    puts filename

    #process get forums
    $get=Hash.new
    if filename.include? "?"
      getBegin=filename.index"?"
      getEnd=filename.length
      getstr=filename.slice! getBegin..getEnd
      Processor::scrub getstr
      $get=Processor::parseGet getstr
    end
    puts "get=> "+$get.to_s


    if filename=="" or /.\//.match filename
      filename+=$config[:homepage]
    end
    puts "requested: "+filename

    if filename!="favicon.ico"
      #send file
      begin
        scriptFilename=filename.insert 0, $config[:root]+"/"
        scriptFilename=scriptFilename.dup.chop.chop.chop.chop+"rb"
        puts "running script "+scriptFilename
        load scriptFilename
      rescue
        puts "no run script sending static file"
        begin
          displayfile=File.open(filename, 'r')
          content=displayfile.read()
          $session.print content
        rescue
          puts "file not found sending 404"
          if $config[:noFileCondition]=="phrase"
            $session.print $config[:noFile]
          elsif $config[:noFileCondition]=="page"
            $session.print File.read $config[:noFile]
          else
            raise "invalid config: \":404condition: "+$config[:noFileCondition]+"\""
          end
        end
      end
    end
    $session.close
  end
end
serverThread.abort_on_exception=false

def view viewName
  content=File.read $config[:root]+"/"+viewName
  Processor::preprocess content
  Js::append content
  $session.print content
end

#command loop
puts "now exepting commands"
while true
  input=gets.chomp
  if input=="c" or input=="close"
    puts "slosing down server"
    serverThread.exit
    if $config[:dbtype]=="silly"
      puts "saving db"
      File.delete $dbFile
      db=File.new $dbFile, "w"
      db.write $dbHash.to_yaml
    elsif $config[:dbtype]=="mongo"
      $client.close
    end
    break
  end
end
