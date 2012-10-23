class Meta
  # Simple object to hold tests...
  attr_accessor :columns
  
  def self.all()
    
  end  
  
  def self._makeHash(t)
      h = {}
      cno = 1
      t.each() do |c|
        cname = c.name
        edit  = true
        edit = false if (c.primary)
        edit = false if (c.name == 'created_at')
        edit = false if (c.name == 'updated_at')
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
                 'edit'     => edit
                }
          cno = cno + 1      
          case col['type']
          when 'integer'
            col['asType'] = 'int'
            #col[cname] = 0 if col[cname].nil?
            
          when 'date'
            col['asType'] ='Date'
            
          when 'datetime'
            col['asType'] ='Date'
            
          else
            col['asType'] ='String'
            
          end
         h[cname] = col
      end
      return h
      
  end
  
  def self.find(tname) 
    c = Kernel.const_get(tname)
    t = _makeHash(c.columns)
    return t
  end
  
end
  