&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME windowMain

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS windowMain 
using Progress.Lang.AppError from propath.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS windowMain 
/*------------------------------------------------------------------------

  File: 

  Description:  

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 04/05/22 -  3:55 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/
routine-level on error undo, throw.
create widget-pool.


/* ***************************  Definitions  ************************** */
{thealth/programas/inventario/inventario-consultar.i}  
{thealth/interface/status-processamento.i} 

/* Parameters Definitions ---                                            */

/* Local Variable Definitions ---                                       */
define variable hd-status       as   handle         no-undo.
define variable lg-abortar      as   logical        no-undo.
define variable hd-files        as   handle         no-undo. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS windowMain 
/*------------------------------------------------------------------------

  File: 

  Description: 
 
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 04/05/22 -  3:57 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frameDefault
&Scoped-define BROWSE-NAME browseDados

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES temp-programa

/* Definitions for BROWSE browseDados                                   */
&Scoped-define FIELDS-IN-QUERY-browseDados temp-programa.ch-nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-browseDados   
&Scoped-define SELF-NAME browseDados
&Scoped-define QUERY-STRING-browseDados FOR EACH temp-programa
&Scoped-define OPEN-QUERY-browseDados OPEN QUERY {&SELF-NAME} FOR EACH temp-programa.
&Scoped-define TABLES-IN-QUERY-browseDados temp-programa
&Scoped-define FIRST-TABLE-IN-QUERY-browseDados temp-programa


/* Definitions for FRAME frameCorpo                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frameCorpo ~
    ~{&OPEN-QUERY-browseDados}

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
define var windowMain as widget-handle no-undo.

/* Definitions of the field level widgets                               */
define button buttonExportar 
     image-up file "assets/excel_32_32.jpg":U
     label "Button 5" 
     size 9.6 by 2.14.

define rectangle rectCorpo
     edge-pixels 2 graphic-edge  no-fill   
     size 129 by 11.38.

define button buttonSair 
     label "Sai&r" 
     size 15 by 1.14.

define button buttonPesquisar 
     label "&Pesquisar" 
     size 15 by 1.14.

define rectangle rectSuperior
     edge-pixels 2 graphic-edge  no-fill   
     size 129 by 3.

define variable checkUtilizarPropath as logical initial no 
     label "Utilizar propath" 
     view-as toggle-box
     size 23.8 by .81 no-undo.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
define query browseDados for 
      temp-programa scrolling.
&ANALYZE-RESUME

/* Browse definitions                                                   */
define browse browseDados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS browseDados windowMain _FREEFORM
  query browseDados display
      temp-programa.ch-nome
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 10.95
         FONT 1
         TITLE "Browse 2" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

define frame frameDefault
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline three-d 
         at col 1 row 1
         size 131 by 16.38
         bgcolor 15 font 1 widget-id 100.

define frame frameSuperior
     buttonPesquisar at row 1.95 col 115 widget-id 6
     checkUtilizarPropath at row 2.29 col 5.2 widget-id 2
     rectSuperior at row 1.1 col 2 widget-id 4
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline three-d 
         at col 1 row 1.24
         size 130 by 3.1
         bgcolor 15  widget-id 400.

define frame frameCorpo
     browseDados at row 1.48 col 3 widget-id 300
     buttonExportar at row 2.43 col 119.6 widget-id 6
     rectCorpo at row 1.29 col 2 widget-id 4
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline three-d 
         at col 1 row 4.33
         size 131 by 11.91
         bgcolor 15 font 1 widget-id 200.

define frame frameRodape 
     buttonSair at row 1 col 115.8 widget-id 6
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline three-d 
         at col 1 row 16.05
         size 130 by 1.14
         bgcolor 15 font 1 widget-id 500.
 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
if session:display-type = "GUI":U then
  create window windowMain assign
         hidden             = yes
         title              = "<insert window title>"
         height             = 16.38
         width              = 131
         max-height         = 20.24
         max-width          = 149
         virtual-height     = 20.24
         virtual-width      = 149
         resize             = yes
         scroll-bars        = no
         status-area        = no
         bgcolor            = ?
         fgcolor            = ?
         keep-frame-z-order = yes
         three-d            = yes
         message-area       = no
         sensitive          = yes.
