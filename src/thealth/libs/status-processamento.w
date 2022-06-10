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
{thealth/libs/status-processamento.i}
/* Parameters Definitions ---                                           */

define input  parameter ch-titulo-janela                as   character  no-undo.
define input  parameter lg-permite-cancelar             as   logical    no-undo.

/* Local Variable Definitions ---                                       */
define variable lg-iniciada                             as   logical    no-undo.

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
&Scoped-Define ENABLED-OBJECTS buttonCancelar 
&Scoped-Define DISPLAYED-OBJECTS editorStatus 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button buttonCancelar auto-end-key 
     image-up file "thealth/assets/cancel_24_24.jpg":U no-focus flat-button
     label "Cancelar" 
     size 6 by 1.43
     bgcolor 8 .

define variable editorStatus as character 
     view-as editor scrollbar-vertical no-box
     size 72 by 6.19 no-undo.


/* ************************  Frame Definitions  *********************** */

define frame frameDialog
     buttonCancelar at row 1 col 68.4
     editorStatus at row 2.43 col 2 no-label widget-id 2
     space(0.59) skip(0.13)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         bgcolor 15 font 1
         title "<insert dialog title>"
         cancel-button buttonCancelar widget-id 100.


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

/* SETTINGS FOR EDITOR editorStatus IN FRAME frameDialog
   NO-ENABLE                                                            */
assign 
       editorStatus:READ-ONLY in frame frameDialog        = true.

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
    run disparaCancelar.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frameDialog 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE centralizarJanela frameDialog 
procedure centralizarJanela :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disparaCancelar frameDialog 
procedure disparaCancelar :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    publish EV_STATUS_PROC_CANCELAR.
    process events.
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
  display editorStatus 
      with frame frameDialog.
  enable buttonCancelar 
      with frame frameDialog.
  view frame frameDialog.
  {&OPEN-BROWSERS-IN-QUERY-frameDialog}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializarInterface frameDialog 
procedure inicializarInterface :
/*------------------------------------------------------------------------------
 Purpose:
 Notes: 
------------------------------------------------------------------------------*/
    if not lg-permite-cancelar
    then do:
        
        assign editorStatus:row in frame frameDialog    = 1
               editorStatus:height-chars                = editorStatus:height-chars + buttonCancelar:height-chars
               buttonCancelar:visible                   = no
               .
    end.
    else do:
        
        assign buttonCancelar:visible   = yes.    
    end.
    
    frame frameDialog:title = ch-titulo-janela.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrarMensagem frameDialog 
procedure mostrarMensagem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define input  parameter ch-mensagem         as   character  no-undo.

    if not lg-iniciada
    then do:
        
        run enable_UI.
        
        run inicializarInterface.
         
        run centralizarJanela.
        
        assign lg-iniciada  = yes. 
    end.
    
    assign editorStatus:screen-value in frame frameDialog   = ch-mensagem.
    process events.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

