#this file shows the worst aspect of ruby: overloading
$dbFile=$config[:db]

#getter dbHash, table, coulumn, row or dbHash, array
def getDB *args
  if args.size!=2 and args.size!=4
    raise "invaled number of parameters"+args.size.to_s
  elsif args.size==4#non array
    tmp=args[0][args[1].to_sym][args[2].to_sym][args[3].to_sym]
  elsif args.size==2#array
    tmp=args[0][args[1][0].to_sym][args[1][1].to_sym][args[1][2].to_sym]
  end
  tmp
end

#setter dbHash, table, column, row, value or dbHash, array, value
def setDB *args
  if args.size!=3 and args.size!=5
    raise "invaled number of parameters"+args.size.to_s
  elsif args.size==5
    args[0][args[1].to_sym][args[2].to_sym][args[3].to_sym]=args[4]
  elsif args.size==3
    args[0][args[1][0].to_sym][args[1][1].to_sym][args[1][2].to_sym]=args[2]
  end
end

#adders
def addDBrow dbHash, table, row
  dbHash[table.to_sym].each do |column|
    column[1][row.to_sym]=nil
  end
end

def addDBcol dbHash, table, column
  if !dbHash[table.to_sym].key? column
    contents=dbHash[table.to_sym][:default].dup
    if $config[:auto_increment_id]
      setDB dbHash, table.to_sym, :default, :id, (contents[:id]+1)
    end
    dbHash[table.to_sym][column.to_sym]=contents
  end
end

#removers
def remDBrow dbHash, table, row
  dbHash[table.to_sym].each do |column|
    column[1].delete row.to_sym
  end
end

def remDBcol dbHash, table, column
  if dbHash[table.to_sym].key? column
    if $config[:auto_increment_id]
      setDB dbHash, table.to_sym, :default, :id, (getDB $dbHash, table, :default, :id)-1
    end
    dbHash[table.to_sym].delete column.to_sym
  end
end

$dbHash=loadyaml $dbFile
