
/*------------------------------------------------------------------------
    File        : resize.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Sep 21 16:24:30 BRT 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
    
define variable ALINHAR_HORIZONTAL_ESQUERDA         as   character  init    'L' no-undo.
define variable ALINHAR_HORIZONTAL_DIREITA          as   character  init    'R' no-undo.
define variable ALINHAR_HORIZONTAL_CENTRO           as   character  init    'C' no-undo.

define variable ALINHAR_VERTICAL_SUPERIOR           as   character  init    'T' no-undo.
define variable ALINHAR_VERTICAL_INFERIOR           as   character  init    'B' no-undo.
define variable ALINHAR_VERTICAL_CENTRO             as   character  init    'C' no-undo.

define temp-table temp-widgets          no-undo
    field hd-widget                     as   handle
    field in-x                          as   integer
    field in-y                          as   integer
    field in-largura                    as   integer
    field in-altura                     as   integer
    field in-largura-pai                as   integer
    field in-altura-pai                 as   integer
    field in-ordem                      as   integer 
    field ch-nome                       as   character 
    field ch-tipo                       as   character
    field hd-pai                        as   handle  
    field ch-alinhar-h                  as   character  init 'L'
    field ch-alinhar-v                  as   character  init 'T'
    field dc-largura-multi              as   decimal    init 1
    field dc-altura-multi               as   decimal    init 1
    field lg-redimencionar-x            as   logical    init no
    field lg-redimencionar-y            as   logical    init no
    index idx1
          in-ordem
    index idx2
          hd-widget          
    .
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */




/* **********************  Internal Procedures  *********************** */

on window-resized of current-window
do:
    
    for each temp-widgets
       where temp-widgets.ch-tipo   = 'FRAME': 
        
        run widgetReposicionar no-error.
    end.
    
    for each temp-widgets
       where temp-widgets.ch-tipo  <> 'FRAME': 
        
        run widgetReposicionar no-error.
    end.
end.



procedure alinharHorizontalDireita:

    define input  parameter hd-handle           as   handle     no-undo.
    
    find first temp-widgets where temp-widgets.hd-widget    = hd-handle.
    
    temp-widgets.ch-alinhar-h = ALINHAR_HORIZONTAL_DIREITA.
end.


procedure widgetAlinharHorizontal:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter hd-componente           as   handle     no-undo.
    define input  parameter ch-alinhamento          as   character  no-undo.
    
    define variable in-ordem                        as   integer    no-undo.

    find first temp-widgets 
         where temp-widgets.hd-widget    = hd-componente
               no-error.
               
    if not available temp-widgets
    then do:

        for last temp-widgets
              by temp-widgets.in-ordem:
           
            assign in-ordem = temp-widgets.in-ordem.
                   
        end.
                   
        assign in-ordem                 = in-ordem + 1
               temp-widgets.in-ordem    = in-ordem
               temp-widgets.hd-widget   = hd-componente
               temp-widgets.in-x        = hd-componente:x
               temp-widgets.in-y        = hd-componente:y
               temp-widgets.in-largura  = hd-componente:width-pixels
               temp-widgets.in-altura   = hd-componente:height-pixels
               temp-widgets.ch-nome     = hd-componente:name               
               temp-widgets.ch-tipo     = hd-componente:type
               temp-widgets.hd-pai      = if hd-componente:frame = ?
                                          then ?
                                          else hd-componente:frame:handle
               .        
    end.
                   
    assign temp-widgets.ch-alinhar-h = ch-alinhamento.
end procedure.

procedure widgetAlinharVertical:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter hd-componente           as   handle     no-undo.
    define input  parameter ch-alinhamento          as   character  no-undo.

    define variable in-ordem                        as   integer    no-undo.

    find first temp-widgets 
         where temp-widgets.hd-widget    = hd-componente
               no-error.
               
    if not available temp-widgets
    then do:

        for last temp-widgets
              by temp-widgets.in-ordem:
           
            assign in-ordem = temp-widgets.in-ordem.
                   
        end.
                   
        assign in-ordem                 = in-ordem + 1
               temp-widgets.in-ordem    = in-ordem
               temp-widgets.hd-widget   = hd-componente
               temp-widgets.in-x        = hd-componente:x
               temp-widgets.in-y        = hd-componente:y
               temp-widgets.in-largura  = hd-componente:width-pixels
               temp-widgets.in-altura   = hd-componente:height-pixels
               temp-widgets.ch-nome     = hd-componente:name               
               temp-widgets.ch-tipo     = hd-componente:type
               temp-widgets.hd-pai      = if hd-componente:frame = ?
                                          then ?
                                          else hd-componente:frame:handle
               .        
    end.               

    assign temp-widgets.ch-alinhar-v = ch-alinhamento.
