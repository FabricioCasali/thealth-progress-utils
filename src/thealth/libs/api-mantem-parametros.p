 
/*------------------------------------------------------------------------
    File        : api-mantem-parametros.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Apr 22 07:57:30 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using Progress.Lang.AppError from propath.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

                     
/* **********************  Internal Procedures  *********************** */

procedure buscarParametro:
/*------------------------------------------------------------------------------
 Purpose: realiza a busca de um determinado parametro
 Notes: caso o parametro nao exista, retorna ch-valor = ?
------------------------------------------------------------------------------*/
    define input  parameter ch-tabela           as   character  no-undo.
    define input  parameter ch-programa         as   character  no-undo.
    define input  parameter ch-usuario          as   character  no-undo.
    define input  parameter ch-chave            as   character  no-undo.
    define output parameter lo-valor            as   longchar   no-undo.

    define variable ch-query                    as   character  no-undo.
    define variable hd-buffer                   as   handle     no-undo.
    define variable lg-existe                   as   logical    no-undo.                                  

    if ch-usuario   = ? 
    then assign ch-usuario = ''.
    
    assign ch-usuario   = trim (ch-usuario)
           ch-query     = substitute ("where &1.ch-programa = '&2' and &1.ch-usuario = '&3' and &1.ch-chave = '&4'",
                                      ch-tabela,
                                      ch-programa,
                                      ch-usuario,
                                      ch-chave). 
    
    create buffer hd-buffer for table ch-tabela.
    
    assign lg-existe    = hd-buffer:find-first (ch-query, no-lock) no-error.
        
    if not lg-existe
    then do:
        
        assign lo-valor = ?.
    end.
    else do:
        
        assign lo-valor = hd-buffer:buffer-field ("lo-valor"):buffer-value. 
    end.
    
end procedure.

procedure removerParametro:
/*------------------------------------------------------------------------------
 Purpose:
 Notes: Caso o parametro nao exista, nÆo dispara erro
------------------------------------------------------------------------------*/
    define input  parameter ch-tabela           as   character  no-undo.
    define input  parameter ch-programa         as   character  no-undo.
    define input  parameter ch-usuario          as   character  no-undo.
    define input  parameter ch-chave            as   character  no-undo.
    
    define variable ch-query                    as   character  no-undo.
    define variable hd-buffer                   as   handle     no-undo.
    define variable lg-existe                   as   logical    no-undo.                                  
    define variable lg-valido                   as   logical    no-undo.
    
    if ch-usuario = ?
    then assign ch-usuario  = ''.
    
    assign ch-usuario   = trim (ch-usuario)
           ch-query     = substitute ("where &1.ch-programa = '&2' and &1.ch-usuario = '&3' and &1.ch-chave = '&4'",
                                      ch-tabela,
                                      ch-programa,
                                      ch-usuario,
                                      ch-chave). 
    
    create buffer hd-buffer for table ch-tabela.
    
    do transaction:

        assign lg-existe    = hd-buffer:find-first (ch-query, exclusive-lock) no-error.
        
        if not lg-existe
        then do:
            
            return.            
        end.
        
        hd-buffer:buffer-delete () no-error.
        
        if error-status:error
        then do:
            
            undo, throw new AppError (substitut ("Falha ao remover registro: &1 - &2", error-status:get-number (1), error-status:get-message (1)), 1).
        end.
    
        catch cs-erro as Progress.Lang.Error :
            
            log-manager:write-message (substitute ("falha > &1", cs-erro:GetMessage(1)), "ERROR") no-error.
            undo, throw cs-erro.                
        end catch.    
    end.


end procedure.

procedure salvarParametro:
/*------------------------------------------------------------------------------
 Purpose: Cria ou atualiza um parametro para determinado usuario
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-tabela           as   character  no-undo.
    define input  parameter ch-programa         as   character  no-undo.
    define input  parameter ch-usuario          as   character  no-undo.
    define input  parameter ch-chave            as   character  no-undo.
    define input  parameter lo-valor            as   character  no-undo.
    
    define variable ch-query                    as   character  no-undo.
    define variable hd-buffer                   as   handle     no-undo.
    define variable lg-existe                   as   logical    no-undo.                                  
    define variable lg-valido                   as   logical    no-undo.
    
    if ch-usuario = ?
    then assign ch-usuario  = ''.
    
    assign ch-usuario   = trim (ch-usuario)
           ch-query     = substitute ("where &1.ch-programa = '&2' and &1.ch-usuario = '&3' and &1.ch-chave = '&4'",
                                      ch-tabela,
                                      ch-programa,
                                      ch-usuario,
                                      ch-chave). 
    
    create buffer hd-buffer for table ch-tabela.
    
    do transaction:

        assign lg-existe    = hd-buffer:find-first (ch-query, exclusive-lock) no-error.
        
        if not lg-existe
        then do:
            
            hd-buffer:buffer-create ().
            assign hd-buffer:buffer-field ("ch-programa"):buffer-value  = ch-programa
                   hd-buffer:buffer-field ("ch-usuario"):buffer-value   = ch-usuario
                   hd-buffer:buffer-field ("ch-chave"):buffer-value     = ch-chave.
        end. 
        
        assign hd-buffer:buffer-field ("lo-valor"):buffer-value = lo-valor.
        
        assign lg-valido    = hd-buffer:buffer-validate () no-error.
        
        if error-status:error
        then do:
            
            undo, throw new AppError (substitut ("Falha ao validar registro: &1 - &2", error-status:get-number (1), error-status:get-message (1)), 1).
        end.
    
        hd-buffer:buffer-release ().
        catch cs-erro as Progress.Lang.Error :
            
            log-manager:write-message (substitute ("falha > &1", cs-erro:GetMessage(1)), "ERROR") no-error.
            undo, throw cs-erro.                
        end catch.    
    end.

end procedure.

