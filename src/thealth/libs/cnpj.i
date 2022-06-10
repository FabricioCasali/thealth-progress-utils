
/*------------------------------------------------------------------------
    File        : cnpj.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri
    Created     : Fri Dec 10 08:43:28 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function validarCNPJ returns logical 
    (ch-cnpj as char) forward.


/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


function validarCNPJ returns logical 
    (ch-cnpj as char  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/    
    define variable ch-base         as   character  no-undo.
    define variable in-mod          as   integer    no-undo.
    define variable ch-novo         as   character  no-undo.
    define variable in-conta        as   integer    no-undo.
    define variable in-soma         as   integer    no-undo.
    
    assign ch-base  = '6543298765432'
           ch-cnpj  = trim (replace (replace (replace (replace (ch-cnpj, '.', ''), '/', ''), '-', ''), ' ', ''))
           .
    
    if length (ch-cnpj) <> 14
    then do:
        return no.
    end.
    
    assign ch-novo = substring (ch-cnpj, 1, 12).
    
    do in-conta = 1 to 12 :
        assign in-soma = in-soma + (integer (substring (ch-base, in-conta + 1, 1)) * INTEGER (substring (ch-cnpj, in-conta, 1))).
    end.
        
    assign in-mod   = in-soma mod 11.
    
    if in-mod   < 2 
    then do:
         
        assign in-mod   = 0.
    end.
    else do:
        assign in-mod   = 11 - in-mod.
    end.     
     
    assign in-soma  = 0
           ch-novo  = substitute ('&1&2', ch-novo, in-mod).
     
    do in-conta = 1 to 13 :
        assign in-soma = in-soma + (integer (substring (ch-base, in-conta, 1)) * INTEGER (substring (ch-novo, in-conta, 1))).
    end.
         
    assign in-mod   = in-soma mod 11.
    
    if in-mod   < 2  
    then do:
         
        assign in-mod   = 0.
    end.
    else do:
        assign in-mod   = 11 - in-mod.
    end.    
    assign ch-novo  = substitute ('&1&2', ch-novo, in-mod).
    return ch-novo  = ch-cnpj.   
end function.

