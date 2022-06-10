
/*------------------------------------------------------------------------
    File        : erro-versao-compilador.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri
    Created     : Tue Apr 05 14:11:17 BRT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{thealth/includes/files.i}

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define temp-table temp-programa             no-undo
                                            like temp-lista-arquivo                                                         
    field lg-erro-crc                       as   logical
    field lg-erro-versao-compilador         as   logical
    .
    
define temp-table temp-tabela               no-undo
    field ch-tabela                         as   character 
    field ch-banco                          as   character
    index idx1
          as primary
          as unique
          ch-banco
          ch-tabela
    .
    
define temp-table temp-relacionamento       no-undo
    field rc-programa                       as   recid
    field rc-tabela                         as   recid
    .