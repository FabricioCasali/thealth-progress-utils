&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME dialoagMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dialoagMain 
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

/* Parameters Definitions ---                                           */

// recebe o handle da temp-table que cont‚m os campos do browse. ex: temp-table tmp-dados:handle
define input  parameter hd-browse-handle        as   handle     no-undo.
define input  parameter hd-tabela-handle        as   handle     no-undo.

define variable hd-ultimo-botao                 as   handle     no-undo.
define variable dc-linha                        as   decimal    no-undo.
define variable dc-coluna                       as   decimal    no-undo.

define variable dc-espaco                       as   decimal    init 0.05   no-undo.
define variable in-altura-botao                 as   integer    init 1      no-undo.

/* Local Variable Definitions ---                                       */

define temp-table temp-browse-coluna-ext    no-undo
    field ch-nome                           as   character  serialize-name 'nome'
    field dc-width                          as   decimal    serialize-name 'largura'
    field in-posicao                        as   integer    serialize-name 'ordem'
    field lg-visivel                        as   logical    serialize-name 'visivel'
    field hd-imagem                         as   handle     serialize-hidden
    field hd-botao                          as   handle     serialize-hidden
    field dc-linha                          as   decimal    serialize-hidden
    index idx1
          as primary
          ch-nome
    index idx2
          dc-linha
    index idx3
          dc-linha descending          
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME D:\Downloads\widgetid.xml

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME dialoagMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buttonOk 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatarPrivateData dialoagMain 
function formatarPrivateData returns character private
  (hd-campo as handle,
   hd-image as handle   ) forward.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button buttonOk auto-go 
     label "OK" 
     size 15 by 1.14
     bgcolor 8 .


/* ************************  Frame Definitions  *********************** */

define frame dialoagMain
     buttonOk at row 14.33 col 66
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         bgcolor 15 font 2
         title "<insert dialog title>"
         default-button buttonOk widget-id 100.

define frame frameColunas
    with 1 down no-box keep-tab-order overlay 
         side-labels no-underline 
         at col 1 row 1
         scrollable size 80 by 13.33
         bgcolor 15 font 2 drop-target widget-id 200.


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
/* REPARENT FRAME */
assign frame frameColunas:FRAME = frame dialoagMain:HANDLE.

/* SETTINGS FOR DIALOG-BOX dialoagMain
   FRAME-NAME                                                           */

define variable XXTABVALXX as logical no-undo.

assign XXTABVALXX = frame frameColunas:MOVE-BEFORE-TAB-ITEM (buttonOk:HANDLE in frame dialoagMain)
/* END-ASSIGN-TABS */.

assign 
       frame dialoagMain:SCROLLABLE       = false
       frame dialoagMain:HIDDEN           = true.

/* SETTINGS FOR FRAME frameColunas
                                                                        */
assign 
       frame frameColunas:HEIGHT           = 13.33
       frame frameColunas:WIDTH            = 80.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME dialoagMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dialoagMain dialoagMain
on window-close of frame dialoagMain /* <insert dialog title> */
do:
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buttonOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonOk dialoagMain
on choose of buttonOk in frame dialoagMain /* OK */
do:
    run atualizarColunas.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buttonOk dialoagMain
on start-move of buttonOk in frame dialoagMain /* OK */
do:
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dialoagMain 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  run inicializarInterface.
  run enable_UI.
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarColunas dialoagMain 
procedure atualizarColunas private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable hd-coluna       as   handle     no-undo.
    define variable in-conta        as   integer    no-undo.
    define variable lg-moveu        as   logical    no-undo.
    
    repeat:
        
        assign lg-moveu = no.
        
        do in-conta = 1 to hd-browse-handle:num-columns:
            
            assign hd-coluna    = hd-browse-handle:get-browse-column (in-conta).
            
            log-manager:write-message (substitute ("acomp  > lendo coluna &1", hd-coluna:name), "DEBUG") no-error.
                    
            find first temp-browse-coluna-ext
                 where temp-browse-coluna-ext.ch-nome   = hd-coluna:name.
                 
            assign hd-coluna:visible    = temp-browse-coluna-ext.hd-imagem:private-data = 'yes'.
            
            if temp-browse-coluna-ext.in-posicao   <> in-conta
            then do:
                
                hd-browse-handle:move-column (IN-CONTA, temp-browse-coluna-ext.in-posicao).
                
                assign lg-moveu = yes.
                leave.
            end.
            
            if not hd-browse-handle:fit-last-column
            then do:
                
                assign hd-coluna:width-chars    = temp-browse-coluna-ext.dc-linha.
            end.
        end.
        
        if not lg-moveu
        then leave.
    end. 
    
     
    // caso esteja ligado o parametro para redimencionar a ultima coluna, 
    // passa novamente pelo browse atualizando o tamanho pois ao movimentar a ordem das colunas
    // algumas podem acabar com o tamanho errado
    if hd-browse-handle:fit-last-column
    then do:
        
        do in-conta = 1 to hd-browse-handle:num-columns:
            
            assign hd-coluna    = hd-browse-handle:get-browse-column (in-conta).
            
            find first temp-browse-coluna-ext
                 where temp-browse-coluna-ext.ch-nome   = hd-coluna:name.
            
            assign hd-coluna:width-chars    = temp-browse-coluna-ext.dc-width.
        end.        
    end.
    

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dialoagMain  _DEFAULT-DISABLE
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
  hide frame dialoagMain.
  hide frame frameColunas.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI dialoagMain  _DEFAULT-ENABLE
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
  enable buttonOk 
      with frame dialoagMain.
  view frame dialoagMain.
  {&OPEN-BROWSERS-IN-QUERY-dialoagMain}
  view frame frameColunas.
  {&OPEN-BROWSERS-IN-QUERY-frameColunas}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializarInterface dialoagMain 
