
/*------------------------------------------------------------------------
    File        : dzconfigurarbrowse.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Sep 02 07:38:54 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.
 
define variable hd-filtro                   as   handle     no-undo.
define variable hd-frame                    as   handle     no-undo.
define variable hd-fechar                   as   handle     no-undo.
define variable hd-texto                    as   handle     no-undo.
define variable in-tamanho-coluna           as   integer    no-undo.
define variable in-tamanho-atual            as   integer    no-undo.
define variable ch-nome-coluna-filtro       as   character  no-undo.
define variable ch-datatype-coluna-filtro   as   character  no-undo.
define variable ch-query-sem-order          as   character  no-undo.
define variable lg-where                    as   logical    no-undo.
define variable in-registros                as   integer    no-undo.
define variable in-filtrados                as   integer    no-undo.
define variable ch-query-default            as   character  no-undo.

define temp-table temp-browse-info          no-undo         serialize-name 'browse'
    field ch-nome                           as   character  serialize-name 'nome'
    .
 
define temp-table temp-browse-coluna        no-undo         serialize-name "colunas"
    field rc-browse-info                    as   recid      serialize-hidden
    field ch-nome                           as   character  serialize-name 'n'
    field dc-width                          as   decimal    serialize-name 'l'
    field in-posicao                        as   integer    serialize-name 'o'
    field lg-visivel                        as   logical    serialize-name 'v' 
    index idx1
          as primary
          ch-nome
    . 

define dataset ds-layout
    serialize-name "layout" 
    for temp-browse-info,
        temp-browse-coluna
    parent-id-relation r1 for temp-browse-info, temp-browse-coluna        
        parent-id-field rc-browse-info     
    .   

define input  parameter hd-browse-handle    as   handle     no-undo.
define input  parameter hd-tabela-handle    as   handle     no-undo.
define input  parameter ch-titulo           as   character  no-undo.



/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */

 

/* **********************  Internal Procedures  *********************** */

procedure atualizarFiltro private:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable ch-query as character no-undo. 

    run montarQuery (output ch-query).                                     
    
    hd-browse-handle:query:query-prepare (ch-query). 
    hd-browse-handle:query:query-open ().
    hd-browse-handle:clear-sort-arrows ().
    
    assign in-filtrados = hd-browse-handle:query:num-results.
    
    run atualizarTitulo.
end procedure.

procedure atualizarTitulo:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable ch-quantidade as character no-undo.
    
    if in-filtrados = in-registros
    then do:
        
        assign ch-quantidade = string (in-registros).
    end.
    else do:
        
        assign ch-quantidade = substitute ("&1 de &2",
                                           in-filtrados, 
                                           in-registros).
    end.
    
    assign hd-browse-handle:frame:title = substitute ("&1 (&2)",
                                                      ch-titulo,
                                                      ch-quantidade).
    
end procedure.

procedure carregarConfiguracaoBrowse:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter lo-json         as   longchar   no-undo.
    
    define variable hd-coluna               as   handle     no-undo.
    define variable in-conta                as   integer    no-undo.
    
    dataset ds-layout:empty-dataset ().
    log-manager:write-message (substitute ("acomp -> cleber: &1", string (lo-json)), 'DEBUG') no-error.
    dataset ds-layout:read-json ('longchar', lo-json) no-error.
    
    if error-status:error 
    then return.
    
    find first temp-browse-info
               no-error.
               
    if not available temp-browse-info 
    then return.
    
    
    assign hd-coluna    = hd-browse-handle:first-column
           in-conta     = 1.
        
    for each temp-browse-coluna 
          by temp-browse-coluna.in-posicao:
    
        hd-coluna   = hd-browse-handle:first-column.
        in-conta    = 1.
        
        do while valid-handle (hd-coluna):
            
            if hd-coluna:name = temp-browse-coluna.ch-nome
            then do:
                
                hd-browse-handle:move-column (in-conta, temp-browse-coluna.in-posicao).
                hd-coluna:width-chars   = temp-browse-coluna.dc-width.
                hd-coluna:visible       = temp-browse-coluna.lg-visivel.
                leave.
            end.
            hd-coluna = hd-coluna:next-column.
            in-conta = in-conta + 1.
        end.
    end.

end procedure.

procedure deletarObjetos :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    delete object hd-filtro no-error.
    delete object hd-frame no-error.
    delete object hd-fechar no-error.
    delete object hd-texto no-error.
end procedure.

procedure fecharFrame private:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    if valid-handle (hd-frame)
    then hd-frame:visible   = no.
 
end procedure.

