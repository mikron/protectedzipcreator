package arm.lsoft.db.logging;

import java.io.IOException;
import java.io.Writer;
import java.sql.SQLException;

/**
 * @author AM.
 */
public class LogWriter {

    private Writer m_OutStream;
    private String m_LocalErr;

    public LogWriter(oracle.sql.CLOB[] outErrBuff) {
        try {
            m_OutStream = outErrBuff[0].setCharacterStream(1);
            m_LocalErr = "";
        } catch (SQLException ex) {
            m_LocalErr = "Error while create log object=" + ex.getLocalizedMessage();
        }
    }
    public void write(String p_ErrMsg) {
        try {
            m_OutStream.write(p_ErrMsg + "\n", 0, p_ErrMsg.length() + 1);
        } catch (IOException ex) {
            m_LocalErr = m_LocalErr + "\nError while write=" + ex.getLocalizedMessage();
        }
    }
    public void write(Exception p_Ex) {
        write(p_Ex.getMessage());
        StackTraceElement[] l_ErrStack = p_Ex.getStackTrace();
        for(int i = 0; i < l_ErrStack.length ; i++) {
            write(l_ErrStack[i].toString());
        }
        write("\n");
    }
    public void close() {
        try {
            m_OutStream.close();
        } catch(IOException ex) {
            m_LocalErr = m_LocalErr + "\nError while close stream=" + ex.getLocalizedMessage();
        }
    }
    public void flush() {
        try {
            m_OutStream.flush();
        } catch(IOException ex) {
            m_LocalErr = m_LocalErr + "\nError while flush stream=" + ex.getLocalizedMessage();
        }
    }
    public String getLocalErr() {
        return m_LocalErr;
    }
}