procedure inicializarInterface private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable in-conta                as   integer    no-undo.
    define variable dc-linha                as   decimal    no-undo.
    define variable hd-tabela-buffer        as   handle     no-undo.
    define variable hd-botao                as   handle     no-undo.
    define variable hd-imagem               as   handle     no-undo.
    define variable ch-nome-coluna          as   character  no-undo.
        
    assign hd-tabela-buffer             = hd-tabela-handle:default-buffer-handle
           dc-linha                     = 0
           frame frameColunas:visible   = no
           frame dialoagMain:title      = 'Configurar colunas'
           . 
           
    
    empty temp-table temp-browse-coluna-ext.           
           
    do in-conta = 1 to hd-browse-handle:num-columns:
        
        create temp-browse-coluna-ext.
        assign ch-nome-coluna                           = hd-browse-handle:get-browse-column(in-conta):name
               temp-browse-coluna-ext.ch-nome           = ch-nome-coluna
               temp-browse-coluna-ext.dc-width          = hd-browse-handle:get-browse-column(in-conta):width-chars
               temp-browse-coluna-ext.in-posicao        = in-conta
               temp-browse-coluna-ext.lg-visivel        = hd-browse-handle:get-browse-column(in-conta):visible
               .
               
                           
        // os campos que estiverem com serialize-hidden nao podem ser ocultos.
        if hd-tabela-buffer:buffer-field(ch-nome-coluna):serialize-hidden
        then next.
        
        assign dc-linha = dc-linha + in-altura-botao + dc-espaco.
        if dc-linha > frame frameColunas:height-chars
        then do:
            // vai aumentando o espa‡o interno do frame a cada itera‡Æo, mas tem que adicionar sempre uma pequna folga ou o progress
            // reclama que o objeto nao cabe no frame
            frame frameColunas:virtual-height-chars = dc-linha + 2. 
        end.

        create button  hd-imagem 
               assign frame         = frame frameColunas:handle
                      row           = dc-linha
                      col           = frame frameColunas:width - 13
                      height-chars  = in-altura-botao
                      width-chars   = 4
                      private-data  = 'yes' // define se o campo esta visivel ou nÆo.
                      flat-button   = yes
                      visible       = yes
                      sensitive     = yes
                      triggers:
                           on choose persistent run trocaStatus in this-procedure.
                      end.
                      
        hd-imagem:load-mouse-pointer ('glove').                      
        hd-imagem:load-image ("thealth/assets/visible_18_18.jpg").
                              
        
        create button hd-botao 
               assign frame         = frame frameColunas:handle
                      row           = dc-linha
                      col           = 1
                      //label         = substring (hd-tabela-buffer:buffer-field(ch-nome-coluna):label, 1, 30)
                      label         = substring (hd-browse-handle:get-browse-column(in-conta):label , 1, 30)
                      private-data  = formatarPrivateData (hd-tabela-buffer:buffer-field(ch-nome-coluna), hd-imagem)
                      height-chars  = in-altura-botao
                      width-chars   = frame frameColunas:width - 20
                      //flat-button   = yes
                      visible       = yes
                      sensitive     = yes
                      movable       = yes
                      triggers:
                           on choose persistent run trocaStatus in this-procedure.
                           on start-move persistent run moverIniciar in this-procedure.
                           on end-move persistent run moverFinalizar in this-procedure.
                      end.

        hd-botao:load-mouse-pointer ('glove').                      
                    
        assign temp-browse-coluna-ext.hd-botao      = hd-botao
               temp-browse-coluna-ext.hd-imagem     = hd-imagem
               temp-browse-coluna-ext.dc-linha      = hd-botao:row
               .
               
        if not temp-browse-coluna-ext.lg-visivel    
        then do:
 
            assign temp-browse-coluna-ext.hd-imagem:private-data = 'no'.
            temp-browse-coluna-ext.hd-imagem:load-image ("thealth/assets/hidden_18_18.jpg"). 
        end.               
    end. 
    
    assign frame frameColunas:visible   = yes.
    frame frameColunas:virtual-height-chars = dc-linha.
    frame frameColunas:move-to-top ().

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moverFinalizar dialoagMain 
procedure moverFinalizar private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    log-manager:write-message (substitute ("acomp  > finalizando: &1", self:name), "DEBUG") no-error.
    run reorganizarWidgets. 
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moverIniciar dialoagMain 
procedure moverIniciar private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    log-manager:write-message (substitute ("acomp  > iniciando: &1", self:name), "DEBUG") no-error.
    
    assign hd-ultimo-botao  = self
           dc-linha         = self:row
           dc-coluna        = self:column
           .

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorganizarWidgets dialoagMain 
procedure reorganizarWidgets :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
    define variable lg-sobe             as   logical    no-undo.
    define variable lg-moveu            as   logical    no-undo.
    define variable dc-nova-posicao     as   decimal    no-undo.
    define variable dc-posicao-calc     as   decimal    no-undo.    
    define variable hd-query            as   handle     no-undo.
    define variable in-conta            as   integer    no-undo.

    if dc-linha = hd-ultimo-botao:row 
    then return.
    
    create query hd-query.
    hd-query:set-buffers (buffer temp-browse-coluna-ext:handle).
    
    assign lg-sobe  = hd-ultimo-botao:row < dc-linha.    

    if lg-sobe
    then hd-query:query-prepare ('preselect each temp-browse-coluna-ext use-index idx2').
    else hd-query:query-prepare ('preselect each temp-browse-coluna-ext use-index idx3').     
    
    hd-query:query-open().
    
    repeat:
        
        hd-query:get-next().
        if hd-query:query-off-end then leave.
        
        if  lg-sobe
        then do:

            if temp-browse-coluna-ext.dc-linha  < hd-ultimo-botao:row
            then next.
            
            if not lg-moveu
            then do:

                assign lg-moveu         = yes
                       dc-nova-posicao  = temp-browse-coluna-ext.dc-linha
                       dc-posicao-calc  = temp-browse-coluna-ext.dc-linha
                       .
            end.        
            
            if temp-browse-coluna-ext.hd-botao  = hd-ultimo-botao
            then do:
                
                assign temp-browse-coluna-ext.dc-linha  = dc-nova-posicao.
            end.
            else do:
                
                assign dc-posicao-calc                  = dc-posicao-calc + in-altura-botao + dc-espaco 
                       temp-browse-coluna-ext.dc-linha  = dc-posicao-calc.
           end.            
        end.
        else do:
            
            if temp-browse-coluna-ext.dc-linha  > hd-ultimo-botao:row
            then next.
            
            if not lg-moveu
            then do:
                
                assign lg-moveu         = yes
                       dc-nova-posicao  = temp-browse-coluna-ext.dc-linha
                       dc-posicao-calc  = temp-browse-coluna-ext.dc-linha
                       . 
            end.        
            
            if temp-browse-coluna-ext.hd-botao  = hd-ultimo-botao
            then do:
                
                assign temp-browse-coluna-ext.dc-linha  = dc-nova-posicao.
            end.
            else do:
                
                assign dc-posicao-calc                  = dc-posicao-calc - in-altura-botao - dc-espaco 
                       temp-browse-coluna-ext.dc-linha  = dc-posicao-calc.
            end.  
        end.
    end.    
    
    
    for each temp-browse-coluna-ext
   use-index idx2:
        
        assign temp-browse-coluna-ext.hd-botao:row      = temp-browse-coluna-ext.dc-linha
               temp-browse-coluna-ext.hd-botao:column   = 1
               temp-browse-coluna-ext.hd-imagem:row     = temp-browse-coluna-ext.dc-linha
               in-conta                                 = in-conta + 1
               temp-browse-coluna-ext.in-posicao        = in-conta.
               .
    end.
    
    delete object hd-query.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trocaStatus dialoagMain 
procedure trocaStatus private :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable hd-botao-imagem as handle no-undo.
    
    if num-entries (self:private-data, '|') = 3
    then do:
        
        hd-botao-imagem = handle (entry (3, self:private-data, '|') ).
    end.
    else do:
        
        hd-botao-imagem = self.
    end.
    
    if hd-botao-imagem:private-data = 'yes' 
    then do:
        
        assign hd-botao-imagem:private-data = 'no'.
        hd-botao-imagem:load-image ("thealth/assets/hidden_18_18.jpg").
    end.
    else do:
        assign hd-botao-imagem:private-data = 'yes'.
        hd-botao-imagem:load-image ("thealth/assets/visible_18_18.jpg").
    end.
    
    
    

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatarPrivateData dialoagMain 
function formatarPrivateData returns character private
  (hd-campo as handle,
   hd-image as handle   ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    define variable ch as character no-undo.
    
    assign ch = hd-campo:name + "|" + hd-campo:data-type + "|" + string (hd-image).
    return ch. 
    
end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

