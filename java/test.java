import java.util.*;
import java.security.*;

public class test{
  public static void main(String[] args){
  
    System.out.println("Hello please give your name...\n");
    Scanner scan = new Scanner(System.in);

    String name = scan.next();
    //byte Byte = Byte.nextByte();
    //int Int = Int.nextInt();
    //float f = f.nextFLoat();
  
    StringBuilder builder = new StringBuilder();
    builder.append("Adding ");
    builder.append("Strings ");
    builder.append("with ");
    builder.append("StringBuilder!\n");


    System.out.println(builder.toString());
    
    System.out.println("Isn't that great" + name + "!\n");
    return;

  }

}
