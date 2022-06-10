
/*------------------------------------------------------------------------
    File        : color-template.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Aug 25 11:29:08 BRT 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

define variable COLOR-TABLE-ROW-ALTERNATE           as   integer    init 21 no-undo.
define variable COLOR-TABLE-ROW-SELECTED            as   integer    init 22 no-undo.
define variable COLOR-ERROR                         as   integer    init 23 no-undo.
define variable COLOR-SUCCESS                       as   integer    init 24 no-undo.
define variable COLOR-WARNING                       as   integer    init 25 no-undo.
define variable COLOR-DISABLED                      as   integer    init 26 no-undo.
define variable COLOR-MONEY-NEGATIVE                as   integer    init 27 no-undo.
define variable COLOR-BLACK                         as   integer    init 28 no-undo.
define variable COLOR-BROWSE-TITLE                  as   integer    init 29 no-undo.
define variable COLOR-BROWSE-TITLE-FOCUS            as   integer    init 30 no-undo.



                          

color-table:num-entries = 45.

color-table:set-dynamic (COLOR-TABLE-ROW-ALTERNATE, true).
color-table:set-rgb-value (COLOR-TABLE-ROW-ALTERNATE, rgb-value (204, 229, 255)).

color-table:set-dynamic (COLOR-TABLE-ROW-SELECTED, true).
color-table:set-rgb-value (COLOR-TABLE-ROW-SELECTED, rgb-value (108, 119, 216)).

color-table:set-dynamic (COLOR-ERROR, true).
color-table:set-rgb-value (COLOR-ERROR, rgb-value (215, 44, 44)).

color-table:set-dynamic (COLOR-SUCCESS, true).
color-table:set-rgb-value (COLOR-SUCCESS, rgb-value (161, 212, 144)).

color-table:set-dynamic (COLOR-WARNING, true).
color-table:set-rgb-value (COLOR-WARNING, rgb-value (255, 255, 0)). 

color-table:set-dynamic (COLOR-WARNING, true).
color-table:set-rgb-value (COLOR-WARNING, rgb-value (207, 201, 52)).

color-table:set-dynamic (COLOR-DISABLED, true).
color-table:set-rgb-value (COLOR-DISABLED, rgb-value (210, 210, 210)).

color-table:set-dynamic (COLOR-MONEY-NEGATIVE, true).
color-table:set-rgb-value (COLOR-MONEY-NEGATIVE, rgb-value (255, 0, 0)).

color-table:set-dynamic (COLOR-BLACK, true).
color-table:set-rgb-value (COLOR-BLACK, rgb-value (0, 0, 0)).

color-table:set-dynamic (COLOR-BROWSE-TITLE, true).
color-table:set-rgb-value (COLOR-BROWSE-TITLE, rgb-value (132, 130, 132)).

color-table:set-dynamic (COLOR-BROWSE-TITLE-FOCUS, true).
color-table:set-rgb-value (COLOR-BROWSE-TITLE-FOCUS, rgb-value (8, 36, 107)).


