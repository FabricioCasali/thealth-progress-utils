/*------------------------------------------------------------------------
    File        : configurar-browse-eventos.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Sep 02 15:49:35 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable hd-browse-{&browse} as   handle     no-undo.
define variable hd-browse-internal  as   handle     no-undo.
define variable ch-query-default-{&browse} 
                                    as   character  no-undo.

define temp-table temp-bch-{&browse} no-undo 
    field hd-column                 as   handle.
    
assign hd-browse-internal = browse {&browse}:handle.    

run thealth/libs/configurar-browse.p persistent set hd-browse-{&browse} (input  browse     {&browse}:handle,
                                                                         input  temp-table {&temp}:handle,
                                                                         input  "{&titulo}").

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */



/* **********************  Internal Procedures  *********************** */

procedure alterarCorLinha{&browse} private:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter in-color        as   integer        no-undo.

    define variable qh                      as   widget-handle  no-undo.
    
    for each temp-bch-{&browse}: 
        
        if valid-handle (temp-bch-{&browse}.hd-column)
        then do:
            assign temp-bch-{&browse}.hd-column:bgcolor = in-color no-error.
        end.
    end.    

end procedure.

procedure carregarConfiguracao{&browse} private:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    run carregarConfiguracaoBrowse in hd-browse-{&browse} (input  {&jsonConfig}).
    run preparar{&browse}.

end procedure.

procedure preparar{&browse} private:
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/
    define variable hd-column as handle no-undo.
    define variable in-index as integer no-undo.
    
    empty temp-table temp-bch-{&browse}.
    
    do in-index = 1 to hd-browse-internal:num-columns:
        
        assign hd-column    = hd-browse-internal:get-browse-column (in-index) no-error.
        
        if error-status:error
        then leave. 
        
        if not valid-handle (hd-column) 
        then leave.
        
        create temp-bch-{&browse}.
        assign temp-bch-{&browse}.hd-column = hd-column.
    end.
end procedure.

procedure registrarQueryDefault{&browse}:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter  ch-query   as   character  no-undo.
    
    run registrarQueryDefault in hd-browse-{&browse} (input  ch-query).
end procedure.

on mouse-menu-click of {&browse} anywhere 
do:
    
    run filtrarColunas in hd-browse-{&browse}.
end. 

on start-search of {&browse} anywhere  
do:
    
    run ordernarColuna in hd-browse-{&browse} .
end. 

on choose of {&config} anywhere
do:
    
    run mostrarConfiguracaoColunas in hd-browse-{&browse}.
    run gerarJsonConfiguracaoBrowse in hd-browse-{&browse} (output {&jsonConfig}).
    run preparar{&browse}.
end.

on choose of {&limpar} anywhere
do: 
    
    run limparFiltros in hd-browse-{&browse}. 
end.
 

on value-changed of {&modo} anywhere
do:
    if {&modo}:screen-value = '1'
    then do:
        
        assign browse {&browse}:column-movable          = false
               browse {&browse}:column-resizable        = false
               browse {&browse}:allow-column-searching  = true.                        
    end.              
    else do:          
        assign browse {&browse}:column-movable          = true
               browse {&browse}:column-resizable        = true
               browse {&browse}:allow-column-searching  = false.                        
    end.
end.

on choose of {&pesquisar} anywhere 
do:
    run deletarObjetos in hd-browse-{&browse}.
    run {&procedPesquisa}.
    run reiniciarDados in hd-browse-{&browse}.
    run gerarJsonConfiguracaoBrowse in hd-browse-{&browse} (output {&jsonConfig}).
end.

on end-move of {&browse} anywhere
do:
    
    run gerarJsonConfiguracaoBrowse in hd-browse-{&browse} (output {&jsonConfig}).
    run preparar{&browse}.    
end.

on end-resize of {&browse} anywhere
do:
    
    run gerarJsonConfiguracaoBrowse in hd-browse-{&browse} (output {&jsonConfig}).
    run preparar{&browse}.    
end.


apply 'value-changed' to {&modo}.