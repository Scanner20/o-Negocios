# o-Negocios Project

## Development Mode Testing

To perform development mode testing, follow these steps:

1. **Download the sample database**  
   Locate the file `Bsinfo/DATA/bkTest_20250831004309.rar` in the repository and extract it to a local disk drive.

2. **Locate the test startup program**  
   In the project `bsinfo/proys/o-n.pjx`, find the program `inicio_test.prg`.

3. **Configure the test environment**  
   In the folder where the database was extracted, locate the configuration file `X:\o-negocios\test\config.ini`, where `X:` represents the local or network drive.

4. **Verify configuration paths**  
   Ensure that the files `inicio_test.prg` and `config.ini` contain the correct paths as shown in the image below:  
   ![Configuration Paths](Bsinfo/DATA/docs/rutas_config_test.png)

5. **Test execution sequence**  
   In the project, locate the file `inicio_test.prg` and follow the steps shown in the following images:  
   ![System Login](Bsinfo/DATA/docs/Ingreso_Sistema.png)  
   ![Select Company](Bsinfo/DATA/docs/Select_company.png)  
   ![Select Period](Bsinfo/DATA/docs/Select_period.png)

6. **Explore available programs and forms**  
   Use the "Other" tab in the project `o-n.pjx` to access menus and identify executable programs or forms. Examples include:  
   - `Bsinfo/menus2/funcbdm00.mnx` → "Accounting"  
   - `Bsinfo/menus2/funalmm00.mnx` → "Inventory and Warehouse"  
   - `Bsinfo/menus2/funvtam00.mnx` → "Sales and Invoicing"  
   - `Bsinfo/menus2/funcjam00.mnx` → "Cash and Banking"  
   - `Bsinfo/menus2/funcctm00.mnx` → "Accounts Receivable"  
   - `Bsinfo/menus2/funcmpm00.mnx` → "Purchasing Logistics"  
   - `Bsinfo/menus2/funprom00.mnx` → "Manufacturing Production Control"  
   - etc.

   Additionally, you can watch the example video:  
   **VFP: How to Filter Accounts in a Grid for Accounting Entries**  
   [Watch on YouTube](https://youtu.be/RQWj48M37_0?si=ELZPbCclY_6NQ4kr)

## Connecting to Other Database Engines

The o-Negocios project includes a database connection class `cnxgen_odbc` located at `classgen/vcxs/admnovis.vcx`. Combined with the configuration file `config.ini`, this class enables flexible connectivity to various data sources beyond native Visual FoxPro `.dbf` tables and `.dbc` containers, either simultaneously or independently.

This is ideal for building interfaces between different applications and ecosystems, as well as for ETL (Extract, Transform, Load) tasks.

Below is an example of how the configuration is defined in the `config.ini` file:  
![Database Connection Configuration](Bsinfo/DATA/docs/Conexion_db_config.png)
