require "socket"
require "yaml"

load "loadConfig.rb"

if $config[:dbtype]=="silly"
  load "db.rb"
elsif $config[:dbtype]=="mongo"
  load "mdb.rb"
end

load "processor.rb"
load "js.rb"

webserver=TCPServer.new($config[:ip], $config[:port])

def getTheGet filename
  get=Hash.new
  if filename.include? "?"
    getBegin=filename.index"?"
    getEnd=filename.length
    getstr=filename.slice! getBegin..getEnd
    Processor::scrub getstr
    get=Processor::parseGet getstr
  end
  get
end

def getFilename session
  request=$session.gets
  puts "request"+request
  
  trimmedrequest=request.gsub(/GET\ \//, "").gsub(/\ HTTP.*/, "")
  filename=trimmedrequest.chomp
  puts filename
  
  $get=getTheGet filename
  puts "get=> "+$get.to_s
  
  
  if filename==""
    filename+=$config[:homepage]
  end
  puts "requested: "+filename
  filename
end

def handle404 session, config
  puts "file not found sending 404"
  if $config[:noFileCondition]=="phrase"
    $session.print $config[:noFile]
  elsif $config[:noFileCondition]=="page"
    $session.print File.read $config[:noFile]
  else
    raise "invalid config: \":404condition: "+$config[:noFileCondition]+"\""
  end
end


serverThread=Thread.new do
  while ($session = webserver.accept)
    begin
      puts "connection"
      $session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

      #get filename
      filename=getFilename $session
      #send file
      scriptFilename=$config[:root]+"/"+filename+".rb"
      htmlFilename=$config[:root]+"/"+filename+".html"
      staticFilename=$config[:static]+"/"+filename
      puts staticFilename
      if File.exists? scriptFilename
        puts "running script "+scriptFilename
        load scriptFilename
      elsif File.exists? htmlFilename
        puts "sending html file "+htmlFilename
        displayfile=File.open(htmlFilename, 'r')
        content=displayfile.read()
        $session.print content
      elsif File.exists? staticFilename
        puts "sending static resorce "+staticFilename
        displayfile=File.open(staticFilename, 'r')
        content=displayfile.read()
        $session.print content
      else
        handle404 $session, $config
      end
    rescue => e
      puts e.backtrace
      $session.print $config[:serverError]
    end
    $session.close
  end
end
serverThread.abort_on_exception=true

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
