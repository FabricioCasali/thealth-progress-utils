
/*------------------------------------------------------------------------
    File        : dz-gerar-excel.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : fabri
    Created     : Mon Jan 31 09:49:11 BRT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define variable EV_EXPORTAR_EXCEL_LINHA     as   character  init 'EV_EXPORTAR_EXCEL'    no-undo.


define temp-table temp-formato-especial     no-undo
    field ch-campo                          as   character 
    field ch-mascara                        as   character 
    field lg-ocultar                        as   logical
    index idx1 
          as primary
          as unique
          ch-campo
    .
    