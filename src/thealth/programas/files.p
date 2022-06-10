
/*------------------------------------------------------------------------
    File        : files.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri  
    Created     : Tue Apr 05 16:21:19 BRT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

using Progress.Lang.AppError from propath. 

{thealth/includes/files.i}
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
procedure abortarProcessamento:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    assign lg-files-abortar-proces = yes.    
 
end procedure.

procedure listaArquivosPasta:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input        parameter           ch-caminho          as   character  no-undo.
    define input        parameter           ch-filtros          as   character  no-undo.
    define input        parameter           lg-subdiretorio     as   logical    no-undo.
    define input-output parameter table for temp-lista-arquivo.
    
    assign lg-files-abortar-proces = no.
    
    run listarArquivosPastaPriv (input  ch-caminho,
                                 input  ch-caminho,
                                 input  ch-filtros, 
                                 input  lg-subdiretorio).
                                 
    if lg-files-abortar-proces
    then undo, throw new AppError ("Processamento cancelado pelo usuario", 999).                                          
end procedure.

procedure listarArquivosPastaPriv private:
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-caminho      as   character  no-undo.
    define input  parameter ch-root         as   character  no-undo.
    define input  parameter ch-filtros      as   character  no-undo.
    define input  parameter lg-subdiretorio as   logical    no-undo.
    
    define variable ch-arquivo              as   character  no-undo.
    define variable ch-arquivo-normaliz     as   character  no-undo.
    define variable ch-caminho-relativo     as   character  no-undo.
    define variable lg-first                as   logical    no-undo.
    define variable in-indice               as   integer    no-undo.
    define variable ch-parte                as   character  no-undo.
    define variable lg-skip                 as   logical    no-undo.
         
    assign ch-caminho = normalizarCaminho (ch-caminho).
    assign ch-root = normalizarCaminho (ch-root).
    
    file-info:file-name = ch-caminho.
    if file-info:file-type = ?
    then next.
    
    if not file-info:file-type matches ('*D*')
    then next.
    
    input from os-dir (ch-caminho). 
     
    t1:
    repeat:
        
        import ch-arquivo.
        
        if ch-arquivo  = '.' 
        or ch-arquivo  = '..'
        then next.
        
        process events.
        
        if lg-files-abortar-proces 
        then do:
            
            return.
        end.
        
        assign ch-arquivo-normaliz  = normalizarCaminho (ch-caminho + '/' + ch-arquivo).
        
        file-info:file-name = ch-arquivo-normaliz.
        
        if file-info:file-type matches ('*D*') 
        and lg-subdiretorio
            then do:
               
                run listarArquivosPastaPriv (input  file-info:file-name, 
                                             input  ch-root,
                                             input  ch-filtros,
                                             input  lg-subdiretorio).
                next.
            end.  
   
            assign ch-caminho-relativo = replace (normalizarCaminho (file-info:full-pathname), ch-root, '').
        
        if ch-caminho-relativo begins ('/')
        then assign ch-caminho-relativo    = substring (ch-caminho-relativo, 2).
        
        publish EV_FILES_PROCESSAR (input  ch-caminho-relativo).
        
        assign lg-skip = no.
        
        if  ch-filtros <> ''
        and ch-filtros <> ?
        then do:
            
            
            do in-indice = 1 to num-entries (ch-filtros, '|'):
                
                assign ch-parte = entry (in-indice, ch-filtros, '|').
                
                if not obtemNomeArquivo (ch-caminho-relativo) matches ch-parte
                then do:
                    assign lg-skip = yes.
                    leave. 
                end.
            end.
            
            if lg-skip
            then next.
        end.
            
        create temp-lista-arquivo.
        assign temp-lista-arquivo.ch-extensao           = obtemExtensao (ch-caminho-relativo)
               temp-lista-arquivo.ch-nome               = obtemNomeArquivo (ch-caminho-relativo) 
               temp-lista-arquivo.ch-caminho-relativo   = ch-caminho-relativo
               temp-lista-arquivo.ch-caminho            = ch-arquivo-normaliz
               temp-lista-arquivo.in-tamanho            = file-info:file-size
               .
               
        process events.
    end.

    input close. 

end procedure.