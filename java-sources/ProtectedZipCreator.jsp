create or replace and compile java source named ProtectedZipCreator as

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.io.ZipOutputStream;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

import java.io.*;
import java.util.ArrayList;

public class ProtectedZipCreator
{
  public static void CreatePasswordProtectedZipCreator(String input_file, String output_file, String password) {
        try {
            //This is name and path of zip file to be created
            ZipFile zipFile = new ZipFile(output_file);

            //Add files to be archived into zip file
            ArrayList<File> filesToAdd = new ArrayList<File>();
            filesToAdd.add(new File(input_file));

            //Initiate Zip Parameters which define various properties
            ZipParameters parameters = new ZipParameters();
            parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE); // set compression method to deflate compression

            //DEFLATE_LEVEL_FASTEST     - Lowest compression level but higher speed of compression
            //DEFLATE_LEVEL_FAST        - Low compression level but higher speed of compression
            //DEFLATE_LEVEL_NORMAL  - Optimal balance between compression level/speed
            //DEFLATE_LEVEL_MAXIMUM     - High compression level with a compromise of speed
            //DEFLATE_LEVEL_ULTRA       - Highest compression level but low speed
            parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);

            //Set the encryption flag to true
            parameters.setEncryptFiles(true);

            //Set the encryption method to AES Zip Encryption
            parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);

            //AES_STRENGTH_128 - For both encryption and decryption
            //AES_STRENGTH_192 - For decryption only
            //AES_STRENGTH_256 - For both encryption and decryption
            //Key strength 192 cannot be used for encryption. But if a zip file already has a
            //file encrypted with key strength of 192, then Zip4j can decrypt this file
            parameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);

            //Set password
            parameters.setPassword(password);

            //Now add files to the zip file
            zipFile.addFiles(filesToAdd, parameters);
        } catch (ZipException e) {
            e.printStackTrace();
        }
    }

    public static void archive(oracle.sql.BLOB input, oracle.sql.BLOB[] output,
                               String pwd, String fileNameInZip, oracle.sql.CLOB[] errOut) {
        LogWriter logWriter = new LogWriter(errOut);
        try {
            logWriter.write("start archive process");
            archive(input.getBinaryStream(), output[0].setBinaryStream(1), pwd, fileNameInZip);
            logWriter.write("end archive process");
        } catch (Exception e) {
            logWriter.write(e);
        }
    }

    public  static void archive(InputStream inputStream, OutputStream bos,
                               String password, String fileNameInZip) throws IOException, ZipException {
        ZipOutputStream zipOutputStream = new net.lingala.zip4j.io.ZipOutputStream(bos);
        ZipParameters parameters = new ZipParameters();
        parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
        parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);
        parameters.setEncryptFiles(true);
        parameters.setSourceExternalStream(true);
        parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_STANDARD);
        parameters.setFileNameInZip(fileNameInZip);
        parameters.setPassword(password);

        zipOutputStream.putNextEntry(null, parameters);
        IOUtils.copy(inputStream, zipOutputStream);
        zipOutputStream.closeEntry();

        zipOutputStream.finish();
        zipOutputStream.close();
        bos.close();
    }
    
}
/
