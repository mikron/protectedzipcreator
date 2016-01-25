create or replace package p_ProtectedZipCreator is

   /* for testing purposes */
   procedure xcompress(av_inputFile in varchar2, av_outputFile in varchar2,
                       av_zipPass varchar2) as
      language java name 'ProtectedZipCreator.CreatePasswordProtectedZipCreator(java.lang.String, java.lang.String, java.lang.String)';

   procedure archive(ab_Input in blob, ab_Output in out nocopy blob,
                     av_zipPass varchar2, av_FileName varchar2,
                     ac_OutErrBuf in out nocopy clob) as
      language java name 'ProtectedZipCreator.archive(oracle.sql.BLOB, oracle.sql.BLOB[],java.lang.String,java.lang.String,oracle.sql.CLOB[])';

/*
   
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

   p_ProtectedZipCreator.Archive(lb_file, lb_Result, '123',
                                 'some_file.txt', lc_Err);

   save_file('SOME_DIRECTORY', 'some_file.zip', lb_Result);
end;

   
      
*/

end p_ProtectedZipCreator;
/