procedure filtrarColunas:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable in-frame-largura        as   integer    no-undo.
    define variable in-frame-altura         as   integer    no-undo.
    define variable in-x-coluna             as   integer    no-undo.
    define variable i                       as   integer    no-undo.
            
    // se o clique não foi no header da coluna            
    if last-event:y > 20 
    then return.
    
    assign in-frame-largura = 250
           in-frame-altura  = 46
           in-x-coluna      = self:first-column:x.
           
    do i = 1 to self:num-columns:
        
        if  last-event:x > in-x-coluna
        and last-event:x < in-x-coluna + hd-browse-handle:get-browse-column (i):width-pixels
        then do:
            
            // caso o frame exista e esteja ativo, destroi e limpa as informa‡äes
            if valid-handle (hd-filtro)
            then do:
                
                run deletarObjetos.
                
                assign ch-nome-coluna-filtro        = ''
                       ch-datatype-coluna-filtro    = ''.
            end.
            
            // guarda a ultima coluna que foi acionada o filtro
            assign ch-nome-coluna-filtro        = hd-browse-handle:get-browse-column (i):name 
                   ch-datatype-coluna-filtro    = hd-browse-handle:get-browse-column (i):data-type.
                   
            
            define variable ch-formato      as   character no-undo.
            
            assign ch-formato   = "x(100)".
            if ch-datatype-coluna-filtro    = 'INTEGER'
            then do:
                
                assign ch-formato   = replace (hd-browse-handle:get-browse-column (i):format, ">", "9").    
                                
            end.                     
            
            // cria o frame com o botao, text e input
            create frame  hd-frame
                   assign frame             = hd-browse-handle:frame
                          x                 = round (((hd-browse-handle:x + hd-browse-handle:width-pixels)) / 2, 0) - round (in-frame-largura / 2, 0)
                          y                 = round (((hd-browse-handle:y + hd-browse-handle:height-pixels)) / 2, 0) - round (in-frame-altura / 2, 0)
                          height-pixels     = in-frame-altura
                          width-pixels      = in-frame-largura  
                          visible           = yes
                          sensitive         = yes.
                   
                        
            create fill-in hd-filtro
                   assign  frame            = hd-frame
                           x                = 1
                           y                = 23
                           height-pixels    = 20 
                           width-pixels     = in-frame-largura - 4
                           visible          = yes
                           sensitive        = yes
                           font             = 4
                           format           = ch-formato
                           triggers:
                               on value-changed persistent run atualizarFiltro in this-procedure.
                           end.
                   .

            create button hd-fechar
                   assign flat-button       = yes
                          frame             = hd-frame
                          x                 = in-frame-largura - 25
                          y                 = 1
                          height-pixels     = 23
                          width-pixels      = 23
                          visible           = yes
                          sensitive         = yes
                          triggers:
                              on choose persistent run fecharFrame in this-procedure.
                          end
                   .
                   
            hd-fechar:load-image ("thealth/assets/cancel_18_18.jpg").

            create text   hd-texto
                   assign frame             = hd-frame
                          x                 = 1
                          y                 = 1
                          height-pixels     = 18
                          width-pixels      = in-frame-largura - 26
                          visible           = yes
                          format            = 'x(200)'
                          screen-value      = hd-browse-handle:get-browse-column (i):label
                          font              = 4
                       .
                       
            apply 'entry' to hd-filtro.                       
            return no-apply.
        end.         
        in-x-coluna = in-x-coluna + hd-browse-handle:get-browse-column (i):width-pixels.
    end.    
    

        

end procedure.

procedure gerarJsonConfiguracaoBrowse:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define output parameter lo-json         as   longchar   no-undo.
    
    define variable hd-coluna               as   handle     no-undo.
    define variable in-conta                as   integer    no-undo.
    
    dataset ds-layout:empty-dataset ().
         
    create temp-browse-info.
    assign temp-browse-info.ch-nome = hd-browse-handle:name.
    
    assign hd-coluna    = hd-browse-handle:first-column
           in-conta     = 1.
    
    do while valid-handle (hd-coluna):
        
        create temp-browse-coluna.
        assign temp-browse-coluna.ch-nome           = hd-coluna:name
               temp-browse-coluna.in-posicao        = in-conta
               temp-browse-coluna.rc-browse-info    = recid (temp-browse-info)
               temp-browse-coluna.dc-width          = hd-coluna:width-chars
               temp-browse-coluna.lg-visivel        = hd-coluna:visible
               .
        
        assign hd-coluna    = hd-coluna:next-column
               in-conta     = in-conta + 1.
    end.
    
    dataset ds-layout:write-json ('longchar', lo-json, no).

