package arm.lsoft.db;

import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.io.ZipOutputStream;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

import java.io.*;

class ProtectedZipCreator {


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


public class ZipCreate {

    public static void main(String args[]) throws ZipException, IOException {
        InputStream inputStream = new FileInputStream("/opt/loginManager.properties");
        OutputStream outputStream = new FileOutputStream("/opt/loginManager.zip");
        ProtectedZipCreator.archive(inputStream, outputStream, "aram", "test.properties");
    }

}