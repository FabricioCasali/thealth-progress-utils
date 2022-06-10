
/*------------------------------------------------------------------------
    File        : files.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri
    Created     : Tue Apr 05 15:09:41 BRT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define temp-table temp-lista-arquivo    no-undo
    field ch-nome                       as   character 
    field ch-caminho                    as   character
    field ch-caminho-relativo           as   character 
    field ch-extensao                   as   character
    field in-tamanho                    as   integer
    index idx1
          ch-caminho-relativo
    .
    
define variable EV_FILES_PROCESSAR      as   character  init 'EV_FILES_PROCESSAR'   
                                                        no-undo.

define variable lg-files-abortar-proces as   logical    no-undo.    
    
/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function normalizarCaminho returns character 
    (ch-caminho as character) forward.

function obtemExtensao returns character 
    (ch-nome-arquivo as character) forward.

function obtemNomeArquivo returns character 
    (ch-nome-arquivo as character) forward.

/* ***************************  Main Block  *************************** */



/* **********************  Internal Procedures  *********************** */



/* ************************  Function Implementations ***************** */

function normalizarCaminho returns character 
    (ch-caminho as character  ):
/*------------------------------------------------------------------------------
 Purpose: normaliza o uso das barras em caminhos de arquivo ou rede
 Notes:
------------------------------------------------------------------------------*/    
    define variable lg-caminho-rede         as   logical    no-undo.
    
    if ch-caminho begins ('\\')
    then do:
        lg-caminho-rede    = yes.
        assign ch-caminho = substring (ch-caminho, 3).
    end.
    
    assign ch-caminho = replace (replace (ch-caminho, '\', '/'), '//', '/').  
    
    if lg-caminho-rede
    then ch-caminho = '\\' + ch-caminho.
    return ch-caminho.
        
end function.

function obtemExtensao returns character 
    ( ch-nome-arquivo as character  ):
/*------------------------------------------------------------------------------
 Purpose: retorna a extensÆo de um arquivo atrav‚s do seu caminho absoluto ou nome do arquivo
 Notes:
------------------------------------------------------------------------------*/    

    assign ch-nome-arquivo = obtemNomeArquivo (ch-nome-arquivo).

    if index (ch-nome-arquivo, '.') = 0
    then return ?.
    
    return entry (num-entries (ch-nome-arquivo, '.'), ch-nome-arquivo, '.').
        
end function.

function obtemNomeArquivo returns character 
    (ch-nome-arquivo as character   ):
/*------------------------------------------------------------------------------
 Purpose: retorna o nome atrav‚s o caminho obsoluto de um arquivo
 Notes:
------------------------------------------------------------------------------*/    
    ch-nome-arquivo = normalizarCaminho (ch-nome-arquivo).
    if index (ch-nome-arquivo, '/') > 0
    then do:
        
        assign ch-nome-arquivo = entry (num-entries (ch-nome-arquivo, '/'), ch-nome-arquivo, '/').
    end.
    return ch-nome-arquivo.
        
end function.