end procedure.

procedure limparFiltros:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    assign ch-nome-coluna-filtro        = ''
           ch-datatype-coluna-filtro    = ''.
    
    run atualizarFiltro.
    run fecharFrame.
    
end procedure.


procedure montarQuery private:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define output parameter ch-query as character no-undo.

    define variable ch-coluna-filtro   as   character  no-undo.
    define variable ch-valor-filtro    as   character  no-undo.
    define variable ch-query-coluna as character no-undo.

    if  ch-query-default   <> ?
    and ch-query-default   <> ''
    then do:
        
        log-manager:write-message (substitute ("index (ch-query-default, 'where'): &1", index (ch-query-default, 'where')), "DEBUG") no-error.
        
        assign ch-query     = ch-query-default
               lg-where     = (index (ch-query-default, 'where') > 0)
               .                       
    end.
    else do:
        
        assign ch-query     = substitute ('preselect each &1',
                                          hd-tabela-handle:name)
               lg-where     = no
               .                       
    end.


    if ch-nome-coluna-filtro   <> ''
    then do:
        
        assign ch-coluna-filtro = substitute ("&1.&2", 
                                              hd-tabela-handle:name,
                                              ch-nome-coluna-filtro)
               ch-valor-filtro  = substitute ("'*&1*'",
                                              trim (hd-filtro:screen-value))
               lg-where         = yes
               .
        
        if ch-datatype-coluna-filtro  = 'DATE'
        then do:
            
            assign ch-coluna-filtro = substitute ("string (&1.&2, '99/99/9999')", 
                                                  hd-tabela-handle:name, 
                                                  ch-nome-coluna-filtro). 
        end.
        
        if ch-datatype-coluna-filtro  = 'DATETIME'
        then do:
            
            assign ch-coluna-filtro = substitute ("string (&1.&2, '99/99/9999 hh:mm:ss')", 
                                                  hd-tabela-handle:name, 
                                                  ch-nome-coluna-filtro). 
        end.
    
        if ch-datatype-coluna-filtro  = 'INTEGER'
        or ch-datatype-coluna-filtro  = 'DECIMAL'
        then do:
            
            assign ch-coluna-filtro = substitute ("string (&1.&2)", 
                                                  hd-tabela-handle:name, 
                                                  ch-nome-coluna-filtro). 
        end.    
            
        assign ch-query = substitute ("&1 &4 &2 matches (&3)",
                                  ch-query,
                                  ch-coluna-filtro,
                                  ch-valor-filtro,
                                  if lg-where then 'and' else 'where').
    end.    
    
    assign ch-query-sem-order = ch-query.

end procedure.

procedure mostrarConfiguracaoColunas:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    run thealth/libs/configurar-browse-modal.w (input  hd-browse-handle,
                                                input  hd-tabela-handle).   
end procedure.

procedure ordernarColuna:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    if hd-browse-handle:query:is-open
    then hd-browse-handle:query:query-close ().
    
    define variable ch-sort     as   character  no-undo.
    define variable in-indice                   as   integer        no-undo.
    
    // encontra o indice da coluna que foi clicada
    do in-indice = 1 to hd-browse-handle:num-columns:
        
        if hd-browse-handle:get-browse-column (in-indice) = hd-browse-handle:current-column
        then do:
            leave.  
        end.
    end.
    
    if hd-browse-handle:current-column:sort-ascending   = ?
    or hd-browse-handle:current-column:sort-ascending   = no
    then do:
        
        assign ch-sort  = "".
    end.
    else do:
        assign ch-sort  = "DESC".
    end.
    
    if ch-query-sem-order   = ''
    or ch-query-sem-order   = ?
    then do:
        
        run montarQuery (output ch-query-sem-order).
        assign in-filtrados = 0.
    end.
    
    hd-browse-handle:clear-sort-arrows ().
    hd-browse-handle:set-sort-arrow (in-indice, (ch-sort = '')).
    hd-browse-handle:query:query-prepare (substitute ("&1 by &2.&3 &4",
                                                      ch-query-sem-order,
                                                      hd-tabela-handle:name,
                                                      hd-browse-handle:current-column:name,
                                                      ch-sort)). 
    hd-browse-handle:query:query-open ().                                                         
end procedure.

procedure registrarQueryDefault:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-query        as   character  no-undo.    
    
    assign ch-query-default = ch-query.

end procedure.

procedure reiniciarDados:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    assign in-registros = hd-browse-handle:query:num-results
           in-filtrados = in-registros.

    run atualizarTitulo.           
end procedure.



