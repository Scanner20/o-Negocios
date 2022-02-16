**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\charts.vcx
**************************************************


**************************************************
*-- Class:        simplechart (k:\aplvfp\classgen\vcxs\charts.vcx)
*-- ParentClass:  olecontrol
*-- BaseClass:    olecontrol
*-- Time Stamp:   01/21/06 10:22:11 AM
*-- OLEObject = C:\WINDOWS\system32\mschrt20.ocx
*-- Class for simple bar and line charts (see Documentation method)
*
DEFINE CLASS simplechart AS olecontrol


	Height = 246
	Width = 274
	Visible = .F.
	*-- Alias of cursor or open table which contains the data for the chart
	calias = ""
	*-- Comma-separated list of the fields within the cursor which contain the data for the columns of the chart
	cdata = ""
	*-- Comma-separated list of column labels; used for legend (if any)
	clabels = ""
	*-- Name of field within the cursor which holds the row labels.
	crowlabels = ""
	*-- Comma-separated list of names of colours to use for bars or lines (e.g. Red, Blue, White)
	ccolours = ""
	*-- Chart's main title
	ctitle = ""
	*-- Text of chart's footnote
	cfootnote = ""
	Name = "simplechart"

	*-- Says whether to ignore any zero data points
	lignorezero = .F.

	*-- Says whether to show markers in the chart
	lshowmarkers = .F.


	*-- Call this to create or update the chart, using data from the cursor
	PROCEDURE createchart
		* This does all the work needed to create or update the chart. 
		* It uses data from a cursor or an open table whose alias is stored
		* in the cAlias property. 

		* To create a chart, follow these steps:
		*   - Fill a cursor or table with the data to be graphed.
		*   - Set cAlias to the alias of this cursor or table
		*   - In cData, place a comma-delimited list of the fields from the 
		*        cursor whose values you want to plot (these must be numeric)
		*   - In cRowLabels, store the name of the field from the cursor
		*        which contains the row labels (if any).
		*   -  In cLabels, store a comma-delimited list of the labels to be used
		*      for the legend; these must correspond one-to-one with the field names
		*      in cData.
		*   - Set other properties as necessary.
		*   - Call this method.
		* For further information, see the Documentation method.

		* The method performs simple error-checking, and returns .F. if the cAlias
		* or cData properties are invalid

		LOCAL lnFieldCount, lnCol, lnRow, lnLabCount, lnItem, lnI
		LOCAL lcColStr, lcColVal, lcRed, lcGreen, lcBlue
		LOCAL lnColIndex, lnColsToSet, lnRed, lnBlue, lnGreen

		WITH THIS

			* Keep the chart invisible while it is being constructed
			.Visible = .F.

			* Preliminary error-checking. If any of these checks fails,
			* just exit without doing anything

			* Check presence of cursor
			IF EMPTY(.cAlias) OR NOT USED(.cAlias)
				RETURN .F.
			ENDIF

			SELECT (.cAlias)

			* Check that the list of data fields is present
			IF EMPTY(.cData)
				RETURN .F.
			ENDIF

			lnFieldCount = ALINES(laData,STRTRAN(.cData,",",CHR(13)))
				&& the above line will fill an array with names of the fields
				&& to be plotted; lnFieldCount will hold the number of fields

			IF lnFieldCount = 0
				RETURN .F.
			ENDIF

			.columnCount = lnFieldCount
			.RowCount = 0

			* scan the cursor, filling the data points as we go
			COUNT FOR NOT DELETED() TO .RowCount
			lnRow = 1
			SCAN FOR NOT DELETED()

				.row = lnRow

				* Fill data points for this record
				FOR lnCol = 1 TO lnFieldCount
					.Column = lnCol
					lnItem = EVALUATE(laData(lnCol))
					IF lnItem>0 OR NOT .lIgnoreZero
						.Data = lnItem
					ENDIF
				ENDFOR

				* Fill the row label for this record
				IF NOT EMPTY(.cRowLabels)
					.rowLabel = EVALUATE(.cRowLabels)
				ENDIF

				lnRow = lnRow+1

			ENDSCAN

			* Set the legend captions 
			IF NOT EMPTY(.cLabels)
				* Unpack the labels
				lnLabCount = ALINES(laLabs,STRTRAN(.clabels,",",CHR(13)))
						&& This will fill the laLabs array with the labels

				FOR lnCol = 1 TO lnFieldCount
					IF lnCol <= lnLabCount
						.Column = lnCol
						.columnLabel = laLabs(lnCol)
					ENDIF
				ENDFOR
			ENDIF 

			* Show markers (if required)
			FOR lnI = 1 TO .ColumnCount
				.Plot.SeriesCollection(lnI).SeriesMarker.Show = .lShowMarkers
			ENDFOR

			* Deal with colours
			IF NOT EMPTY(.cColours)

				* Create arrays containing the colour names and corresponding values
				lcColStr = "red,  green, blue,    black, white,   grey,   gray,   yellow, brown, magenta, cyan,     darkblue, darkgreen"
				lcColVal =  "255, 65280, 16711680,0,     16777215,8421504,8421504,65535,  128,   16711935,16776960, 8388608,  32768"
					&& the above are 24-bit integer values, and are included for reference only
				lcRed =     "255, 0,     0,       0,      255,   128,     128,    255,    128,    255,    0,        0,        0"
				lcGreen =   "0,   255,   0,       0,      255,   128,     128,    255,    128,    0,      255,      0,        128"
				lcBlue   =  "0,   0,     255,     0,      255,   128,     128,    0,      0,      255,    255,      128,      0"
				ALINES(lacolStr,STRTRAN(lcColStr,",",CHR(13)),.T.)
				ALINES(lacolVal,STRTRAN(lcColVal,",",CHR(13)),.T.)
				ALINES(laRed,STRTRAN(lcRed,",",CHR(13)),.T.)
				ALINES(laGreen,STRTRAN(lcGreen,",",CHR(13)),.T.)
				ALINES(laBlue,STRTRAN(lcBlue,",",CHR(13)),.T.)
						&& ALINES() only valid in VFP 6.0 and above

				* Put the list of required colours into an array
				.cColours = LOWER(.cColours)
				lnColsToSet = ALINES(laReqCols,STRTRAN(.cColours,",",CHR(13)),.T.)

				lnColsToSet = MIN(lnColsToSet,.ColumnCount)
					&& We need to process the number of colours passed, or the number of
					&& columns in the chart, whichever is lower

				* Loop through the columns, setting the colours as required
				FOR lnI = 1 TO lnColsToSet

					* Locate this column's required colour in the colour name array
					lnColIndex = ASCAN(laColStr,laReqCols(lnI))

					IF lnColIndex > 0

						* Determine the red, green and blue elements
						lnRed = VAL(laRed(lnColIndex))
						lnGreen = VAL(laGreen(lnColIndex))
						lnBlue = VAL(laBlue(lnColIndex))

						* Set the bar's colours
						.Plot.SeriesCollection(lnI).DataPoints(-1).Brush.FillColor.Set(lnRed,lnGreen,lnBlue)

						* Set colours for line series
						.Plot.SeriesCollection(lnI).pen.vtColor.Set(lnRed,lnGreen,lnBlue)

					ENDIF 
				ENDFOR
			ENDIF

			* Deal with title and footnote
			IF NOT EMPTY(.cTitle)
				.Title.Text = .cTitle
				.Title.VtFont.Name = "Arial"
				.Title.VtFont.Size = 12
				.Title.VtFont.Style = 1  && bold
			ENDIF

			IF NOT EMPTY(.cFootnote)
				.Footnote.Text = .cFootnote
			ENDIF 

			* Make the chart visible
			.Visible = .T.

		ENDWITH

		RETURN .T.
	ENDPROC


	*-- Read this to learn how to use this class.
	PROCEDURE documentation
		* Documentation for the class. Not intended to be executed.

		RETURN

		*	SimpleChart class. Written by Mike Lewis (Mike Lewis Consultants
		*	Ltd.), February - March 2002.

		*	Copyright Mike Lewis Consultants Ltd. All rights reserved.
		*	Feel free to use this class in any way you like, but please
		* 	do not remove our copyright notice or the following disclaimer:

		*	Although we have tested this class thoroughly, we cannot accept
		*	any legal liability for its use. Do not use this class unless you
		*	are satisfied that it works correctly in your application.

		*	We welcome your feedback. Please email Mike Lewis at mikl@compuserve.com
		*	or see www.ml-consult.co.uk


		*	What does it do?

		*	The SimpleChart class produces two- and three-dimensional charts
		*	and graphs, using data from a Visual FoxPro table or cursor.


		*	What do I need?

		*	The class is based on Microsoft's MSChart ActiveX control
		*	(MSChrt20.Ocx), which comes with VFP 6.0 and 7.0. To use the
		*	class, you will need the ActiveX control to be installed on your
		*	own computer. To distribute applications which use the class,
		*	you will need to ensure that the OCX file is present and
		*	properly registered on the end-user's computer.


		*	How do I use it?

		*	The first step is to provide a table or cursor which contains
		*	the data required for your chart. Then drop the class on a VFP
		*	form, set certain properties, and finally call its CreateChart
		*	method.


		*	The cursor

		*	The chart is always populated with data from a cursor (or
		*	table). You can use an existing cursor if it already contains
		*	the required data, or you can create one specifically for this
		*	purpose.

		*	The cursor must have the following characteristics:

		*	- A record for each data point on the chart.

		*	- A field for each of the series on the chart. These fields must
		*	be numeric.

		*	- Optionally, a field containing the row label for the current
		*	record. This field must be a character string.

		*	As an example, suppose you wanted to plot monthly sales value
		*	and monthly sales quantity for the year to date. Your cursor might look
		*	something like this:

		*	  MONTH_NAME      SALES_VAL      SALES_QTY
		*	    JAN             4000             32
		*	    FEB             4020             33
		*	    MAR             4090             36
		*	    APR             4070             34

		*	This will produce a chart with two lines and four
		*	data points. The horizotal axis will show the four month names
		*	as labels.


		*	Minimum properties

		*	Once you have dropped the SimpleChart control onto a VFP form,
		*	you must set certain properties. You can do this either in the
		*	Form Designer or in code (for example, in the control's Init
		*	event).

		*	The following are the key properties that you must set:

		*	     cAlias    The alias of the cursor (or table) containing the
		*	               data to be plotted. 
		*
		*	     cData     A comma-delimited list of the fields within the
		*	               cusor which contain the actual data.

		*	In addition, you will probably want to set one or both of the
		*	following properties:

		*	     cRowLabels     The name of the field within the cursor
		*	               containing the row labels (these will appear
		*	               along the x-axis).

		*	     cLabels   A comma-delimited list of the labels that are to
		*	               appear in the legend (if any).

		*	To continue with the above example, the following code sets the
		*	required properties:

		*	     WITH THIS
		*	       .cAlias = "csrSales"
		*	       .cData = "sales_val,sales_qty"
		*	       .cRowLabels = "month_name"
		*	       .cLabels = "Value,Quantity"
		*	     ENDWITH


		*	Other properties

		*	The above properties are the only ones needed to create a
		*	default chart. However, the class also exposes many other
		*	properties that can be used to customise the chart in various
		*	ways. Some of the more important of these are listed below.

		*   The folowing are native properties of the MSChart control
		*	(further details can be found in the Help file for the control).


		*	     BorderStyle    The border for the entire chart (0 = no
		*	                    border, 1 = single line; default 0).

		*	     ChartType      0=3D bar, 1=2D bar, 2=3D line, 3=2D line,
		*	                    4=3D area, 5=2D area, 6=3D step, 7=2D step,
		*	                    and several others (default 3).

		*	     ShowLegend     .T. to show a legend (default .F.).

		* 	And these are custom properties that you might wish to use:

		*		cColours		A comma-delimited list of the colours to be use
		*						for the chart. The following colours are supported:
		*						red, green, blue, black, white, grey, gray, yellow, 
		*						brown, magenta, cyan, darkblue, darkgreen
		*						For example, if the chart has three series, the following
		*						code will set these to blue, white and yellow 
		*						respectively:
		*						THIS.cColours = "BLUE,WHITE,YELLOW"
		*						(these are not case-sensitive)

		*		cFootnote		Text of a small title which appears at the bottom
		*						of the chart

		*		cTitle			Text of a main title for the chart; this appears
		*						centred at the top of the chart

		*	    lIgnoreZero  	If .T., any zero values in the data will not
		*		              	be plotted. (Default .F.).

		*		lShowMarkers	If T., data points will be highlighted by special symbols.
		*						(Default .F.)


		*	Creating the chart

		*	Once you have set the required properties, call the control's
		*	CreateChart method. This will read the cursor, populate the
		*	chart with data, and display the chart. The cursor must be open
		*	when you call this method.


		*	Things that can go wrong

		*	If the CreateChart method is unable to create the chart, it
		*	will return .F. and the chart will not appear. If this happens,
		*	you should check the following:

		*	-    The cursor or table containing the data must be open, and
		*	     its alias stored in the cAlias property.

		*	-    The cData property must contain the name of at least one of
		*	     the (numeric) fields from the cursor.

		*	     
	ENDPROC


ENDDEFINE
*
*-- EndDefine: simplechart
**************************************************
