*!*	dbf2sql.prg
*!*	Yes, it works with memo fields.
*!*	Creates tablename.sql file from any open and selected table 
*!*	and fills it with sql create table ... and insert ... commands 
*!*	for each record. You might want to prepend this commands with 
*!*	drop table ... command using any txt editor.
*!*	Just open table, select it and run this program. You should
*!*	find (tablename).sql file in prg directory.
*!*	
*!*	I am using phpMyAdmin. Entering location of (tablename).sql into 
*!*	'Location of the textfile' and executing it, I can update
*!* MySQL	database users table on local or remote server.
*!*	You can also use "mysql ... < (tablename).sql" command from
*!*	command line.
*!*	
*!*	When working on SQL table notice that on Unix case matters.
*!*	Table and fields names are uppercase.
*!*	There are some restrictions
*!*	- Only C,N,D,M and L types of fields are supported
*!*	- There also can be some problems with escaping characters in your data.
*!*	
*!*	Program is written in MS Visual FoxPro 6.0 and works fine
*!*	for me. It should also work fine for any older dbf file version
*!*	foxpro 6.0 can read. 
*!*	
*!*	If you have problems DON'T PANIC. 
*!*		See www.j-sistem.hr/online/dev/index.htm - maybe there is 
*!*			improved version
*!*		Improve code and send it back to me, and I shall make it 
*!*			available for download
*!*	  Complain to me. Maybe I have been there.
*!*	    Danko Josic
*!*	    dj@j.sistem.hr
*!*	    www.j.sistem.hr
*!*	
*!* You are free to use this code and modify it in any way you
*!*	see fit.
*!*	
*!*	Legal:
*!*	I can not be held responsible for any damage to your data or 
*!*	peace of mind or anything else that can come out as result of 
*!*	using this code.   
*!*	
*!*	
*!*	If you improve this code please send it back to me and I shall 
*!*	publish it on www.j-sistem.hr/online/dev/index.htm
*!***********************************************************************	

	clear 
	set talk off
	* Sat date format you are using
*	set date to german
	m.dbftable_stem = lower(alias())
	m.lnFHandle = FCREATE(m.dbftable_stem+'.sql')
	* command 'create table' with 'IF NOT EXISTS' option
*	m.SQLCOMMAND = 'CREATE TABLE IF NOT EXISTS '+	m.dbftable_stem+' ('+fld_setup()+');'
	* or without
	m.SQLCOMMAND = 'CREATE TABLE '+	m.dbftable_stem+' ('+fld_setup()+');'
	* Verbose? Uncomment next line.
*	? m.SQLCOMMAND
	=FWRITE( m.lnFHandle, m.SQLCOMMAND+CHR(13))
	m.nrec = reccount()
	scan
		*	Uncomment if you would like to have field names in insert command
*		m.SQLCOMMAND = "insert into "+m.dbftable_stem+"("+fld_names()+") "+"values ("+fld_content()+")"
		* I am using without field names for mysql and it works fine
		m.SQLCOMMAND = "insert into "+m.dbftable_stem+" values ("+fld_content()+");"
		* Verbose? Uncomment next line.
*		? m.SQLCOMMAND
		=FWRITE( m.lnFHandle, m.SQLCOMMAND+CHR(13))
		* count records backwards
		? m.nrec
		m.nrec = m.nrec - 1
	endscan
	=FCLOSE( m.lnFHandle)  
	modi comm (m.dbftable_stem+'.sql')
return

*----------------------------------------------------------------------------
* Reads record data, modifying "'" to "`" and ',' to '.' in numeric fields
* This function is a good place to escape characters, add some field definitions etc...
*----------------------------------------------------------------------------
function fld_content
private lcret, nn, lnFieldcount, ladbf
	dimension ladbf(1)
	m.lnFieldcount = AFIELDS(ladbf)  && Create array
	m.maxflds = m.lnFieldcount
	m.lcret = ''
	FOR m.nn = 1 TO m.maxflds
		m.fld = eval(ladbf(m.nn,1))
	   	do case
			case ladbf(m.nn,2)='C'
				m.c = "'"+chrtran(alltrim(m.fld),"'","`")+"'"
			case ladbf(m.nn,2)='N'
				m.c = chrtran(padr(m.fld,ladbf(m.nn,3)),',','.')
			case ladbf(m.nn,2)='D'
				m.c = '"'+dtos(m.fld)+'"'
			case ladbf(m.nn,2)='M'
				m.c = "'"+chrtran(alltrim(m.fld),"'","`")+"'"
			case ladbf(m.nn,2)='L'
				m.c = iif( m.fld,'1','0')
			otherwise:	   	
				m.c = '***'	&& we have problem
	   	endcase
		m.lcret = m.lcret + m.c
	   	if m.nn < m.maxflds
	   		m.lcret = m.lcret + ','
	   	endif
	next
return alltrim(m.lcret)	

*----------------------------------------------------------------------------
* Returns field names of selected table
*----------------------------------------------------------------------------
function fld_names
private lcret, nn, lnFieldcount, ladbf
	dimension ladbf(1)
	m.lnFieldcount = AFIELDS(ladbf)  && Create array
	m.maxflds = m.lnFieldcount
	m.lcret = ''
	FOR m.nn = 1 TO m.maxflds
		m.lcret = m.lcret+ladbf(m.nn,1)
	   	if m.nn < m.maxflds
	   		m.lcret = m.lcret + ','
	   	endif
	next
return m.lcret	

*----------------------------------------------------------------------------
function fld_setup
private lcret, nn, lnFieldcount, ladbf
	dimension ladbf(1)
	m.lnFieldcount = AFIELDS(ladbf)  && Create array
	m.maxflds = m.lnFieldcount
	m.lcret = ''
	FOR m.nn = 1 TO m.maxflds
			* Verbose? Uncomment next line.
*	   	? padr(ladbf(m.nn,1),20),ladbf(m.nn,2),ladbf(m.nn,3),ladbf(m.nn,4)
	   	m.lcret = m.lcret+ladbf(m.nn,1)+' '
	   	do case
			case ladbf(m.nn,2)='C'
				m.lcret = m.lcret +'char'+'('+padr(ladbf(m.nn,3),3)+')'	
			case ladbf(m.nn,2)='N'
				if empty(ladbf(m.nn,4))
					m.lcret = m.lcret +'int'+'('+padr(ladbf(m.nn,3),3)+')'	
				else
					m.lcret = m.lcret +'float'+'('+padr(ladbf(m.nn,3),3)+','+padr(ladbf(m.nn,4),2)+')'
				endif
			case ladbf(m.nn,2)='D'
				m.lcret = m.lcret +'date'	
			case ladbf(m.nn,2)='M'
				m.lcret = m.lcret +'text'	
			case ladbf(m.nn,2)='L'
				m.lcret = m.lcret +'char (1)'	
			otherwise:	   	
				m.lcret = m.lcret +'***'	&& Field type not recognized - we have problem
	   	endcase
	   	if m.nn < m.maxflds
	   		m.lcret = m.lcret + ','
	   	endif
	next
return m.lcret	
