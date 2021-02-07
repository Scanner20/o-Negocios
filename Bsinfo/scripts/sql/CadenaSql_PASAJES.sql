/*
	Programa 		:	REGISTRO DE VENTAS 2018

	Desarrollado por 	: 	Jcouncil 

*/

USE BD_PAXPROD

declare @ls_fecha_1 Char(10)
declare @ls_fecha_2 Char(10)
declare @boleteria1 int



set @boleteria1  = -1
set @ls_fecha_1= '01/06/2018'
set @ls_fecha_2= '10/06/2018'
                             
Select 
       CCOMPROBANTE_ORIGEN ,
       Fecha, Tdoc,Coficina, Oficina, Serie, Documento, Identidad, Cliente, Pasajes, Excesos, Otros, Importe, IGV,  Total, Total_General, Estado, contable,
       
       CTIPO_OPERACION,        
       
       Tref, Numero_Ref, Fecha_Ref, Ope, Pasajero,
       Case CPAGO 
            When 'VISA'                        Then 'VS'            
            When 'VISA DSCTO TVIRTUAL'         Then 'VS'            
            When 'SAFETYPAY DSCTO TVIRTUAL'    Then 'SP'
            When 'PAGOEFECTIVO DSCTO TVIRTUAL' Then 'APP'            
            When 'MASTERCARD DSCTO TVIRTUAL'   Then 'MC'            
            When 'MASTERCARD'                  Then 'MC'            
            When 'AMERICAN EXPRESS'            Then 'AMEX'            
            When 'DINNERS'                     Then 'Dinners'
            When 'PAGO EFECTIVO'               Then 'APP'
            When 'SAFETY PAY'                  Then 'SP'            
            Else CPAGO             
       End as Medio_Pago,
       Promocion_Convenio, FViaje, Contador    
