import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
public class ImageToTexture{
  public static byte ColorToNTSCGreyscale(int c){
    int r = (c >> 16) & 0xFF;
    int g = (c >> 8) & 0xFF;
    int b = c & 0xFF;
    double temp = 0.299 * r + 0.587 * g + 0.114 * b;
    return (byte)temp;
  }
  public static void main(String[] args){
    if(args.length < 1){
      System.out.println("Command argument of input image file needed");
      return;
    }
    try{
      File f = new File(args[0]);
      BufferedImage img = ImageIO.read(f);
      if(img.getWidth() != 32 || img.getHeight() != 32){
        System.out.println("Image must be 32x32 pixels");
        return;
      }
      byte[] greyscaleValues = new byte[1024];
      for(int i = 0; i < 1024; i++){
        greyscaleValues[i] = ColorToNTSCGreyscale(img.getRGB(i % 32, i / 32));
      }
      String outputName = args[0];
      outputName = outputName.substring(0,outputName.lastIndexOf("."))+".texture";
      f = new File(outputName);
      FileOutputStream fout = new FileOutputStream(f);
      fout.write(greyscaleValues);
      fout.close();
    } catch (IOException e){
      System.out.println("Invalid image, input image must be a 32x32 image file");
    }
  }
}