end procedure.

procedure widgetInicializar:
/*------------------------------------------------------------------------------
 Purpose: realiza a inicializa‡Æo de todos os objetos. Este m‚todo deve ser chamado ANTES
          de qualquer outro metodo relativo ao layout, e tamb‚m deve ser chamado DEPOIS de 
          todos os elementos visuais terem sido definidos
 Notes:
------------------------------------------------------------------------------*/
    define variable hd-widget       as   handle         no-undo.
    
    empty temp-table temp-widgets.
    
    assign current-window:min-width-pixels  = current-window:width-pixels
           current-window:min-height-pixels = current-window:height-pixels
           current-window:max-width-pixels  = session:width-pixels
           current-window:max-height-pixels = session:height-pixels
           .

    run widgetProcessaWidget (0, frame {&FRAME_PADRAO}:handle, ?).

end procedure.

procedure widgetProcessaWidget:
/*------------------------------------------------------------------------------
 Purpose: realiza o processado e registro do widget, criando a temporaria 
          de controle dos elementos
 Notes:
------------------------------------------------------------------------------*/

    define input  parameter in-ordem        as   integer    no-undo.
    define input  parameter hd-handle       as   handle     no-undo.
    define input  parameter hd-pai          as   handle     no-undo.
    
    do while valid-handle (hd-handle):
        
        log-manager:write-message (substitute ("acomp  > lendo widget -> &1 >> &2",
                                               hd-handle:name,
                                               hd-handle:type), "DEBUG") no-error.
                                               
        if hd-handle:type  <> "FIELD-GROUP"
        then do:
            
            find first temp-widgets 
                 where temp-widgets.hd-widget   = hd-handle
                       no-error.

            if not available temp-widgets
            then do:
                                       
                create temp-widgets.
            end.
            
            assign in-ordem                 = in-ordem + 1
                   temp-widgets.in-ordem    = in-ordem
                   temp-widgets.hd-widget   = hd-handle
                   temp-widgets.in-x        = hd-handle:x
                   temp-widgets.in-y        = hd-handle:y
                   temp-widgets.in-largura  = hd-handle:width-pixels
                   temp-widgets.in-altura   = hd-handle:height-pixels
                   temp-widgets.ch-nome     = hd-handle:name               
                   temp-widgets.ch-tipo     = hd-handle:type
                   temp-widgets.hd-pai      = hd-pai
                   .
                   
            if valid-handle (hd-pai)
            then do:
                
                assign temp-widgets.dc-largura-multi    = (hd-handle:width-pixels / hd-pai:width-pixels) * 100
                       temp-widgets.dc-altura-multi     = (hd-handle:height-pixels / hd-pai:height-pixels) * 100
                       temp-widgets.in-altura-pai       = hd-pai:height-pixels
                       temp-widgets.in-largura-pai      = hd-pai:width-pixels
                       . 
            end.     
            else do:
                assign temp-widgets.dc-largura-multi    = (hd-handle:width-pixels / {&WINDOW-NAME}:min-width-pixels) * 100
                       temp-widgets.dc-altura-multi     = (hd-handle:height-pixels / {&WINDOW-NAME}:min-height-pixels) * 100
                       . 
            end.              
        end.
        
        if  can-query (hd-handle, "first-child") 
        and hd-handle:first-child   <> ?
        then do:

            run widgetProcessaWidget (input  in-ordem,
                                      input  hd-handle:first-child,
                                      if hd-handle:type = "FIELD-GROUP"
                                      then hd-pai
                                      else hd-handle). 
        end.

        hd-handle   = hd-handle:next-sibling.
    end.
end procedure.

