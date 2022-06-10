
/*------------------------------------------------------------------------
    File        : email.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabricio casali
    Created     : Mon Dec 06 17:53:55 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function validarEmail returns logical 
    (v-email as character) forward.


/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


function validarEmail returns logical 
    (ch-email as character   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable in-arroba           as   integer    no-undo.
    define variable in-conta            as   integer    no-undo.
    define variable ch-letra            as   character  no-undo.
    define variable lg-ponto            as   logical    no-undo.
    define variable lg-ponto-2          as   logical    no-undo.    
    
    if ch-email = ?
    then return no.
    
    assign ch-email = lower (trim (ch-email)).
    
    if length (ch-email)    < 5
    then return no.
    
    assign in-arroba    = index (ch-email, '@').
    
    if in-arroba   <= 1
    then return no.
    
    if substring (ch-email, length (ch-email), 1)   = '.'
    then return no.
    
    do in-conta = 1 to in-arroba - 1:
    
        assign ch-letra = substring (ch-email, in-conta, 1).
        
        if (    keycode (ch-letra) >= 97
            and keycode (ch-letra) <= 122)
        or (    keycode (ch-letra)  = 95)
        or (    keycode (ch-letra) >= 48
            and keycode (ch-letra) <= 57)
        then do:
            .
        end.
        else return no.
    end.          

        
    do in-conta = in-conta + 1 to length (ch-email):
    
        assign ch-letra = substring (ch-email, in-conta, 1).
        
        if (    keycode (ch-letra) >= 97
            and keycode (ch-letra) <= 122)
        or (    keycode (ch-letra)  = 95)
        or (    keycode (ch-letra) >= 48
            and keycode (ch-letra) <= 57)
        or (    keycode (ch-letra)  = 46)            
        then do:
            
            if keycode (ch-letra) = 46
            then do:
                
                if not lg-ponto 
                then lg-ponto           = yes.
                else if not lg-ponto-2
                     then lg-ponto-2    = yes.
                     else return no.
            end.
            
        end.
        else return no.
    end.
    
    
    
    if not lg-ponto
    then return no.
    
    return yes.          
        

end function.