from
(
  Select 
  
        CCOMPROBANTE_ORIGEN ,
  
         Bol.GESTADO_COMPROBANTE Estado,
         Bol.GESTADO_CONTABLE_COMPROBANTE COntable,
         
         CONVERT( char(10), BOL.FHEMISION, 103 ) as Fecha,

         case Bol.GTIPO_COMPROBANTE          
              When 175 then 16         
              When 179 then 7 
              WHEN 349 THEN 3
              WHEN 173 THEN 1                               
              else '' 
          End Tdoc,                     
                         
         Ofi.COFICINA Coficina,
         Ofi.SOFICINA Oficina,

         Bol.NSERIE AS Serie,
         Bol.NSECUENCIA AS Documento,
         
         Case isnull( Bol.TRUC ,'')
         
              WHEN '' THEN Bol.TDOCUMENTO_IDENTIDAD
              
              ELSE  Bol.TRUC 
              
         End as IDENTIDAD,
         
         Case Bol.GESTADO_COMPROBANTE 
              When 183 then 'ANULADO'
              else              
                  Case isnull( Bol.TRAZON_SOCIAL ,'')
                       when '' then
                             UPPER( isnull(BOL.PATERNO,'') + SPACE(1) + isnull(BOL.MATERNO,'') + SPACE(1) + isnull(BOL.NOMBRES,'') )
                       else
                            ( Select MAX(TRAZON_SOCIAL) from JURIDICA WITH (NOLOCK)  where RTRIM(Truc) = RTRIM(Bol.Truc)  )
                  End 
         End as Cliente,
         
         /* PARCHE PARA NO MOSTRAR IMPORTE EN PASAJES DE CORTESIA */
         CASE Bol.GTIPO_COMPROBANTE                     
              WHEN 179 THEN  Bol.NPRECIO_TOTAL*-1                         
              ELSE  
                   Case Bol.Ctipo_Operacion 
                        when 5 then 0.00
                        else Bol.NPRECIO_TOTAL
                   End

         END AS Pasajes,
         
         0.00 as Excesos,	
         0.00 as Otros	,
         0.00  as Importe,
         0.00 as IGV	,
         
         /* PARCHE PARA NO MOSTRAR IMPORTE EN PASAJES DE CORTESIA */
         CASE Bol.GTIPO_COMPROBANTE                     
              WHEN 179 THEN  Bol.NPRECIO_TOTAL*-1                         
              ELSE  
                   Case Bol.Ctipo_Operacion 
                        when 5 then 0.00
                        else Bol.NPRECIO_TOTAL
                   End

         END AS Total,

         /* PARCHE PARA NO MOSTRAR IMPORTE EN PASAJES DE CORTESIA */
         CASE Bol.GTIPO_COMPROBANTE                     
              WHEN 179 THEN  Bol.NPRECIO_TOTAL*-1                         
              ELSE  
                   Case Bol.Ctipo_Operacion 
                        when 5 then 0.00
                        else Bol.NPRECIO_TOTAL
                   End                   
         END AS Total_General,

                         
         Case WHEN Bol.Gtipo_Comprobante NOT IN ( 175, 349 , 173) 
         
              Then 16                            -- NOTA DE CREDITO
         
              
              Else
                    -- BOLETO BOV O FAC              
                    Case Bol.CTIPO_OPERACION
                         ---when 7 THEN 16
                         When 6 THEN 16
                         else ''
                    END


         End Tref,  
         
         isnull(         
                -- When 349 then 'BOV'
                -- When 173 then 'FAC'              
                -- When 175 then 'BOL'         
                -- When 179 then 'N/C'
         Case WHEN Bol.Gtipo_Comprobante NOT IN ( 175, 349 , 173 ) 
              Then 
                   DBO.FX_OBTENER_NUMREF_FHREF(BOL.CCOMPROBANTE) 
              else
                    Case Bol.Ctipo_Operacion
                          when 6 then -- AGT                          
                                Case ( SELECT ETKT.COFICINA FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK) 
                                        WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN AND ETKT.GTIPO_COMPROBANTE in ( 176 ) )
                                      when  576 THEN 
                                         ( SELECT isnull(NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA),'')
                                             FROM BD_PAXPROD.dbo.COMPROBANTE ETKT  WITH (NOLOCK)
                                            WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                              AND ETKT.GTIPO_COMPROBANTE in ( 176 ) )
                                      when  26 THEN -- PLAZA VEA
                                         ( SELECT isnull(NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA),'')
                                             FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                            WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                              AND ETKT.GTIPO_COMPROBANTE in ( 176 ) )                                      
                                      else                          
                                         ( SELECT isnull(NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA),'')
                                             FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                            WHERE ETKT.CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                              AND ETKT.GTIPO_COMPROBANTE   in ( 176 ) ) -- SE BUSCA SU ETICKET
                                End  
                          when 7 then --VIRTUAL
                             ( SELECT NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA)
                                       FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                 WHERE ETKT.CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                   AND ETKT.GTIPO_COMPROBANTE   in ( 176 ) ) -- SE BUSCA SU ETICKET                                     
                          
                          when 5 then 
                          /* PAsaje de Cortesia */
                             ( SELECT NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA)
                               FROM BD_PAXPROD.dbo.COMPROBANTE PASE WITH (NOLOCK)
                              WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                AND PASE.GTIPO_COMPROBANTE in ( 180 ) )                             
                               
                     End
                                  
          End 
          ---,'NO VA') as Numero_Ref ,
          ,'') as Numero_Ref ,
          
         Case Bol.Gtipo_Comprobante 
              -- NOTA DE CREDITO     
              When 179 Then    
                      ISNULL( ( SELECT convert( char(10), ETKT.FHEMISION , 103 )-- FECHA DE BOLETO ORIGEN
                                  FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)                              
                                 WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN --MODIFICADO SE HA HECHO EL MATCH A PARTIR DEL CCOMPROBANTE Y CCOMPROBANTE_ORIGEN
                                   AND ETKT.GTIPO_COMPROBANTE in ( 175,349,173 ) ), DBO.FX_OBTENER_FHREF(BOL.CCOMPROBANTE_ORIGEN))   --FUNCION AGREGADA PARA RECUPERAR                                   
              when 176 then null
              else 
                   Case Bol.Ctipo_Operacion 
                        when 5 then -- OP PASAJE DE CORTESIA
                           ( SELECT convert( char(10), ETKT.FHEMISION, 103)
                               FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                              WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                AND ETKT.GTIPO_COMPROBANTE in ( 180 ) )                                
                        when 6 then -- OP VCANJE AGV     
                               /*  Identificar Eticket o Doc Electronico */                               
                                ( SELECT convert( char(10), ETKT.FHEMISION, 103)
                                              FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                             WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                               AND ETKT.GTIPO_COMPROBANTE in ( 176 ) )
                                  
                        when 7 then -- OP CANJE CANAL ONLINE       
                                       ( SELECT convert( char(10), ETKT.FHEMISION, 103)
                                           FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                          WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                            AND ETKT.GTIPO_COMPROBANTE = 176 )


                    End                                                   

         End as Fecha_Ref ,           
         
         Case Bol.GTIPO_COMPROBANTE       
              when  175 then         
                    Case Bol.CTIPO_OPERACION
                         when 7 THEN '13' 
                         When 6 THEN '13' 
                         else '0'
                    END
              else '0'     
         End Ope,
         
         Case Bol.GESTADO_COMPROBANTE 
              When 183 then ''
              else UPPER( isnull(BOL.PATERNO,'') + SPACE(1) + isnull(BOL.MATERNO,'') + SPACE(1) + isnull(BOL.NOMBRES,'') ) 
         End as Pasajero,      

         Bol.CTIPO_OPERACION,
   
         Case Bol.Ctipo_Operacion  
              
              When 2 Then 'CR'          -- CREDITOS
              
              When 5 Then 'EFECTIVO'    -- PASE DE CORTESIA
              
              When 7 then /* SEPARAR TARJETAS DE PAGO EFECTIVO  */              
                     Case Bol.IMIGRADO -- SI ESTA MIGRADO TRAER DE FICS                         
                          When 1 Then ''
                          /*
                                      (Select UPPER(PTipo.Nombre) 
                                         from  OLD_PASAJES_FICS as P WITH (NOLOCK)
                                         Left Join OLD_PASAJESTIPOS_FICS PTipo WITH (NOLOCK)
                                              on P.TipoPasaje = PTipo.Id
                                        where Numero = 
                                                      ( SELECT isnull(NSERIE +'-'+ CONVERT(CHAR(10),NSECUENCIA),'')
                                                           FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                                          WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                                            AND ETKT.GTIPO_COMPROBANTE in ( 176 ) )  )  
                          */     
                          ------ Revisar 
                          else
                             Case when GTIPO_COMPROBANTE = 175 then                              
                                  -- Se evalua si Tiene Detalle de Forma de PAgo ( Visa, MC etc)
                                  CASE ISNULL( ( Select Top 1 (TGD.DTG_D ) 
                                                    from PAGO P  WITH (NOLOCK)           
                                                    LEFT JOIN TG_D TGD WITH (NOLOCK)
                                                         ON TGD.CTG_D=P.GPASARELA_DE_PAGO
                                                    Where P.CRESERVA_DETALLE =  ( SELECT ETKT.CRESERVA_DETALLE 
                                                                                      FROM BD_PAXPROD.dbo.COMPROBANTE as ETKT WITH (NOLOCK)
                                                                                     WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                                                                       AND ETKT.GTIPO_COMPROBANTE in ( 176 ) ) )    ,'')                      
                                          When '' Then   /* RECAUDOS*/
                                                  ( Select Top 1 (TGD.DTG_D )
                                                                 from PAGO P             
                                                                 LEFT JOIN TG_D TGD 
                                                                      ON TGD.CTG_D=P.GMEDIO_DE_PAGO
                                                                Where P.CRESERVA_DETALLE =  ( SELECT ETKT.CRESERVA_DETALLE
                                                                                                FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                                                                               WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                                                                                 AND ETKT.GTIPO_COMPROBANTE in ( 176 ) ) )   
                                          else -- TARJETAS
                                                 ( Select Top 1  (TGD.DTG_D )
                                                     from PAGO P             
                                                     JOIN TG_D TGD 
                                                          ON TGD.CTG_D=P.GPASARELA_DE_PAGO
                                                     Where P.IACTIVO = 1
                                                      AND  P.CRESERVA_DETALLE =  ( SELECT ETKT.CRESERVA_DETALLE
                                                                                     FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                                                                    WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                                                                          AND ETKT.GTIPO_COMPROBANTE in ( 176 ) 
                                                                                  ) 
                                                  ) 

                                   End
                             when GTIPO_COMPROBANTE in ( 173, 349 ) then
                             
                                        CASE ISNULL( ( Select Top 1 (TGD.DTG_D ) 
                                                    from PAGO P  WITH (NOLOCK)           
                                                    LEFT JOIN TG_D TGD WITH (NOLOCK)
                                                         ON TGD.CTG_D=P.GPASARELA_DE_PAGO
                                                    Where P.CRESERVA_DETALLE = Bol.CRESERVA_DETALLE ),' ')
                                                    
                                          When '' Then   /* RECAUDOS*/
                                                  ( Select Top 1 (TGD.DTG_D )
                                                                 from PAGO P             
                                                                 LEFT JOIN TG_D TGD 
                                                                      ON TGD.CTG_D=P.GMEDIO_DE_PAGO
                                                                Where P.CRESERVA_DETALLE = Bol.CRESERVA_DETALLE )
                                          else -- TARJETAS
                                                 ( Select Top 1  (TGD.DTG_D )
                                                     from PAGO P             
                                                     JOIN TG_D TGD 
                                                          ON TGD.CTG_D=P.GPASARELA_DE_PAGO
                                                     Where P.IACTIVO = 1
                                                      AND  P.CRESERVA_DETALLE =  Bol.CRESERVA_DETALLE
                                                  )
                                        End
                         End
                   End
              When 6 then 
                         --'AGT'
                        ( Select Top 1 (TGD.DTG_D )
                            from PAGO P             
                       LEFT JOIN TG_D TGD 
                            ON TGD.CTG_D=P.GMEDIO_DE_PAGO
                           Where P.CRESERVA_DETALLE =  ( SELECT ETKT.CRESERVA_DETALLE
                                                           FROM BD_PAXPROD.dbo.COMPROBANTE ETKT WITH (NOLOCK)
                                                          WHERE CCOMPROBANTE_ORIGEN = BOL.CCOMPROBANTE_ORIGEN 
                                                           AND ETKT.GTIPO_COMPROBANTE in ( 176 ) ) )      
              When 19 Then 'CA'                      
              
              Else       -- SE EVALUA EL CODIGO DE MEDIO DE PAGO TARJETA O DEBITO
                   Case ( Select Top 1 ( P.GMEDIO_DE_PAGO  )
                            From PAGO P   WITH (NOLOCK)
                            JOIN TG_D TGD WITH (NOLOCK)
                                 ON TGD.CTG_D=P.GMEDIO_DE_PAGO 
                                 WHERE  P.CRESERVA = Bol.CRESERVA )
                                 
                            when 142 Then
                                      ( Select Top 1 ( TGD.STG_D )
                                              From PAGO P    WITH (NOLOCK)
                                              JOIN TG_D TGD  WITH (NOLOCK)
                                                   ON TGD.CTG_D=P.GPASARELA_DE_PAGO
                                              WHERE  P.CRESERVA = Bol.CRESERVA  )
                            when 143 Then
                                      ( Select Top 1 ( TGD.STG_D )
                                              From PAGO P   WITH (NOLOCK)
                                              JOIN TG_D TGD WITH (NOLOCK)
                                                   ON TGD.CTG_D=P.GPASARELA_DE_PAGO  
                                              WHERE  P.CRESERVA = Bol.CRESERVA  )
                            -- RESTO DE FORMAS DE PAGO                            
                            else
                               ISNULL(  ( select Top 1 (TGD.DTG_D )
                                            From PAGO P   WITH (NOLOCK)
                                            JOIN TG_D TGD WITH (NOLOCK)
                                              ON TGD.CTG_D=P.GMEDIO_DE_PAGO
                                           WHERE  P.CRESERVA = Bol.CRESERVA ),DBO.FX_OBTENER_MEDIO_PAGO(Bol.CCOMPROBANTE))  --MODIFICADO                                    

                   End
         end as CPAGO,
           
         Bol.IMIGRADO,
           
         Case Bol.Gtipo_Comprobante 
              When 175 Then                                            
                    Case Bol.Ctipo_Operacion                     
                          when 5 then 'PASAJE DE CORTESIA'
                          else  
                               Case V.IPROMOCION_TRAFICO
                                    When 1 then ''
                                    else upper(v.DVARIACION)            
                               End 
                    end                    
              When 179 Then                                            
                    Case Bol.Ctipo_Operacion                     
                          when 5 then 'PASAJE DE CORTESIA'
                          else                            
                             ( Select upper(v.DVARIACION)
                               from  variacion V WITH (NOLOCK)
                               where ( IPROMOCION_TRAFICO=0 and Bol.CVARIACION=v.CVARIACION ) )
                               
                    End 
         End 
          as Promocion_Convenio ,         

        Case Bol.Ctipo_Operacion 
             when 33 then ''
             else
                Case Bol.Gtipo_Comprobante 
                     /* boleto */
                     When 175 Then CONVERT( CHAR(10), Bol.FHVIAJE , 103) +SPACE(1)+ CONVERT( CHAR(5), Bol.FHVIAJE , 108)
                     /* BOV */
                     When 349 Then CONVERT( CHAR(10), Bol.FHVIAJE , 103) +SPACE(1)+ CONVERT( CHAR(5), Bol.FHVIAJE , 108)
                     /* FAC */
                     When 173 Then CONVERT( CHAR(10), Bol.FHVIAJE , 103) +SPACE(1)+ CONVERT( CHAR(5), Bol.FHVIAJE , 108)
                     else ''
                end
         End  as FViaje,

         Case Bol.Ctipo_Operacion 
              when 5  then 0 
              when 33 then 0 
              else                        
                  Case Bol.GESTADO_COMPROBANTE 
                       when 183 then 0              
                       else Case Bol.GTIPO_COMPROBANTE when 179 then -1 else 1 end 
                  End              
          end as CONTADOR
                  
                          
    from BD_PAXPROD.dbo.Comprobante Bol WITH (NOLOCK)
         LEFT JOIN BD_PAXPROD.dbo.OFICINA Ofi WITH (NOLOCK)
              ON Bol.COFICINA = Ofi.COFICINA
              
         LEFT JOIN BD_PAXPROD.dbo.USUARIO Usr WITH (NOLOCK)
              ON  Usr.CUSUARIO = Bol.CUSUARIO
              
         LEFT JOIN dbo.RESERVA as RSV WITH (NOLOCK)
              ON Bol.CRESERVA = RSV.CRESERVA
              
         LEFT JOIN dbo.RESERVA_DETALLE as RSVDET WITH (NOLOCK)
              ON  Bol.CRESERVA_DETALLE = RSVDET.CRESERVA_DETALLE        
         LEFT JOIN VARIACION V WITH (NOLOCK)
         ON Bol.CVARIACION=v.CVARIACION
                                        
        where ( FHEMISION >= @ls_fecha_1 + ' 00:00:00'
          and   FHEMISION <= @ls_fecha_2 + ' 23:59:59' )
          
          and  Bol.GTIPO_COMPROBANTE in ( 175,179, 173, 349 )     
          

) Detalle

where  coficina = @Boleteria1 or @Boleteria1 = -1

order by Oficina , Fecha