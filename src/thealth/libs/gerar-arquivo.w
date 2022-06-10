&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frameDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frameDialog 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{thealth/libs/color-template.i}

/* Parameters Definitions ---                                           */
define input  parameter ch-caminho                  as   character  no-undo.
define input  parameter ch-arquivo                  as   character  no-undo.
define input  parameter lg-permite-alterar-nome     as   logical    no-undo.
define output parameter lg-confirmar                as   logical    no-undo. 
define output parameter ch-caminho-completo         as   character  no-undo.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME D:\Downloads\widgetid.xml

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frameDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buttonFolder textCaminho textNomeArquivo ~
buttonOk buttonCancelar 
&Scoped-Define DISPLAYED-OBJECTS textCaminho textNomeArquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button buttonCancelar auto-end-key 
     label "Cancelar" 
     size 15 by 1.14
     bgcolor 8 .

define button buttonFolder 
     image-up file "thealth/assets/folder_18_18.jpg":U no-focus flat-button
     label "" 
     size 6 by 1.14.

define button buttonOk auto-go 
     label "OK" 
     size 15 by 1.14
     bgcolor 8 .

define variable textCaminho as character format "X(256)":U 
     label "Salvar em" 
     view-as fill-in 
     size 64 by 1 no-undo.

define variable textNomeArquivo as character format "X(256)":U 
     label "Nome arquivo" 
     view-as fill-in 
     size 37.2 by 1 no-undo.


/* ************************  Frame Definitions  *********************** */

define frame frameDialog
     buttonFolder at row 1.91 col 80 widget-id 4
     textCaminho at row 1.95 col 14 colon-aligned widget-id 2
     textNomeArquivo at row 3.05 col 14.2 colon-aligned widget-id 6
     buttonOk at row 4.24 col 57.8
     buttonCancelar at row 4.24 col 73
     space(3.39) skip(0.13)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         bgcolor 15 font 1
         title "<insert dialog title>"
         default-button buttonOk cancel-button buttonCancelar widget-id 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX frameDialog
   FRAME-NAME                                                           */
assign 
       frame frameDialog:SCROLLABLE       = false
       frame frameDialog:HIDDEN           = true.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frameDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frameDialog frameDialog
on window-close of frame frameDialog /* <insert dialog title> */
do:
  apply "END-ERROR":U to self. 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buttonCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonCancelar frameDialog
on choose of buttonCancelar in frame frameDialog /* Cancelar */
do:
    assign lg-confirmar = no.
    apply 'close' to frame frameDialog.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buttonFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonFolder frameDialog
on choose of buttonFolder in frame frameDialog
do:
    run acaoSelecionarPasta.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buttonOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonOk frameDialog
on choose of buttonOk in frame frameDialog /* OK */
do:
    if textCaminho:bgcolor in frame frameDialog    <> ? 
    or textNomeArquivo:bgcolor                     <> ?
    then do:
        
        message 'Corrija os campos destacados para poder seguir com a gera‡Æo do arquivo.'
        view-as alert-box information buttons ok.
        return.
    end.
     
     
    assign lg-confirmar         = yes
           ch-caminho-completo  = textCaminho:screen-value.
    
    if  substring (ch-caminho-completo, length (ch-caminho-completo))  <> '/'
    and substring (ch-caminho-completo, length (ch-caminho-completo))  <> '\'
    then do:
        
        assign ch-caminho-completo  = ch-caminho-completo + '/'.
    end.
    
    assign ch-caminho-completo  = ch-caminho-completo + textNomeArquivo:screen-value.
    
    define variable lg-caminho-rede as logical no-undo.
    
    assign lg-caminho-rede  = ch-caminho-completo  matches ('\\*').
    
    assign ch-caminho-completo  = replace (ch-caminho-completo, '/', '\').
    
    if lg-caminho-rede
    then do:
        
        assign ch-caminho-completo  = substitute ('\\&1', substring (ch-caminho-completo, 3)).
    end.
    
    
    apply 'close' to frame frameDialog.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME textCaminho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL textCaminho frameDialog
on value-changed of textCaminho in frame frameDialog /* Salvar em */
do:
    run acaoValidarCaminho.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME textNomeArquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL textNomeArquivo frameDialog
on value-changed of textNomeArquivo in frame frameDialog /* Nome arquivo */
do:
    run acaoValidarNomeArquivo.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frameDialog 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK:
  run enable_UI.
  run inicializarInterface.
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acaoSelecionarPasta frameDialog 
procedure acaoSelecionarPasta private :
/*------------------------------------------------------------------------------
 Purpose: exibe a janela para selecionar a pasta de sa¡da.
 Notes:
------------------------------------------------------------------------------*/

    define variable lg-ok           as   logical    no-undo.
    define variable ch-caminho-s    as   character  no-undo.
    
    system-dialog get-dir ch-caminho-s
                  initial-dir ch-caminho
                  title 'Escolha o diret¢rio para salvar o arquivo'.
                  
    if  ch-caminho-s   <> ?
    and ch-caminho-s   <> ''
    then do:
        
        assign textCaminho:screen-value in frame frameDialog    = ch-caminho-s.                   
    end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acaoValidarCaminho frameDialog 
procedure acaoValidarCaminho private :
/*------------------------------------------------------------------------------
 Purpose: verifica se o caminho digitado/selecionado ‚ v lido.
 Notes:
------------------------------------------------------------------------------*/

    assign file-info:file-name  = textCaminho:screen-value in frame frameDialog.
    
    if file-info:file-name      = ?
    or not file-info:file-type  matches ('*D*')
    then do:
        
        assign textCaminho:bgcolor  = COLOR-ERROR.
    end.
    else do:
        
        assign textCaminho:bgcolor  = ?.
    end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acaoValidarNomeArquivo frameDialog 
procedure acaoValidarNomeArquivo private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    if self:screen-value         = ?
    or trim (self:screen-value)  = ''
    then do:
        
        assign self:bgcolor = COLOR-ERROR.
        return.
    end.
    
    if index (self:screen-value, '&') > 0
    or index (self:screen-value, ';') > 0
    or index (self:screen-value, '|') > 0
    or index (self:screen-value, '$') > 0
    or index (self:screen-value, '@') > 0
    then do:
        
        assign self:bgcolor = COLOR-ERROR.
        return.
    end.
    
    assign self:bgcolor = ?.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frameDialog  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  hide frame frameDialog.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frameDialog  _DEFAULT-ENABLE
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
  display textCaminho textNomeArquivo 
      with frame frameDialog.
  enable buttonFolder textCaminho textNomeArquivo buttonOk buttonCancelar 
      with frame frameDialog.
  view frame frameDialog.
  {&OPEN-BROWSERS-IN-QUERY-frameDialog}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializarInterface frameDialog 
procedure inicializarInterface private :
/*------------------------------------------------------------------------------
 Purpose: inicializa a interface e configura os campos
 Notes:
------------------------------------------------------------------------------*/
    
    if not lg-permite-alterar-nome
    then do:
        
        assign textNomeArquivo:sensitive in frame frameDialog   = no.
    end.
    
    assign textCaminho:screen-value     = ch-caminho
           textNomeArquivo:screen-value = ch-arquivo
           frame frameDialog:title      = 'Gerar arquivo em'.
           
    apply 'value-changed' to textCaminho.
    apply 'value-changed' to textNomeArquivo.           

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

