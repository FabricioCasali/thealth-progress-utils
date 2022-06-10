
/*------------------------------------------------------------------------
    File        : dates.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Mon Aug 30 17:58:49 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function converterParaAnoMesDia returns character 
    (dt as date,
     ch-separador as character) forward.

function diasNoMes returns integer 
    (in-ano as integer,
     in-mes as integer) forward.

function idadePorExtenso returns character 
    (input  dt-nasc     as   date,
     input  dt-compara  as   date) forward.

function ultimoDiaMes returns date 
    (in-ano         as   integer,
     in-mes         as   integer) forward.

/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


function converterParaAnoMesDia returns character 
    (dt as date,
     ch-separador as character   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/    
    
    define variable ch-result       as   character  no-undo.
    define variable ch-original     as   character  no-undo.
    
    if dt = ?
    then return ?.
    
    if ch-separador     = ?
    then ch-separador   = ''.
    
    assign ch-original          = session:date-format
           session:date-format  = 'dmy'
           ch-result            = string (dt, '99/99/9999')
           ch-result            = substring (ch-result, 7, 4) + ch-separador + substring (ch-result, 4, 2) + ch-separador + substring (ch-result, 1, 2).
           session:date-format  = ch-original 
           .
           
    return ch-result.
        
end function.

function diasNoMes returns integer 
    (in-ano as integer,
     in-mes as integer  ):
/*------------------------------------------------------------------------------
 Purpose: retorna a quantidade de dias em um determinado mˆs
 Notes:
------------------------------------------------------------------------------*/    

    define variable dt-ini      as   date   no-undo.
    define variable dt-fim      as   date   no-undo.
    
    assign dt-ini   = date (in-mes, 1, in-ano)
           dt-fim   = UltimoDiaMes (in-ano, in-mes).
           
    return interval (dt-fim, dt-ini, "days") + 1. 
end function.

function idadePorExtenso returns character 
    (input  dt-nasc     as   date,
     input  dt-compara  as   date  ):
/*------------------------------------------------------------------------------
 Purpose: retorna a idade no formato "17 anos, 4 meses e 7 dias"
 Notes:
------------------------------------------------------------------------------*/    
    define variable in-ano      as   integer    no-undo.
    define variable in-mes      as   integer    no-undo.
    define variable in-dia      as   integer    no-undo.
    define variable i           as   integer    no-undo.

    assign in-ano   = interval (dt-compara, dt-nasc, 'year')
           in-mes   = interval (dt-compara, dt-nasc, 'month')
           i        = in-ano * 12
           in-mes   = in-mes - i.

    if day (dt-nasc)    < day (dt-compara) 
    then do:
        
        assign in-dia   = day (dt-compara) - day (dt-nasc).
    end.
    else do:
        
        if day (dt-nasc)    > day (dt-compara) 
        then do:
                
            assign in-dia   = DiasNoMes (year (dt-nasc), month(dt-nasc)) - (day (dt-nasc) - 1).
        end.
    end.

    return substitute ("&1 &2, &3 &4 e &5 &6",
                       in-ano,
                       if in-ano = 0 or in-ano >= 2 then 'anos' else 'ano',
                       in-mes, 
                       if in-mes = 0 or in-mes >= 2 then 'meses' else 'mˆs',
                       in-dia,
                       if in-dia = 0 or in-dia >= 2 then 'dias' else 'dia').    
        
end function.

function ultimoDiaMes returns date 
    (in-ano         as   integer,
     in-mes         as   integer  ):
/*------------------------------------------------------------------------------
 Purpose: retorna o ultimo dia do mes corrente
 Notes:
------------------------------------------------------------------------------*/    


    define variable dt-ultimo-dia-mes       as   date       no-undo.
         
    assign dt-ultimo-dia-mes    = date (in-mes, 1, in-ano)
           dt-ultimo-dia-mes    = add-interval (dt-ultimo-dia-mes, 1, "month")
           dt-ultimo-dia-mes    = dt-ultimo-dia-mes - 1.
           
    return dt-ultimo-dia-mes.
        
end function.

