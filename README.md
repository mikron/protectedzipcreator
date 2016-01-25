# ProtectedZipCreator
Create password protected Zip files, using java stored procedures. 
The example of the compressing blob file into zip file is described bellow
```sql
   p_ProtectedZipCreator.Archive(ab_Input => lb_file, 
                                 ab_Output => lb_Result, 
                                 av_zipPass => 'some_password',
                                 av_FileName => 'some_file.txt', 
                                 ac_OutErrBuf => lc_Err);
```
where, ab_Input - the source file for compressing, ab_Output - the compressed zip file, av_ZipPass - the password for the zip file, av_FileName - the filename inside the zip archive, ac_OutErrBuf - clob file containing the log of the java errors.


## Install
For installing firstly you will need loadjava utility. The loadjava utility loads Java source and class files into the database. When class files are created in a conventional manner, outside the database, loadjava is used to get them into the database. For the ProtectedZipCreator we need to install `zip4j` external library. Change the directory of the terminal to `{project_root}/external-libraries/zip4j-1.3.2.jar` directory and execute the following script in order to load java into Oracle database. 
```
loadjava -user db_user/db_user_pass@db_name -resolve -v zip4j-1.3.2.jar
```
After loading java library to the Database, compile the `{project_root}/java-sources` and `{project_root}/packages` sources into the Database.

## Example
You will need to have `SOME_DIRECTORY` directory and inside of the directory file called `some_file.txt`. After executing the bellow script, in the `SOME_DIRECTORY` directory will be created a compressed file `some_file.zip`.
```sql
declare
   lb_file blob;
   lb_Result blob;
   lc_Err clob;

   procedure LoadBlobFromFile(av_Directory varchar2, av_FileName varchar2) is
      lb_xml bfile := bFilename(av_Directory, av_FileName);
      li_dest int := 1;
      li_src int := 1;
      warning int;
      ltx int := 0;
   begin
      dbms_lob.fileopen(lb_xml, dbms_lob.lob_readonly);
      put(dbms_lob.getlength(lb_xml), ai_Pref => 0);
      dbms_lob.loadblobfromfile(lb_file, lb_xml, dbms_lob.getlength(lb_xml),
                                li_dest, li_src);
      dbms_lob.fileclose(lb_xml);
   end;

   procedure save_file(av_Directory varchar2, av_FileName varchar2, lb_Src blob) is
      l_file UTL_FILE.FILE_TYPE;
      l_buffer raw(32767);
      l_amount binary_integer := 32767;
      l_pos integer := 1;
      l_blob_len integer;
   begin
   
      l_blob_len := DBMS_LOB.getlength(lb_Src);
   
      -- Open the destination file.
      l_file := UTL_FILE.fopen(av_Directory, av_FileName, 'w', 32767);
   
      -- Read chunks of the BLOB and write them to the file
      -- until complete.
      while l_pos < l_blob_len loop
         DBMS_LOB.read(lb_Src, l_amount, l_pos, l_buffer);
         UTL_FILE.put_raw(l_file, l_buffer, true);
         l_pos := l_pos + l_amount;
      end loop;
   
      -- Close the file.
      UTL_FILE.fclose(l_file);
   
   exception
      when others then
         -- Close the file if something goes wrong.
         if UTL_FILE.is_open(l_file) then
            UTL_FILE.fclose(l_file);
         end if;
         raise;
   end;

begin
   dbms_lob.createtemporary(lb_file, true, dbms_lob.call);
   dbms_lob.createtemporary(lb_Result, true, dbms_lob.call);
   dbms_lob.createtemporary(lc_Err, true, dbms_lob.call);
   LoadBlobFromFile('SOME_DIRECTORY', 'some_file.txt');

   p_ProtectedZipCreator.Archive(ab_Input => lb_file, ab_Output => lb_Result,
                                 av_zipPass => '123',
                                 av_FileName => 'some_file.txt',
                                 ac_OutErrBuf => lc_Err);

   save_file('SOME_DIRECTORY', 'some_file.zip', lb_Result);
end;
```
