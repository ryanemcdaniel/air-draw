using Leap;
using TobiasErichsen.teVirtualMIDI;
using System;


public class AirVisualizer {


    private static Guid manufacturer = new Guid("aa4e075f-3504-4aab-9b06-9a4104a91cf0");
    private static Guid product = new Guid("bb4e075f-3504-4aab-9b06-9a4104a91cf0");

    public static void Main() {
        
        // Instantiate the port
        Console.WriteLine("Initializing MIDI port...");
        TeVirtualMIDI.logging(TeVirtualMIDI.TE_VM_LOGGING_MISC | TeVirtualMIDI.TE_VM_LOGGING_RX | TeVirtualMIDI.TE_VM_LOGGING_TX);
        var drawLink = new TeVirtualMIDI("C# loopback", 65535, TeVirtualMIDI.TE_VM_FLAGS_PARSE_RX, ref manufacturer, ref product);
        Console.WriteLine("Done!");

        // Connect to Leap controller
        Console.WriteLine("Initializing Leap...");
        Controller leapMotion = new Controller();
        do {
            System.Threading.Thread.Sleep(1000);
            Console.WriteLine(".");
        } while (!leapMotion.IsConnected);
        
        // Allows controller to analyze frames as a background applciation
        leapMotion.SetPolicy(Controller.PolicyFlag.POLICY_BACKGROUND_FRAMES);

        bool isDrawing = true;
        bool wasDrawing = true;

        byte[] c_midC_on =  { 0b10011010, 0b00111100, 0b01111111 };
        byte[] c_midC_off = { 0b10001010, 0b00111100, 0b01111111 };

        // Main loop
        for(;;) {
            
            // Extract frame
            Frame f = leapMotion.Frame();
            
            // Check that only right hand is on stage
            if (f.Hands.Count == 1){
                Hand h = f.Hands[0];
                if(h.IsRight){
                    
                    // Set mode flags
                    if(isDrawing) wasDrawing = true;
                    else wasDrawing = false;
                    
                    // Gather coordinates
                    var indexTip = h.Fingers[1].TipPosition;
                    var middleTip = h.Fingers[2].TipPosition;

                    // Is middle finger close to index?
                    var distance = MathF.Sqrt(MathF.Pow((indexTip.x - middleTip.x), 2) + MathF.Pow((indexTip.y - middleTip.y), 2) + MathF.Pow((indexTip.z - middleTip.z), 2));
                    if (distance <= 20){
                        isDrawing = false;
                        Console.WriteLine("drawing");    
                    }
                    else {
                        isDrawing = true;
                        Console.WriteLine("not drawing");  
                    };

                    // Send is drawing MIDI change method
                    if (isDrawing ^ wasDrawing) {
                        Console.WriteLine("send");
                        drawLink.sendCommand(new byte[]{0b10011101, 0, 0});
                    };

                    // Scale heights
                    // Centimeters
                    var scaleX = indexTip.x / 10;
                    var scaleY = indexTip.y / 10;
                    var scaleZ = indexTip.z / 10;

                    // Send coordinates over MIDI
                    if (scaleX > 0) drawLink.sendCommand(new byte[]{0b10011010, (byte) scaleX, 0});
                    else            drawLink.sendCommand(new byte[]{0b10011010, 0, (byte) MathF.Abs(scaleX)});

                    if (scaleY > 0) drawLink.sendCommand(new byte[]{0b10011011, (byte) scaleY, 0});
                    else            drawLink.sendCommand(new byte[]{0b10011011, 0, (byte) MathF.Abs(scaleY)});
                    
                    if (scaleZ > 0) drawLink.sendCommand(new byte[]{0b10011100, (byte) scaleZ, 0});
                    else            drawLink.sendCommand(new byte[]{0b10011100, 0, (byte) MathF.Abs(scaleZ)});

                    drawLink.sendCommand(new byte[]{0b10011110, (byte) MathF.Abs(scaleY), (byte) MathF.Abs(scaleX)});
                    drawLink.sendCommand(new byte[]{0b10001110, (byte) MathF.Abs(scaleY), (byte) MathF.Abs(scaleX)});
                    
                    // Exit if not in drawing mode and close to camera
                    if (!isDrawing && scaleX > 75) return;
                }
            System.Threading.Thread.Sleep(50);
            }
        }
    }

}