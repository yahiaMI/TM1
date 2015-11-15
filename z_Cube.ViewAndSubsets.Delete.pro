601,100
602,"z_Cube.ViewAndSubsets.Delete"
562,"NULL"
586,
585,
564,
565,"w0TAS>cyn7EW\oaM7\cXlbXaqw`@8j_shVyf3Ew>r\5LR;dTcTj0jP\dFg;7I1]ghY0wHx<a5GxPxpsd6lQ<R\sWt@:I[7rEv\bpGdq88uZb9RpTyLTPCh`KaGQ=7^7ZZ][tQIE_xL`uSydIfinrX3s7EEP^jKs=xkE<>j<_Rud3T]H8UPtldFIaGFK]dCT?^DeV:rg<"
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
560,3
pCube
pView
pDebug
561,3
2
2
1
590,3
pCube,"Z_ADMIN_PARAM"
pView,"TEST"
pDebug,0
637,3
pCube,Cube
pView,View
pDebug,Debug Mode
577,0
578,0
579,0
580,0
581,0
582,0
572,82

#****Begin: Generated Statements***
#****End: Generated Statements****

# This process delete a processing view for the cube and for specified view name

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
  AsciiOutput( sDebugFile, '            pView           : ' | pView );

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

# TODO View validation 

ViewDestroy(pCube,pView);

cSubset = pView;

nDimensionIndex = 1;
sDimension = TabDim( pCube, nDimensionIndex );

While( sDimension @<> '' );

	If( SubsetExists( sDimension, cSubset ) = 1 );
	
		SubsetDestroy(sDimension, cSubset); 
		
	EndIf;

	nDimensionIndex = nDimensionIndex + 1;
	sDimension = TabDim( pCube, nDimensionIndex );
	
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
