
/*------------------------------------------------------------------------
    File        : dz-gerar-excel.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri
    Created     : Mon Jan 31 09:45:05 BRT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using Progress.Lang.AppError from propath.

{thealth/libs/exportar-excel.i} 

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function exportarCampo returns logical 
    (hd-buffer as handle,
     in-campo as integer) forward.

function gerarRange returns character 
    (in-coluna as integer,
     in-linha  as integer) forward.


/* ***************************  Main Block  *************************** */



/* **********************  Internal Procedures  *********************** */

procedure exportarExcel:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-caminho          as   character          no-undo.
    define input  parameter hd-buffer           as   handle             no-undo.
    
    empty temp-table temp-formato-especial.
    run exportarExcelEspecial (input  ch-caminho, 
                               input  hd-buffer, 
                               input  table temp-formato-especial).     

end procedure.

procedure exportarExcelEspecial:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-caminho          as   character          no-undo.
    define input  parameter hd-buffer           as   handle             no-undo.
    define input  parameter table               for  temp-formato-especial. 

    define variable hd-excel                    as   component-handle   no-undo.
    define variable hd-book                     as   component-handle   no-undo.
    define variable hd-sheet                    as   component-handle   no-undo.
    define variable hd-query                    as   handle             no-undo.
    define variable in-coluna                   as   integer            no-undo.
    define variable in-linha                    as   integer            no-undo.
    define variable in-campo                    as   integer            no-undo.
    define variable ch-range                    as   character          no-undo.
    define variable ch-valor                    as   character          no-undo.
    define variable ch-tipo                     as   character          no-undo.    
    define variable in-max-coluna               as   integer            no-undo.
    define variable lg-possui-registro          as   logical            no-undo.
    
    do on error undo, throw:
        create 'excel.application' hd-excel.
        
        assign hd-book                  = hd-excel:WorkBooks:Add ()
               hd-sheet                 = hd-excel:ActiveSheet
               hd-excel:DisplayAlerts   = no 
               hd-excel:visible         = no
               hd-excel:ScreenUpdating  = no
               in-linha                 = 1
               in-coluna                = 0
               lg-possui-registro       = can-find (first temp-formato-especial)
               .
    
        do in-campo = 1 to hd-buffer:num-fields:
            
            if not exportarCampo (hd-buffer, in-campo)
            then next.
            
            assign in-coluna    = in-coluna + 1
                   ch-range     = gerarRange (in-coluna, in-linha)
                   ch-valor     = codepage-convert (hd-buffer:buffer-field (in-campo):name, 'iso8859-1', session:charset).
                   
            if  hd-buffer:buffer-field (in-campo):label    <> ? 
            and hd-buffer:buffer-field (in-campo):label    <> ''
            and hd-buffer:buffer-field (in-campo):label    <> ch-valor
            then do:
                
                assign ch-valor = codepage-convert (hd-buffer:buffer-field (in-campo):label, 'iso8859-1', session:charset).
            end.                     
                   
            assign hd-excel:Range (ch-range):Value  = ch-valor.                   
        end.
        
        create query hd-query.
        hd-query:set-buffers (hd-buffer).
        hd-query:query-prepare (substitute ('preselect each &1', hd-buffer:name)).
        hd-query:query-open().
    
        repeat:
            
            hd-query:get-next().
            
            if hd-query:query-off-end then leave.    
               
            assign in-linha     = in-linha + 1
                   in-coluna    = 0. 
    
            publish EV_EXPORTAR_EXCEL_LINHA (input  in-linha - 1).               
            
            do in-campo = 1 to hd-buffer:num-fields:
                
                if not exportarCampo (hd-buffer, in-campo)
                then next.
                
                assign in-coluna        = in-coluna + 1
                       ch-range         = gerarRange (in-coluna, in-linha)
                       ch-valor         = codepage-convert (hd-buffer:buffer-field (in-campo):buffer-value,'iso8859-1', session:charset)
                       ch-tipo          = hd-buffer:buffer-field (in-campo):data-type
                       in-max-coluna    = if in-coluna > in-max-coluna  
                                          then in-coluna
                                          else in-max-coluna
                       . 
                       
                if  available temp-formato-especial
                and temp-formato-especial.ch-mascara           <> ?
                and trim (temp-formato-especial.ch-mascara)    <> ''
                then do:
                    
                    case ch-tipo:
                        when 'decimal'
                        then assign ch-valor    = string (decimal (ch-valor), temp-formato-especial.ch-mascara).
                        when 'integer'
                        then assign ch-valor    = string (integer (ch-valor), temp-formato-especial.ch-mascara).
                        when 'logical'
                        then assign ch-valor    = string (logical (ch-valor), temp-formato-especial.ch-mascara).
                        when 'date'
                        then assign ch-valor    = string (date (ch-valor), temp-formato-especial.ch-mascara).
                        when 'datetime'
                        then assign ch-valor    = string (datetime (ch-valor), temp-formato-especial.ch-mascara).
                        otherwise
                             assign ch-valor    = string (ch-valor, temp-formato-especial.ch-mascara).
                    end case.
                      
                    assign hd-excel:Range (ch-range):NumberFormat   = '@'.                 
                end.            
                else do:
                    
                    if ch-tipo  = 'character'
                    then do:
                        
                       assign hd-excel:Range (ch-range):NumberFormat    = '@'.
                    end.
                    if ch-tipo  = 'logical'
                    then do:
                           
                        if ch-valor = 'yes' 
                        or ch-valor = 'no'
                        then do:
                            
                            assign ch-valor = if ch-valor = 'yes' then 'Sim' else 'NÆo'.
                        end.
                    end.
                end.
                assign hd-excel:Range (ch-range):Value  = ch-valor.
            end.
        end.
        
        hd-excel:columns ('A:XX'):AutoFit.            
        
        hd-excel:ActiveWorkbook:saveAs (ch-caminho, 51,,,,,).                                                                                                                        
        
        assign hd-excel:ScreenUpdating  = yes. 
               hd-excel:visible         = yes.     
               
        release object hd-book no-error.           
        release object hd-excel no-error.
        
        catch cs-erro as Progress.Lang.Error:            
            
            undo, throw new AppError (substitute ('Falha ao exportar dados para o Excel: &1', cs-erro:GetMessage(1))).
        end.
    end.
end procedure.

/* ************************  Function Implementations ***************** */

function exportarCampo returns logical 
    (hd-buffer as handle, 
    in-campo as integer  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/    
    find first temp-formato-especial 
         where temp-formato-especial.ch-campo   = hd-buffer:buffer-field (in-campo):name 
               no-error.
    
    if available temp-formato-especial
    then return not temp-formato-especial.lg-ocultar.
    
    return not hd-buffer:buffer-field (in-campo):serialize-hidden.
    
end function.

function gerarRange returns character 
    (in-coluna as integer,
     in-linha  as integer  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/    
    define variable ch-colunas                  as   character          no-undo.
    define variable in-mod                      as   integer            no-undo.
    define variable in-index                    as   integer            no-undo.
    define variable in-total                    as   integer            no-undo.
    define variable ch-range                    as   character          no-undo.
    
    assign ch-colunas   = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
           in-total     = in-coluna - 1
           .
           
    do while in-total  > 25:

        assign ch-range = chr (65 + (in-total mod 26)) + ch-range
               in-total = truncate (in-total / 26, 0) - 1.        
    end.           
    
    assign ch-range = chr (65 + in-total) + ch-range + string (in-linha).
    return ch-range.  
end function.