else {&WINDOW-NAME} = current-window.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW windowMain
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
assign frame frameCorpo:FRAME = frame frameDefault:HANDLE
       frame frameRodape:FRAME = frame frameDefault:HANDLE
       frame frameSuperior:FRAME = frame frameDefault:HANDLE.

/* SETTINGS FOR FRAME frameCorpo
                                                                        */
/* BROWSE-TAB browseDados rectCorpo frameCorpo */
/* SETTINGS FOR FRAME frameDefault
   FRAME-NAME                                                           */

define variable XXTABVALXX as logical no-undo.

assign XXTABVALXX = frame frameCorpo:MOVE-BEFORE-TAB-ITEM (frame frameRodape:HANDLE)
       XXTABVALXX = frame frameSuperior:MOVE-BEFORE-TAB-ITEM (frame frameCorpo:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME frameRodape
                                                                        */
/* SETTINGS FOR FRAME frameSuperior
                                                                        */
if session:display-type = "GUI":U and VALID-HANDLE(windowMain)
then windowMain:hidden = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE browseDados
/* Query rebuild information for BROWSE browseDados
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH temp-programa.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE browseDados */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME windowMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL windowMain windowMain
on end-error of windowMain /* <insert window title> */
or endkey of {&WINDOW-NAME} anywhere do:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */ 
  if this-procedure:persistent then return no-apply.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL windowMain windowMain
on window-close of windowMain /* <insert window title> */
do:
  /* This event will close the window and terminate the procedure.  */
  apply "CLOSE":U to this-procedure.
  return no-apply. 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameSuperior
&Scoped-define SELF-NAME buttonPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonPesquisar windowMain
on choose of buttonPesquisar in frame frameSuperior /* Pesquisar */
do:
    run acaoPesquisar.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameDefault
&Scoped-define BROWSE-NAME browseDados
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK windowMain 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
assign CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{thealth/interface/resize.i &FRAME_PADRAO="frameDefault"}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
on close of this-procedure 
   run disable_UI.

/* Best default for GUI applications is...                              */
pause 0 before-hide.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  run enable_UI.
  run inicializarInterface.
  if not this-procedure:persistent then
    wait-for close of this-procedure. 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acaoPesquisar windowMain 
procedure acaoPesquisar private :
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/
    
    define variable ch-parte            as   character  no-undo.
    define variable in-indice           as   integer    no-undo.
    
    empty temp-table temp-lista-arquivo.
    empty temp-table temp-programa.
    empty temp-table temp-tabela.
    empty temp-table temp-relacionamento.
    
    assign lg-abortar   = no.
     
    do on error undo, return: 
         
        run thealth/interface/status-processamento.w persistent set hd-status (input  "Processando", yes).        
        subscribe to EV_STATUS_PROC_CANCELAR in hd-status run-procedure "eventoStatus".
        subscribe to EV_FILES_PROCESSAR in hd-files run-procedure "eventoLerArquivo". 
        
        run mostrarMensagem in hd-status ("Iniciando").
          
        if checkUtilizarPropath:checked in frame frameSuperior 
        then do: 
            
            do in-indice = 1 to num-entries (propath, ','): 
                 
                assign ch-parte = entry (in-indice, propath, ',').
                
                run listaArquivosPasta in hd-files (input              ch-parte, 
                                                    input              '*.r',
                                                    input              yes,
                                                    input-output table temp-lista-arquivo).
            end.
        end.

        for each temp-lista-arquivo:
            
            if can-find (first temp-programa 
                         where temp-programa.ch-caminho-relativo  = temp-lista-arquivo.ch-caminho-relativo)
            then do:
                
                next.
            end.     
            
            create temp-programa.
            buffer-copy temp-lista-arquivo to temp-programa.
           
            rcode-information:file-name = temp-lista-arquivo.ch-caminho no-error.
            if error-status:error
            then do:accept-changes (
                
                if error-status:get-number (1) = 44
                then do:
                    
                    assign temp-programa.lg-erro-versao-compilador  = yes.                    
                end.
                
                if error-status:get-number (1) = 1896
                then do:
                end.                
            end.
        end.
        
        for each temp-programa:
            
            if temp-programa. 
            
            
        end.
        
                
        catch cs-erro as Progress.Lang.Error:            
            
            if cs-erro:GetMessageNum(1) = 1
            then do:
        
                message substitute ("Ops...~nOcorreu um erro ao XXX.~n&1",
                        cs-erro:GetMessage(1))
                view-as alert-box error buttons ok.
            end.
            else do:
                if cs-erro:GetMessageNum(1) = 999
                then do:
                     
                    message substitute ("&1", cs-erro:GetMessage(1))
                    view-as alert-box error buttons ok.
                    undo, return.                    
                end.
                else do: 
                            
                    message substitute ("Ops...~nOcorreu um erro ao XXX.~nInforme a TI com um print desta mensagem.~n&1",
                                                        cs-erro:GetMessage(1))
                    view-as alert-box error buttons ok.
                end.
            end.
            undo, return.           
        end.
        
                        
        finally:
            
            unsubscribe EV_FILES_PROCESSAR in this-procedure.
            unsubscribe EV_STATUS_PROC_CANCELAR in hd-status.

            delete object hd-status.    
        end.
    end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI windowMain  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  if session:display-type = "GUI":U and VALID-HANDLE(windowMain)
  then delete widget windowMain.
  if this-procedure:persistent then delete procedure this-procedure.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI windowMain  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  view frame frameDefault in window windowMain.
  {&OPEN-BROWSERS-IN-QUERY-frameDefault}
  display checkUtilizarPropath 
      with frame frameSuperior in window windowMain.
  enable rectSuperior buttonPesquisar checkUtilizarPropath 
      with frame frameSuperior in window windowMain.
  {&OPEN-BROWSERS-IN-QUERY-frameSuperior}
  enable rectCorpo browseDados buttonExportar 
      with frame frameCorpo in window windowMain.
  {&OPEN-BROWSERS-IN-QUERY-frameCorpo}
  enable buttonSair 
      with frame frameRodape in window windowMain.
  {&OPEN-BROWSERS-IN-QUERY-frameRodape}
  view windowMain.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eventoLerArquivo windowMain 
procedure eventoLerArquivo :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-caminho-relativo     as   character  no-undo. 
    
    run mostrarMensagem in hd-status (input  substitute ('Lendo arquivo &1', ch-caminho-relativo)) no-error.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eventoStatus windowMain 
procedure eventoStatus :
/*------------------------------------------------------------------------------
 Purpose:
 Notes: 
------------------------------------------------------------------------------*/
    define variable lg-confirmar        as   logical    no-undo.
     
    message "Confirma cancelar o processamento?" 
    view-as alert-box question buttons yes-no update lg-confirmar.
    
    if not lg-confirmar 
    then return.
    
    run abortarProcessamento in hd-files.  
 
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializarInterface windowMain 
procedure inicializarInterface private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    run widgetInicializar. 
    
    run widgetRedimencionar (frame frameDefault:handle). 
     
    run widgetRedimencionarX (frame frameSuperior:handle).
    run widgetAlinharHorizontal (buttonPesquisar:handle, ALINHAR_HORIZONTAL_DIREITA).
    run widgetRedimencionarX (rectSuperior:handle).
    
    run widgetRedimencionar (frame frameCorpo:handle).
    run widgetRedimencionar (browse browseDados:handle).
    run widgetAlinharHorizontal (buttonExportar:handle, ALINHAR_HORIZONTAL_DIREITA).
    run widgetRedimencionar (rectCorpo:handle).
    
    run widgetRedimencionarX (frame frameRodape:handle).
    run widgetAlinharVertical (frame frameRodape:handle, ALINHAR_VERTICAL_INFERIOR).
    run widgetAlinharHorizontal (buttonSair:handle, ALINHAR_HORIZONTAL_DIREITA).
    
    run thealth/programas/files.p persistent set hd-files.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

