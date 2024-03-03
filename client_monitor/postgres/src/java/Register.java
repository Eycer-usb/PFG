package src.java;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Register {
    public String objectivePath = null;
    public String header = null;
    public String iteration = null;

    public Register(String objectivePath, String[] header, Integer iteration ){
        this.objectivePath = objectivePath;
        this.header = String.join(",", header);
        this.iteration = Integer.toString(iteration);
    }

    public void storeCSVLine(String[] line ) throws IOException {
        String filepath = this.objectivePath;
        File file = new File(filepath);

        if(this.createFile(file)) {
           FileWriter fw = new FileWriter(file, true);
           fw.write(this.iteration + "," + String.join(",", line ) + "\n");
           fw.close();
        }
    }

    public Boolean createFile(File file) throws IOException {
        if (file.exists()) {
            return true;
        }
        if (file.createNewFile()) {
            FileWriter fw = new FileWriter(file, true);
            fw.write(this.header + "\n");
            fw.close();
            System.out.println("File Created");
            return true;
        }else {
            System.out.println("Error Creating File");
            return false;
        }
    }
    
}
