local oCursor
nSeconds=seconds()
USE h:\o-negocios\aromas\data\ccbtbdoc
oCursor = cur2obj( 'ccbtbdoc' )   &&call to storing function (Amend cursor name accordingly)

public oBo  &&In order to keep result datasession active in your VFP session
oBo=createobject('TestBo')
oBo.consume_data(oCursor)   


****** Test Session (private)
define class TestBo as session

    procedure init
        set deleted on
        this.open_tables()

    procedure open_tables
        *
        *

    procedure consume_data
        lparameters oCursor
        =obj2cur( oCursor ,'CursorOnTarget')    && call to restoring function

        wait wind 'Passed ' + str(oCursor.NumberOfRecords)  + ' records in '  +;
         str( seconds() -  nSeconds, 10,3) + ' seconds'
        browse normal

enddefine


************************************************************************
*  Store Cursor to object.
*  In fact, Creates Parser object and tells him to
*  suck in cursor and then returns it all back to caller.
*  Accepts 3 parameters for source alias , 'for' and 'while' conditions
************************************************************************
function cur2obj
    lparameters cAlias,cForCondition,cWhileCondition
    local oTable,sv_alias

    sv_alias=alias()
    select (cAlias)

    oTable=createobject('table_parser')
    oTable.cur2obj(cAlias,cForCondition,cWhileCondition)

    select (sv_alias)
    return oTable



******************************
*  Restore Cursor from object
******************************
function obj2cur
    lparameters oTable,cAlias

    create cursor &cAlias from array oTable.arrstru

    if oTable.NumberOfRecords = 0
        return
    endif

    append from array oTable.arrdata

    if oTable.MemoCount=0
        go top
        return
    endif

    local nMemoRec, cMemoName, cMemoContent , i , j
    j=0
    for i=1 to oTable.FieldsCount
        if oTable.arrstru(i,2) = 'M'
            j = j + 1
            cMemoName = cAlias+'.' + oTable.arrstru(i,1)
            replace &cMemoName with oTable.arrmemo(recno(),j) all
        endif
    next

    go top
    return

***********************************
* Custom Object used as
* cursor carrier
***********************************
define class table_parser as custom
    OriginalAlias=''
    NumberOfRecords=0
    MemoCount=0
    FieldsCount=0

    declare arrstru(1)
    declare arrdata(1)
    declare arrmemo(1)


    procedure cur2obj
        lparameters cAlias,cForCondition,cWhileCondition
        local lcArrStru,sv_rec

        select (cAlias)
        go top

        this.OriginalAlias = cAlias
        declare lcArrStru(1)

        =afields(lcArrStru)
        acopy(lcArrStru,this.arrstru)

        this.MemoCount = this.count_memo_fields()

        if eof()
            this.NumberOfRecords=0
            return
        endif

        if type('cForCondition') <> 'C'
            cForCondition = ' .t. '
        endif

        if type('cWhileCondition') <> 'C'
            cWhileCondition = ' .t. '
        endif

        create cursor tmpCursor  from array this.arrstru
        select (cAlias)
        scan  for &cForCondition while &cWhileCondition
            scatter memvar memo
            insert into tmpCursor from memvar
        endscan

        select tmpCursor
        go top

        if eof()
            use
            return
        endif
        this.NumberOfRecords=reccount()

        if this.MemoCount > 0

            local i,j,cMemoName,nMemoRec
            declare this.arrmemo( this.NumberOfRecords , this.MemoCount )

            scan
                nMemoRec=recno()
                j=0
                for i=1 to alen(lcArrStru,1)
                    if lcArrStru(i,2) = 'M'
                        cMemoName = 'tmpCursor.' + lcArrStru(i,1)
                        j = j + 1
                        this.arrmemo(nMemoRec,j)= &cMemoName
                    endif
                next
            endscan

        endif

        declare this.arrdata(this.NumberOfRecords, this.FieldsCount )
        copy to array this.arrdata
        use



    procedure count_memo_fields
        this.FieldsCount=alen(this.arrstru,1)

        local i,j
        j=0
        for i=1 to alen(this.arrstru,1)
            if this.arrstru(i,2) = 'M'
                j=j+1
            endif
        next
        return j




enddefine
********************************