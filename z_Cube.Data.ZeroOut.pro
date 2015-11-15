601,100
602,"z_Cube.Data.ZeroOut"
562,"NULL"
586,
585,
564,
565,"aagHvxVAju[KmbAL^U0\^vv1PckcJgQRG5zQnYQLu5s;pcn]V7_PU^nfAgcAdx:y0sdLaR:T^dF1yVr6\eBut9_t\y>Z@y4_3Pm=[5>vtGW7@>zJPv2Ch4j[liVhQv9l\@PNaIm>UB]k^OpR<usyh>KWPh7:s4W5a[cbQ]Q5TZNg?obaq?OV7iQBbSVAP6XW6h2g]C5p"
559,0
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
560,5
pCube
pDelimDim
pDelimElem
pFilter
pDebug
561,5
2
2
2
2
1
590,5
pCube,"COEURG_FISCA"
pDelimDim,"&"
pDelimElem,"+"
pFilter,"COEURG_VERSION+Version_2013&COEURG_ANNEE_RELATIVE+N-1&COEURG_NATURE+NATURE_CFE+NATURE_CCI+NATURE_TB+NATURE_TEOM+NATURE_TH+NATURE_TLV+NATURE_THLV+NATURE_TSB&COEURG_FISCA_INDIC+MT_BRUT"
pDebug,1
637,5
pCube,Cube Name
pDelimDim,Dimension Delimiter
pDelimElem,Element Delimiter
pFilter,Filter (Dim 1 + Elem1 + Elem2
pDebug,Debug Mode
577,0
578,0
579,0
580,0
581,0
582,0
572,177

#****Begin: Generated Statements***
#****End: Generated Statements****



# This process automatically creates a view, zeros it out and delete the view.
# It can handle specific element references for any number of dimensions and elements.

# Note:
# - The pFilter parameter contains the dimenson and elements to be used for filtering.
# - The format of the pFilter parameter is as follows (using the default delimiters of & and +):
#     Dim1+Elem1+Elem2&Dim2+Elem3+Elem4
# - The dimension parameters do not need to be given in the index order of dimensions in the cube.
# - The dimension name is specified as the first member of the delimited string of elements.

#pFilter = '';
#ExecuteProcess('z_Cube.Data.ZeroOut','pCube',zcubecible,'pDelimDim','&','pDelimElem','+','pFilter',pFilter,'pDebug',0);


### Constants ###

cProcess = GetProcessName();
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
cDebugFile = GetProcessErrorFileDirectory | cProcess | '.' | cTimeStamp | '.';
cView = '' | cProcess | '.' | NumberToString( ROUND( RAND( ) *100000 ) );
cSubset = cView;


### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Prolog.debug';

  # Log start time
  AsciiOutput( sDebugFile, 'Process Started: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

  # Log parameters
  AsciiOutput( sDebugFile, 'Parameters: pCube      : ' | pCube );
  AsciiOutput( sDebugFile, '            pDelimDim  : ' | pDelimDim );
  AsciiOutput( sDebugFile, '            pDelimElem : ' | pDelimElem );
  AsciiOutput( sDebugFile, '            pFilter    : ' | pFilter );

EndIf;


### Validate Parameters ###

nErrors = 0;

# If blank delimiter specified then convert to default
If( Trim( pDelimDim ) @= '' );
  pDelimDim = '&';
EndIf;

If( Trim( pDelimElem ) @= '' );
  pDelimElem = '+';
EndIf;

# If no cube has been specified then terminate process
If( Trim( pCube ) @= '' );
  nErrors = 1;
  sMessage = 'No cube specified';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

# If specified cube does not exist then terminate process
If( CubeExists( pCube ) = 0 );
  nErrors = 1;
  sMessage = 'Cube: ' | pCube | ' does not exist';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;


### Create View ###

If( pDebug <= 1 );
  If( ViewExists( pCube, cView ) = 1 );
    ViewDestroy( pCube, cView );
  EndIf;
  ViewCreate( pCube, cView );
EndIf;


### Split filter and create subsets ###


sFilter = pFilter;
nDelimDimIndex = 1;

#for view & subset deletion
sFilter_Delete = pFilter;

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
        'pAddToSubset',1,
        'pDebug',0
      );
      If( SubsetGetSize( sDimension, cSubset ) > 0 );
        ViewSubsetAssign(pCube, cView, sDimension, cSubset);
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


### Zero Out View ###
If( pDebug >= 1 );
  AsciiOutput( sDebugFile, 'View and Subsets created' );
EndIf;
If( pDebug <= 1 );
  ViewZeroOut( pCube, cView );
EndIf;


### End Prolog ###
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,98

#****Begin: Generated Statements***
#****End: Generated Statements****



### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Epilog.debug';


EndIf;




### View deletion ###
ViewDestroy(pCube, cView);


### Subset deletion ###

### Split filter and create subsets ###



nDelimDimIndex = 1;

# Split filter into seperate dimensions
While( nDelimDimIndex <> 0 & Long( sFilter_Delete ) > 0 );

  nDelimDimIndex = Scan( pDelimDim, sFilter_Delete );
  If( nDelimDimIndex <> 0 );
    sArgument = Trim( SubSt( sFilter_Delete, 1, nDelimDimIndex - 1 ) );
    sFilter_Delete = Trim( SubSt( sFilter_Delete, nDelimDimIndex + Long( pDelimDim ), Long( sFilter_Delete ) ) );
  Else;
    sArgument = Trim( sFilter_Delete );
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
    If( pDebug <= 1 );
		SubsetDestroy(sDimension, cSubset);
		sMessage = 'Dimension: ' | sDimension | ' subset deletion OK';
    EndIf;
  Else;
	nErrors = 1;
    sMessage = 'Dimension: ' | sDimension | ' does not exist';
    If( pDebug >= 1 );
      AsciiOutput( sDebugFile, sMessage );
    EndIf;
    ItemReject( sMessage );
  EndIf;
End;


### Debug ###

If( pDebug >= 1 );


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
1217,1
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
918,0
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
