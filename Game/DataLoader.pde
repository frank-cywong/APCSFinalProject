import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Arrays;
public class DataLoader{
  HashMap<String, String> readConfigData(){
    HashMap<String, String> output = new HashMap<String, String>();
    Scanner in = new Scanner(createInput(DATA_FILE));
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
}
