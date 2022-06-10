
/*------------------------------------------------------------------------
    File        : cpf.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabricio casali
    Created     : Thu Dec 02 10:02:41 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function validarCPF returns logical 
    (ch-cpf as character) forward.


/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


function validarCPF returns logical 
    (ch-cpf as character  ):
/*------------------------------------------------------------------------------
 Purpose: verifica se o cpf esta correto
 Notes:
------------------------------------------------------------------------------*/    
define variable ch-cpf-limpo    as   character          no-undo.
    define variable in-multi1       as   integer extent 9   no-undo.
    define variable in-multi2       as   integer extent 10  no-undo.
    define variable in-indice       as   integer            no-undo.
    define variable in-resto        as   integer            no-undo.
    define variable ch-digito       as   character          no-undo.
    define variable ch-temp         as   character          no-undo.
    define variable in-soma         as   integer            no-undo.

    if ch-cpf   = ?
    or ch-cpf   = ''
    then return no.
    
    do in-indice = 1 to 9 :
        assign in-multi1[in-indice] = 12 - (in-indice + 1).
    end.
    do in-indice = 1 to 10:
        assign in-multi2[in-indice] = 13 - (in-indice + 1).
    end.
    
    
    assign ch-cpf-limpo = replace (replace (replace (ch-cpf, ' ', ''), '-', ''), '.', '').
    
   if length (ch-cpf-limpo)   <> 11 
   then do:    
      return no.
   end.

    do in-indice = 0 to 9:
        
        assign ch-temp  = fill (string (in-indice), 11).
        
        if ch-temp  = ch-cpf-limpo 
        then do:
           return no.
        end.
    end.

    assign ch-temp  = substring (ch-cpf-limpo, 1, 10).
    
    do in-indice = 1 to 9:
    
        assign in-soma = in-soma + integer (substring (ch-temp, IN-indice, 1)) * in-multi1[in-indice].
    end.
    
    assign in-resto = in-soma mod 11.
    
    if in-resto < 2 
    then do:
        
        assign in-resto = 0.
    end.
    else do:
        
        assign in-resto = 11 - in-resto.
    end.
    
    assign ch-digito    = string (in-resto)
           ch-temp      = ch-temp + ch-digito
           in-soma      = 0.
           
    do in-indice = 1 to 10:
        assign in-soma  = in-soma + integer (substring (ch-temp, IN-indice, 1)) * in-multi2[in-indice].
    end.
    
    assign in-resto = in-soma mod 11.
    
    if in-resto < 2 
    then do:
        
        assign in-resto = 0.
    end.
    else do:
        
        assign in-resto = 11 - in-resto.
    end.
    assign ch-digito = ch-digito + string (in-resto).
    
    return substring (ch-cpf-limpo, 10) = ch-digito.        
end function.

