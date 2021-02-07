
SELECT CodMat as articulo ,;
	 desmat as Nombre ,;
	 UndStk as Unidades ,;
	 Lote,;
	 FchVto As Vencimiento ,;
	 Stkact as stock_Total ,;
	 StkLote as Stock_Lote,;
	 Prec_prom as Precio_Promedio ,;
	 valor_alm as Costo_almacen, ;
	 LEFT(CodMat,GnLenDiv)+'DD' AS tpoDiv  ; 
	 FROM temporal INTO CURSOR items_det ORDER BY TpoDiv,Articulo READWRITE
	 
SELECT Articulo,;
		Nombre ,;
		Sum(stock_Total) As stock_Total ,;
		SUM(Stock_Lote) as Stock_Lote ,;
		SUM(Costo_almacen) as Costo_almacen, ;
		LEFT(Articulo,GnLenDiv)+'TF' AS tpoDiv  ; 
		from items_det GROUP BY tpodiv INTO CURSOR Items_TFAM READWRITE	 