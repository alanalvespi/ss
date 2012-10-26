class Meta
  # Simple object to hold tests...
  attr_accessor :columns
  
  def self.all()
    
  end  
  
  def self._makeHash(t,fkeys,comments)
      h = {}
      cno = 1
      t.each() do |c|
        cname = c.name
        edit  = true
        edit = false if (c.primary)
        edit = false if (c.name == 'created_at')
        edit = false if (c.name == 'updated_at')
        fk = fkeys[cname]      
        colname = comments[cno - 1]
        if (colname[0] == '#') then
          colname = colname[1..-1]
          display = '#'
        else
          display = ' '
        end
        col = {"name"     => c.name,
               "sql_type" => c.sql_type, 
               "is_null"  => c.null,
               "limit"    => c.limit.nil? ? 0 : c.limit,
               "precision"=> c.precision,
               "scale"    => c.scale,
               "type"     => "#{c.type}",
               "default"  => c.default,
               "primary"  => c.primary,
               "coder"    => c.coder,
               "collation"=> c.collation,
               "col"      => c.name,
               'cno'      => cno,
               'edit'     => edit,
               'col_name' => colname,
               'display'  => display
             }
             if (fk) then
               col['constraint_name']        = fk['constraint_name']
               col['referenced_table_name']  = fk['referenced_table_name']
               col['referenced_column_name'] = fk['referenced_column_name']
               col['referenced_class']       = fk['referenced_class']
             else
               col['constraint_name']        = ''
               col['referenced_table_name']  = ''
               col['referenced_column_name'] = ''
               col['referenced_class']       = ''
             end
          cno = cno + 1      
          case col['type']
          when 'integer'
            col['asType'] = 'int'
            #col[cname] = 0 if col[cname].nil?
            
          when 'date'
            col['asType'] ='Date'
            
          when 'datetime'
            col['asType'] ='Date'
            
          when 'decimal'
            col['asType'] ='Number'
            
          else
            col['asType'] ='String'
            
          end
         h[cname] = col
      end
      return h
      
  end
  
  def self.find(tname) 
    
    tplural = tname.pluralize
    fkeyArray = ActiveRecord::Base.connection.execute("select column_name, constraint_name, referenced_table_name, referenced_column_name from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where CONSTRAINT_SCHEMA = 'sentrysystem' and Table_name = '#{tplural}'")
    fkeys= {}
    fkeyArray.each do |fkey|
      asClass = fkey[2]
      asClass = asClass.singularize.capitalize if asClass 
      fkeys[fkey[0]] = {'column_name'=>fkey[0],'constraint_name'=>fkey[1],'referenced_table_name'=>fkey[2],'referenced_column_name'=>fkey[3],'referenced_class'=>asClass}
    end
    
    comments = ActiveRecord::Base.connection.select_values("select column_comment from INFORmation_Schema.columns where table_schema = 'sentrysystem' and table_name = '#{tplural}' order by ordinal_position")
    c = Kernel.const_get(tname)
    t = _makeHash(c.columns,fkeys,comments)
    return t
  end
  
end
  