procedure widgetRedimencionar:
/*------------------------------------------------------------------------------
 Purpose: sinaliza o widget como redimensionavel no eixo X e Y
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter hd-handle           as   handle     no-undo.
    
    find first temp-widgets 
         where temp-widgets.hd-widget   = hd-handle.
    
    assign temp-widgets.lg-redimencionar-x  = yes
           temp-widgets.lg-redimencionar-y  = yes
           .

end procedure.

procedure widgetRedimencionarX:
/*------------------------------------------------------------------------------
 Purpose: sinaliza o widget como redimensionavel no eixo X
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter hd-handle           as   handle     no-undo.
    
    find first temp-widgets 
         where temp-widgets.hd-widget   = hd-handle.
    
    assign temp-widgets.lg-redimencionar-x  = yes.

end procedure. 

procedure widgetRedimencionarY:
/*------------------------------------------------------------------------------
 Purpose: sinaliza o widget como redimensionavel no eixo Y
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter hd-handle           as   handle     no-undo.
    
    find first temp-widgets 
         where temp-widgets.hd-widget   = hd-handle.
    
    assign temp-widgets.lg-redimencionar-y  = yes.

end procedure.

procedure widgetReposicionar:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable dc-x            as   decimal    no-undo.
    define variable dc-y            as   decimal    no-undo.
    define variable dc-dif          as   decimal    no-undo.

    define buffer buf-temp-widgets  for  temp-widgets.
        
    if valid-handle (temp-widgets.hd-pai)
    then do:
        
        find first buf-temp-widgets
             where buf-temp-widgets.hd-widget   = temp-widgets.hd-pai.
    end.
    
    assign dc-x = {&WINDOW-NAME}:width-pixels - {&WINDOW-NAME}:min-width-pixels
           dc-y = {&WINDOW-NAME}:height-pixels - {&WINDOW-NAME}:min-height-pixels
           .
    
    if temp-widgets.lg-redimencionar-x
    then do:
        
        assign dc-dif                               = truncate ((dc-x / temp-widgets.dc-largura-multi) * 100, 0)
               temp-widgets.hd-widget:width-pixels  = temp-widgets.in-largura + dc-x
               no-error.
    end.
    
    if  temp-widgets.lg-redimencionar-y 
    then do:
        
        assign dc-dif                               = truncate ((dc-y / temp-widgets.dc-altura-multi) * 100, 0)
               temp-widgets.hd-widget:height-pixels = temp-widgets.in-altura + dc-y
               no-error. 
    end.
    
    if  temp-widgets.ch-alinhar-h  = ALINHAR_HORIZONTAL_DIREITA
    and available buf-temp-widgets
    and buf-temp-widgets.lg-redimencionar-x
    then do:
        
        assign temp-widgets.hd-widget:x = temp-widgets.in-x + dc-x no-error.
    end.
    
    if temp-widgets.ch-alinhar-v  = ALINHAR_VERTICAL_INFERIOR
    and available buf-temp-widgets
    and buf-temp-widgets.lg-redimencionar-y
    then do:
        
        assign temp-widgets.hd-widget:y = temp-widgets.in-y + dc-y no-error.
    end.
    
    if  temp-widgets.ch-alinhar-h  = ALINHAR_HORIZONTAL_CENTRO
    and available buf-temp-widgets
    and buf-temp-widgets.lg-redimencionar-x
    then do:
        
        assign temp-widgets.hd-widget:x = truncate (temp-widgets.hd-pai:width-pixels / 2, 0) - truncate (temp-widgets.hd-widget:width-pixels / 2, 0) - 1 no-error.
    end.
    
    if temp-widgets.ch-alinhar-v  = ALINHAR_VERTICAL_CENTRO
    and available buf-temp-widgets
    and buf-temp-widgets.lg-redimencionar-y
    then do:
        
        assign temp-widgets.hd-widget:y = truncate (temp-widgets.hd-pai:height-pixels / 2, 0) - truncate (temp-widgets.hd-widget:height-pixels / 2, 0) - 1 no-error.
    end.
    

    if temp-widgets.ch-tipo = 'FRAME'
    then do:
        
        assign temp-widgets.hd-widget:virtual-width-pixels  = temp-widgets.hd-widget:width-pixels
               temp-widgets.hd-widget:virtual-height-pixels = temp-widgets.hd-widget:height-pixels
               no-error.
    end.

end procedure.
