import java.io.BufferedWriter;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Arrays;
public class DataLoader{
  HashMap<String, String> readConfigData(){
    HashMap<String, String> output = new HashMap<String, String>();
    InputStream inStream = createInput(DATA_FILE);
    if(inStream == null){
      inStream = createInput(DEFAULT_DATA_FILE); // Should always exist, only modify if adding new config
    }
    if(inStream == null){
      return null;
    }
    Scanner in = new Scanner(inStream);
    while(in.hasNextLine()){
      String temp = in.nextLine();
      int toSplit = temp.indexOf(" = ");
      if(toSplit == -1){
        continue;
      }
      output.put(temp.substring(0, toSplit), temp.substring(toSplit + 3));
    }
    in.close();
    return output;
  }
  // Returns if write was successful
  boolean writeConfigData(HashMap<String, String> configs){
    try{
      BufferedWriter out = new BufferedWriter(new OutputStreamWriter(createOutput(DATA_FILE)));
      String[] keys = configs.keySet().toArray(new String[0]);
      keys = sort(keys);
      for(String configKey : keys){
        String output = configKey + " = " + configs.get(configKey) + "\n";
        out.write(output);
      }
      out.flush();
      out.close();
      return true;
    } catch (IOException e){
      return false;
    }
  }
  // Loads texture from binary .texture file
  byte[] loadTextureFromFile(String fileName){
    try{
      InputStream in = createInput(fileName);
      if(in == null){
        throw new IOException("File not found");
      }
      byte[] output = new byte[1024];
      in.read(output);
      in.close();
      return output;
    } catch (IOException e){
      byte[] blank = new byte[1024];
      for(int i = 0; i < 1024; i++){
        blank[i] = (byte)0xFF;
      }
      return blank;
    }
  }
}
