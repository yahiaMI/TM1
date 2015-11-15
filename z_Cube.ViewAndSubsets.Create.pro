601,100
602,"z_Cube.ViewAndSubsets.Create"
562,"NULL"
586,
585,
564,
565,"wApW9i[LfpK4sJ]`w0JwHHga:Uu``F8xE:[6Tjuor8vp<mZQJDX9<jI4RAr3V3>5]MRDmpj=gLv6qI^]ri[M5oGx:QM_7\e\PyRX7AG^TCZeGAD?NK1Ts3ryjC5581lrlC24qts:R:QMJCLvTBOi34OlxDlkG\3y3g7gwXkNjaOoov^c\5sVBVz`a8EKNv`SKztkAIIy"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,
568,""""
570,
571,
569,0
592,0
599,1000
560,9
pCube
pSuppressZero
pSuppressConsol
pSuppressRules
pDelimDim
pDelimElem
pView
pFilter
pDebug
561,9
2
1
1
1
2
2
2
2
1
590,9
pCube,"Z_ADMIN_PARAM"
pSuppressZero,1
pSuppressConsol,1
pSuppressRules,1
pDelimDim,"&"
pDelimElem,"+"
pView,"TEST"
pFilter,"Z_ADMIN_PARAM+BKP_DIR&Z_VAR_TXT+STR_VAR1"
pDebug,1
637,9
pCube,Cube
pSuppressZero,Suppress Zeros (Boolean Yes = 1)
pSuppressConsol,Suppress Calcs (Boolean Yes = 1)
pSuppressRules,Suppress Rules (Boolean Yes = 1)
pDelimDim,Dimension Delimiter
pDelimElem,Element Delimiter
pView,View
pFilter,pFilter
pDebug,Debug Mode
577,0
578,0
579,0
580,0
581,0
582,0
572,192

#****Begin: Generated Statements***
#****End: Generated Statements****

# This process creates a processing view for the cube and for specified dimensions of the cube
# It creates empty subsets and assigns the empty subsets to the view.

# Note:
# - A subsequent process is required to insert elements into subsets otherwise the
#   views will not contain any data!

# pCube = '';
# pSuppressZero = 1;
# pSuppressConsol = 1;
# pSuppressRules = 1;
# pDelimDim = '&';
# pDelimElem = '+';
# pView = P_NAME;
# pFilter = '';
# pDebug = 0;
# ExecuteProcess('z_Cube.ViewAndSubsets.Create', 'pCube', pCube, 'pSuppressZero', pSuppressZero, 'pSuppressConsol', pSuppressConsol, 'pSuppressRules', pSuppressRules, pDelimDim,'pDelimDim', pDelimElem, 'pView', pView, 'pFilter', pFilter, 'pDebug', pDebug);   
### Constants ###

cProcess = 'z_Cube.ViewAndSubsets.Create' ;
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
cDebugFile = GetProcessErrorFileDirectory | cProcess | '.' | cTimeStamp | '.';


### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Prolog.debug';

  # Log start time
  AsciiOutput( sDebugFile, 'Process Started: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

  # Log parameters
  AsciiOutput( sDebugFile, 'Parameters: pCube           : ' | pCube );
  AsciiOutput( sDebugFile, '            pSuppressZero   : ' | NumberToString( pSuppressZero ) );
  AsciiOutput( sDebugFile, '            pSuppressConsol : ' | NumberToString( pSuppressConsol ) );
  AsciiOutput( sDebugFile, '            pSuppressRules  : ' | NumberToString( pSuppressRules ) );
  AsciiOutput( sDebugFile, '            pDelimDim     : ' | pDelimDim );
  AsciiOutput( sDebugFile, '            pDelimElem     : ' | pDelimElem );
  AsciiOutput( sDebugFile, '            pView           : ' | pView );
  AsciiOutput( sDebugFile, '            pFilter         : ' | pFilter );

EndIf;


### Validate Parameters ###

nErrors = 0;

# Validate cube
If( Trim( pCube ) @= '' );
  nErrors = 1;
  sMessage = 'No cube specified';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;
If( CubeExists( pCube ) = 0 );
  nErrors = 1;
  sMessage = 'Cube: ' | pCube | ' does not exist';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

# Validate suppression parameters
If( pSuppressZero <> 0 & pSuppressZero <> 1 );
  nErrors = 1;
  sMessage = 'Invalid value for suppress zero parameter';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

If( pSuppressConsol <> 0 & pSuppressConsol <> 1 );
  nErrors = 1;
  sMessage = 'Invalid value for suppress consol parameter';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

If( pSuppressRules <> 0 & pSuppressRules <> 1 );
  nErrors = 1;
  sMessage = 'Invalid value for suppress rules parameter';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

# TODO Validate view and subsets


# Validate delimiter
If( pDelimDim @= '' );
  pDelimDim = '&';
EndIf;

If( pDelimElem @= '' );
  pDelimElem = '+';
EndIf;

### Build View ###

# The name of the subets will be the view name.

If( ViewExists( pCube, pView ) = 1);
	ViewDestroy( pCube, pView );
EndIf;
ViewCreate( pCube, pView );

cSubset = pView;
If( pDebug >= 1 );
  AsciiOutput( sDebugFile, 'Cube: ' | pCube |', View: ' | pView );
EndIf;

sFilter = pFilter;
nDelimDimIndex = 1;

# Split filter into seperate dimensions
While( nDelimDimIndex <> 0 & Long( sFilter ) > 0 );

  nDelimDimIndex = Scan( pDelimDim, sFilter );
  If( nDelimDimIndex <> 0 );
    sArgument = Trim( SubSt( sFilter, 1, nDelimDimIndex - 1 ) );
    sFilter = Trim( SubSt( sFilter, nDelimDimIndex + Long( pDelimDim ), Long( sFilter ) ) );
  Else;
    sArgument = Trim( sFilter );
  EndIf;

  # Split argument into dimension and elements
  nDelimElemIndex = Scan( pDelimElem, sArgument );
  If( nDelimElemIndex = 0 );
    # Argument does not contain at least one delimiter (the first delimiter seperates the dimension name from the elements)
    nErrors = 1;
    sMessage = 'Filter not specified correctly: ' | sArgument;
    If( pDebug >= 1 );
      AsciiOutput( sDebugFile, sMessage );
    EndIf;
    ItemReject( sMessage );
  EndIf;

  sDimension = Trim( SubSt( sArgument, 1, nDelimElemIndex - 1 ) );
  sElements = Trim( SubSt( sArgument, nDelimElemIndex + 1, Long( sArgument ) ) );

  # Check that dimension exists in the cube
  If( DimensionExists( sDimension ) = 1 );
    # Step 3: Create subset and assign to view
    If( pDebug <= 1 );

      ExecuteProcess( 'z_Dim.Sub.Create.ByElement',
        'pDimension', sDimension,
        'pSubset', cSubset,
        'pElements', sElements,
        'pDelimiter', pDelimElem,
        'pAddToSubset',0,
        'pDebug',0
      );
      If( SubsetGetSize( sDimension, cSubset ) > 0 );
        ViewSubsetAssign(pCube, pView, sDimension, cSubset);
      Else;
        # Empty subset created. Cancel process
        nErrors = 1;
        sMessage = 'Dimension: ' | sDimension | ' created an empty subset';
        If( pDebug >= 1 );
          AsciiOutput( sDebugFile, sMessage );
        EndIf;
        ItemReject( sMessage );
      EndIf;
    EndIf;
  Else;
    # The dimension does not exist in the model. Cancel process
    nErrors = 1;
    sMessage = 'Dimension: ' | sDimension | ' does not exist';
    If( pDebug >= 1 );
      AsciiOutput( sDebugFile, sMessage );
    EndIf;
    ItemReject( sMessage );
  EndIf;
End;
### End Prolog ###
573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,4

#****Begin: Generated Statements***
#****End: Generated Statements****

575,31

#****Begin: Generated Statements***
#****End: Generated Statements****


### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Epilog.debug';

  # Log errors
  If( nErrors <> 0 );
    AsciiOutput( sDebugFile, 'Errors Occurred' );
  EndIf;

  # Log finish time
  AsciiOutput( sDebugFile, 'Process Finished: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

EndIf;


### If errors occurred terminate process with a major error status ###

If( nErrors <> 0 );
  ProcessQuit;
EndIf;


### End Epilog ###
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
